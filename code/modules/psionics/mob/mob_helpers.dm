/mob/living/proc/has_psi_aug()
	return FALSE

/mob/living/carbon/has_psi_aug()
	var/obj/item/organ/internal/augment/psi/psiaug = internal_organs_by_name[BP_AUG_PSI]
	return psiaug && !psiaug.is_broken()

/mob/living/proc/is_psi_blocked()
	return !can_commune()

/mob/living/carbon/is_psi_blocked()
	if(!psi && !has_psi_aug())
		if(isSynthetic())
			return SPAN_ALIEN("Reaching out, your mind grasps at nothing.")
		if (isvaurca(src))
			return SPAN_CULT("You reach out into the Nlom; your call sails right through and yields no response.")
		if (is_diona())
			return SPAN_ALIEN("[src]'s mind is incompatible, formless.")
	for (var/obj/item/implant/mindshield/I in src)
		if (I.implanted)
			return SPAN_WARNING("[src]'s mind is inaccessible, like hitting a brick wall.")
	return FALSE

/mob/living/proc/is_psi_pingable()
	return !is_psi_blocked()

/mob/living/simple_animal/is_psi_pingable()
	return psi_pingable
