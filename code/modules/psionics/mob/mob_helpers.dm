/mob/living/proc/has_psi_aug()
	return FALSE

/mob/living/carbon/has_psi_aug()
	var/obj/item/organ/internal/augment/psi/psiaug = internal_organs_by_name[BP_AUG_PSI]
	return psiaug && !psiaug.is_broken()

/mob/living/proc/is_psi_blocked(mob/user)
	return !has_psionics()

/mob/living/carbon/is_psi_blocked(mob/user)
	var/cancelled = FALSE
	SEND_SIGNAL(src, COMSIG_PSI_MIND_POWER, user, &cancelled)
	if(cancelled || (!has_zona_bovinae() && !has_psi_aug()))
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

/mob/living/proc/is_psi_pingable()
	return !is_psi_blocked()

/mob/living/simple_animal/is_psi_pingable()
	return psi_pingable
