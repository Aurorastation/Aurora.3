/datum/event/apc_damage
	no_fake = 1

/datum/event/apc_damage/start()
	..()

	var/obj/machinery/power/apc/victim_apc = acquire_random_apc()
	if(QDELETED(victim_apc))
		return

	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			victim_apc.overload_lighting(100, TRUE)
			victim_apc.set_broken()
			if(!QDELETED(victim_apc.cell))
				victim_apc.cell.corrupt()

		if(EVENT_LEVEL_MODERATE)
			victim_apc.overload_lighting(85, TRUE)
			victim_apc.set_broken()
			if(!QDELETED(victim_apc.cell))
				victim_apc.cell.corrupt()

		//EVENT_LEVEL_MUNDANE and if someone fucked up the config
		else
			victim_apc.overload_lighting(60, TRUE)
			victim_apc.emagged = TRUE
			victim_apc.flicker_all()

	victim_apc.update_icon()
	victim_apc.update()

/**
 * Returns a random, valid APC from a station area
 */
/datum/event/apc_damage/proc/acquire_random_apc()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)
	RETURN_TYPE(/obj/machinery/power/apc)

	var/list/possible_valid_apcs = list()

	for(var/area/candidate_area in GLOB.the_station_areas)
		var/obj/machinery/power/apc/candidate_apc = candidate_area.apc
		if(QDELETED(candidate_apc))
			continue

		if(!is_valid_apc(candidate_apc))
			continue

		possible_valid_apcs += candidate_area.apc


	if(!length(possible_valid_apcs))
		return

	return pick(possible_valid_apcs)

/**
 * Returns whether the given APC is valid for this event
 */
/datum/event/apc_damage/proc/is_valid_apc(obj/machinery/power/apc/apc)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	var/turf/T = get_turf(apc)
	return !apc.is_critical && !apc.emagged && T && is_station_level(T.z)
