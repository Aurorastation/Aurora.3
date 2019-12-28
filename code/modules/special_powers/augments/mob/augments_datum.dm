/datum/augments
	var/max_stamina = 50               // Maximum stamina we have.
	var/stamina = 50                   // The stamina we have left.
	var/next_power_use = 0             // Time until next usage.

	// Cached powers.
	var/list/melee_powers             // Powers used in melee range.
	var/list/grab_powers              // Powers use by using a grab.
	var/list/ranged_powers            // Powers used at range.
	var/list/manifestation_powers     // Powers that create an item.

	var/rebuild_power_cache = TRUE    // If we wanna rebuild our cached powers.

/datum/augments/proc/set_cooldown

/datum/augments/proc/spend_power

/datum/psi_complexus/proc/rebuild_power_cache()
	if(rebuild_power_cache)

		melee_powers =         list()
		grab_powers =          list()
		ranged_powers =        list()
		manifestation_powers = list()
		powers_by_faculty =    list()

		for(var/faculty in ranks)
			var/relevant_rank = get_rank(faculty)
			var/datum/psionic_faculty/faculty_decl = SSpsi.get_faculty(faculty)
			for(var/thing in faculty_decl.powers)
				var/datum/special_power/psionic/power = thing
				if(relevant_rank >= power.min_rank)
					if(!powers_by_faculty[power.faculty]) powers_by_faculty[power.faculty] = list()
					powers_by_faculty[power.faculty] += power
					if(power.use_ranged)
						if(!ranged_powers[faculty]) ranged_powers[faculty] = list()
						ranged_powers[faculty] += power
					if(power.use_melee)
						if(!melee_powers[faculty]) melee_powers[faculty] = list()
						melee_powers[faculty] += power
					if(power.use_manifest)
						manifestation_powers += power
					if(power.use_grab)
						if(!grab_powers[faculty]) grab_powers[faculty] = list()
						grab_powers[faculty] += power
		rebuild_power_cache = FALSE