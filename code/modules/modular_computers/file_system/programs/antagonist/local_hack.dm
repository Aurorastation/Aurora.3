/datum/computer_file/program/local_hack
	filename = "localhack"
	filedesc = "Local Area Hacktool"
	program_icon_state = "hostile"
	extended_desc = "This program allows the user to hack into various remotely accessable devices."
	available_on_ntnet = FALSE
	available_on_syndinet = TRUE
	size = 5
	usage_flags = PROGRAM_ALL_REGULAR
	color = LIGHT_COLOR_RED

/datum/computer_file/program/local_hack/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-antagonist-localhack", 500, 400, "Local Area Hacktool")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/local_hack/vueui_transfer(oldobj)
	for(var/o in SSvueui.transfer_uis(oldobj, src, "mcomputer-antagonist-localhack", 500, 400, "Local Area Hacktool"))
		var/datum/vueui/ui = o
		ui.auto_update_content = TRUE
	return TRUE

/datum/computer_file/program/local_hack/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	data["_PC"] = get_header_data(data["_PC"])

	var/list/hackables = list()

	for(var/obj/machinery/door/airlock/airlock in range(5, src))
		var/list/airlockData = list("name" = null, "location" = null, "ref" = "\ref[airlock]")

		airlockData["name"] = airlock.name
		var/turf/airlock_turf = get_turf(airlock)
		airlockData["location"] = "[airlock_turf.x], [airlock_turf.y], [airlock_turf.z]"
		hackables[++hackables.len] = airlockData

	data["hackables"] = sortByKey(hackables, "name")

	return data // This UI needs to constantly update


/datum/computer_file/program/local_hack/Topic(href, href_list)
	. = ..()

	if(href_list["hack"])
		to_chat(usr, span("notice", "You begin the hack."))
		var/obj/machinery/door/airlock/airlock = locate(href_list["hack"]) in range(5, src)
		airlock.ui_interact(usr)
		return TRUE