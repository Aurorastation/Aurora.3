/singleton/psionic_power/zona_absorption
	name = "Zona Bovinae Absorption"
	desc = "Absorb a psionic energy from a being's Zona Bovinae, granting you an extra point to be used in the Point Shop."
	icon_state = "tech_shield_old"
	point_cost = 0
	ability_flags = PSI_FLAG_SPECIAL
	spell_path = /obj/item/spell/zona_absorption

/obj/item/spell/zona_absorption
	name = "zona bovinae absorption"
	icon_state = "chain_lightning"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 30
	psi_cost = 10

/obj/item/spell/zona_absorption/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!isliving(hit_atom))
		return
	var/mob/living/L = hit_atom
	if(L.is_psi_blocked())
		to_chat(user, SPAN_WARNING("This being doesn't have a Zona Bovinae."))
		return
	if(HAS_TRAIT(L, TRAIT_ZONA_BOVINAE_ABSORBED))
		to_chat(user, SPAN_WARNING("You already absorbed points from this creature!"))
		return
	. = ..()
	if(!.)
		return

	user.visible_message(SPAN_DANGER("[user] grabs [L]'s head..."), SPAN_DANGER("You grab [L]'s head..."))
	if(do_mob(user, L, 5 SECONDS))
		L.flash_pain(20)
		L.adjustHalLoss(20)
		playsound(get_turf(L), 'sound/effects/psi/power_feedback.ogg', 100)
		user.visible_message(SPAN_DANGER("[user] absorbs tendrils of psionic energy from [L]!"),
							SPAN_DANGER("You absorb psionic energy from [L], granting you an extra Psionic Point Shop point."))
		var/mob/living/M = user
		M.psi.psi_points++
		to_chat(L, SPAN_DANGER("A splitting headache courses through your mind! Your head feels a bit lighter..."))
		ADD_TRAIT(L, TRAIT_ZONA_BOVINAE_ABSORBED, TRAIT_SOURCE_PSIONICS)
