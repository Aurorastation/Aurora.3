/singleton/psionic_power/mind_muddle
	name = "Mind Muddle"
	desc = "Use this at range to confuse a target and give them a little bit of pain."
	icon_state = "wiz_tele"
	point_cost = 1
	ability_flags = PSI_FLAG_EVENT
	spell_path = /obj/item/spell/mind_muddle

/obj/item/spell/mind_muddle
	name = "mind muddle"
	desc = "Confuse people. That's all it does. Oh, and the pain."
	icon_state = "warp_strike"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 20
	psi_cost = 10

/obj/item/spell/mind_muddle/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(!ishuman(hit_atom))
		to_chat(user, SPAN_WARNING("That won't work on them!"))
		return
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = hit_atom
	H.confused += 20
	to_chat(H, SPAN_DANGER("A stinging sensation fills your mind! You feel nauseated..."))
	H.adjustHalLoss(15)

