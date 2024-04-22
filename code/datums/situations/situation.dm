/singleton/situation
	/// The situation's name. Displayed in the round end report and some other places.
	var/name = "Generic Situation"
	/// The situation's description. Displayed in the round end report and some other places.
	var/desc = "A generic situation that should not be in the rotation."
	/// What sectors this situation can spawn in. An empty list is all sectors.
	var/list/sector_whitelist = list()
	/// The type of situation this is. NOT a boolean or a bitfield.
	var/mission_type = SITUATION_TYPE_NONCANON
	/// The maps to load. This is a list of /datum/map_template. If left null, no new maps will be loaded.
	/// If no maps are loaded, then the situation is assumed to take place on the Horizon, in which case you'll need to override setup_zlevel()
	/// or setup_planet() to add custom logic.
	var/list/maps_to_load
	/// This determines mission creation behaviour. Not a bitfield.
	var/setup_type = SITUATION_SET_UP_ON_NEW_ZLEVEL
	/// Weight given to the situation in pickweight when being picked.
	var/weight = 20
	/// If set, this variable will force a certain type of planet to spawn, bypassing the planet check. Must still have the appropriate setup_type set.
	var/force_planet_type
	/// The minimum amount of actors we want to spawn in this situation.
	var/min_actor_amount = 1
	/// The minimum amount of storytellers we want to spawn in this situation.
	var/min_storyteller_amount = 0
	/// The maximum amount of actors we want to spawn in this situation.
	var/max_actor_amount = 6
	/// The maximum amount of storytellers we want to spawn in this situation.
	var/max_storyteller_amount = 1

/**
 * This proc handles the creation and spawning of everything that the situation needs.
 * This could be a map or landmarks or whatever.
 */
/singleton/situation/proc/setup_situation()
	SHOULD_NOT_OVERRIDE(TRUE)
	for(var/M in maps_to_load)
		var/datum/map_template/template = new M
		if(setup_type == SITUATION_SET_UP_ON_NEW_ZLEVEL)
			setup_zlevel(template)
		else if(setup_type == SITUATION_SET_UP_ON_PLANET)
			setup_planet(template)
	return TRUE

/**
 * This proc is the one called to set up a new z-level for the situation.
 * This is the one you should override for custom logic.
 */
/singleton/situation/proc/setup_zlevel(datum/map_template/template)
	var/turf/T = template.load_new_z()
	LAZYADD(SSodyssey.situation_zlevels, T.z)

/**
 * This proc is the one called to set up a new planet for the situation.
 * This is the one you should override for custom logic.
 */
/singleton/situation/proc/setup_planet(datum/map_template/template)
	// In case force_planet_type is not set, search for an appropriate planet and only spawn one as a last resort.
	if(!force_planet_type)
		for(var/map_z in GLOB.map_sectors)
			var/obj/effect/overmap/OM = GLOB.map_sectors[map_z]
			if(istype(OM, /obj/effect/overmap/visitable/sector/exoplanet))
				var/obj/effect/overmap/visitable/sector/exoplanet/planet = OM
				if(is_planet_appropriate(planet))
					//TODOMATT: make the template actually spawn on the planet
					SSodyssey.set_planet(OM)
					break

				// If we don't find an ideal planet, make one manually.
				// rip init times
				if(!SSodyssey.situation_planet)
					SSodyssey.set_planet(create_appropriate_planet())
	else
		if(!istype(force_planet_type, /obj/effect/overmap/visitable/sector/exoplanet))
			log_and_message_admins(FONT_HUGE("CRITICAL FAILURE: Force planet type on [name] situation was of an unexpected type!"))
			return FALSE

		var/obj/effect/overmap/visitable/sector/exoplanet/new_planet = new force_planet_type
		SSodyssey.set_planet(new_planet)

		//todomatt: spawn templates on the planet

/**
 * This proc determines if a planet is appropriate for the situation to spawn in.
 * Override this if you need to make sure that a certain planet type exists for a mission.
 * At the same time, there is a possibility that a mission-required planet may not have spawned. Use create_appropriate_planet in that case.
 */
/singleton/situation/proc/is_planet_appropriate(obj/effect/overmap/visitable/sector/exoplanet/planet)
	return TRUE

/**
 * This proc is the last resort in case an appropriate planet for this situation was NOT found.
 * We search through every planet instead of directly spawning one because there might not be a need to spawn one if the appropriate planet already exists.
 */
/singleton/situation/proc/create_appropriate_planet()
	return
