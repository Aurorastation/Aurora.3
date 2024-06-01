// The area list is put together here, because some things need it early on. Turrets controls, for example.

SUBSYSTEM_DEF(finalize)
	name = "Map Finalization"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = INIT_ORDER_MAPFINALIZE

	var/dmm_suite/maploader
	var/datum/away_mission/selected_mission

/datum/controller/subsystem/finalize/Initialize(timeofday)
	// Setup the global antag uplink. This needs to be done after SSatlas as it requires current_map.
	global.uplink = new

	var/time = world.time
	SSatlas.current_map.finalize_load()
	log_subsystem_mapfinalization("Finalized map in [(world.time - time)/10] seconds.")

	load_space_ruin()

	if(GLOB.config.generate_asteroid)
		time = world.time
		SSatlas.current_map.generate_asteroid()
		log_subsystem_mapfinalization("Generated asteroid in [(world.time - time)/10] seconds.")

	// Generate the area list.
	resort_all_areas()

	// This is dependant on markers.
	populate_antag_spawns()

	// Generate contact report.
	generate_contact_report()

	return SS_INIT_SUCCESS

/proc/resort_all_areas()
	GLOB.all_areas = list()
	for (var/area/A in world)
		GLOB.all_areas += A

	sortTim(GLOB.all_areas, GLOBAL_PROC_REF(cmp_name_asc))

/datum/controller/subsystem/finalize/proc/load_space_ruin()
	maploader = new

	if(!selected_mission)
		log_subsystem_mapfinalization("Not loading away mission, because no mission has been selected.")
		admin_notice(SPAN_DANGER("Not loading away mission, because no mission has been selected."), R_DEBUG)
		return
	for(var/map in selected_mission.map_files)
		var/mfile = "[selected_mission.base_dir][map]"
		var/time = world.time
		LOG_DEBUG("Attempting to load [mfile]")

		if (!maploader.load_map(file(mfile), 0, 0, no_changeturf = TRUE))
			log_subsystem_mapfinalization_error("Failed to load '[mfile]'!")
			log_mapping("Failed to load '[mfile]'!")
			admin_notice(SPAN_DANGER("Failed to load '[mfile]'!"), R_DEBUG)
		else
			log_subsystem_mapfinalization("Loaded away mission on z [world.maxz] in [(world.time - time)/10] seconds.")
			admin_notice(SPAN_DANGER("Loaded away mission on z [world.maxz] in [(world.time - time)/10] seconds."), R_DEBUG)
			SSatlas.current_map.restricted_levels.Add(world.maxz)
	QDEL_NULL(maploader)

/datum/controller/subsystem/finalize/proc/generate_contact_report()
	if(!selected_mission)
		return
	var/report_text = selected_mission.get_contact_report()
	for(var/obj/effect/landmark/C in GLOB.landmarks_list)
		if(C.name == "Mission Paper")
			var/obj/item/paper/P = new /obj/item/paper(get_turf(C))
			P.name = "Icarus reading report"
			P.info = report_text
			P.update_icon()
