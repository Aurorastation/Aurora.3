/mob/living/carbon/proc/handcuff_update()
	if(handcuffed)
		drop_r_hand()
		drop_l_hand()
		stop_pulling()
		throw_alert("Handcuffed", /atom/movable/screen/alert/restrained/handcuffed, new_master = handcuffed)
	else
		clear_alert("Handcuffed")
		if(buckled_to && buckled_to.buckle_require_restraints)
			buckled_to.unbuckle()
	update_inv_handcuffed()

/mob/living/carbon/proc/legcuff_update()
	if(legcuffed)
		throw_alert("Legcuffed", /atom/movable/screen/alert/restrained/legcuffed, new_master = legcuffed)
	else
		clear_alert("Legcuffed")
	update_inv_legcuffed()

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0

	else if (W == handcuffed)
		handcuffed = null
		handcuff_update()

	else if (W == legcuffed)
		legcuffed = null
		legcuff_update()
	else
		..()

	return
