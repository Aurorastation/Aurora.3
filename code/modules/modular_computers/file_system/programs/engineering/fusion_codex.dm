/datum/computer_file/program/fusion_codex
	filename = "fusioncodex"
	filedesc = "Fusion Codex"
	program_icon_state = "medcomp"
	program_key_icon_state = "teal_key"
	extended_desc = "Useful program to reference reaction chains for nuclear fusion reactors."
	size = 14
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_run = list(ACCESS_ENGINE)
	required_access_download = list(ACCESS_ENGINE)
	available_on_ntnet = TRUE
	tgui_id = "FusionCodex"

/datum/computer_file/program/fusion_codex/ui_data(mob/user)
	var/list/data = list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	// Here goes listification
	if(!data["reactions"])
		data["reactions"] = SScodex.fusion_codex_data

	return data
