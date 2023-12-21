/datum/computer_file/program/manifest
	filename = "manifest"
	filedesc = "Crew Manifest"
	program_icon_state = "menu"
	program_key_icon_state = "black_key"
	extended_desc = "This program is used for viewing the crew manifest."
	usage_flags = PROGRAM_ALL
	size = 3
	tgui_id = "NTOSManifest"

	requires_ntnet = TRUE
	available_on_ntnet = TRUE

/datum/computer_file/program/manifest/ui_data(mob/user)
	var/list/data = initial_data()
	return data

/datum/computer_file/program/manifest/ui_static_data(mob/user)
	var/list/data = list()
	data["manifest"] = SSrecords.get_manifest_list()
	data["allow_follow"] = isobserver(usr)
	return data
