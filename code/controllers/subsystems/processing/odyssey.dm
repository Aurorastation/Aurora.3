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

/datum/controller/subsystem/processing/odyssey/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/processing/odyssey/Recover()
	situation = SSodyssey.situation

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

/datum/controller/subsystem/processing/odyssey/proc/set_planet(obj/effect/overmap/visitable/sector/exoplanet/planet)
	if(!istype(planet))
		return

	situation_planet = planet
	situation_zlevels = planet.map_z
