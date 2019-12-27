/datum/special_power
	var/name              // Name. If null, psipower won't be generated on roundstart.
	var/cooldown          // Deciseconds cooldown after using this power.
	var/admin_log = FALSE // Whether or not using this power prints an admin attack log.
	var/use_ranged        // This power functions from a distance.
	var/use_melee         // This power functions at melee range.
	var/use_manifest      // This power manifests an item in the user's hands.
	var/use_description   // A short description of how to use this power, shown via assay.
	var/use_sound         // A sound effect to play when the power is used.

/datum/special_power/proc/handle_post_power(var/mob/living/user, var/atom/target)
	return FALSE

/datum/special_power/proc/invoke(var/mob/living/user, var/atom/target)
	return FALSE
