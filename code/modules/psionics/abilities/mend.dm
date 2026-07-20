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
	item_icons = null
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

	var/victim_psi_sensitivity = H.check_psi_sensitivity()  //Faster healing for psi-sensitive people, slower for psi-resistant people.
	var/effect_multiplier = 2 ** victim_psi_sensitivity // -1 = 0.5x speed, 0 = 1x speed, 1 = 2x speed, 2 = 4x speed, etc.

	user.visible_message(SPAN_NOTICE("[user] lays a palm on [H]..."), SPAN_NOTICE("You lay your palm on [H] and get to work."))
	for(var/obj/item/organ/O in H.internal_organs)
		if(do_mob(user, H, 1 SECONDS / effect_multiplier))
			if(O.get_damage() > 0) // Fix internal damage
				to_chat(user, SPAN_NOTICE("You flow your regenerative psionic energy through their [O.name]..."))
				if(do_mob(user, H, 10 SECONDS / effect_multiplier))
					if(pay_energy(30))
						to_chat(user, SPAN_NOTICE("You mend their [O.name]'s bruising."))
						O.heal_damage(O.get_damage())
					else
						return
				else
					return

			if((O.status & ORGAN_BROKEN))
				to_chat(user, SPAN_NOTICE("You flow your regenerative psionic energy through their [O.name]..."))
				if(do_mob(user, H, 10 SECONDS / effect_multiplier))
					if(pay_energy(30))
						to_chat(user, SPAN_NOTICE("You restart their [O.name]'s functionality."))
						O.status &= ~ORGAN_BROKEN
					else
						return
				else
					return

			if(O.get_damage() <= 5 && O.organ_tag == BP_EYES && H.sdisabilities & BLIND) // Fix eyes
				if(do_mob(user, H, 1 SECONDS / effect_multiplier))
					to_chat(user, SPAN_NOTICE("You flow your regenerative psionic energy through their [O.name]..."))
					if(do_mob(user, H, 10 SECONDS / effect_multiplier))
						if(pay_energy(30))
							to_chat(user, SPAN_NOTICE("You cure their blindness."))
							H.sdisabilities &= ~BLIND
						else
							return
					else
						return

			if(O.organ_tag == BP_HEART && H.is_asystole()) // Fix heart
				if(do_mob(user, H, 5 SECONDS / effect_multiplier))
					if(pay_energy(10))
						to_chat(user, SPAN_NOTICE("You pulse psionic energy through their heart and it begins to beat again."))
						H.resuscitate()
					else
						return
				else
					return
		else
			return

	for(var/obj/item/organ/E in H.bad_external_organs) // Fix bones
		var/obj/item/organ/external/affected = E
		if(do_mob(user, H, 1 SECONDS / effect_multiplier))
			if((affected.get_damage() < affected.min_broken_damage * GLOB.config.organ_health_multiplier) && (affected.status & ORGAN_BROKEN))
				to_chat(user, SPAN_NOTICE("You flow your regenerative psionic energy through the broken bone in the [affected.name]..."))
				if(do_mob(user, H, 10 SECONDS / effect_multiplier))
					if(pay_energy(25))
						affected.status &= ~ORGAN_BROKEN
						to_chat(user, SPAN_NOTICE("You mend their [affected.name] together."))
					else
						return
				else
					return
			if((affected.status & ORGAN_ARTERY_CUT))
				if(do_mob(user, H, 10 SECONDS / effect_multiplier))
					if(pay_energy(25))
						affected.status &= ~ORGAN_ARTERY_CUT
						to_chat(user, SPAN_NOTICE("You mend a spliced artery in their [affected.name]."))
					else
						return
				else
					return
			if((affected.status & ORGAN_DEAD))
				if(do_mob(user, H, 10 SECONDS / effect_multiplier))
					if(pay_energy(25))
						affected.status &= ~ORGAN_DEAD
						to_chat(user, SPAN_NOTICE("You mend some necrosis from their [affected.name]."))
					else
						return
				else
					return
			if(affected.tendon && (affected.tendon_status() & TENDON_CUT) && affected.tendon.can_recover())
				if(do_mob(user, H, 10 SECONDS / effect_multiplier))
					if(pay_energy(25))
						to_chat(user, SPAN_NOTICE("You mend the damaged tendon in their [affected.name]."))
						affected.tendon.rejuvenate()
					else
						return
				else
					return
		else
			return

	for(var/obj/item/organ/external/external_organ in H.organs) // Fix limbs
		if(do_mob(user, H, 1 SECONDS / effect_multiplier))
			if(external_organ.status & ORGAN_ROBOT) // No robot parts for this.
				continue
			if(external_organ.get_damage() <= 0)
				continue
			to_chat(user, SPAN_NOTICE("You flow your regenerative psionic energy through the flesh of their [external_organ.name]..."))
			if(do_mob(user, H, 10 SECONDS / effect_multiplier))
				if(pay_energy(20))
					external_organ.heal_damage(external_organ.get_brute_damage(), external_organ.get_burn_damage(), internal = FALSE, robo_repair = FALSE)
					to_chat(user, SPAN_NOTICE("You mend their [external_organ.name]'s flesh."))
					for(var/datum/wound/W as anything in external_organ.wounds)
						if(LAZYLEN(W.embedded_objects))
							to_chat(user, SPAN_WARNING("You heal what you can, but unyielding metal shrapnel in their [external_organ.name] prevent you from completing your work."))
				else
					return
			else
				return
		else
			return

	user.visible_message(SPAN_NOTICE("[user] raises their palm from [H]."), SPAN_NOTICE("You raise your palm, having finished your work."))
