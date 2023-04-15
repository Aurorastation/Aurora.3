/datum/computer_file/program/docks
	filename = "docks"
	filedesc = "Docking Ports Management Program"
	program_icon_state = "docks"
	program_key_icon_state = "lightblue_key"
	extended_desc = "Used to manage the docks, and any docked ships."
	required_access_run = access_heads
	required_access_download = access_heads
	usage_flags = PROGRAM_CONSOLE
	requires_ntnet = TRUE
	size = 8
	color = LIGHT_COLOR_BLUE

/datum/computer_file/program/docks/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-command-docks", 580, 700, "Docking Ports Management Program")
	ui.open()

/datum/computer_file/program/docks/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-command-docks", 580, 700, "Docking Ports Management Program")
	return TRUE

// Gathers data for ui
/datum/computer_file/program/docks/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
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
					"name" = landmark.name,
					"tag" = landmark.landmark_tag
				)
				for(var/shuttle_key in SSshuttle.shuttles)
					var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_key]
					if(shuttle && shuttle.current_location && shuttle.current_location.landmark_tag == landmark.landmark_tag)
						docks[docks.len]["shuttle"] = shuttle.name
						break
			else
				docks[++docks.len] = list(
					"name" = landmark_tag,
					"tag" = landmark_tag,
					"shuttle" = "???"
				)
	data["docks"] = docks

	return data

/datum/computer_file/program/docks/Topic(href, href_list)
	. = ..()

	switch(href_list["action"])
		if("reconnect")
			computer.sync_linked()

	SSvueui.check_uis_for_change(src)
