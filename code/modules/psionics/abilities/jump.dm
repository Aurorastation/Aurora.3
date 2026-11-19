/singleton/psionic_power/jump
	name = "Jump"
	desc = "Teleport to a destination you click on."
	icon_state = "tech_dispel"
	point_cost = 3
	ability_flags = PSI_FLAG_LONER
	spell_path = /obj/item/spell/jump

/obj/item/spell/jump
	name = "jump"
	icon_state = "warp_strike"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 15

/obj/item/spell/jump/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(user.buckled_to)
		to_chat(user, SPAN_WARNING("You cannot jump while buckled down!"))
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.legcuffed)
			to_chat(user, SPAN_WARNING("You cannot jump while your legs are cuffed together!"))
			return
		var/obj/item/clothing/shoes/sneakers/orange/cuffed_shoes = H.shoes
		if(istype(cuffed_shoes) && cuffed_shoes.chained)
			to_chat(user, SPAN_WARNING("You cannot jump while your shoes are chained together!"))
			return
	. = ..()
	if(!.)
		return
	user.visible_message(SPAN_WARNING("[user] warps and disappears!"), SPAN_WARNING("You weave the Nlom to bring you to your destination!"))
	do_teleport(user, hit_atom)
