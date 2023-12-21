/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: staff_state
 *
 * Checks that the user has the correlating rights.
 */

/var/global/datum/ui_state/admin_state/admin_state = new(R_ADMIN)
/var/global/datum/ui_state/admin_state/moderator_state = new(R_MOD)
/var/global/datum/ui_state/admin_state/debug_state = new(R_DEBUG)
/var/global/datum/ui_state/admin_state/fun_state = new(R_FUN)
/var/global/datum/ui_state/admin_state/staff_state = new()

/datum/ui_state/admin_state
	var/rights_to_check = null

/datum/ui_state/admin_state/can_use_topic(src_object, mob/user)
	if(!rights_to_check)
		return user.client.holder ? UI_INTERACTIVE : UI_CLOSE
	if(check_rights(rights_to_check, user=user))
		return UI_INTERACTIVE
	return UI_CLOSE
