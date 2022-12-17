	// var/dat = {"
	// 	<center><B>Game Panel</B></center><hr>\n
	// 	<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
	// 	"}
	// if(master_mode == ROUNDTYPE_STR_SECRET || master_mode == ROUNDTYPE_STR_MIXED_SECRET)
	// 	dat += "<A href='?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	// dat += {"
	// 	<BR>
	// 	<A href='?src=\ref[src];create_object=1'>Create Object</A><br>
	// 	<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>
	// 	<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>
	// 	<br><A href='?src=\ref[src];vsc=airflow'>Edit Airflow Settings</A><br>
	// 	<A href='?src=\ref[src];vsc=phoron'>Edit Phoron Settings</A><br>
	// 	<A href='?src=\ref[src];vsc=default'>Choose a default ZAS setting</A><br>
	// 	"}

/datum/vueui_module/game_panel
	var/list/objects = list()

/datum/vueui_module/game_panel/New()
	objects = typesof(/obj)

/datum/vueui_module/game_panel/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "admin-game-panel", 800, 600, "Game Panel", state = staff_state)
		ui.header = "minimal"

	ui.open()

/datum/vueui_module/game_panel/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!data)
		. = data = list()

	LAZYINITLIST(data["objs"])
	if(LAZYLEN(data["objs"]) != objects.len)
		data["objs"] = objects // this should only need to happen once but just in case

	LAZYINITLIST(data["sel_objs"])

/datum/vueui_module/game_panel/Topic(href, href_list)
	if(!check_rights(R_SPAWN))
		log_and_message_admins("attempted to access the game panel without sufficient rights.")
		return
