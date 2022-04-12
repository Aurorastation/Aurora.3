/client/proc/edit_admin_permissions()
	set category = "Admin"
	set name = "Permissions Panel"
	set desc = "Edit admin permissions"
	if(!check_rights(R_PERMISSIONS))
		return

	var/static/datum/vueui_module/permissions_panel/global_permissions_panel = new()
	global_permissions_panel.ui_interact(usr)

/datum/vueui_module/permissions_panel

/datum/vueui_module/permissions_panel/ui_interact(mob/user)
	if (!check_rights(R_PERMISSIONS))
		return

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "admin-permissions-panel", 800, 600, "Permissions panel", state = admin_state)
		ui.header = "minimal"
		ui.data = vueui_data_change(list(), user, ui)

	ui.open()

/datum/vueui_module/permissions_panel/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = list()
	var/list/admins = list()

	for (var/admin_ckey in admin_datums)
		var/datum/admins/D = admin_datums[admin_ckey]
		if(!D)
			continue

		var/list/d = list()
		d["ckey"] = admin_ckey
		d["rank"] = D?.rank || "*none*"
		d["rights"] = rights2text(D.rights, " ") || "*none*"

		admins += list(d)

	data["admins"] = admins
	data["forumuserui_enabled"] = config.use_forumuser_api

	return data

/datum/vueui_module/permissions_panel/Topic(href, href_list)
	if (!check_rights(R_PERMISSIONS))
		log_and_message_admins("attempted to edit the admin permissions without sufficient rights.")
		return

	var/admin_ckey = ckey(href_list["ckey"])
	var/action = href_list["action"]
	var/datum/admins/D = admin_datums[admin_ckey]

	if (action != "add" && (!admin_ckey || !D))
		to_chat(usr, SPAN_NOTICE("No ckey specified or no such admin found."))
		return

	if (action == "add")
		action = "rank"
		admin_ckey = _get_admin_ckey()

		if (!admin_ckey)
			return

	if (action == "remove")
		_remove_admin(admin_ckey, D)
	else if (action == "rank")
		_edit_rank(admin_ckey, D)
	else if (action == "rights")
		_edit_rights(admin_ckey, D)

	var/list/new_data = vueui_data_change()

	for (var/U in SSvueui.get_open_uis(src))
		var/datum/vueui/ui = U
		if (ui.status <= STATUS_DISABLED)
			continue

		ui.push_change(new_data.Copy())

/datum/vueui_module/permissions_panel/proc/_remove_admin(admin_ckey, datum/admins/D)
	PRIVATE_PROC(TRUE)

	admin_datums -= admin_ckey
	D.disassociate()

	log_and_message_admins("removed [admin_ckey] from the admins list.")
	log_admin_rank_modification(admin_ckey, "Removed")

/datum/vueui_module/permissions_panel/proc/_edit_rank(admin_ckey, datum/admins/D)
	PRIVATE_PROC(TRUE)

	var/new_rank
	if(admin_ranks.len)
		new_rank = input("Please select a rank", "New rank", null, null) as null|anything in (admin_ranks|"*New Rank*")
	else
		new_rank = input("Please select a rank", "New rank", null, null) as null|anything in list("Game Master","Game Admin", "Trial Admin", "Admin Observer","*New Rank*")

	var/rights = D?.rights || 0

	switch(new_rank)
		if(null, "")
			return
		if("*New Rank*")
			new_rank = input("Please input a new rank", "New custom rank", null, null) as null|text

			if(config.admin_legacy_system)
				new_rank = ckeyEx(new_rank)

			if(!new_rank)
				to_chat(usr, SPAN_ALERT("Error editing rank: invalid rank."))
				return

			if(admin_ranks.len)
				if(new_rank in admin_ranks)
					rights = admin_ranks[new_rank]		//we typed a rank which already exists, use its rights
				else
					admin_ranks[new_rank] = 0			//add the new rank to admin_ranks
		else
			rights = admin_ranks[new_rank]				//we input an existing rank, use its rights

	if(D)
		D.disassociate()								//remove adminverbs and unlink from client
		D.rank = new_rank								//update the rank
		D.rights = rights								//update the rights based on admin_ranks (default: 0)
	else
		D = new /datum/admins(new_rank, rights, admin_ckey)

	var/client/C = directory[admin_ckey]						//find the client with the specified ckey (if they are logged in)
	D.associate(C)											//link up with the client and add verbs

	log_and_message_admins("edited the admin rank of [admin_ckey] to [new_rank]")
	log_admin_rank_modification(admin_ckey, new_rank)

