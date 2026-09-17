/datum/computer_file/program/bartending_codex
	filename = "barcodex"
	filedesc = "Bartending Codex"
	program_icon_state = "generic"
	program_key_icon_state = "teal_key"
	extended_desc = "Useful program to view cocktail recipes and how to make them."
	size = 2
	required_access_download = null
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	tgui_id = "ChemCodex"

/datum/computer_file/program/bartending_codex/ui_data(mob/user)
	var/list/data = list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	// Here goes listification
	if(!data["reactions"])
		data["reactions"] = SScodex.bartending_codex_data

	return data
