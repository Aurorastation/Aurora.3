var/list/admin_ranks = list()								//list of all ranks with associated rights
var/list/forum_groupids_to_ranks = list()

/datum/admin_rank
	var/rank_name
	var/group_id
	var/rights

/datum/admin_rank/New(raw_data)
	group_id = raw_data["role_id"]
	rank_name = raw_data["name"]
	rights = auths_to_rights(raw_data["auths"])

/datum/admin_rank/proc/auths_to_rights(list/auths)
	. = 0

	for (var/auth in auths)
		switch (lowertext(auth))
			if ("r_buildmode","r_build")
				. |= R_BUILDMODE
			if ("r_admin")
				. |= R_ADMIN
			if ("r_ban")
				. |= R_BAN
			if ("r_fun")						
				. |= R_FUN
			if ("r_server")					
				. |= R_SERVER
			if ("r_debug")					
				. |= R_DEBUG
			if ("r_permissions","r_rights")	
				. |= R_PERMISSIONS
			if ("r_possess")					
				. |= R_POSSESS
			if ("r_stealth")					
				. |= R_STEALTH
			if ("r_rejuv","r_rejuvinate")	
				. |= R_REJUVINATE
			if ("r_varedit")					
				. |= R_VAREDIT
			if ("r_sound","r_sounds")
				. |= R_SOUNDS
			if ("r_spawn","r_create")
				. |= R_SPAWN
			if ("r_moderator")				
				. |= R_MOD
			if ("r_developer")		
				. |= R_DEV
			if ("r_cciaa")			
				. |= R_CCIAA
			if ("r_everything","r_host","r_all")
				. |= (R_BUILDMODE | R_ADMIN | R_BAN | R_FUN | R_SERVER | R_DEBUG | R_PERMISSIONS | R_POSSESS | R_STEALTH | R_REJUVINATE | R_VAREDIT | R_SOUNDS | R_SPAWN | R_MOD | R_CCIAA | R_DEV)
			else
				crash_with("Unknown rank in [rank_file]: [auth]")

/proc/load_admin_ranks(rank_file="config/admin_ranks.json")
	admin_ranks.Cut()

	var/list/data = json_decode(file2text(rank_file))

	for (var/list/group in data)
		var/datum/admin_rank/rank = new(group)
		admin_ranks[rank.name] = rank
		forum_groupids_to_ranks["[rank.group_id]"] = rank

/hook/startup/proc/loadAdmins()
	load_admins()
	return 1

/proc/load_admins()
	clear_admins()

	if(config.admin_legacy_system)
		load_admin_ranks()

		//load text from file
		var/list/Lines = file2list("config/admins.txt")

		//process each line seperately
		for(var/line in Lines)
			if(!length(line))
				continue
			if(copytext(line,1,2) == "#")
				continue

			//Split the line at every "-"
			var/list/List = text2list(line, "-")
			if(!List.len)
				continue

			//ckey is before the first "-"
			var/ckey = ckey(List[1])
			if(!ckey)
				continue

			//rank follows the first "-"
			var/rank = ""
			if(List.len >= 2)
				rank = ckeyEx(List[2])

			//load permissions associated with this rank
			var/datum/admin_rank/rank_object = admin_ranks[rank]

			//create the admin datum and store it for later use
			var/datum/admins/D = new /datum/admins(rank, rank_object?.rights || 0, ckey)

			//find the client for a ckey if they are connected and associate them with the new admin datum
			D.associate(directory[ckey])

	else
		//The current admin system uses SQL

		establish_db_connection(dbcon)
		if(!dbcon.IsConnected())
			error("Failed to connect to database in load_admins(). Reverting to legacy system.")
			log_misc("Failed to connect to database in load_admins(). Reverting to legacy system.")
			config.admin_legacy_system = 1
			load_admins()
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, rank, (flags & 0xFFFF) as flags FROM ss13_player WHERE rank IS NOT NULL AND (flags & 0xFFFF) != 0")
		query.Execute()
		while(query.NextRow())
			var/ckey = query.item[1]
			var/rank = query.item[2]
			var/rights = query.item[3]
			if(istext(rights))
				rights = text2num(rights)
			
			var/datum/admins/D = new /datum/admins(rank, rights, ckey)
			//find the client for a ckey if they are connected and associate them with the new admin datum
			D.associate(directory[ckey])

		if(!admin_datums)
			error("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			log_misc("The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			config.admin_legacy_system = 1
			load_admins()
			return

#ifdef TESTING
	var/msg = "Admins Built:\n"
	for(var/ckey in admin_datums)
		var/rank
		var/datum/admins/D = admin_datums[ckey]
		if(D)	rank = D.rank
		msg += "\t[ckey] - [rank]\n"
	testing(msg)
#endif

/proc/clear_admins()
	//clear the datums references
	admin_datums.Cut()
	for(var/s in staff)
		var/client/C = s
		C.remove_admin_verbs()
		C.holder = null
	staff.Cut()

	// Clears admins from the world config.
	for (var/A in world.GetConfig("admin"))
		world.SetConfig("APP/admin", A, null)

/proc/update_admins_from_api(reload_once_done=FALSE)
	set background = TRUE

	if (!establish_db_connection(dbcon))
		return

	clear_admins_table()

	for (var/datum/admin_rank/rank in admin_ranks)
		var/datum/http_request/forumuser_api/req = new()

		req.prepare_roles_query(rank.group_id)
		req.begin_async()

		UNTIL(req.is_complete())

		var/datum/http_response/resp = req.into_response()

		if (resp.errored)
			crash_with("Role request errored for id [rank.group_id] with: [resp.error]")
			continue

		for (var/datum/forum_user/user in resp.body)
			insert_user_to_admins_table(user)

	if (reload_once_done)
		load_admins()

/proc/clear_admins_table()
	var/DBQuery/query = dbcon.NewQuery("TRUNCATE TABLE ss13_admins")
	query.Execute()

/proc/insert_user_to_admins_table(datum/forum_user/user)
	var/rights = 0

	for (var/group_id in (user.forum_secondary_groups + user.forum_primary_group))
		var/datum/admin_rank/r = forum_groupids_to_ranks["[group_id]"]
		if (r)
			rights |= r.rights

	var/primary_rank = forum_groupids_to_ranks["user.forum_primary_group"]?.rank_name || "Administrator"

	var/DBQuery/query = dbcon.NewQuery("INSERT INTO ss13_admins VALUES (:ckey:, :rank:, :flags:)")
	query.Execute(list("ckey" = ckey(user.ckey), "rank" = primary_rank, "flags" = rights))
