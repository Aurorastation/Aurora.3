/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: heavy_vehicle
 *
 * Checks that the user is inside a mech, that the mech is powered and is the right one.
 *
 */

GLOBAL_DATUM_INIT(heavy_vehicle_state, /datum/ui_state/heavy_vehicle, new)

/datum/ui_state/heavy_vehicle/can_use_topic(src_object, mob/user)
	. = user.shared_ui_interaction(src_object)

	if(!istype(src_object, /obj/item/mecha_equipment))
		return
	var/obj/item/mecha_equipment/mecha_equip = src_object
	if(ismech(user.loc))
		var/mob/living/heavy_vehicle/mech = user.loc
		if(mecha_equip.owner == mech && mech.power == MECH_POWER_ON)
			return UI_INTERACTIVE
