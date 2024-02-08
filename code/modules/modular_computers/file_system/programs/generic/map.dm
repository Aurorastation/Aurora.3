/datum/computer_file/program/map
	filename = "map"
	filedesc = "Map Program"
	extended_desc = "This program may be used to see the decks or levels of the vessel, station, or ship."
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

	var/z_level = z_override ? z_override : user.z
	if(z_level in SSatlas.current_map.station_levels)
		data["map_image"] = SSholomap.minimaps_area_colored_base64[z_level]

	data["user_x"] = user.x
	data["user_y"] = user.y
	data["user_z"] = user.z
	data["station_levels"] = SSatlas.current_map.station_levels
	data["z_override"] = z_override

	data["dept_colors_map"] = list(
		list("d"="Command", "c"=HOLOMAP_AREACOLOR_COMMAND),
		list("d"="Security", "c"=HOLOMAP_AREACOLOR_SECURITY),
		list("d"="Medical", "c"=HOLOMAP_AREACOLOR_MEDICAL),
		list("d"="Science", "c"=HOLOMAP_AREACOLOR_SCIENCE),
		list("d"="Engineering", "c"=HOLOMAP_AREACOLOR_ENGINEERING),
		list("d"="Operations", "c"=HOLOMAP_AREACOLOR_OPERATIONS),
		list("d"="Civilian", "c"=HOLOMAP_AREACOLOR_CIVILIAN),
		list("d"="Hallways", "c"=HOLOMAP_AREACOLOR_HALLWAYS),
		list("d"="Dock", "c"=HOLOMAP_AREACOLOR_DOCK),
		list("d"="Hangar", "c"=HOLOMAP_AREACOLOR_HANGAR),
	)

	return data

/datum/computer_file/program/map/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "z_override")
		z_override = text2num(params["z_override"])
