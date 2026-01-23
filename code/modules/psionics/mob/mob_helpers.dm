/// !DEPRECATED: GO USE check_psi_sensitivity() INSTEAD
/atom/movable/proc/has_psi_aug()
	return FALSE

/mob/living/carbon/has_psi_aug()
	var/obj/item/organ/internal/augment/bioaug/psi/psiaug = internal_organs_by_name[BP_AUG_PSI]
	return psiaug && !psiaug.is_broken()

/**
 * Checks via signal if the target is blocked from RECEIVING psionic messages.
 * Traditionally, most organic life can in some way RECEIVE psionic messages via a Zona Bovinae, though some lack it.
 * Implants, drugs, and some psi powers may temporarily block RECEIVING.
 *
 * User should be the "Caster" of the power if possible.
 * Wide_Field should be set to TRUE for anything calling this inside For/While loops.
 * Basically if you're searching a list, declare it TRUE so that lethal mind blankers don't instagib you.
 * If it's single-target, keep it FALSE.
 *
 * This is NOT a check for "Can Receive?", if you need that go use check_psi_sensitivity().
 */
/atom/movable/proc/is_psi_blocked(mob/user, var/wide_field = FALSE)
	var/cancelled = FALSE
	var/cancel_return = SPAN_WARNING("[src]'s mind is inaccessible, like hitting a brick wall.")
	SEND_SIGNAL(src, COMSIG_PSI_MIND_POWER, user, &cancelled, &cancel_return, wide_field)
	if(cancelled || (!has_zona_bovinae() && !has_psi_aug()))
		return cancel_return

/**
 * Check the "effective psi-sensitivity" of a mob. AKA: The target's RECEIVING statistic.
 * This can be influenced by anything wishing to reply to the signal, such as implants, drugs, other psi-powers, etc.
 * It also includes the actual psi-sensitivity of real psionics such as Skrell.
 * This returns a float that is any real number (including negatives).
 *
 * A typical human will (assuming they have no positive temporary modifiers) will return anywhere from -2 and 0,
 * so for a "not-psi sensitive" check, you'll want to do check_psi_sensitivity() <= 0.
 *
 * A typical "real psionic" will return between 1 and 2. Possibly more.
 * So to check for "Yes they're psychic", look for check_psi_sensitivity >= 1
 *
 * And for "Any positive mods allowed", use check_psi_sensitivity > 0
 */
/atom/movable/proc/check_psi_sensitivity()
	var/effective_sensitivity = 0
	SEND_SIGNAL(src, COMSIG_PSI_CHECK_SENSITIVITY, &effective_sensitivity)
	return effective_sensitivity

/mob/living/check_psi_sensitivity()
	var/effective_sensitivity = ..()
	if(psi)
		effective_sensitivity += psi.get_rank()
	return effective_sensitivity

/atom/movable/proc/has_zona_bovinae()
	return FALSE

/mob/living/has_zona_bovinae()
	return TRUE

/mob/living/carbon/has_zona_bovinae()
	if(HAS_TRAIT(src, TRAIT_PSIONICALLY_DEAF))
		return FALSE
	return TRUE

/atom/movable/proc/is_psi_pingable()
	return !is_psi_blocked()

/mob/living/simple_animal/is_psi_pingable()
	return psi_pingable
