/datum/complexus

	var/stun = 0                      // Number of process ticks we are stunned for.
	var/max_stamina = 50               // Maximum stamina we have.
	var/stamina = 50                   // The stamina we have left.
	var/next_power_use = 0             // Time until next usage.
	var/cost_modifier = 1             // Multiplier for power use stamina costs.

	// Cached powers.
	var/list/melee_powers             // Powers used in melee range.
	var/list/grab_powers              // Powers use by using a grab.
	var/list/ranged_powers            // Powers used at range.
	var/list/manifestation_powers     // Powers that create an item.

	var/rebuild_power_cache = TRUE    // Whether or not we need to rebuild our cache of powers.
	var/mob/living/owner              // Reference to our owner.

/datum/complexus/proc/set_cooldown(var/value)
	return

/datum/complexus/proc/spend_power(var/value)
	return

/datum/complexus/proc/rebuild_power_cache()
	return
