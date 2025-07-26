/singleton/psionic_power/psi_search
	name = "Psionic Search"
	desc = "Scan your Z-level for Nlom signatures. The distance will be slightly inaccurate for weak signatures."
	icon_state = "wiz_shield"
	point_cost = 0
	ability_flags = PSI_FLAG_FOUNDATIONAL
	spell_path = /obj/item/spell/psi_search

/obj/item/spell/psi_search
	name = "psionic search"
	desc = "A psionic magnifying glass."
	icon_state = "generic"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 5
	psi_cost = 10

/obj/item/spell/psi_search/on_use_cast(mob/user)
	. = ..()
	if(!.)
		return
	if(!isliving(user))
		return
	var/mob/living/L = user
	L.visible_message(SPAN_NOTICE("[L] puts two fingers to [L.get_pronoun("his")] forehead and focuses..."),
					SPAN_NOTICE("You put two fingers to your temple and focus on locating Nlom signatures..."))
	if(do_after(L, 3 SECONDS))
		var/list/level_humans = list()
		var/found_apex = FALSE
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			if(H == L)
				continue
			if((GET_Z(H) == GET_Z(L)) && !H.is_psi_blocked(user))
				if(HAS_TRAIT(H, TRAIT_PSIONIC_SUPPRESSION))
					continue
				level_humans |= H
				if(H.psi)
					if(H.psi.get_rank() >= PSI_RANK_APEX)
						found_apex = TRUE
		if(!length(level_humans))
			to_chat(L, SPAN_WARNING("The Nlom is quiet and empty here."))
			return TRUE
		if(found_apex)
			to_chat(L, SPAN_DANGER(FONT_HUGE("You reach out into the Nlom and your senses are overwhelmed by a massive signature!")))
			L.flash_pain(20)
			L.adjustHalLoss(20)
			return
		var/list/signatures = list()
		var/harmonious_signatures = 0
		var/sensitive_signatures = 0
		var/perceptive_signatures = 0
		for(var/mob/living/carbon/human/H in level_humans)
			if(!H.psi)
				perceptive_signatures++
				continue
			if(H.psi && H.psi.get_rank() == PSI_RANK_SENSITIVE)
				sensitive_signatures++
				continue
			if(H.psi && H.psi.get_rank() == PSI_RANK_HARMONIOUS)
				harmonious_signatures++
				continue
		if(perceptive_signatures)
			signatures += "[perceptive_signatures] weak signature[perceptive_signatures > 1 ? "s" : ""]"
		if(sensitive_signatures)
			signatures += "[sensitive_signatures] robust signature[sensitive_signatures > 1 ? "s" : ""]"
		if(harmonious_signatures)
			signatures += "[harmonious_signatures] very powerful signature[harmonious_signatures > 1 ? "s" : ""]"
		to_chat(user, SPAN_NOTICE("Reaching out into the Nlom, you sense [english_list(signatures)]."))
