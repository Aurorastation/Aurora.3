/datum/tgui_module/ui_state(mob/user)
	return always_state

/datum/tgui_module/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/tgui_module/moderator/ui_state(mob/user)
	return moderator_state

/datum/tgui_module/admin/ui_state(mob/user)
	return admin_state
