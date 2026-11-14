/singleton/persistent_type/generic/horizon_machinery_parts
	/// Persistent machinery present on the Horizon when the round's map finished loading.
	var/list/machinery_parts_register = list()
	/// Whether initialization completed successfully. Prevents a failed load from overwriting saved parts.
	var/parts_initialized = FALSE

/** Loads saved stock parts and supplies them to mapped machinery for application during initialization. */
/singleton/persistent_type/generic/horizon_machinery_parts/initialization_hook()
	machinery_parts_register = list()
	parts_initialized = FALSE
	if(!SSpersistence.map_supports_persistence)
		return

	var/datum/persistent_generic/saved_generic = SSpersistence.genericLoad(/singleton/persistent_type/generic/horizon_machinery_parts, skip_caching = TRUE)
	var/list/saved_payload = saved_generic?.content
	var/list/saved_machines = islist(saved_payload?["machines"]) ? saved_payload["machines"] : saved_payload

	var/current_day = get_current_irl_day()
	var/current_timeofday = world.timeofday

	for(var/obj/structure/machinery/machine in world)
		CHECK_TICK
		var/turf/machine_turf = get_turf(machine)
		if(!machine_turf || !is_station_level(machine_turf.z) || !machine.has_ranked_component_types())
			continue

		machinery_parts_register += machine
		var/persistent_parts_id = "[machine_turf.x]-[machine_turf.y]-[machine_turf.z]-[machine.type]"
		machine.persistent_parts_id = persistent_parts_id
		var/list/machine_data = saved_machines?[persistent_parts_id]
		if(islist(machine_data))
			machine.persistent_parts_content = machine_data
			machine.persistent_parts_load_day = current_day
			machine.persistent_parts_load_timeofday = current_timeofday
	parts_initialized = TRUE

/** Saves stock parts for mapped machinery that have persistent part upgrades or degraded parts. */
/singleton/persistent_type/generic/horizon_machinery_parts/finalization_hook()
	if(!parts_initialized)
		return

	var/list/all_machines = list()
	for(var/obj/structure/machinery/machine as anything in machinery_parts_register)
		CHECK_TICK
		if(QDELETED(machine) || !machine.persistent_parts_id)
			continue

		var/list/machine_data = machine.get_persistent_parts_data()
		if(islist(machine_data))
			all_machines[machine.persistent_parts_id] = machine_data

	var/list/payload = list(
		"saved_day" = get_current_irl_day(),
		"saved_timeofday" = world.timeofday,
		"machines" = all_machines
	)
	SSpersistence.genericSave(/singleton/persistent_type/generic/horizon_machinery_parts, payload)

