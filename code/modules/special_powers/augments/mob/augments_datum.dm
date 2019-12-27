/datum/augments
	var/max_stamina = 50               // Maximum stamina we have.
	var/stamina = 50                   // The stamina we have left.
	var/next_power_use = 0             // Time until next usage.

	// Cached powers.
	var/list/melee_powers             // Powers used in melee range.
	var/list/grab_powers              // Powers use by using a grab.
	var/list/ranged_powers            // Powers used at range.
	var/list/manifestation_powers     // Powers that create an item.

/datum/augments/proc/set_cooldown