
/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init instance).
	2. The map is initialized, and map objects are created.
	3. world/New() runs, creating the process scheduler (and the old master controller) and spawning their setup.
	4. processScheduler/setup() runs, creating all the processes. game_controller/setup() runs, calling initialize() on all movable atoms in the world.
	5. The gameticker is created.

*/
var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	generate_gameid()

	makeDatumRefLists()
	load_configuration()

	qdel(src)


/var/game_id = null
/proc/generate_gameid()
	if(game_id != null)
		return
	game_id = ""

	var/list/c = list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	var/l = c.len

	var/t = world.realtime
	while(t != 0)
		game_id += c[(t % l) + 1]
		t = round(t / l)

/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session


#define RECOMMENDED_VERSION 510
/world/New()
	//logs
	diary_date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[diary_date_string] hrefs.htm")
	diary = file("data/logs/[diary_date_string].log")
	diary << "[log_end]\n[log_end]\nStarting up. (ID: [game_id]) [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(config.log_runtime)
		diary_runtime = file("data/logs/_runtime/[diary_date_string]-runtime.log")

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND to [RECOMMENDED_VERSION]."

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	callHook("startup")
	//Emergency Fix
	load_mods()
	//end-emergency fix

	src.update_status()

	. = ..()

	sleep_offline = 1

	// Set up roundstart seed list.
	plant_controller = new()

	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	//Create the asteroid Z-level.
	if(config.generate_asteroid)
		new /datum/random_map(null,13,32,5,217,223)

	// Create autolathe recipes, as above.
	populate_lathe_recipes()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	processScheduler = new
	master_controller = new /datum/controller/game_controller()
	spawn(1)
		processScheduler.deferSetupFor(/datum/controller/process/ticker)
		processScheduler.setup()
		master_controller.setup()

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

var/list/world_api_rate_limit = list()

/world/Topic(T, addr, master, key)
	var/list/response[] = list()
	var/list/queryparams[] = json_decode(T)
	queryparams["addr"] = addr //Add the IP to the queryparams that are passed to the api functions
	var/query = queryparams["query"]
	var/auth = queryparams["auth"]
	log_debug("API: Request Received - from:[addr], master:[master], key:[key]")
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key], auth:[auth] [log_end]"

	if (!ticker) //If the game is not started most API Requests would not work because of the throtteling
		response["statuscode"] = 500
		response["response"] = "Game not started yet!"
		return json_encode(response)

	if (isnull(query))
		log_debug("API - Bad Request - No query specified")
		response["statuscode"] = 400
		response["response"] = "Bad Request - No query specified"
		return json_encode(response)

	var/datum/topic_command/command = topic_commands[query]

	//Check if that command exists
	if (isnull(command))
		log_debug("API: Unknown command called: [query]")
		response["statuscode"] = 501
		response["response"] = "Not Implemented"
		return json_encode(response)

	var/unauthed = api_do_auth_check(addr,auth,command)
	if (unauthed)
		if (unauthed == 3)
			log_debug("API: Request denied - Auth Service Unavailable")
			response["statuscode"] = 503
			response["response"] = "Auth Service Unavailable"
			return json_encode(response)
		else if (unauthed == 2)
			log_debug("API: Request denied - Throttled")
			response["statuscode"] = 429
			response["response"] = "Throttled"
			return json_encode(response)
		else
			log_debug("API: Request denied - Bad Auth")
			response["statuscode"] = 401
			response["response"] = "Bad Auth"
			return json_encode(response)

	log_debug("API: Auth valid")

	if(command.check_params_missing(queryparams))
		log_debug("API: Mising Params - Status: [command.statuscode] - Response: [command.response]")
		response["statuscode"] = command.statuscode
		response["response"] = command.response
		response["data"] = command.data
		return json_encode(response)
	else
		command.run_command(queryparams)
		log_debug("API: Command called: [query] - Status: [command.statuscode] - Response: [command.response]")
		response["statuscode"] = command.statuscode
		response["response"] = command.response
		response["data"] = command.data
		return json_encode(response)


