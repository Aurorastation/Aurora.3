#define WORLD_ICON_SIZE 32
#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32
#define WORLD_MIN_SIZE 32

/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init instance).
	2. The map is initialized, and map objects are created.
	3. world/New() runs, creating & starting the master controller.
	4. The master controller initializes the rest of the game.

*/
var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	generate_gameid()

	makeDatumRefLists()
	load_configuration()

	qdel(src) //we're done
	init = null

/datum/global_init/Destroy()
	..()
	return 3	// QDEL_HINT_HARDDEL ain't defined here, so magic number it is.

/var/game_id = null
/proc/generate_gameid()
	if(game_id != null)
		return
	game_id = ""

	var/list/c = list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	var/l = c.len

	var/t = world.timeofday
	for(var/_ = 1 to 4)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)
	game_id = "-[game_id]"
	t = round(world.realtime / (10 * 60 * 60 * 24))
	for(var/_ = 1 to 3)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)

/world
	mob = /mob/abstract/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	maxx = WORLD_MIN_SIZE	// So that we don't get map-window-popin at boot. DMMS will expand this.
	maxy = WORLD_MIN_SIZE
	fps = 30

#define RECOMMENDED_VERSION 510
/world/New()
	//logs
	diary_date_string = time2text(world.realtime, "YYYY/MM/DD")
	href_logfile = file("data/logs/[diary_date_string] hrefs.htm")
	diary = "data/logs/[diary_date_string]_[game_id].log"
	log_startup()
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(config.log_runtime)
		diary_runtime = file("data/logs/_runtime/[diary_date_string]-runtime.log")

	if(byond_version < RECOMMENDED_VERSION)
		log_error("Your server's byond version does not meet the recommended requirements for this server. Please update BYOND to [RECOMMENDED_VERSION].")

	world.TgsNew()

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	callHook("startup")

	. = ..()

#ifdef UNIT_TEST
	#if defined(MANUAL_UNIT_TEST)

	world.log << "[ascii_green] *** NOTICE *** [ascii_reset] Unit Tests Enabled.  This will destroy the world when testing is complete."

	#else

	world.log << "::notice::Unit Tests Enabled.  This will destroy the world when testing is complete."

	#endif

	load_unit_test_changes()
#endif

	// Do not add initialization stuff to this file, unless it *must* run before the MC initializes!
	// (hint: you generally won't need this)
	// To do things on server-start, create a subsystem or shove it into one of the miscellaneous init subsystems.

	Master.Initialize(10, FALSE)

#undef RECOMMENDED_VERSION

	return

var/list/world_api_rate_limit = list()

/world/Topic(T, addr, master, key)
	var/list/response[] = list()
	var/list/queryparams[]

	if (!SSfail2topic)
		response["statuscode"] = 500
		response["response"] = "Server not initialized."
		return json_encode(response)
	else if (SSfail2topic.IsRateLimited(addr))
		response["statuscode"] = 429
		response["response"] = "Rate limited."
		return json_encode(response)

	if (length(T) > 2000)
		response["statuscode"] = 413
		response["response"] = "Payload too large."
		return json_encode(response)

	try
		queryparams = json_decode(T)
	catch()
		queryparams = list()

	log_debug("API: Request Received - from:[addr], master:[master], key:[key]")
	log_topic(T, addr, master, key, queryparams)

	// TGS topic hook. Returns if successful, expects old-style serialization.
	var/tgs_topic_return = TgsTopic(T)

	if (tgs_topic_return)
		log_debug("API - TGS3 Request.")
		return tgs_topic_return
	else if (!queryparams.len)
		log_debug("API - Bad Request - Invalid/no JSON data sent.")
		response["statuscode"] = 400
		response["response"] = "Bad Request - Invalid/no JSON data sent."
		return json_encode(response)

	queryparams["addr"] = addr //Add the IP to the queryparams that are passed to the api functions
	var/query = queryparams["query"]
	var/auth = queryparams["auth"]

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

	var/unauthed = command.check_auth(addr, auth)
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

