/singleton/psionic_power/barrier
	name = "Psionic Barrier"
	desc = "Activate in hand to give yourself psionic armour. This armour is slightly worse than generic heavy armour, and has a small passive upkeep."
	icon_state = "const_mend"
	point_cost = 1
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/barrier

/obj/item/spell/barrier
	name = "psionic barrier"
	icon_state = "generic"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 20
	psi_cost = 30

/obj/item/spell/barrier/on_use_cast(mob/user, bypass_psi_check)
	if(!ishuman(user))
		return
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = user
	var/armor = H.psi.GetComponent(/datum/component/armor/psionic)
	if(armor)
		to_chat(H, SPAN_WARNING("You are already enveloped by psionic armour!"))
		return
	to_chat(H, SPAN_NOTICE("You are enveloped by a protective warmth."))
	H.psi.AddComponent(/datum/component/armor/psionic, list(LASER = ARMOR_LASER_MEDIUM, BULLET = ARMOR_BALLISTIC_CARBINE, ENERGY = ARMOR_ENERGY_RESISTANT, MELEE = ARMOR_MELEE_RESISTANT))
