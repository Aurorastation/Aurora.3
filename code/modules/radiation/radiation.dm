// Describes a point source of radiation.  Created either in response to a pulse of radiation, or over an irradiated atom.
// Sources will decay over time, unless something is renewing their power!
/datum/radiation_source
	/// Location of the radiation source.
	var/turf/source_turf
	/// Strength of the radiation being emitted.
	var/rad_power
	/// True for automatic decay. False if owner promises to handle it (i.e. Supermatter, INDRA, etc.)
	var/decay = TRUE
	/// True for not affecting AREA_FLAG_RAD_SHIELDED areas.
	var/respect_rad_shielding = FALSE
	/// True for power falloff with distance.
	var/flat = FALSE
	/// Cached maximum range, used for quick checks against mobs.
	var/range

/datum/radiation_source/New(source_turf, rad_power, decay = TRUE)
	src.source_turf = source_turf
	src.rad_power = rad_power
	src.decay = decay

/datum/radiation_source/Destroy()
	SSradiation.sources -= src
	if(SSradiation.sources_assoc[src.source_turf] == src)
		SSradiation.sources_assoc -= src.source_turf
	src.source_turf = null
	. = ..()

/**
 * Initialization handling decaying sources. Decrease by RADIATION_DECAY_RATE per SSradiation.fire() in latter cases.
 */
/datum/radiation_source/proc/update_rad_power(new_power = null)
	if(new_power == null || new_power == rad_power)
		return // No change
	else if(new_power <= RADIATION_LOWER_LIMIT)
		qdel(src) // Decayed to nothing
	else
		rad_power = new_power
		if(!flat)
			// R = rad_power / dist**2 - Solve for dist
			range = min(round(sqrt(rad_power / RADIATION_LOWER_LIMIT)), 31)

/turf/var/cached_rad_resistance = 0

/turf/proc/calc_rad_resistance()
	cached_rad_resistance = 0
	for(var/obj/O in src.contents)
		if(!(O.rad_resistance_modifier <= 0) && O.density)
			var/material/M = O.get_material()
			if(!M)	continue
			cached_rad_resistance += (M.weight * O.rad_resistance_modifier) / RADIATION_MATERIAL_RESISTANCE_DIVISOR
	// Looks like storing the contents length is meant to be a basic check if the cache is stale due to items enter/exiting.  Better than nothing so I'm leaving it as is. ~Leshana
	SSradiation.resistance_cache[src] = (length(contents) + 1)

/turf/simulated/wall/calc_rad_resistance()
	SSradiation.resistance_cache[src] = (length(contents) + 1)
	cached_rad_resistance = (density ? material.weight / RADIATION_MATERIAL_RESISTANCE_DIVISOR : 0)

/obj
	/// Allow overriding rad resistance.
	var/rad_resistance_modifier = 1

/**
 * Retrieves the atom's current radiation level. By default, this will return `loc.get_rads()`.
 *
 * Returns integer.
 */
/atom/proc/get_rads()
	if(loc)
		return loc.get_rads()
	return 0

/turf/get_rads()
	return SSradiation.get_rads_at_turf(src)

/**
 * Called when radiation affects the atom.
 *
 * * severity - The amount of radiation being applied. Also see RAD_LEVEL_*.
 *
 * Returns boolean
 */
/atom/proc/rad_act(severity)
	return 1

/**
 * Called when radiation affects a /mob/living.
 *
 * * severity - The amount of radiation being applied. Anything over RAD_LEVEL_LOW will deal [severity] dispersed damage and run rad_act to everything in it.
 *
 * Returns boolean
 */
/mob/living/rad_act(severity)
	if(severity > RAD_LEVEL_LOW)
		apply_damage(severity, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
		for(var/atom/I in src)
			I.rad_act(severity)
