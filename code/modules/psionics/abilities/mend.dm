/singleton/psionic_power/mend
	name = "Mend"
	desc = "Mend a creature's wounds. This handles internal wounds as well, such as ruptured organs and broken bones."
	icon_state = "tech_biomedaura"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/mend

/obj/item/spell/mend
	name = "mend"
	desc = "Clear!"
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 30

/obj/item/spell/mend/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!ishuman(hit_atom))
		return

	var/mob/living/carbon/human/H = hit_atom
	if(!H.has_zona_bovinae())
		to_chat(user, SPAN_WARNING("Psionic power cannot flow through this being."))
		return

	if(H.stat == DEAD || H.status_flags & FAKEDEATH)
		to_chat(user, SPAN_WARNING("Psionic power does not flow through a dead person."))
		return

	. = ..()
	if(!.)
		return

	user.visible_message(SPAN_NOTICE("[user] lays a palm on [H]..."), SPAN_NOTICE("You lay your palm on [H] and get to work."))
	to_chat(user, SPAN_NOTICE("You start by flowing your regenerative psionic energy through their vital organs..."))
	for(var/obj/item/organ/O in H.internal_organs)
		if(do_mob(user, H, 15 SECONDS))
			if(O.damage > 0) // Fix internal damage
				to_chat(SPAN_NOTICE("You mend their [O]'s bruising."))
				O.heal_damage(O.damage)
			if(HAS_FLAG(O.status, ORGAN_BROKEN))
				to_chat(SPAN_NOTICE("You restart their [O]'s functionality."))
				O.status &= ~ORGAN_BROKEN
			if(O.damage <= 5 && O.organ_tag == BP_EYES) // Fix eyes
				H.sdisabilities &= ~BLIND

	to_chat(user, SPAN_NOTICE("You continue by flowing your regenerative psionic energy through their limbs..."))
	for(var/obj/item/organ/external/O in H.organs) // Fix limbs
		if(!O.robotic < ORGAN_ROBOT) // No robot parts for this.
			continue
		if(do_mob(user, H, 15 SECONDS))
			to_chat(SPAN_NOTICE("You mend their [O]'s bruising."))
			O.heal_damage(0, O.damage, internal = TRUE, robo_repair = FALSE)

	to_chat(user, SPAN_NOTICE("Finally, you flowing your regenerative psionic energy through their broken limbs..."))
	for(var/obj/item/organ/E in H.bad_external_organs) // Fix bones
		var/obj/item/organ/external/affected = E
		if(do_mob(user, H, 10 SECONDS))
			if((affected.damage < affected.min_broken_damage * config.organ_health_multiplier) && (affected.status & ORGAN_BROKEN))
				to_chat(SPAN_NOTICE("You mend their [affected] together."))
				affected.status &= ~ORGAN_BROKEN
			if(affected.status & ORGAN_ARTERY_CUT)
				to_chat(SPAN_NOTICE("You mend a spliced artery in their [affected]."))
				affected.status &= ~ORGAN_ARTERY_CUT
			if(affected.status & ORGAN_DEAD)
				to_chat(SPAN_NOTICE("You mend some necrosis from their [affected]."))
				affected.status &= ~ORGAN_DEAD
	user.visible_message(SPAN_NOTICE("[user] raises their palm from [H]."), SPAN_NOTICE("You raise your palm, having finished your work."))
