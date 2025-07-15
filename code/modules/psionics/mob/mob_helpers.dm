/mob/living/proc/has_psi_aug()
	return FALSE

/mob/living/carbon/has_psi_aug()
	var/obj/item/organ/internal/augment/psi/psiaug = internal_organs_by_name[BP_AUG_PSI]
	return psiaug && !psiaug.is_broken()

/mob/living/proc/is_psi_blocked(var/mob/caster, feedback)
	return !has_psionics()

/mob/living/carbon/is_psi_blocked(var/mob/caster, feedback)
	if((HAS_TRAIT(src, TRAIT_PSIONICALLY_DEAF) && !has_psi_aug()) || has_mind_blanker(caster, feedback))
		return SPAN_WARNING("[src]'s mind is inaccessible, like hitting a brick wall.")
	for (var/obj/item/implant/mindshield/I in src)
		if (I.implanted)
			return SPAN_WARNING("[src]'s mind is inaccessible, like hitting a brick wall.")
	return FALSE

/mob/living/proc/has_zona_bovinae()
	return TRUE

/mob/living/carbon/has_zona_bovinae()
	if(HAS_TRAIT(src, TRAIT_PSIONICALLY_DEAF))
		return FALSE
	return TRUE

/mob/living/proc/is_psi_pingable(var/mob/caster, feedback)
	return !is_psi_blocked(caster, feedback)

/mob/living/simple_animal/is_psi_pingable(var/mob/caster, feedback)
	return psi_pingable

/mob/living/proc/has_mind_blanker(var/mob/caster, feedback)
	return FALSE

/mob/living/carbon/has_mind_blanker(var/mob/caster, feedback)
	var/obj/item/organ/internal/augment/mind_blanker/trap = internal_organs_by_name[BP_AUG_MIND_BLANKER_L]
	if (trap && !trap.is_broken())
		if (feedback && isliving(caster))
			var/mob/living/victim = caster
			victim.adjustBrainLoss(20)
			victim.confused += 20
			to_chat(victim, SPAN_DANGER("Agony lances through my mind as [src]'s mind clamps down upon me."))
		return TRUE

	var/obj/item/organ/internal/augment/mind_blanker/mindblanker = internal_organs_by_name[BP_AUG_MIND_BLANKER]
	return mindblanker && !mindblanker.is_broken()
