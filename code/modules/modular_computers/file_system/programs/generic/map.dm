/datum/computer_file/program/map
	filename = "map"
	filedesc = "Map Program"
	extended_desc = "..."
	program_icon_state = "map"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE
	size = 4
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	tgui_id = "Map"

/datum/computer_file/program/map/ui_data(mob/user)
	var/list/data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	// var/map_image = SSholomap.holo_minimaps[3]
	// data["map_image"] = icon2base64(map_image)

	var/list/map_images = list()
	for(var/map_image in SSholomap.holo_minimaps)
		map_images += icon2base64(map_image)

	data["map_images"] = map_images

	return data

/datum/computer_file/program/map/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