/world/Reboot(var/reason)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/

	processScheduler.stop()

	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

	// Handle runtime condensing here
	if (config.log_runtime)
		var/input_file = "data/logs/_runtime/[diary_date_string]-runtime.log"
		var/output_file = "data/logs/_runtime/[diary_date_string]-runtime-condensed.log"

		var/command = "tools/Runtime Condenser/RuntimeCondenser.exe -q -s [input_file] -d [output_file]"

		if (src.system_type == MS_WINDOWS)
			command = replacetext(command, "/", "\\")

		var/exit_code = shell(command)
		if (exit_code)
			log_debug("RuntimeCondenser.exe exited with error code [exit_code].")

	..(reason)

var/inerror = 0
/world/Error(var/exception/e)
	//runtime while processing runtimes
	if (inerror)
		inerror = 0
		return ..(e)

	inerror = 1

	e.time_stamp()
	log_exception(e)

	inerror = 0
	return ..(e)

// We need this elsewhere!
/exception/var/time_stamped = 0

/exception/proc/time_stamp()
	if (time_stamped)
		return

	//newline at start is because of the "runtime error" byond prints that can't be timestamped.
	name = "\n\[[time2text(world.timeofday,"hh:mm:ss")]\][name]"

	//this is done this way rather then replace text to pave the way for processing the runtime reports more thoroughly
	//	(and because runtimes end with a newline, and we don't want to basically print an empty time stamp)
	var/list/split = splittext(desc, "\n")
	for (var/i in 1 to split.len)
		if (split[i] != "")
			split[i] = "\[[time2text(world.timeofday,"hh:mm:ss")]\][split[i]]"
	desc = jointext(split, "\n")

	time_stamped = 1

/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode


/hook/startup/proc/initialize_greeting()
	world.initialize_greeting()
	return 1

/world/proc/initialize_greeting()
	server_greeting = new()


/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")

	if (config.use_age_restriction_for_jobs)
		config.load("config/age_restrictions.txt", "age_restrictions")

/hook/startup/proc/loadMods()
	world.load_mods()
	world.load_mentors() // no need to write another hook.
	return 1

/world/proc/load_mods()
	if(config.admin_legacy_system)
		var/text = file2text("config/moderators.txt")
		if (!text)
			error("Failed to load config/mods.txt")
		else
			var/list/lines = text2list(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(directory[ckey])

/world/proc/load_mentors()
	if(config.admin_legacy_system)
		var/text = file2text("config/mentors.txt")
		if (!text)
			error("Failed to load config/mentors.txt")
		else
			var/list/lines = text2list(text, "\n")
			for(var/line in lines)
				if (!line)
					continue
				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Mentor"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(directory[ckey])

/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"[config.forumurl]\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Forums"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(ticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>STARTING</b>"

	if (!config.enter_allowed)
		features += "closed"

	features += config.abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	/*
	is there a reason for this? the byond site shows 'hosted by X' when there is a proper host already.
	if (host)
		features += "hosted by <b>[host]</b>"
	*/

	if (!host && config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [list2text(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5

/hook/startup/proc/load_databases()
	//Construct the database object from an init file.
	dbcon = initialize_database_object("config/dbconfig.txt")

	if (!setup_database_connection(dbcon))
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return 1

/proc/initialize_database_object(var/filename)
	if (!filename)
		// The code is written in a manner that is spasses out whenever dbcon = null, so we just make a dummy DB object.
		return new/DBConnection()

	var/list/data = list("address", "port", "database", "login", "password")

	var/list/Lines = file2list(filename)

	if (!Lines)
		// Return dummy object for safety.
		return new/DBConnection()

	for (var/t in Lines)
		if (!t)
			continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		name = lowertext(copytext(t, 1, pos))
		value = copytext(t, pos + 1)

		if (!name)
			continue

		if (name in data)
			data[name] = value
		else
			log_misc("Unknown setting while setting up database connection. Filename: '[filename]', value: '[value]'.")

	return new/DBConnection(data["address"], data["port"], data["database"], data["login"], data["password"])

/proc/setup_database_connection(var/DBConnection/con)
	if (!con)
		error("No DBConnection object passed to setup_database_connection().")
		return 0

	if (con.failed_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	con.Connect()
	. = con.IsConnected()
	if ( . )
		con.failed_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		con.failed_connections++		//If it failed, increase the failed connections counter.
		world.log << con.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection(var/DBConnection/con)
	if (!con)
		error("No DBConnection object passed to establish_db_connection() proc.")
		return 0

	if (con.failed_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if (!con.IsConnected())
		return setup_database_connection(con)
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF
