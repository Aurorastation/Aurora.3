/mob/living/carbon/alien/diona/attack_hand(mob/living/carbon/human/M as mob)
	if(istype(M) && M.a_intent == I_HELP && !(src.stat & DEAD))
		if(M.species && M.species.name == "Diona" && do_merge(M))
			return
		M.visible_message("\blue [M] pets the [src]")
		return
	else if (src.stat & DEAD)
		get_scooped(M)
	..()

/mob/living/carbon/alien/diona/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H))
		return ..()
	get_scooped(H, usr)
	return
