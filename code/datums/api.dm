//
// This file contains the API commands for the serverside API
//
// IMPORTANT:
//	When changing api commands always update the version number of the API
//	The version number is defined in /datum/topic_command/api_get_version

//Init the API at startup
/hook/startup/proc/setup_api()
	for (var/path in typesof(/datum/topic_command) - /datum/topic_command)
		var/datum/topic_command/A = new path()
		if(A != null)
			topic_commands[A.name] = A
			topic_commands_names.Add(A.name)
		listclearnulls(topic_commands)
		listclearnulls(topic_commands_names)

	if (config.api_rate_limit_whitelist.len)
		// To make the api_rate_limit_whitelist[addr] grabs actually work.
		for (var/addr in config.api_rate_limit_whitelist)
			config.api_rate_limit_whitelist[addr] = 1

	return 1

/world/proc/api_do_auth_check(var/addr, var/auth, var/datum/topic_command/command)
	//Check if command is on nothrottle list
	if(command.no_throttle == 1)
		log_debug("API: Throttling bypassed - Command [command.name] set to no_throttle")
	else
		if(world_api_rate_limit[addr] != null && config.api_rate_limit_whitelist[addr] == null) //Check if the ip is in the rate limiting list and not in the whitelist
			if(abs(world_api_rate_limit[addr] - world.time) < config.api_rate_limit) //Check the last request time of the ip
				world_api_rate_limit[addr] = world.time // Set the time of the last request
				return 2 //Throttled
		world_api_rate_limit[addr] = world.time // Set the time of the last request


	//Check if the command is on the auth whitelist
	if(command.no_auth == 1)
		log_debug("API: Auth bypassed - Command [command.name] set to no_auth")
		return 0 // Authed (bypassed)

	var/DBQuery/authquery = dbcon.NewQuery({"SELECT api_f.command
	FROM ss13_api_token_command as api_t_f, ss13_api_tokens as api_t, ss13_api_commands as api_f
	WHERE api_t.id = api_t_f.token_id AND api_f.id = api_t_f.command_id
	AND	api_t.deleted_at IS NULL
	AND (
	(token = :token: AND ip = :ip: AND command = :command:)
	OR
	(token = :token: AND ip IS NULL AND command = :command:)
	OR
	(token = :token: AND ip = :ip: AND command = \"_ANY\")
	OR
	(token = :token: AND ip IS NULL AND command = \"_ANY\")
	OR
	(token IS NULL AND ip IS NULL AND command = :command:)
	)"})
	//Check if the token is not deleted
	//Check if one of the following is true:
	// Full Match - Token IP and Command Matches
	// Any IP - Token and Command Matches, IP is set to NULL (not required)
	// Any Command - Token and IP Matches, Command is set to _ANY
	// Any Command, Any IP - Token Matches, IP is set to NULL (not required), Command is set to _ANY
	// Public - Token is set to NULL, IP is set to NULL and command matches

	authquery.Execute(list("token" = auth, "ip" = addr, "command" = command.name))
	log_debug("API: Auth Check - Query Executed - Returned Rows: [authquery.RowCount()]")

	if (authquery.RowCount())
		return 0 // Authed
	return 1 // Bad Key


proc/api_update_command_database()
	log_debug("API: DB Command Update Called")
	//Check if DB Connection is established
	if (!establish_db_connection(dbcon))
		return 0 //Error

	var/DBQuery/commandinsertquery = dbcon.NewQuery({"INSERT INTO ss13_api_commands (command,description)
	VALUES (:command_name:,:command_description:)
	ON DUPLICATE KEY UPDATE description = :command_description:;"})

	for(var/com in topic_commands)
		var/datum/topic_command/command = topic_commands[com]
		commandinsertquery.Execute(list("command_name" = command.name, "command_description" = command.description))
	log_debug("API: DB Command Update Executed")
	return 1 //OK

//API Boilerplate
/datum/topic_command
	var/name = null //Name for the command
	var/no_auth = 0 //If the user does NOT need to be authed to use the command
	var/no_throttle = 0 //If this command should NOT be limited by the throtteling
	var/description = null //Description for the command
	var/list/params = list() //Required Parameters for the command
	//Explanation of the parameter options:
	//Required - name -> Name of the parameter - should be the same as the index in the list
	//Required - desc -> Description of the parameter
	//Required - req -> Is this a required parameter: 1 -> Yes, 0 -> No
	//Required - type -> What type is this:
	//						str->String,
	//						int->Integer,
	//						lst->List/array,
	//						senderkey->unique identifier of the person sending the request
	//						slct -> Select one of multiple specified options
	//Required* - options -> The possible options that can be selected (slct)
	var/statuscode = null
	var/response = null
	var/data = null
/datum/topic_command/proc/run_command(queryparams)
	// Always returns 1 --> Details status in statuscode, response and data
	return 1
/datum/topic_command/proc/check_params_missing(queryparams)
	//Check if some of the required params are missing
	// 0 -> if all params are supplied
	// >=1 -> if a param is missing
	var/list/missing_params = list()
	var/errorcount = 0

	for(var/key in params)
		var/list/param = params[key]
		if(queryparams[key] == null)
			if(param["req"] == 0)
				log_debug("API: The following parameter is OPTIONAL and missing: [param["name"]] - [param["desc"]]")
			else
				log_debug("API: The following parameter is REQUIRED but missing: [param["name"]] - [param["desc"]]")
				errorcount ++
				missing_params += param["name"]
	if(errorcount)
		log_debug("API: Request aborted. Required parameters missing")
		statuscode = 400
		response = "Required params missing"
		data = missing_params
		return errorcount
	return 0

//
// API for the API
//
/datum/topic_command/api_get_version
	name = "api_get_version"
	description = "Gets the version of the API"
	no_auth = 1
	no_throttle = 1
/datum/topic_command/api_get_version/run_command(queryparams)
	var/list/version = list()
	var/versionstring = null
	//The Version Number follows SemVer http://semver.org/
	version["major"] = 2 //Major Version Number --> Increment when implementing breaking changes
	version["minor"] = 5 //Minor Version Number --> Increment when adding features
	version["patch"] = 0 //Patchlevel --> Increment when fixing bugs

	versionstring = "[version["major"]].[version["minor"]].[version["patch"]]"

	statuscode = 200
	response = versionstring
	data = version
	return 1


//Get all the commands a specific token / ip combo is authorized to use
/datum/topic_command/api_get_authed_commands
	name = "api_get_authed_commands"
	description = "Returns the commands that can be accessed by the requesting ip and token"
/datum/topic_command/api_get_authed_commands/run_command(queryparams)
	var/list/commands = list()


	//Check if DB Connection is established
	if (!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB Connection Unavailable"
		return 1

	var/DBQuery/commandsquery = dbcon.NewQuery({"SELECT api_f.command
	FROM ss13_api_token_command as api_t_f, ss13_api_tokens as api_t, ss13_api_commands as api_f
	WHERE api_t.id = api_t_f.token_id AND api_f.id = api_t_f.command_id
	AND (
		(token = :token: AND ip = :ip:)
		OR
		(token = :token: AND ip IS NULL)
		OR
		(token IS NULL AND ip = :ip:)
	)
	ORDER BY command DESC"})


	commandsquery.Execute(list("token" = queryparams["auth"], "ip" = queryparams["addr"]))
	while (commandsquery.NextRow())
		commands[commandsquery.item[1]] = commandsquery.item[1]
		if(commandsquery.item[1] == "_ANY")
			statuscode = 200
			response = "Authorized commands retrieved - ALL"
			data = topic_commands_names
			return 1


	statuscode = 200
	response = "Authorized commands retrieved"
	data = commands
	return 1

//Get details for a specific api command
/datum/topic_command/api_explain_command
	name = "api_explain_command"
	description = "Explains a specific API command"
	no_throttle = 1
	params = list(
		"command" = list("name"="command","desc"="The name of the API command that should be explained","req"=1,"type"="str")
		)
/datum/topic_command/api_explain_command/run_command(queryparams)
	var/datum/topic_command/apicommand = topic_commands[queryparams["command"]]
	var/list/commanddata = list()

	if (isnull(apicommand))
		statuscode = 501
		response = "Not Implemented - The requested command does not exist"
		return 1

	//Then query for auth
	if (!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB Connection Unavailable"
		return 1

	var/DBQuery/permquery = dbcon.NewQuery({"SELECT api_f.command
	FROM ss13_api_token_command as api_t_f, ss13_api_tokens as api_t, ss13_api_commands as api_f
	WHERE api_t.id = api_t_f.token_id AND api_f.id = api_t_f.command_id
	AND	api_t.deleted_at IS NULL
	AND (
	(token = :token: AND ip = :ip: AND command = :command:)
	OR
	(token = :token: AND ip IS NULL AND command = :command:)
	OR
	(token = :token: AND ip = :ip: AND command = \"_ANY\")
	OR
	(token = :token: AND ip IS NULL AND command = \"_ANY\")
	OR
	(token IS NULL AND ip IS NULL AND command = :command:)
	)"})
	//Get the tokens and the associated commands
	//Check if the token, the ip and the command matches OR
	// the token + command matches and the ip is NULL (commands that can be used by any ip, but require a token)
	// the token + ip matches and the command is NULL (Allow a specific ip with a specific token to use all commands)
	// the token + ip is NULL and the command matches (Allow a specific command to be used without auth)

	permquery.Execute(list("token" = queryparams["auth"], "ip" = queryparams["addr"], "command" = queryparams["command"]))

	if (!permquery.RowCount())
		statuscode = 401
		response = "Unauthorized - To access this command"
		return 1

	commanddata["name"] = apicommand.name
	commanddata["description"] = apicommand.description
	commanddata["params"] = apicommand.params

	statuscode = 200
	response = "Command data retrieved"
	data = commanddata
	return 1


/datum/topic_command/update_command_database
	name = "update_command_database"
	description = "Updates the available topic commands in the database"
/datum/topic_command/update_command_database/run_command(queryparams)
	api_update_command_database()

	statuscode = 200
	response = "Database Updated"
	return 1

//
// API for the other stuff
//

//Char Names
/datum/topic_command/get_char_list
	name = "get_char_list"
	description = "Provides a list of all characters ingame"
/datum/topic_command/get_char_list/run_command(queryparams)
	var/list/chars = list()

	var/list/mobs = sortmobs()
	for(var/mob/M in mobs)
		if(!M.ckey) continue
		chars[M.name] += M.key ? (M.client ? M.key : "[M.key] (DC)") : "No key"

	statuscode = 200
	response = "Char list fetched"
	data = chars
	return 1

//Admin Count
/datum/topic_command/get_count_admin
	name = "get_count_admin"
	description = "Gets the number of admins connected"
/datum/topic_command/get_count_admin/run_command(queryparams)
	var/n = 0
	for (var/client/client in clients)
		if (client.holder && client.holder.rights & (R_ADMIN))
			n++

	statuscode = 200
	response = "Admin count fetched"
	data = n
	return 1

//CCIA Count
/datum/topic_command/get_count_cciaa
	name = "get_count_cciaa"
	description = "Gets the number of ccia connected"
/datum/topic_command/get_count_ccia/run_command(queryparams)
	var/n = 0
	for (var/client/client in clients)
		if (client.holder && (client.holder.rights & R_CCIAA) && !(client.holder.rights & R_ADMIN))
			n++

	statuscode = 200
	response = "CCIA count fetched"
	data = n
	return 1

//Mod Count
/datum/topic_command/get_count_mod
	name = "get_count_mod"
	description = "Gets the number of mods connected"
/datum/topic_command/get_count_mod/run_command(queryparams)
	var/n = 0
	for (var/client/client in clients)
		if (client.holder && (client.holder.rights & R_MOD) && !(client.holder.rights & R_ADMIN))
			n++

	statuscode = 200
	response = "Mod count fetched"
	data = n
	return 1

//Player Count
/datum/topic_command/get_count_player
	name = "get_count_player"
	description = "Gets the number of players connected"
/datum/topic_command/get_count_player/run_command(queryparams)
	var/n = 0
	for(var/mob/M in player_list)
		if(M.client)
			n++

	statuscode = 200
	response = "Player count fetched"
	data = n
	return 1

//Get available Fax Machines
/datum/topic_command/get_faxmachines
	name = "get_faxmachines"
	description = "Gets all available fax machines"
/datum/topic_command/get_faxmachines/run_command(queryparams)
	var/list/faxlocations = list()

	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		faxlocations.Add(F.department)

	statuscode = 200
	response = "Fax machines fetched"
	data = faxlocations
	return 1

//Get Fax List
/datum/topic_command/get_faxlist
	name = "get_faxlist"
	description = "Gets the list of faxes sent / received"
	params = list(
		"faxtype" = list("name"="faxtype","desc"="Type of the faxes that should be retrieved","req"=1,"type"="slct","options"=list("sent","received"))
		)
/datum/topic_command/get_faxlist/run_command(queryparams)
	var/list/faxes = list()
	switch (queryparams["faxtype"])
		if ("received")
			faxes = arrived_faxes
		if ("sent")
			faxes = sent_faxes

	if (!faxes || !faxes.len)
		statuscode = 404
		response = "No faxes found"
		data = null
		return 1

	var/list/output = list()
	for (var/i = 1, i <= faxes.len, i++)
		var/obj/item/a = faxes[i]
		output += "[i]"
		output[i] = a.name ? a.name : "Untitled Fax"

	statuscode = 200
	response = "Fetched Fax List"
	data = output
	return 1

//Get Specific Fax
/datum/topic_command/get_fax
	name = "get_fax"
	description = "Gets a specific fax that has been sent or received"
	params = list(
		"faxtype" = list("name"="faxtype","desc"="Type of the faxes that should be retrieved","req"=1,"type"="slct","options"=list("sent","received")),
		"faxid" = list("name"="faxid","desc"="ID of the fax that should be retrieved","req"=1,"type"="int")
		)
/datum/topic_command/get_fax/run_command(queryparams)
	var/list/faxes = list()
	switch (queryparams["faxtype"])
		if ("received")
			faxes = arrived_faxes
		if ("sent")
			faxes = sent_faxes

	if (!faxes || !faxes.len)
		statuscode = 500
		response = "No faxes found!"
		data = null
		return 1

	var/fax_id = text2num(queryparams["faxid"])
	if (fax_id > faxes.len || fax_id < 1)
		statuscode = 404
		response = "Invalid Fax ID"
		data = null
		return 1

	var/output = list()
	if (istype(faxes[fax_id], /obj/item/weapon/paper))
		var/obj/item/weapon/paper/a = faxes[fax_id]
		output["title"] = a.name ? a.name : "Untitled Fax"

		var/content = replacetext(a.info, "<br>", "\n")
		content = strip_html_properly(content, 0)
		output["content"] = content

		statuscode = 200
		response = "Fax (Paper) with id [fax_id] retrieved"
		data = output
		return 1
	else if (istype(faxes[fax_id], /obj/item/weapon/photo))
		statuscode = 501
		response = "Fax is a Photo - Unable to send"
		data = null
		return 1
	else if (istype(faxes[fax_id], /obj/item/weapon/paper_bundle))
		var/obj/item/weapon/paper_bundle/b = faxes[fax_id]
		output["title"] = b.name ? b.name : "Untitled Paper Bundle"

		if (!b.pages || !b.pages.len)
			statuscode = 500
			response = "Fax Paper Bundle is empty - This should not happen"
			data = null
			return 1

		var/i = 0
		for (var/obj/item/weapon/paper/c in b.pages)
			i++
			var/content = replacetext(c.info, "<br>", "\n")
			content = strip_html_properly(content, 0)
			output["content"] += "Page [i]:\n[content]\n\n"

			statuscode = 200
			response = "Fax (PaperBundle) retrieved"
			data = output
			return 1

	statuscode = 500
	response = "Unable to recognize the fax type. Cannot send contents!"
	data = null
	return 1

//Get Ghosts
/datum/topic_command/get_ghosts
	name = "get_ghosts"
	description = "Gets the ghosts"
/datum/topic_command/get_ghosts/run_command(queryparams)
	var/list/ghosts[] = list()
	ghosts = get_ghosts(1,1)

	statuscode = 200
	response = "Fetched Ghost list"
	data = ghosts
	return 1

// Crew Manifest
/datum/topic_command/get_manifest
	name = "get_manifest"
	description = "Gets the crew manifest"
/datum/topic_command/get_manifest/run_command(queryparams)
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

	// for(var/k in positions)
	//	 positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"

	statuscode = 200
	response = "Manifest fetched"
	data = positions
	return 1

//Player Ckeys
/datum/topic_command/get_player_list
	name = "get_player_list"
	description = "Gets a list of connected players"
	params = list(
		"showadmins" = list("name"="show admins","desc"="A boolean to toggle whether or not hidden admins should be shown with proper or improper ckeys.","req"=0,"type"="int")
		)
/datum/topic_command/get_player_list/run_command(queryparams)
	var/show_hidden_admins = 0

	if (!isnull(queryparams["showadmins"]))
		show_hidden_admins = text2num(queryparams["showadmins"])

	var/list/players = list()
	for (var/client/C in clients)
		if (show_hidden_admins && C.holder && C.holder.fakekey)
			players += ckey(C.holder.fakekey)
		else
			players += C.ckey

	statuscode = 200
	response = "Player list fetched"
	data = players
	return 1

//Get info about a specific player
/datum/topic_command/get_player_info
	name = "get_player_info"
	description = "Gets information about a specific player"
	params = list(
		"search" = list("name"="search","desc"="List with strings that should be searched for","req"=1,"type"="lst")
		)
/datum/topic_command/get_player_info/run_command(queryparams)
	var/list/search = queryparams["search"]

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
		statuscode = 449
		response = "No match found"
		data = null
		return 1
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
		statuscode = 200
		response = "Client data fetched"
		data = info
		return 1
	else
		statuscode = 449
		response = "Multiple Matches found"
		data = null
		return 1

//Get Server Status
/datum/topic_command/get_serverstatus_public
	name = "get_serverstatus_public"
	description = "Gets the serverstatus"
	no_auth = 1

/datum/topic_command/get_serverstatus/run_command(queryparams)
	var/s[]
	s["version"] = game_version
	s["mode"] = master_mode
	s["respawn"] = config.abandon_allowed
	s["enter"] = config.enter_allowed
	s["vote"] = config.allow_vote_mode
	s["ai"] = config.allow_ai
	s["host"] = host ? host : null
	s["players"] = 0
	s["stationtime"] = worldtime2text()
	s["roundduration"] = get_round_duration_formatted()
	s["map"] = current_map.full_name

	if(queryparams["status"] == "2")
		var/list/players = list()
		var/list/admins = list()

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue
				admins[C.key] = C.holder.rank
			players += C.key

		s["players"] = players.len
		s["playerlist"] = players
		s["admins"] = admins.len
		s["adminlist"] = admins
	else
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			n++

		s["players"] = n
		s["admins"] = admins

	statuscode = 200
	response = "Server Status fetched"
	data = s
	return 1

//Get Server Status
/datum/topic_command/get_serverstatus
	name = "get_serverstatus"
	description = "Gets the serverstatus"

/datum/topic_command/get_serverstatus/run_command(queryparams)
	var/s[]
	s["version"] = game_version
	s["mode"] = master_mode
	s["respawn"] = config.abandon_allowed
	s["enter"] = config.enter_allowed
	s["vote"] = config.allow_vote_mode
	s["ai"] = config.allow_ai
	s["host"] = host ? host : null
	s["players"] = 0
	s["admins"] = 0
	s["stationtime"] = worldtime2text()
	s["roundduration"] = get_round_duration_formatted()
	s["gameid"] = game_id
	s["map"] = current_map.full_name

	if(queryparams["status"] == "2")
		var/list/players = list()
		var/list/admins = list()

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue
				admins[C.key] = C.holder.rank
			players += C.key

		s["players"] = players.len
		s["playerlist"] = players
		s["admins"] = admins.len
		s["adminlist"] = admins
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

	statuscode = 200
	response = "Server Status fetched"
	data = s
	return 1

//Get a Staff List
/datum/topic_command/get_stafflist
	name = "get_stafflist"
	description = "Gets a list of connected staffmembers"
/datum/topic_command/get_stafflist/run_command(queryparams)
	var/list/staff = list()
	for (var/client/C in admins)
		staff[C] = C.holder.rank

	statuscode = 200
	response = "Staff list fetched"
	data = staff
	return 1

//Grant Respawn
/datum/topic_command/grant_respawn
	name = "grant_respawn"
	description = "Grants a respawn to a specific target"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that authorized the respawn","req"=1,"type"="senderkey"),
		"target" = list("name"="target","desc"="Ckey of the target that should be granted a respawn","req"=1,"type"="str")
		)
/datum/topic_command/grant_respawn/run_command(queryparams)
	var/list/ghosts = get_ghosts(1,1)
	var/target = queryparams["target"]
	var/allow_antaghud = queryparams["allow_antaghud"]
	var/senderkey = queryparams["senderkey"] //Identifier of the sender (Ckey / Userid / ...)

	var/mob/abstract/observer/G = ghosts[target]

	if(!G in ghosts)
		statuscode = 404
		response = "Target not in ghosts list"
		data = null
		return 1

	if(G.has_enabled_antagHUD && config.antag_hud_restricted && allow_antaghud == 0)
		statuscode = 409
		response = "Ghost has used Antag Hud - Respawn Aborted"
		data = null
		return 1
	G.timeofdeath=-19999	/* time of death is checked in /mob/verb/abandon_mob() which is the Respawn verb.
										 timeofdeath is used for bodies on autopsy but since we're messing with a ghost I'm pretty sure
										 there won't be an autopsy.
									*/
	var/datum/preferences/P

	if (G.client)
		P = G.client.prefs
	else if (G.ckey)
		P = preferences_datums[G.ckey]
	else
		statuscode = 500
		response = "Something went wrong, couldn't find the target's preferences datum"
		data = null
		return 1

	for (var/entry in P.time_of_death)//Set all the prefs' times of death to a huge negative value so any respawn timers will be fine
		P.time_of_death[entry] = -99999

	G.has_enabled_antagHUD = 2
	G.can_reenter_corpse = 1

	G:show_message(text("<span class='notice'><B>You may now respawn.	You should roleplay as if you learned nothing about the round during your time with the dead.</B></span>"), 1)
	log_admin("[senderkey] allowed [key_name(G)] to bypass the 30 minute respawn limit via the API",ckey=key_name(G),admin_key=senderkey)
	message_admins("Admin [senderkey] allowed [key_name_admin(G)] to bypass the 30 minute respawn limit via the API", 1)


	statuscode = 200
	response = "Respawn Granted"
	data = null
	return 1

//Ping Test
/datum/topic_command/ping
	name = "ping"
	description = "API test command"
/datum/topic_command/ping/run_command(queryparams)
	var/x = 1
	for (var/client/C)
		x++
	statuscode = 200
	response = "Pong"
	data = x
	return 1

//Restart Round
/datum/topic_command/restart_round
	name = "restart_round"
	description = "Restarts the round"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that authorized the restart","req"=1,"type"="senderkey")
		)
/datum/topic_command/restart_round/run_command(queryparams)
	var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)

	to_world("<font size=4 color='#ff2222'>Server restarting by remote command.</font>")
	log_and_message_admins("World restart initiated remotely by [senderkey].")
	feedback_set_details("end_error","remote restart")

	spawn(50)
		log_game("Rebooting due to remote command.")
		world.Reboot(10)

	statuscode = 200
	response = "Restart Command accepted"
	data = null
	return 1

//Get available Fax Machines
/datum/topic_command/send_adminmsg
	name = "send_adminmsg"
	description = "Sends a adminmessage to a player"
	params = list(
		"ckey" = list("name"="ckey","desc"="The target of the adminmessage","req"=1,"type"="str"),
		"msg" = list("name"="msg","desc"="The message that should be sent","req"=1,"type"="str"),
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that sent the adminmessage","req"=1,"type"="senderkey"),
		"rank" = list("name"="rank","desc"="The rank that should be displayed - Defaults to admin if none specified","req"=0,"type"="str")
		)

/datum/topic_command/send_adminmsg/run_command(queryparams)
	/*
		We got an adminmsg from IRC bot lets split the API
		expected output:
			1. ckey = ckey of person the message is to
			2. msg = contents of message, parems2list requires
			3. rank = Rank that should be displayed
			4. senderkey = the ircnick that send the message.
	*/

	var/client/C
	var/req_ckey = ckey(queryparams["ckey"])

	for(var/client/K in clients)
		if(K.ckey == req_ckey)
			C = K
			break
	if(!C)
		statuscode = 404
		response = "No client with that name on server"
		data = null
		return 1

	var/rank = queryparams["rank"]
	if(!rank)
		rank = "Admin"

	var/message =	"<font color='red'>[rank] PM from <b><a href='?discord_msg=[queryparams["senderkey"]]'>[queryparams["senderkey"]]</a></b>: [queryparams["msg"]]</font>"
	var/amessage =	"<font color='blue'>[rank] PM from <a href='?discord_msg=[queryparams["senderkey"]]'>[queryparams["senderkey"]]</a> to <b>[key_name(C, highlight_special = 1)]</b> : [queryparams["msg"]]</font>"

	C.received_discord_pm = world.time
	C.discord_admin = queryparams["senderkey"]

	C << 'sound/effects/adminhelp.ogg'
	C << message

	for(var/client/A in admins)
		if(A != C)
			A << amessage


	statuscode = 200
	response = "Admin Message sent"
	data = null
	return 1

//Send a Command Report
/datum/topic_command/send_commandreport
	name = "send_commandreport"
	description = "Sends a command report"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that sent the commandreport","req"=1,"type"="senderkey"),
		"title" = list("name"="title","desc"="The message title that should be sent, Defaults to NanoTrasen Update if not specified","req"=0,"type"="str"),
		"body" = list("name"="body","desc"="The message body that should be sent","req"=1,"type"="str"),
		"type" = list("name"="type","desc"="The type of the message that should be sent, Defaults to freeform","req"=0,"type"="slct","options"=list("freeform","ccia")),
		"sendername" = list("name"="sendername","desc"="IC Name of the sender for the CCIA Report, Defaults to CCIAAMS, \[Command-StationName\]","req"=0,"type"="str"),
		"announce" = list("name"="announce","desc"="If the report should be announce 1 -> Yes, 0 -> No, Defaults to 1","req"=0,"type"="int")
		)
/datum/topic_command/send_commandreport/run_command(queryparams)
	var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
	var/reporttitle = sanitizeSafe(queryparams["title"]) //Title of the report
	var/reportbody = nl2br(sanitize(queryparams["body"],encode=0,extra=0,max_length=0)) //Body of the report
	var/reporttype = queryparams["type"] //Type of the report: freeform / ccia / admin
	var/reportsender = sanitizeSafe(queryparams["sendername"]) //Name of the sender
	var/reportannounce = text2num(queryparams["announce"]) //Announce the contents report to the public: 1 / 0

	if(!reporttitle)
		reporttitle = "NanoTrasen Update"
	if(!reporttype)
		reporttype = "freeform"
	if(!reportannounce)
		reportannounce = 1

	//Set the report footer for CCIA Announcements
	if (reporttype == "ccia")
		if (reportsender)
			reportbody += "<br><br>- [reportsender], Central Command Internal Affairs Agent, [commstation_name()]"
		else
			reportbody += "<br><br>- CCIAAMS, [commstation_name()]"

	//Send the message to the communications consoles
	post_comm_message(reporttitle, reportbody)

	if(reportannounce == 1)
		command_announcement.Announce(reportbody, reporttitle, new_sound = 'sound/AI/commandreport.ogg', do_newscast = 1, msg_sanitized = 1);
	if(reportannounce == 0)
		to_world("<span class='alert'>New NanoTrasen Update available at all communication consoles.</span>")
		to_world(sound('sound/AI/commandreport.ogg'))


	log_admin("[senderkey] has created a command report via the api: [reportbody]",admin_key=senderkey)
	message_admins("[senderkey] has created a command report via the api", 1)

	statuscode = 200
	response = "Command Report sent"
	data = null
	return 1

//Send Fax
/datum/topic_command/send_fax
	name = "send_fax"
	description = "Sends a fax"
	params = list(
		"senderkey" = list("name"="senderkey","desc"="Unique id of the person that sent the fax","req"=1,"type"="senderkey"),
		"title" = list("name"="title","desc"="The message title that should be sent","req"=1,"type"="str"),
		"body" = list("name"="body","desc"="The message body that should be sent","req"=1,"type"="str"),
		"target" = list("name"="target","desc"="The target faxmachines the fax should be sent to","req"=1,"type"="lst")
		)
/datum/topic_command/send_fax/run_command(queryparams)
	var/list/responselist = list()
	var/list/sendsuccess = list()
	var/list/targetlist = queryparams["target"] //Target locations where the fax should be sent to
	var/senderkey = sanitize(queryparams["senderkey"]) //Identifier of the sender (Ckey / Userid / ...)
	var/faxtitle = sanitizeSafe(queryparams["title"]) //Title of the report
	var/faxbody = sanitize(queryparams["body"],max_length=0) //Body of the report
	var/faxannounce = text2num(queryparams["announce"]) //Announce the contents report to the public: 0 - Dont announce, 1 - Announce, 2 - Only if pda not linked

	if(!targetlist || targetlist.len < 1)
		statuscode = 400
		response = "Parameter target not set"
		data = null
		return 1

	var/sendresult = 0
	var/notifyresult = 1

	//Send the fax
	for (var/obj/machinery/photocopier/faxmachine/F in allfaxes)
		if (F.department in targetlist)
			sendresult = send_fax(F, faxtitle, faxbody, senderkey)
			if (sendresult == 1)
				sendsuccess.Add(F.department)
				if(!LAZYLEN(F.alert_pdas))
					notifyresult = 0
					responselist[F.department] = "notlinked"
				else
					responselist[F.department] = "success"
			else
				responselist[F.department] = "failed"

	//Announce that the fax has been sent
	if(faxannounce == 1 || (faxannounce==2 && notifyresult==0))
		if(sendsuccess.len < 1)
			command_announcement.Announce("A fax message from Central Command could not be delivered because all of the following fax machines are inoperational: <br>"+jointext(targetlist, ", "), "Fax Delivery Failure", new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);
		else
			command_announcement.Announce("A fax message from Central Command has been sent to the following fax machines: <br>"+jointext(sendsuccess, ", "), "Fax Received", new_sound = 'sound/AI/commandreport.ogg', msg_sanitized = 1);

	log_admin("[senderkey] sent a fax via the API: : [faxbody]",admin_key=senderkey)
	message_admins("[senderkey] sent a fax via the API", 1)

	statuscode = 200
	response = "Fax sent"
	data = responselist
	return 1

/datum/topic_command/send_fax/proc/send_fax(var/obj/machinery/photocopier/faxmachine/F, title, body, senderkey)
	// Create the reply message
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( null ) //hopefully the null loc won't cause trouble for us
	P.name = "[current_map.boss_name] - [title]"
	P.info = body
	P.update_icon()

	// Stamps
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!P.stamped)
		P.stamped = new
	P.stamped += /obj/item/weapon/stamp
	P.add_overlay(stampoverlay)
	P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

	if(F.receivefax(P))
		log_and_message_admins("[senderkey] sent a fax message to the [F.department] fax machine via the api. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[F.x];Y=[F.y];Z=[F.z]'>JMP</a>)")
		sent_faxes += P
		return 1
	else
		qdel(P)
		return 0

// Update discord_bot's channels.
/datum/topic_command/update_bot_channels
	name = "update_bot_channels"
	description = "Tells the ingame instance of the Discord bot to update its cached channels list."

/datum/topic_command/update_bot_channels/run_command()
	data = null

	if (!discord_bot)
		statuscode = 404
		response = "Ingame Discord bot not initialized."
		return 1

	switch (discord_bot.update_channels())
		if (1)
			statuscode = 404
			response = "Ingame Discord bot is not active."
		if (2)
			statuscode = 500
			response = "Ingame Discord bot encountered error attempting to access database."
		else
			statuscode = 200
			response = "Ingame Discord bot's channels were successfully updated."

	return 1

// Gets the currently configured access levels
/datum/topic_command/get_access_levels
	name = "get_access_levels"
	description = "Gets the currently configured access levels."

/datum/topic_command/get_access_levels/run_command()
	var/list/access_levels = list()
	for(var/datum/access/acc in get_all_access_datums())
		access_levels.Add(list(acc.get_info_list()))

	data = access_levels
	statuscode = 200
	response = "Levels Sent"
	return 1

// Reloads the current cargo configuration
/datum/topic_command/cargo_reload
	name = "cargo_reload"
	description = "Reloads the current cargo configuration."
	params = list(
		"force" = list("name"="force","desc"="Force the reload even if orders have already been placed","type"="int","req"=0)
	)

/datum/topic_command/cargo_reload/run_command(queryparams)
	var/force = text2num(queryparams["force"])
	if(!SScargo.get_order_count())
		SScargo.load_from_sql()
		message_admins("Cargo has been reloaded via the API.")
		statuscode = 200
		response = "Cargo Reloaded from SQL."
	else
		if(force)
			SScargo.load_from_sql()
			message_admins("Cargo has been force-reloaded via the API. All current orders have been purged.")
			statuscode = 200
			response = "Cargo Force-Reloaded from SQL."
		else
			statuscode = 500
			response = "Orders have been placed. Use force parameter to overwrite."
	return 1

//Gets a overview of all polls (title, id, type)
/datum/topic_command/get_polls
	name = "get_polls"
	description = "Gets a overview of all polls."
	params = list(
		"current_only" = list("name"="current_only","desc"="Only get information about the current polls","type"="int","req"=0),
		"admin_only" = list("name"="admin_only","desc"="Only get information about the admin_only polls","type"="int","req"=0)
	)

/datum/topic_command/get_polls/run_command(queryparams)
	var/current_only = text2num(queryparams["current_only"])
	var/admin_only = text2num(queryparams["admin_only"])

	if(!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB-Connection unavailable"
		return 1

	var/list/polldata = list()

	var/DBQuery/select_query = dbcon.NewQuery("SELECT id, polltype, starttime, endtime, question, multiplechoiceoptions, adminonly FROM ss13_poll_question [(current_only || admin_only) ? "WHERE" : ""] [(admin_only ? "adminonly = true " : "")][(current_only && admin_only ? "AND " : "")][(current_only ? "Now() BETWEEN starttime AND endtime" : "")]")
	select_query.Execute()
	while(select_query.NextRow())
		polldata["[select_query.item[1]]"] = list(
			"id"=select_query.item[1],
			"polltype"=select_query.item[2],
			"starttime"=select_query.item[3],
			"endtime"=select_query.item[4],
			"question"=select_query.item[5],
			"multiplechoiceoptions"=select_query.item[6],
			"adminonly"=select_query.item[7]
			)

	statuscode = 200
	response = "Polldata sent"
	data = polldata
	return 1


// Gets infos about a poll
/datum/topic_command/get_poll_info
	name = "get_poll_info"
	description = "Gets Information about a poll."
	params = list(
		"poll_id" = list("name"="poll_id","desc"="The poll id that should be queried","type"="int","req"=1)
	)

/datum/topic_command/get_poll_info/run_command(queryparams)
	var/poll_id = text2num(queryparams["poll_id"])

	if(!establish_db_connection(dbcon))
		statuscode = 500
		response = "DB-Connection unavailable"
		return 1

	//Get general data about the poll
	var/DBQuery/select_query = dbcon.NewQuery("SELECT id, polltype, starttime, endtime, question, multiplechoiceoptions, adminonly, publicresult, viewtoken FROM ss13_poll_question WHERE id = :poll_id:")
	select_query.Execute(list("poll_id"=poll_id))

	//Check if the poll exists
	if(!select_query.NextRow())
		statuscode = 404
		response = "The requested poll does not exist"
		data = null
		return 1
	var/list/poll_data = list(
		"id"=select_query.item[1],
		"polltype"=select_query.item[2],
		"starttime"=select_query.item[3],
		"endtime"=select_query.item[4],
		"question"=select_query.item[5],
		"multiplechoiceoptions"=select_query.item[6],
		"adminonly"=select_query.item[7],
		"publicresult"=select_query.item[8]
		)

	//Lets add a WI link to the poll, if we have the WI configured
	if(config.webint_url)
		poll_data["link"]="[config.webint_url]server/poll/[select_query.item[1]]/[select_query.item[9]]"

	var/list/result_data = list()

	/** Return different data based on the poll type: */
	//If we have a option or a multiple choice poll, return the number of options
	if(poll_data["polltype"] == "OPTION" || poll_data["polltype"] == "MULTICHOICE")
		var/DBQuery/result_query = dbcon.NewQuery({"SELECT ss13_poll_vote.optionid, ss13_poll_option.text, COUNT(*) as option_count
			FROM ss13_poll_vote
			LEFT JOIN ss13_poll_option ON ss13_poll_vote.optionid = ss13_poll_option.id
			WHERE ss13_poll_vote.pollid = :poll_id:
			GROUP BY ss13_poll_vote.optionid"})
		result_query.Execute(list("poll_id"=poll_id))

		while(result_query.NextRow())
			result_data["[result_query.item[1]]"] = list(
				"option_id"=result_query.item[1],
				"option_question"=result_query.item[2],
				"option_count"=result_query.item[3]
			)
		if(!length(result_data))
			statuscode = 500
			response = "No data returned by result query."
			data = null
			return 1

	//If we have a numval poll, return the options with the min, max, and average
	else if(poll_data["polltype"] == "NUMVAL")
		var/DBQuery/result_query = dbcon.NewQuery({"SELECT ss13_poll_vote.optionid, ss13_poll_option.text, ss13_poll_option.minval, ss13_poll_option.maxval, ss13_poll_option.descmin, ss13_poll_option.descmid, ss13_poll_option.descmax, AVG(rating) as option_rating_avg, MIN(rating) as option_rating_min, MAX(rating) as option_rating_max
		FROM ss13_poll_vote
		LEFT JOIN ss13_poll_option ON ss13_poll_vote.optionid = ss13_poll_option.id
		WHERE ss13_poll_vote.pollid = :poll_id:
		GROUP BY ss13_poll_vote.optionid"})
		result_query.Execute(list("poll_id"=poll_id))
		while(result_query.NextRow())
			result_data["[result_query.item[1]]"] = list(
				"option_id"=result_query.item[1],
				"option_question"=result_query.item[2],
				"option_minval"=result_query.item[3],
				"option_maxval"=result_query.item[4],
				"option_descmin"=result_query.item[5],
				"option_descmid"=result_query.item[6],
				"option_descmax"=result_query.item[7],
				"option_rating_min"=result_query.item[8],
				"option_rating_max"=result_query.item[9],
				"option_rating_avg"=result_query.item[10] //TODO: Expand that with MEDIAN once we upgrade mariadb
			)
		if(!length(result_data))
			statuscode = 500
			response = "No data returned by result query."
			data = null
			return 1

	//If we have a textpoll, return the number of answers
	else if(poll_data["polltype"] == "TEXT")
		var/DBQuery/result_query = dbcon.NewQuery({"SELECT COUNT(*) as count FROM ss13_poll_textreply WHERE pollid = :poll_id:"})
		result_query.Execute(list("poll_id"=poll_id))
		if(result_query.NextRow())
			result_data = list(
				"response_count"=result_query.item[1]
			)
		else
			statuscode = 500
			response = "No data returned by result query."
			data = null
			return 1
	else
		statuscode = 500
		response = "Unknown Poll Type"
		data = poll_data
		return 1


	poll_data["results"] = result_data

	statuscode = 200
	response = "Poll data fetched"
	data = poll_data
	return 1

//Sends a text to everyone on the server
/datum/topic_command/broadcast_text
	name = "broadcast_text"
	description = "Sends a text to everyone on the server."
	params = list(
		"text" = list("name"="text","desc"="The text that should be sent","req"=1,"type"="str")
	)

/datum/topic_command/broadcast_text/run_command(queryparams)
	to_world(queryparams["text"])

	statuscode = 200
	response = "Text sent"
	return 1