/proc/reboot_world()
	world.Reboot()

/world/Reboot(reason, hard_reset = FALSE)
	if (!hard_reset && world.TgsAvailable())
		switch (config.rounds_until_hard_restart)
			if (-1)
				hard_reset = FALSE
			if (0)
				hard_reset = TRUE
			else
				if (SSpersist_config.rounds_since_hard_restart >= config.rounds_until_hard_restart)
					hard_reset = TRUE
					SSpersist_config.rounds_since_hard_restart = 0
				else
					hard_reset = FALSE
					SSpersist_config.rounds_since_hard_restart++
	else if (!world.TgsAvailable() && hard_reset)
		hard_reset = FALSE

	SSpersist_config.save_to_file("data/persistent_config.json")
	Master.Shutdown()

	var/datum/chatOutput/co
	for(var/client/C in clients)
		co = C.chatOutput
		if(co)
			co.ehjax_send(data = "roundrestart")

	if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
		for(var/client/C in clients)
			C << link("byond://[config.server]")

	world.TgsReboot()

	if (hard_reset)
		log_misc("World hard rebooted at [time_stamp()].")
		shutdown_logging()
		world.TgsEndProcess()

	log_misc("World soft rebooted at [time_stamp()].")
	shutdown_logging()
	..(reason)

/world/Error(var/exception/e)
	var/static/inerror = 0

	//runtime while processing runtimes
	if (inerror)
		inerror = 0
		return ..(e)

	inerror = 1

// A horrible hack for unit tests but fuck runtiming timers.
// They don't provide any useful information, and as such, are being suppressed.
#ifdef UNIT_TEST

	if (findtextEx(e.name, "Invalid timer:") || findtextEx(e.desc, "Invalid timer:"))
		inerror = 0
		return

#endif // UNIT_TEST

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

/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")

	if (config.age_restrictions_from_file)
		config.load("config/age_restrictions.txt", "age_restrictions")

/world/proc/update_status()
	var/list/s = list()

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"[config.forumurl]\">" //Change this to wherever you want the hub to link to.
	s += "Forums"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if (Master.initialization_time_taken)	// This is set at the end of initialization.
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

	if (config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [jointext(features, ", ")]"

	s = s.Join()

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5

/hook/startup/proc/load_databases()
	if(!config.sql_enabled)
		log_error("Database Connection disabled. - Skipping Connection Establishment")
		return 1
	//Construct the database object from an init file.
	dbcon = initialize_database_object("config/dbconfig.txt")

	if(!setup_database_connection(dbcon))
		log_error("Your server failed to establish a connection with the configured database.")
	else
		log_error("Database connection established.")
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
		log_error("No DBConnection object passed to setup_database_connection().")
		return 0

	if (con.failed_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	con.Connect()
	. = con.IsConnected()
	if ( . )
		con.failed_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		con.failed_connections++		//If it failed, increase the failed connections counter.
		con.last_fail = world.timeofday

#ifdef UNIT_TEST
		// UTs are presumed public. Change this to hide your shit.
		log_error("Database connection failed with message:")
		log_error(con.ErrorMsg())
#else
		log_error("[time2text(con.last_fail, "hh:mm:ss")]: Database connection failed (try #[con.failed_connections]/[FAILED_DB_CONNECTION_CUTOFF])")
		log_error(con.ErrorMsg())
#endif

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection(var/DBConnection/con)
	if (!config.sql_enabled)
		return FALSE

	if (!con)
		log_error("No DBConnection object passed to establish_db_connection() proc.")
		return FALSE

	if (con.failed_connections > FAILED_DB_CONNECTION_CUTOFF)
		if(world.timeofday < con.last_fail + 100) // 10 seconds
			log_error("DB connection cutoff exceeded for a database object in establish_db_connection().")
			return FALSE

		con.failed_connections = 0

	if (!con.IsConnected())
		return setup_database_connection(con)
	else
		return TRUE

#undef FAILED_DB_CONNECTION_CUTOFF
