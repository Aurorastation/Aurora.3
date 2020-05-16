/mob/living/carbon/alien/diona/attack_hand(mob/living/carbon/human/M)
	if(istype(M) && M.a_intent == I_HELP && !stat)
		if(M.is_diona() && do_merge(M))
			return
		M.visible_message(span("notice", "[M] pets \the [src]."))
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
		if(H.species && H.species.name == "Diona" && do_merge(H))
			return
		get_scooped(H) // GET SCOOPED - geeves
		return
	else if(H.a_intent == I_GRAB && hat && !(H.l_hand && H.r_hand))
		hat.forceMove(get_turf(src))
		H.put_in_hands(hat)
		H.visible_message(span("warning", "\The [H] removes \the [src]'s [hat]."))
		hat = null
		update_icons()
	else
		return ..()

/mob/living/carbon/alien/diona/attackby(var/obj/item/W, var/mob/user)
	if(user.a_intent == I_HELP && istype(W, /obj/item/clothing/head))
		if(hat)
			to_chat(user, span("warning", "\The [src] is already wearing \the [hat]."))
			return
		user.unEquip(W)
		wear_hat(W)
		user.visible_message(span("notice", "\The [user] puts \the [W] on \the [src]."))
		return
	else if(istype(W, /obj/item/reagent_containers) || istype(W, /obj/item/stack/medical) || istype(W,/obj/item/gripper/))
		..(W, user)
		return
	else if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(W, /obj/item/material/knife) || istype(W, /obj/item/material/kitchen/utensil/knife))
			harvest(user)
			return
	..(W, user)