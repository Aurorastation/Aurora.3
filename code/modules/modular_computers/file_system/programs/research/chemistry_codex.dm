/datum/computer_file/program/chemistry_codex
	filename = "chemcodex"
	filedesc = "Chemistry Codex"
	program_icon_state = "medcomp"
	program_key_icon_state = "teal_key"
	extended_desc = "Useful program to view chemical reactions and how to make them."
	size = 14
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_run = list(access_medical, access_research)
	required_access_download = list(access_medical, access_research)
	available_on_ntnet = TRUE

/datum/computer_file/program/chemistry_codex/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-chemcodex", 450, 600, filedesc)
	ui.open()

/datum/computer_file/program/chemistry_codex/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-chemcodex", 450, 600, filedesc)
	return TRUE

// Gathers data for ui. This is not great vueui example, all data sent from server is static.
/datum/computer_file/program/chemistry_codex/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	// Here goes listification
	if(data["reactions"] == null)
		. = data
		data["reactions"] = SSchemistry.codex_data
