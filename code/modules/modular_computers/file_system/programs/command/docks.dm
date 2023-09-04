/datum/computer_file/program/docks
	filename = "docks"
	filedesc = "Docking Ports Management Program"
	extended_desc = "Used to manage the docks, hangars, and any docked ships."
	program_icon_state = "docks"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_run = access_heads
	required_access_download = access_heads
	usage_flags = PROGRAM_CONSOLE
	tgui_id = "Docks"

/datum/computer_file/program/docks/ui_data(mob/user)
	var/list/data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/obj/effect/overmap/visitable/connected = computer.linked

	var/list/docks = list()
	if(connected)
		data["connected_name"] = connected.name
		for(var/landmark_tag in connected.tracked_dock_tags)
			var/obj/effect/shuttle_landmark/landmark = SSshuttle.registered_shuttle_landmarks[landmark_tag]
			if(landmark && istype(landmark))
				docks[++docks.len] = list(
					"name" = landmark.name
				)
				for(var/shuttle_key in SSshuttle.shuttles)
					var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_key]
					if(shuttle && shuttle.current_location && shuttle.current_location.landmark_tag == landmark.landmark_tag)
						docks[docks.len]["shuttle"] = shuttle.name
						break
			else
				docks[++docks.len] = list(
					"name" = landmark_tag,
					"shuttle" = "???"
				)
	data["docks"] = docks

	return data

/datum/computer_file/program/docks/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
