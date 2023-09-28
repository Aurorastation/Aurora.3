/singleton/psionic_power/jump
	name = "Jump"
	desc = "Teleport to a destination you click on."
	icon_state = "tech_dispel"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/jump

/obj/item/spell/jump
	name = "jump"
	icon_state = "warp_strike"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 15

/obj/item/spell/jump/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	. = ..()
	if(!.)
		return
	user.visible_message(SPAN_WARNING("[user] warps and disappears!"), SPAN_WARNING("You weave the Nlom to bring you to your destination!"))
	do_teleport(user, hit_atom)
