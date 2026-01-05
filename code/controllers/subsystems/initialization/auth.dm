// This subsystem loads later in the init process. Not last, but after most major things are done.

SUBSYSTEM_DEF(auth)
	name = "Auth"
	init_order = INIT_ORDER_AUTH
	flags = SS_NO_FIRE


	var/list/admin_ranks = list() //list of all ranks with associated rights

/datum/controller/subsystem/auth/Initialize(timeofday)
	load_admin_ranks()
	load_admins()

	if (GLOB.config.use_authentik_api)
		update_admins_from_authentik(TRUE)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/auth/proc/load_admin_ranks(rank_file="config/admin_ranks.json")
	admin_ranks.Cut()

	if(!(rustg_file_exists(rank_file) == "true"))
		log_config("The file [rank_file] does not exist, unable to load the admin ranks.")
		return

	var/list/data = json_decode(file2text(rank_file))

	for (var/list/group in data)
		var/datum/admin_rank/rank = new(group)
		admin_ranks[rank.rank_name] = rank

/datum/controller/subsystem/auth/proc/load_admins()
	clear_admins()

	if(GLOB.config.admin_legacy_system)
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
			if(List.len != 2)
				continue

			//ckey is before the first "-"
			var/ckey = ckey(List[1])
			if(!ckey)
				continue

			//rank follows the first "-"
			var/rank = trim(List[2])

			//load permissions associated with this rank
			var/datum/admin_rank/rank_object = admin_ranks[rank]

			if (!rank_object)
				log_world("ERROR: Unrecognized rank in admins.txt: \"[rank]\"")
				continue

			//create the admin datum and store it for later use
			var/datum/admins/D = new /datum/admins(rank, rank_object?.rights || 0, ckey)

			//find the client for a ckey if they are connected and associate them with the new admin datum
			D.associate(GLOB.directory[ckey])

			LOG_DEBUG("AdminRanks: Updated Admins from Legacy System")

	else
		//The current admin system uses SQL
		if(!SSdbcore.Connect())
			log_world("ERROR: AdminRanks: Failed to connect to database in load_admins(). Reverting to legacy system.")
			log_misc("AdminRanks: Failed to connect to database in load_admins(). Reverting to legacy system.")
			GLOB.config.admin_legacy_system = 1
			load_admins()
			return

		var/datum/db_query/query = SSdbcore.NewQuery("SELECT ckey, `rank`, flags FROM ss13_admins")
		query.Execute(FALSE)

		while(query.NextRow())
			var/ckey = query.item[1]
			var/rank = query.item[2]
			var/rights = query.item[3]
			if(istext(rights))
				rights = text2num(rights)

			var/datum/admins/D = new /datum/admins(rank, rights, ckey)
			//find the client for a ckey if they are connected and associate them with the new admin datum
			D.associate(GLOB.directory[ckey])

		if(!admin_datums)
			log_world("ERROR: AdminRanks: The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			log_misc("AdminRanks: The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system.")
			GLOB.config.admin_legacy_system = 1
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


/datum/controller/subsystem/auth/proc/clear_admins()
	//clear the datums references
	admin_datums.Cut()
	for(var/s in GLOB.staff)
		var/client/C = s
		C.remove_admin_verbs()
		C.holder = null
	GLOB.staff.Cut()

	// Clears admins from the world config.
	for (var/A in world.GetConfig("admin"))
		world.SetConfig("APP/admin", A, null)


/datum/controller/subsystem/auth/proc/update_admins_from_authentik(reload_once_done=FALSE)
	if(!SSdbcore.Connect())
		log_and_message_admins("AdminRanks: Failed to connect to database in update_admins_from_authentik(). Carrying on with old staff lists.")
		return FALSE

	// Step 1: Fetch all groups from Authentik with pagination
	var/list/datum/authentik_group/all_groups = list()
	var/current_page = 1
	var/has_next = TRUE

	while (has_next)
		var/datum/http_request/authentik_api/groups_req = new()
		groups_req.prepare_groups_query(current_page)
		groups_req.begin_async()

		UNTIL(groups_req.is_complete())

		var/datum/http_response/groups_resp = groups_req.into_response()

		if (groups_resp.errored)
			log_and_message_admins("AdminRanks: Loading groups from Authentik API FAILED. Please alert web-service maintainers!")
			crash_with("Groups request errored with: [groups_resp.error]")
			return FALSE

		if (groups_resp.status_code != 200)
			log_and_message_admins("AdminRanks: Loading groups from Authentik API FAILED. Please alert web-service maintainers!")
			crash_with("Groups request failed with status code: [groups_resp.status_code] body: [json_encode(groups_resp.body)]")
			return FALSE

		// Parse groups from this page
		var/list/results = groups_resp.body["results"]
		for (var/group_data in results)
			var/datum/authentik_group/group = new(group_data)
			all_groups += group

		// Check for next page
		var/list/pagination = groups_resp.body["pagination"]
		if (pagination && pagination["next"])
			current_page = pagination["next"]
		else
			has_next = FALSE

	// Step 2: Filter groups by gameserver.sync
	var/list/datum/authentik_group/sync_groups = list()
	var/list/group_ids = list()

	for (var/datum/authentik_group/group in all_groups)
		if (group.sync_enabled)
			sync_groups += group
			group_ids += group.group_id

	if (!length(sync_groups))
		log_and_message_admins("AdminRanks: No groups with gameserver.sync enabled found in Authentik.")
		return FALSE

	// Step 3: Fetch users for sync-enabled groups with pagination
	var/list/datum/authentik_user/all_users = list()
	current_page = 1
	has_next = TRUE

	while (has_next)
		var/datum/http_request/authentik_api/users_req = new()
		users_req.prepare_users_query(group_ids, current_page)
		users_req.begin_async()

		UNTIL(users_req.is_complete())

		var/datum/http_response/users_resp = users_req.into_response()

		if (users_resp.errored)
			crash_with("Users request errored with: [users_resp.error]")
			log_and_message_admins("AdminRanks: Loading users from Authentik API FAILED. Please alert web-service maintainers immediately!")
			return FALSE

		if (users_resp.status_code != 200)
			log_and_message_admins("AdminRanks: Loading users from Authentik API FAILED. Please alert web-service maintainers!")
			crash_with("Users request failed with status code: [users_resp.status_code] body: [json_encode(users_resp.body)]")
			return FALSE


		// Parse users from this page
		var/list/user_results = users_resp.body["results"]
		for (var/user_data in user_results)
			var/datum/authentik_user/user = new(user_data)
			all_users += user

		// Check for next page
		var/list/pagination = users_resp.body["pagination"]
		if (pagination && pagination["next"])
			current_page = pagination["next"]
		else
			has_next = FALSE

	// Step 4: Process users
	var/list/datum/authentik_user/admins_to_push = list()

	for (var/datum/authentik_user/user in all_users)
		// Skip users without ckey
		if (isnull(user.ckey) || !length(user.ckey))
			LOG_DEBUG("AdminRanks: [user.username] does not have a ckey linked - Ignoring")
			continue

		// Determine primary group
		user.determine_primary_group(sync_groups)

		admins_to_push += user

	// Step 5: Update database
	var/datum/db_query/prep_query = SSdbcore.NewQuery("UPDATE ss13_admins SET status = 0")
	prep_query.Execute(FALSE) //Needs to be executed sync, as we need to wait for it to finish before we can update the admins
	qdel(prep_query)

	var/list/admins = list()
	for (var/datum/authentik_user/user in admins_to_push)
		if (isnull(user.ckey))
			LOG_DEBUG("AdminRanks: [user.username] does not have a ckey linked - Ignoring")
			continue
		var/list/admin = list()
		admin["status"] = 1
		admin["ckey"] = ckey(user.ckey)

		// Aggregate rights from all groups
		admin["flags"] = user.aggregate_rights(sync_groups)

		// Get primary rank name
		var/primary_rank = user.primary_group_name
		if (!primary_rank)
			primary_rank = "Staff Member"
		admin["rank"] = primary_rank

		admins[++admins.len] = admin
	SSdbcore.MassInsert("ss13_admins", admins, duplicate_key=FALSE, ignore_errors=FALSE, warn=TRUE, async=FALSE)

	var/datum/db_query/del_query = SSdbcore.NewQuery("DELETE FROM ss13_admins WHERE status = 0")
	del_query.Execute(FALSE)
	qdel(del_query)

	if (reload_once_done)
		load_admins()

	LOG_DEBUG("AdminRanks: Updated Admins from Authentik API")

	return TRUE
