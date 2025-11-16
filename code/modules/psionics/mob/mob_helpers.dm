/// !DEPRECATED: GO USE check_psi_sensitivity() INSTEAD
/mob/proc/has_psi_aug()
	return FALSE

/mob/living/carbon/has_psi_aug()
	var/obj/item/organ/internal/augment/psi/psiaug = internal_organs_by_name[BP_AUG_PSI]
	return psiaug && !psiaug.is_broken()

/**
 * Checks via signal if the target is blocked from RECEIVING psionic messages.
 * Traditionally, most organic life can in some way RECEIVE psionic messages via a Zona Bovinae, though some lack it.
 * Implants, drugs, and some psi powers may temporarily block RECEIVING.
 *
 * TODO: TCJ Because there are some cases of mechanical objects being capable of RECEIVING, they may by necessity also involve this check.
 * TODO: TCJ For example, Nlom-interface light switches, but a psi-caster put a mental blocker on them to prevent other people from using their lightswitch.
 *
 * This is NOT a check for "Can Receive?", if you need that go use check_psi_sensitivity().
 */
/mob/proc/is_psi_blocked(mob/user)
	var/cancelled = FALSE
	SEND_SIGNAL(src, COMSIG_PSI_MIND_POWER, user, &cancelled)
	if(cancelled || (!has_zona_bovinae() && !has_psi_aug())) // TODO: TCJ go make the Zona Bovinae a real organ with a psi_check_sensitivity registration so you can remove it from this.
		return SPAN_WARNING("[src]'s mind is inaccessible, like hitting a brick wall.")

/**
 * Check the "effective psi-sensitivity" of a mob. AKA: The target's RECEIVING statistic.
 * This can be influenced by anything wishing to reply to the signal, such as implants, drugs, other psi-powers, etc.
 * It also includes the actual psi-sensitivity of real psionics such as Skrell.
 * This can technically return negative numbers or floats, so you'll need to check > 0 or <= 0 if you need it as a boolean.
 */
/mob/proc/check_psi_sensitivity()
	var/effective_sensitivity = 0
	SEND_SIGNAL(src, COMSIG_PSI_CHECK_SENSITIVITY, &effective_sensitivity)
	return effective_sensitivity

/mob/living/check_psi_sensitivity()
	var/effective_sensitivity = ..()
	if(psi)
		effective_sensitivity += psi.get_rank()
	return effective_sensitivity

/mob/proc/has_zona_bovinae()
	return FALSE

/mob/living/has_zona_bovinae()
	return TRUE

/mob/living/carbon/has_zona_bovinae()
	if(HAS_TRAIT(src, TRAIT_PSIONICALLY_DEAF))
		return FALSE
	return TRUE

/mob/living/proc/is_psi_pingable()
	return !is_psi_blocked()

/mob/living/simple_animal/is_psi_pingable()
	return psi_pingable
