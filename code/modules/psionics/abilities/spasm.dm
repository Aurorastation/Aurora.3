/singleton/psionic_power/spasm
	name = "Spasm"
	desc = "Force a target to drop the items in its hands. Note that this has a hefty power use and cooldown."
	icon_state = "genetics_closed"
	point_cost = 1
	ability_flags = PSI_FLAG_EVENT
	spell_path = /obj/item/spell/spasm

/obj/item/spell/spasm
	name = "spasm"
	desc = "Made you drop your gun."
	icon_state = "control"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 100
	/// This looks like a lot, but this ability is really strong.
	psi_cost = 20

/obj/item/spell/spasm/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(!ishuman(hit_atom))
		to_chat(user, SPAN_WARNING("That won't work!"))
		return
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = hit_atom
	H.drop_l_hand()
	H.drop_r_hand()
	to_chat(H, SPAN_DANGER("Your mind is filled by an acute pain making you drop what you're holding!"))
	H.flash_pain(50)
