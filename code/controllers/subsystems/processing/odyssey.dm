PROCESSING_SUBSYSTEM_DEF(odyssey)
	name = "Odyssey"
	init_order = INIT_ORDER_ODYSSEY
	flags = SS_BACKGROUND|SS_NO_FIRE
	wait = 8

	/// The selected situation singleton.
	var/singleton/situation/situation
	/// The z-levels that the situation takes place in. If null, it means that there are no loaded zlevels for this situation.
	/// It probably takes place on the Horizon in that case.
	var/list/situation_zlevels
	/// This is the planet the situation takes place on. If null, then the mission takes place on a non-planet zlevel.
	/// Should only be changed through set_planet().
	var/obj/effect/overmap/visitable/sector/exoplanet/situation_planet
	/// A list of currently spawned actors for easy access.
	var/list/actors
	/// A list of currently spawned storytellers for easy access.
	var/list/storytellers

/datum/controller/subsystem/processing/odyssey/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/processing/odyssey/Recover()
	situation = SSodyssey.situation
	situation_planet = SSodyssey.situation_planet
	situation_zlevels = SSodyssey.situation_zlevels
	actors = SSodyssey.actors
	storytellers = SSodyssey.storytellers

/**
 * Picks a random situation while keeping in mind sector requirements.
 * If successful, makes the SS start firing.
 */
/datum/controller/subsystem/processing/odyssey/proc/pick_situation()
	var/list/all_situations = GET_SINGLETON_SUBTYPE_LIST(/singleton/situation)
	var/list/possible_situations = list()
	for(var/singleton/situation/S in all_situations)
		if(SSatlas.current_sector.name in S.sector_whitelist || !length(S.sector_whitelist))
			possible_situations[S] = S.weight

	if(!length(possible_situations))
		log_debug("CRITICAL ERROR: No available situation for sector [SSatlas.current_sector.name]!")
		log_and_message_admins(SPAN_DANGER(FONT_HUGE("CRITICAL ERROR: NO SITUATIONS ARE AVAILABLE FOR THIS SECTOR! CHANGE THE GAMEMODE MANUALLY!")))
		return

	situation = pickweight(possible_situations)
	flags &= ~SS_NO_FIRE

/**
 * This is the proc that should be used to set the situation planet.
 */
/datum/controller/subsystem/processing/odyssey/proc/set_planet(obj/effect/overmap/visitable/sector/exoplanet/planet)
	if(!istype(planet))
		return

	situation_planet = planet
	situation_zlevels = planet.map_z

/**
 * Adds an actor to the subsystem actor list.
 */
/datum/controller/subsystem/processing/odyssey/proc/add_actor(mob/living/carbon/human/H)
	LAZYADD(actors, H)

/**
 * Adds a storyteller to the subsystem storyteller list.
 */
/datum/controller/subsystem/processing/odyssey/proc/add_storyteller(mob/living/storyteller/S)
	LAZYADD(storytellers, S)

/**
 * Removes an actor from the subsystem actor list.
 */
/datum/controller/subsystem/processing/odyssey/proc/remove_actor(mob/living/carbon/human/H)
	LAZYREMOVE(actors, H)

/**
 * Removes a storyteller from the subsystem storyteller list.
 */
/datum/controller/subsystem/processing/odyssey/proc/remove_storyteller(mob/living/storyteller/S)
	LAZYREMOVE(storytellers, S)
