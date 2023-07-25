/singleton/psionic_power/sunder
	name = "Sunder"
	desc = "Destroy a living being's Zona Bovinae. This will make them psionically deaf."
	icon_state = "ling_berserk"
	point_cost = 0
	ability_flags = PSI_FLAG_APEX
	minimum_rank = PSI_RANK_APEX
	spell_path = /obj/item/spell/sunder

/obj/item/spell/sunder
	name = "sunder"
	icon_state = "chain_lightning"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 30
	psi_cost = 20

/obj/item/spell/rend/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!isliving(hit_atom))
		return

	var/mob/living/L = hit_atom
	if(!L.has_zona_bovinae())
		to_chat(user, SPAN_WARNING("This being doesn't have a Zona Bovinae."))
		return

	. = ..()
	if(!.)
		return

	user.visible_message(SPAN_DANGER("[user] grabs [L]'s head..."), SPAN_DANGER("You grab [L]'s head..."))
	if(do_mob(user, L, 5 SECONDS))
		if(L.psi)
			QDEL_NULL(L.psi)
		ADD_TRAIT(L, TRAIT_PSIONICALLY_DEAF, TRAIT_SOURCE_PSIONICS)
		L.flash_pain(100)
		L.adjustHalLoss(50)
		L.stuttering += 20
		playsound(get_turf(L), 'sound/effects/psi/power_feedback.ogg', 100)
		user.visible_message(SPAN_DANGER("[user] unleashes a psionic shock through [L]'s head!"),
							SPAN_DANGER("You unleash a psionic shock through [L]'s head, targeting their Zona Bovinae and destroying it."))
		to_chat(L, SPAN_HIGHDANGER("A large, painful shock courses through your head. Part of your brain feels like it's gone."))
		if(isskrell(L))
			to_chat(L, SPAN_CULT("You feel absolutely empty..."))
