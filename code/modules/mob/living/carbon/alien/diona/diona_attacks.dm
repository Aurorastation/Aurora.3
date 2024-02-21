/mob/living/carbon/alien/diona/attack_hand(mob/living/carbon/human/M)
	if(istype(M) && M.a_intent == I_HELP && !stat)
		if(M.is_diona() && do_merge(M))
			return
		M.visible_message(SPAN_NOTICE("[M] pets \the [src]."))
		return
	else if (stat == DEAD)
		get_scooped(M) // GET SCOOPED - geeves
	..()

//#TODO-MERGE: Test nymph hats
/mob/living/carbon/alien/diona/MouseDrop(atom/over_object)
	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H))
		return ..()
	if(H.a_intent == I_HELP)
		if(H.species && H.species.name == SPECIES_DIONA && do_merge(H))
			return
		get_scooped(H) // GET SCOOPED - geeves
		return
	else if(H.a_intent == I_GRAB && hat && !(H.l_hand && H.r_hand))
		hat.forceMove(get_turf(src))
		H.put_in_hands(hat)
		H.visible_message(SPAN_WARNING("\The [H] removes \the [src]'s [hat]."))
		hat = null
		update_icon()
	else
		return ..()

/mob/living/carbon/alien/diona/attackby(obj/item/attacking_item, mob/user)
	if(user.a_intent == I_HELP && istype(attacking_item, /obj/item/clothing/head))
		if(hat)
			to_chat(user, SPAN_WARNING("\The [src] is already wearing \the [hat]."))
			return
		user.unEquip(attacking_item)
		wear_hat(attacking_item)
		user.visible_message(SPAN_NOTICE("\The [user] puts \the [attacking_item] on \the [src]."))
		return
	else if(istype(attacking_item, /obj/item/reagent_containers) || istype(attacking_item, /obj/item/stack/medical) || istype(attacking_item,/obj/item/gripper/))
		..()
		return
	else if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(attacking_item, /obj/item/material/knife) || istype(attacking_item, /obj/item/material/kitchen/utensil/knife))
			harvest(user)
			return
	..(attacking_item, user)
