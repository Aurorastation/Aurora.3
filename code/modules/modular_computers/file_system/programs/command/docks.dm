/datum/computer_file/program/docks
	filename = "docks"
	filedesc = "Docking Ports Management Program"
	nanomodule_path = /datum/nano_module/program/docks
	program_icon_state = "docks"
	program_key_icon_state = "lightblue_key"
	extended_desc = "Used to manage the docks, and any docked ships."
	required_access_run = access_heads
	required_access_download = access_heads
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	requires_ntnet = FALSE
	size = 8
	color = LIGHT_COLOR_BLUE

/datum/nano_module/program/docks
	name = "Docking Ports Management Program"

/datum/nano_module/program/docks/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/program = host
	var/obj/item/modular_computer/computer = program.computer
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

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "docks.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()

datum/nano_module/program/docks/Topic(href, href_list)
	if(..())
		return TRUE

	switch(href_list["action"])
		if("reconnect")
			var/datum/computer_file/program/program = host
			var/obj/item/modular_computer/computer = program.computer
			computer.sync_linked()

	SSnanoui.update_uis(src)
	return TRUE

