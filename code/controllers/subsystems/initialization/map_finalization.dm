// The area list is put together here, because some things need it early on. Turrets controls, for example.

SUBSYSTEM_DEF(finalize)
	name = "Map Finalization"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_MAPFINALIZE

	var/dmm_suite/maploader
	var/datum/away_mission/selected_mission

/datum/controller/subsystem/finalize/Initialize(timeofday)
	// Setup the global antag uplink. This needs to be done after SSatlas as it requires current_map.
	global.uplink = new

	var/time = world.time
	current_map.finalize_load()
	log_subsystem_mapfinalization("Finalized map in [(world.time - time)/10] seconds.")

	load_space_ruin()

	if(GLOB.config.dungeon_chance > 0)
		place_dungeon_spawns()

	if(GLOB.config.generate_asteroid)
		time = world.time
		current_map.generate_asteroid()
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
			current_map.restricted_levels.Add(world.maxz)
	QDEL_NULL(maploader)

/datum/controller/subsystem/finalize/proc/place_dungeon_spawns()
	var/map_directory = "maps/dungeon_spawns/"
	var/list/files = flist(map_directory)
	var/start_time = world.time
	var/dungeons_placed = 0
	var/dmm_suite/maploader = new

	var/dungeon_chance = GLOB.config.dungeon_chance

	log_subsystem_mapfinalization("Attempting to create asteroid dungeons for [length(GLOB.asteroid_spawn)] different areas, with [length(files) - 1] possible dungeons, with a [dungeon_chance]% chance to spawn a dungeon per area.")

	for(var/turf/spawn_location in GLOB.asteroid_spawn)

		if(length(files) <= 0) //Sanity
			log_subsystem_mapfinalization("There aren't enough dungeon map files to fill the entire dungeon map. There may be less dungeons than expected.")
			break

		if(prob(dungeon_chance))

			var/chosen_dungeon = pick(files)

			if(!dd_hassuffix(chosen_dungeon,".dmm")) //Don't read anything that isn't a map file
				files -= chosen_dungeon
				log_subsystem_mapfinalization_error("ALERT: [chosen_dungeon] is not a .dmm file! Skipping!")
				continue

			var/map_file = file("[map_directory][chosen_dungeon]")

			if(isfile(map_file)) //Sanity
				log_subsystem_mapfinalization("Loading dungeon '[chosen_dungeon]' at coordinates [spawn_location.x], [spawn_location.y], [spawn_location.z].")
				maploader.load_map(map_file,spawn_location.x,spawn_location.y,spawn_location.z)
				dungeons_placed += 1
			else
				log_subsystem_mapfinalization_error("ERROR: Something weird happened with the file: [chosen_dungeon].")
				log_mapping("ERROR: Something weird happened with the file: [chosen_dungeon].")

			if(dd_hassuffix(chosen_dungeon,"_unique.dmm")) //Unique dungeons should only spawn once.
				files -= chosen_dungeon

	log_subsystem_mapfinalization("Loaded [dungeons_placed] asteroid dungeons in [(world.time - start_time)/10] seconds.")

	qdel(maploader)

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
