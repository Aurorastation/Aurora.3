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

	/// If zero/null, show the z-level of the user, otherwise show `z_override` z-level.
	var/z_override = 0

/datum/computer_file/program/map/ui_data(mob/user)
	var/list/data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/list/map_images = list()
	for(var/map_image in SSholomap.minimaps)
		map_images += icon2base64(map_image)
	data["map_images"] = map_images

	data["user_x"] = user.x
	data["user_y"] = user.y
	data["user_z"] = user.z

	return data

/datum/computer_file/program/map/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "z_override")
		z_override = text2num(params["z_override"])