/datum/vueui_module/permissions_panel/proc/_edit_rights(datum/admins/D, admin_ckey)
	PRIVATE_PROC(TRUE)

	if (!D)
		return

	var/list/permissionlist = list()
	for(var/i = 1, i <= R_MAXPERMISSION, i <<= 1)
		permissionlist[rights2text(i)] = i
	var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist

	if(!new_permission)
		return

	D.rights ^= permissionlist[new_permission]

	log_and_message_admins("toggled the [new_permission] permission of [admin_ckey]")
	log_admin_permission_modification(admin_ckey, permissionlist[new_permission])

/datum/vueui_module/permissions_panel/proc/_get_admin_ckey()
	PRIVATE_PROC(TRUE)

	var/new_ckey = ckey(input(usr, "New admin's ckey", "Admin ckey", null) as text|null)
	if(!new_ckey)
		return ""

	if(new_ckey in admin_datums)
		to_chat(usr, SPAN_ALERT("[new_ckey] is already an admin."))
		return ""

	return new_ckey

/datum/vueui_module/permissions_panel/proc/log_admin_rank_modification(admin_ckey, new_rank)
	if (config.admin_legacy_system)
		return

	if (!check_rights(R_PERMISSIONS))
		to_chat(usr, SPAN_DANGER("You do not have permission to do this!"))
		return

	if (!establish_db_connection(dbcon))
		to_chat(usr, SPAN_WARNING("Failed to establish database connection."))
		return

	if (!admin_ckey || !new_rank)
		return

	admin_ckey = ckey(admin_ckey)

	if (!istext(admin_ckey) || !istext(new_rank))
		return

	var/DBQuery/select_query = dbcon.NewQuery("SELECT ckey FROM `ss13_admins` WHERE ckey = :ckey:")
	select_query.Execute(list("ckey" = admin_ckey))

	var/new_admin = TRUE
	if (select_query.NextRow())
		new_admin = FALSE

	if (new_admin)
		var/DBQuery/update_query = dbcon.NewQuery("INSERT INTO `ss13_admins` VALUES (:ckey:, :rank:, 0)")
		update_query.Execute(list("ckey" = admin_ckey, "rank" = new_rank))
		to_chat(usr, SPAN_NOTICE("New admin added to the DB."))

	else if (new_rank != "Removed")
		var/DBQuery/insert_query = dbcon.NewQuery("UPDATE `ss13_admins` SET rank = :rank: WHERE ckey = :ckey:")
		insert_query.Execute(list("ckey" = admin_ckey, "rank" = new_rank))
		to_chat(usr, SPAN_NOTICE("Admin's rank changed."))

	else if (new_rank == "Removed")
		var/DBQuery/insert_query = dbcon.NewQuery("DELETE FROM ss13_admins WHERE ckey = :ckey:")
		insert_query.Execute(list("ckey" = admin_ckey))
		to_chat(usr, SPAN_NOTICE("Admin removed."))

/datum/vueui_module/permissions_panel/proc/log_admin_permission_modification(admin_ckey, new_permission)
	if (config.admin_legacy_system)
		return

	if (!check_rights(R_PERMISSIONS))
		to_chat(usr, SPAN_DANGER("You do not have permission to do this!"))
		return

	if (!establish_db_connection(dbcon))
		to_chat(usr, SPAN_WARNING("Failed to establish database connection."))
		return

	if(!admin_ckey || !new_permission)
		return

	admin_ckey = ckey(admin_ckey)

	if(istext(new_permission))
		new_permission = text2num(new_permission)

	if(!istext(admin_ckey) || !isnum(new_permission))
		return

	var/DBQuery/select_query = dbcon.NewQuery("SELECT flags FROM ss13_admins WHERE ckey = :ckey:")
	select_query.Execute(list("ckey" = admin_ckey))

	var/admin_rights = 0
	if (select_query.NextRow())
		admin_rights = text2num(select_query.item[1])
	else
		return

	if(admin_rights & new_permission) //This admin already has this permission, so we are removing it.
		var/DBQuery/insert_query = dbcon.NewQuery("UPDATE `ss13_admins` SET flags = :flags: WHERE ckey = :ckey:")
		insert_query.Execute(list("flags" = admin_rights & ~new_permission, "ckey" = admin_ckey))
		to_chat(usr, SPAN_NOTICE("Permission removed."))
	else //This admin doesn't have this permission, so we are adding it.
		var/DBQuery/insert_query = dbcon.NewQuery("UPDATE `ss13_admins` SET flags = :flags: WHERE ckey = :ckey:")
		insert_query.Execute(list("flags" = admin_rights | new_permission, "ckey" = admin_ckey))
		to_chat(usr, SPAN_NOTICE("Permission added."))
