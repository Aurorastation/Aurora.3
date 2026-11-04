/datum/computer_file/program/chemistry_codex
	filename = "chemcodex"
	filedesc = "Chemistry Codex"
	program_icon_state = "medcomp"
	program_key_icon_state = "teal_key"
	extended_desc = "Useful program to view chemical reactions and how to make them."
	size = 14
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_run = list(/datum/access/medical::id, /datum/access/research::id)
	required_access_download = list(/datum/access/medical::id, /datum/access/research::id)
	available_on_ntnet = TRUE
	tgui_id = "ChemCodex"

/datum/computer_file/program/chemistry_codex/ui_data(mob/user)
	var/list/data = list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	// Here goes listification
	if(!data["reactions"])
		data["reactions"] = SScodex.chemistry_codex_data

	return data
