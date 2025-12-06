/datum/component/eye/base_planner
	eye_type = /mob/abstract/eye/base_planner
	action_type = /datum/action/eye/base_planner

/datum/action/eye/base_planner
	eye_type = /mob/abstract/eye/base_planner

/datum/action/eye/base_planner/choose_blueprint_object
	name = "Choose Blueprint Object"
	procname = "choose_blueprint_object"
	button_icon_state = "pencil"
	target_type = EYE_TARGET

/datum/action/eye/base_planner/place_template
	name = "Place Template Schematic"
	procname = "place_template"
	button_icon_state = "template_insert"
	target_type = EYE_TARGET

/datum/action/eye/base_planner/erase_all
	name = "Erase All Schematics"
	procname = "erase_all"
	button_icon_state = "eraser"
	target_type = EYE_TARGET

/datum/action/eye/base_planner/help
	name = "Help"
	procname = "help"
	button_icon_state = "help"
	target_type = COMPONENT_TARGET

/datum/component/eye/base_planner/proc/help()
	if(!current_looker)
		return
	to_chat(current_looker, SPAN_NOTICE("-***********************************************************-"))
	to_chat(current_looker, SPAN_NOTICE("Left Click			= Place selected object blueprint."))
	to_chat(current_looker, SPAN_NOTICE("Control Click		= Clear blueprint objects in selected turf."))
	to_chat(current_looker, SPAN_NOTICE("Middle Mouse Click	= Copy the selected blueprint object as ."))
	to_chat(current_looker, SPAN_NOTICE("*-*********************************************************-*"))
