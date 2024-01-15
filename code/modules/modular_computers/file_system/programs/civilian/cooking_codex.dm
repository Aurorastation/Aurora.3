/datum/computer_file/program/cooking_codex
	filename = "cookcodex"
	filedesc = "Cooking Codex"
	program_icon_state = "supply"
	program_key_icon_state = "teal_key"
	extended_desc = "Useful program to view cooking recipes."
	size = 14
	required_access_download = null
	available_on_ntnet = TRUE
	tgui_id = "CookingCodex"

/datum/computer_file/program/cooking_codex/ui_data(mob/user)
	var/list/data = list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	data["recipes"] = SScodex.cooking_codex_data

	return data
