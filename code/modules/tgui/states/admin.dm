/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: staff_state
 *
 * Checks that the user has the correlating rights.
 */

GLOBAL_DATUM_INIT(admin_state, /datum/ui_state/admin_state, new(R_ADMIN))
GLOBAL_DATUM_INIT(moderator_state, /datum/ui_state/admin_state, new(R_MOD))
GLOBAL_DATUM_INIT(debug_state, /datum/ui_state/admin_state, new(R_DEBUG))
GLOBAL_DATUM_INIT(fun_state, /datum/ui_state/admin_state, new(R_FUN))
GLOBAL_DATUM_INIT(staff_state, /datum/ui_state/admin_state, new)

/datum/ui_state/admin_state
	var/rights_to_check = null

/datum/ui_state/admin_state/can_use_topic(src_object, mob/user)
	if(!rights_to_check)
		return user.client.holder ? UI_INTERACTIVE : UI_CLOSE
	if(check_rights(rights_to_check, user=user))
		return UI_INTERACTIVE
	return UI_CLOSE
