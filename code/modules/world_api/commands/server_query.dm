//Get Server Status
/datum/topic_command/get_serverstatus
	name = "get_serverstatus"
	description = "Gets the server status."
	no_auth = TRUE

/datum/topic_command/get_serverstatus/run_command(queryparams)
	var/list/s[] = list()
	s["version"] = game_version
	s["mode"] = master_mode
	s["respawn"] = config.abandon_allowed
	s["enter"] = config.enter_allowed
	s["vote"] = config.allow_vote_mode
	s["ai"] = config.allow_ai
	s["host"] = host ? host : null
	s["stationtime"] = worldtime2text()
	s["roundduration"] = get_round_duration_formatted()
	s["gameid"] = game_id
	s["game_state"] = SSticker ? 0 : SSticker.current_state
	s["transferring"] = emergency_shuttle ? !emergency_shuttle.online() : FALSE

	s["players"] = clients.len
	s["admins"] = 0

	for(var/client/C in clients)
		if(C.holder)
			if(C.holder.fakekey)
				continue

			s["admins"]++

	statuscode = 200
	response = "Server status fetched."
	data = s
	return TRUE


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
	return TRUE

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
	return TRUE

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
	return TRUE

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
	return TRUE

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
	return TRUE

//Player Count
/datum/topic_command/get_count_player
	name = "get_count_player"
	description = "Gets the number of players connected"
	no_auth = TRUE

/datum/topic_command/get_count_player/run_command(queryparams)
	var/n = 0
	for(var/mob/M in player_list)
		if(M.client)
			n++

	statuscode = 200
	response = "Player count fetched"
	data = n
	return TRUE

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
	return TRUE

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

	statuscode = 200
	response = "Manifest fetched"
	data = positions
	return TRUE

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
	return TRUE

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
		return TRUE
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
		return TRUE
	else
		statuscode = 449
		response = "Multiple Matches found"
		data = null
		return TRUE
