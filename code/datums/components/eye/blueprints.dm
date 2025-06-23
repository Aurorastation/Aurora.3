/datum/component/eye/blueprints
	eye_type = /mob/abstract/eye/blueprints
	action_type = /datum/action/eye/blueprints

/datum/action/eye/blueprints
	eye_type = /mob/abstract/eye/blueprints

/datum/action/eye/blueprints/mark_new_area
	name = "Mark New Area"
	procname = "create_area"
	button_icon_state = "pencil"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/remove_selection
	name = "Remove Selection"
	procname = "remove_selection"
	button_icon_state = "eraser"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/edit_area
	name = "Edit Area"
	procname = "edit_area"
	button_icon_state = "edit_area"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/remove_area
	name = "Remove Area"
	procname = "remove_area"
	button_icon_state = "remove_area"
	target_type = EYE_TARGET

/datum/action/eye/blueprints/help
	name = "Help"
	procname = "help"
	button_icon_state = "help"
	target_type = COMPONENT_TARGET

/datum/component/eye/blueprints/proc/help()
	if(!current_looker)
		return
	to_chat(current_looker, SPAN_NOTICE("***********************************************************"))
	to_chat(current_looker, SPAN_NOTICE("Left Click		= Select Area"))
	to_chat(current_looker, SPAN_NOTICE("Shift Click    = Deselect Area"))
	to_chat(current_looker, SPAN_NOTICE("Control Click	= Clear Selection"))
	to_chat(current_looker, SPAN_NOTICE("***********************************************************"))

/datum/component/eye/blueprints/shuttle
	eye_type = /mob/abstract/eye/blueprints/shuttle
