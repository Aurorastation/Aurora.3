var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()

	makeDatumRefLists()
	load_configuration()

	qdel(src)


/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session



#define RECOMMENDED_VERSION 501
/world/New()
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diary << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND"

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	if(config && config.log_runtime)
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

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

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr, master, key)
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (T == "admins")
		var/n = 0
		for (var/client/client in clients)
			if (client.holder && client.holder.rights & (R_MOD|R_ADMIN))
				n++

		return n

	else if (T == "cciaa")
		var/n = 0
		for (var/client/client in clients)
			if (client.holder && (client.holder.rights & R_CCIAA) && !(client.holder.rights & R_ADMIN))
				n++

		return n

	else if (T == "gamemode")
		return master_mode

	else if (T == "who")
		var/list/players = list()
		for (var/client/C in clients)
			players += C.key

		return list2params(players)

	else if (copytext(T,1,7) == "status")
		var/input[] = params2list(T)
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config.abandon_allowed
		s["enter"] = config.enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null

		// This is dumb, but spacestation13.com's banners break if player count isn't the 8th field of the reply, so... this has to go here.
		s["players"] = 0
		s["stationtime"] = worldtime2text()
		s["roundduration"] = round_duration()

		if(input["status"] == "2")
			var/list/players = list()
			var/list/admins = list()

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue
					admins[C.key] = C.holder.rank
				players += C.key

			s["players"] = players.len
			s["playerlist"] = list2params(players)
			s["admins"] = admins.len
			s["adminlist"] = list2params(admins)
		else
			var/n = 0
			var/admins = 0

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue	//so stealthmins aren't revealed by the hub
					admins++
				s["player[n]"] = C.key
				n++

			s["players"] = n
			s["admins"] = admins

		return list2params(s)

	else if(T == "manifest")
		if (!ticker)
			return "Game not started yet!"

		var/list/positions = list()
		var/list/set_names = list(
				"heads" = command_positions,
				"sec" = security_positions,
				"eng" = engineering_positions,
				"med" = medical_positions,
				"sci" = science_positions,
				"civ" = civilian_positions,
				"bot" = nonhuman_positions
			)

		for(var/datum/data/record/t in data_core.general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = make_list_rank(t.fields["real_rank"])

			var/department = 0
			for(var/k in set_names)
				if(real_rank in set_names[k])
					if(!positions[k])
						positions[k] = list()
					positions[k][name] = rank
					department = 1
			if(!department)
				if(!positions["misc"])
					positions["misc"] = list()
				positions["misc"][name] = rank

		for(var/k in positions)
			positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"

		return list2params(positions)

	else if(copytext(T,1,5) == "mute")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		for (var/client/C in clients)
			if (C.ckey == ckey(input["mute"]))
				C.mute_discord = !C.mute_discord

				switch (C.mute_discord)
					if (1)
						C << "<b><font color='red'>You have been muted from replying to Discord PMs by [input["admin"]]!</font></b>"
						log_and_message_admins("[C] has been muted from Discord PMs by [input["admin"]].")
						return "[C.key] is now muted from replying to Discord PMs."
					if (0)
						C << "<b><font color='red'>You have been unmuted from replying to Discord PMs by [input["admin"]]!</font></b>"
						log_and_message_admins("[C] has been unmuted from Discord PMs by [input["admin"]].")
						return "[C.key] is now unmuted from replying to Discord PMs."

		return "I couldn't find that ckey!"

	else if(copytext(T,1,5) == "info")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		var/list/search = params2list(input["info"])
		var/list/ckeysearch = list()
		for(var/text in search)
			ckeysearch += ckey(text)

		var/list/match = list()

		for(var/mob/M in mob_list)
			var/strings = list(M.name, M.ckey)
			if(M.mind)
				strings += M.mind.assigned_role
				strings += M.mind.special_role
			for(var/text in strings)
				if(ckey(text) in ckeysearch)
					match[M] += 10 // an exact match is far better than a partial one
				else
					for(var/searchstr in search)
						if(findtext(text, searchstr))
							match[M] += 1

		var/maxstrength = 0
		for(var/mob/M in match)
			maxstrength = max(match[M], maxstrength)
		for(var/mob/M in match)
			if(match[M] < maxstrength)
				match -= M

		if(!match.len)
			return "No matches"
		else if(match.len == 1)
			var/mob/M = match[1]
			var/info = list()
			info["key"] = M.key
			if (M.client)
				var/client/C = M.client
				info["discordmuted"] = C.mute_discord ? "Yes" : "No"
			info["name"] = M.name == M.real_name ? M.name : "[M.name] ([M.real_name])"
			info["role"] = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind"
			var/turf/MT = get_turf(M)
			info["loc"] = M.loc ? "[M.loc]" : "null"
			info["turf"] = MT ? "[MT] @ [MT.x], [MT.y], [MT.z]" : "null"
			info["area"] = MT ? "[MT.loc]" : "null"
			info["antag"] = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind"
			info["hasbeenrev"] = M.mind ? M.mind.has_been_rev : "No mind"
			info["stat"] = M.stat
			info["type"] = M.type
			if(isliving(M))
				var/mob/living/L = M
				info["damage"] = list2params(list(
							oxy = L.getOxyLoss(),
							tox = L.getToxLoss(),
							fire = L.getFireLoss(),
							brute = L.getBruteLoss(),
							clone = L.getCloneLoss(),
							brain = L.getBrainLoss()
						))
			else
				info["damage"] = "non-living"
			info["gender"] = M.gender
			return list2params(info)
		else
			return "Multiple matches found!"

	else if(copytext(T,1,9) == "adminmsg")
		/*
			We got an adminmsg from IRC bot lets split the input then validate the input.
			expected output:
				1. adminmsg = ckey of person the message is to
				2. msg = contents of message, parems2list requires
				3. validatationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
				4. sender = the ircnick that send the message.
		*/


		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		var/client/C
		var/req_ckey = ckey(input["adminmsg"])

		for(var/client/K in clients)
			if(K.ckey == req_ckey)
				C = K
				break
		if(!C)
			return "No client with that name on server"

		var/rank = input["rank"]
		if(!rank)
			rank = "Admin"

		var/message =	"<font color='red'>Discord-[rank] PM from <b><a href='?discord_msg=[input["sender"]]'>Discord-[input["sender"]]</a></b>: [input["msg"]]</font>"
		var/amessage =  "<font color='blue'>Discord-[rank] PM from <a href='?discord_msg=[input["sender"]]'>Discord-[input["sender"]]</a> to <b>[key_name(C)]</b> : [input["msg"]]</font>"

		C.received_discord_pm = world.time
		C.discord_admin = input["sender"]

		C << 'sound/effects/adminhelp.ogg'
		C << message


		for(var/client/A in admins)
			if(A != C)
				A << amessage

		return "Message Successful"

	else if(copytext(T,1,6) == "notes")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		return show_player_info_discord(ckey(input["notes"]))

	else if(copytext(T,1,4) == "age")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		var/age = get_player_age(input["age"])
		if(isnum(age))
			if(age >= 0)
				return "[age]"
			else
				return "Ckey not found"
		else
			return "Database connection failed or not set up"

	else if (copytext(T, 1, 8) == "restart")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			log_and_message_admins("Remote restart attempted and stopped. Dumping topic call data.")
			log_and_message_admins("TOPIC: \"[T]\", from: [addr], master: [master], key: [key].")
			return bad_key

		world << "<font size=4 color='#ff2222'>Server restarting by remote command.</font>"
		log_and_message_admins("World restart initiated remotely by [input["restart"]].")
		feedback_set_details("end_error","remote restart")

		if (blackbox)
			blackbox.save_all_data_to_sql()

		sleep(50)
		log_game("Rebooting due to remote command.")
		world.Reboot(2)

		return "Server successfully restarted."

	else if (copytext(T, 1, 9) == "announce")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		var/message = replacetext(input["msg"], "\n", "<br>")
		world << "<span class=notice><b>[input["announce"] ? input["announce"] : "Administrator"] Announces via Discord:</b><p style='text-indent: 50px'>[message]</p></span>"
		log_and_message_admins("[input["announce"]] announced remotely: [input["msg"]].")

		return "Announcement successfully sent."

	else if (copytext(T, 1, 8) == "faxlist")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		if (!ticker)
			return "Round hasn't started yet! No faxes to display!"

		var/list/faxes = list()
		switch (input["faxlist"])
			if ("received")
				faxes = arrived_faxes
			if ("sent")
				faxes = sent_faxes

		if (!faxes || !faxes.len)
			return "No faxes found!"

		var/list/output = list()
		for (var/i = 1, i <= faxes.len, i++)
			var/obj/item/a = faxes[i]
			output += "ID [i]"
			output["ID [i]"] = a.name ? a.name : "Untitled Fax"

		return list2params(output)

	else if (copytext(T, 1, 7) == "getfax")
		var/input[] = params2list(T)
		var/bad_key = do_topic_spam_protection(addr, input["key"])

		if (bad_key)
			return bad_key

		var/list/faxes = list()
		switch (input["received"])
			if ("received")
				faxes = arrived_faxes
			if ("sent")
				faxes = sent_faxes

		if (!faxes || !faxes.len)
			return "No faxes found!"

		var/fax_id = text2num(input["getfax"])
		if (fax_id > faxes.len || fax_id < 1)
			return "Invalid fax ID!"

		var/output = list()
		if (istype(faxes[fax_id], /obj/item/weapon/paper))
			var/obj/item/weapon/paper/a = faxes[fax_id]
			output["title"] = a.name ? a.name : "Untitled Fax"

			var/content = replacetext(a.info, "<br>", "\n")
			content = strip_html_properly(content, 0)
			output["content"] = content

			return list2params(output)
		else if (istype(faxes[fax_id], /obj/item/weapon/photo))
			return "The fax is a photo. I cannot send images, unfortunately..."
		else if (istype(faxes[fax_id], /obj/item/weapon/paper_bundle))
			var/obj/item/weapon/paper_bundle/b = faxes[fax_id]
			output["title"] = b.name ? b.name : "Untitled Paper Bundle"

			if (!b.pages || !b.pages.len)
				return "The bundle was empty! How is that even possible?"

			var/i = 0
			for (var/obj/item/weapon/paper/c in b.pages)
				i++
				var/content = replacetext(c.info, "<br>", "\n")
				content = strip_html_properly(content, 0)
				output["content"] += "Page [i]:\n[content]\n\n"

			return list2params(output)

		return "Unable to recognize the fax type. Cannot send contents!"

/world/Reboot(var/reason)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/

	processScheduler.stop()

	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

	..(reason)

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


/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")


/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.loadsql("config/dbconfig.txt")
	config.loadforumsql("config/forumdbconfig.txt")

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
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
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
var/failed_db_connections = 0
var/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return 1

proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF

/world/proc/do_topic_spam_protection(var/addr, var/key)
	if (!config.comms_password || config.comms_password == "")
		return "No comms password configured, aborting."

	if (key == config.comms_password)
		return 0
	else
		if (world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

			spawn(50)
				world_topic_spam_protect_time = world.time
				return "Bad Key (Throttled)"

		world_topic_spam_protect_time = world.time
		world_topic_spam_protect_ip = addr

		return "Bad Key"
