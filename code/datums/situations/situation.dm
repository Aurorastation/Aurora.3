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
	/// If no maps are loaded, then the situation is assumed to take place on the Horizon, in which case you'll need to override setup_situation() to add custom logic.
	var/list/maps_to_load
	/// This determines mission creation behaviour. Not a bitfield.
	var/setup_type = SITUATION_SET_UP_ON_NEW_ZLEVEL
	/// Weight given to the situation in pickweight when being picked.
	var/weight = 20

/**
 * This proc handles the creation and spawning of everything that the situation needs.
 * This could be a map or landmarks or whatever.
 */
/singleton/situation/proc/setup_situation()
	for(var/M in maps_to_load)
		var/datum/map_template/template = new M
		if(setup_type == SITUATION_SET_UP_ON_NEW_ZLEVEL)
			var/turf/T = template.load_new_z()
			SSodyssey.situation_zlevels = list(T.z)
		else if(setup_type == SITUATION_SET_UP_ON_PLANET)
			for(var/map_z in GLOB.map_sectors)
				var/obj/effect/overmap/OM = GLOB.map_sectors[map_z]
				if(istype(OM, /obj/effect/overmap/visitable/sector/exoplanet))
					var/obj/effect/overmap/visitable/sector/exoplanet/planet = OM
					if(is_planet_appropriate(planet))
						//TODOMATT: make the template actually spawn on the planet
						SSodyssey.situation_planet = OM
						break

					// In case we don't find an ideal planet, make one manually.
					// rip init times
					if(!SSodyssey.situation_planet)
						SSodyssey.situation_planet = create_appropriate_planet()
	return TRUE

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
