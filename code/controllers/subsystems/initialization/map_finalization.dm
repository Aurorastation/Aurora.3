// The area list is put together here, because some things need it early on. Turrets controls, for example.

/datum/controller/subsystem/finalize
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
	log_ss("map_finalization", "Finalized map in [(world.time - time)/10] seconds.")

	select_ruin()
	load_space_ruin()

	if(config.dungeon_chance > 0)
		place_dungeon_spawns()

	if(config.generate_asteroid)
		time = world.time
		current_map.generate_asteroid()
		log_ss("map_finalization", "Generated asteroid in [(world.time - time)/10] seconds.")

	// Generate the area list.
	resort_all_areas()

	// This is dependant on markers.
	populate_antag_spawns()

	// Generate contact report.
	generate_contact_report()

	..()

/proc/resort_all_areas()
	all_areas = list()
	for (var/area/A in world)
		all_areas += A

	sortTim(all_areas, /proc/cmp_name_asc)

/datum/controller/subsystem/finalize/proc/select_ruin()
	//Get all the folders in dynamic maps and check if they contain a config.json
	var/map_directory = "dynamic_maps/"
	var/list/mission_list = list()
	var/list/weighted_mission_list = list()

	var/list/subfolders = get_subfolders(map_directory)

	//Build the list of available missions
	for(var/folder in subfolders)
		var/list/mission_config = null
		var/datum/away_mission/am = null
		if(!fexists("[folder]config.json"))
			log_ss("map_finalization", "Found no cofiguration file in [folder] - Skipping")
			continue

		try
			mission_config = json_decode(file2text("[folder]config.json"))
		catch(var/exception/ed)
			log_ss("map_finalization", "Invalid config.json in [folder]: [ed]")
			continue

		try
			am = new(mission_config, folder)
		catch(var/exception/ec)
			log_ss("map_finalization", "Error while creating away mission datum: [ec]")
			continue

		if(length(am.valid_maps))
			if(!(current_map.name in am.valid_maps))
				log_ss("map_finalization", "[current_map.name] is not a valid map for [am.name]")
				continue

		if(!am.validate_maps(folder))
			continue

		mission_list[am.name] = am
		if(am.autoselect)
			weighted_mission_list[am.name] = am.weight
		else
			log_debug("[am.name] has a disabled autoselect")

	if(!length(mission_list))
		log_ss("map_finalization", "Found no valid ruins for the current map.")
		return

	log_ss("map_finalization", "Loaded ruin config.")

	//Check if we have a enforced mission we should try to load.
	if(SSpersist_config.forced_awaymission in mission_list)
		selected_mission = mission_list[SSpersist_config.forced_awaymission]
		log_ss("map_finalization", "Selected enforced away mission.")
		admin_notice(SPAN_DANGER("Selected enforced away mission."), R_DEBUG)
		return
	else
		log_ss("map_finalization", "Failed to selected enforced away mission. Fallback to weighted selection.")
		admin_notice(SPAN_DANGER("Failed to selected enforced away mission. Fallback to weighted selection."), R_DEBUG)

	var/mission_name = pickweight(weighted_mission_list)
	selected_mission = mission_list[mission_name]
	admin_notice(SPAN_DANGER("Selected away mission."), R_DEBUG)
	return

/datum/controller/subsystem/finalize/proc/load_space_ruin()
	maploader = new

	if(!selected_mission)
		log_ss("map_finalization", "Not loading away mission, because no mission has been selected.")
		admin_notice(SPAN_DANGER("Not loading away mission, because no mission has been selected."), R_DEBUG)
		return
	for(var/map in selected_mission.map_files)
		var/mfile = "[selected_mission.base_dir][map]"
		var/time = world.time
		log_debug("Attempting to load [mfile]")

		if (!maploader.load_map(file(mfile), 0, 0, no_changeturf = TRUE))
			log_ss("map_finalization", "Failed to load '[mfile]'!")
			admin_notice(SPAN_DANGER("Failed to load '[mfile]'!"), R_DEBUG)
		else
			log_ss("map_finalization", "Loaded away mission on z [world.maxz] in [(world.time - time)/10] seconds.")
			admin_notice(SPAN_DANGER("Loaded away mission on z [world.maxz] in [(world.time - time)/10] seconds."), R_DEBUG)
			current_map.restricted_levels.Add(world.maxz)
	QDEL_NULL(maploader)

/datum/controller/subsystem/finalize/proc/place_dungeon_spawns()
	var/map_directory = "maps/dungeon_spawns/"
	var/list/files = flist(map_directory)
	var/start_time = world.time
	var/dungeons_placed = 0
	var/dmm_suite/maploader = new

	var/dungeon_chance = config.dungeon_chance

	log_ss("map_finalization","Attempting to create asteroid dungeons for [length(asteroid_spawn)] different areas, with [length(files) - 1] possible dungeons, with a [dungeon_chance]% chance to spawn a dungeon per area.")

	for(var/turf/spawn_location in asteroid_spawn)

		if(length(files) <= 0) //Sanity
			log_ss("map_finalization","There aren't enough dungeon map files to fill the entire dungeon map. There may be less dungeons than expected.")
			break

		if(prob(dungeon_chance))

			var/chosen_dungeon = pick(files)

			if(!dd_hassuffix(chosen_dungeon,".dmm")) //Don't read anything that isn't a map file
				files -= chosen_dungeon
				log_ss("map_finalization","ALERT: [chosen_dungeon] is not a .dmm file! Skipping!")
				continue

			var/map_file = file("[map_directory][chosen_dungeon]")

			if(isfile(map_file)) //Sanity
				log_ss("map_finalization","Loading dungeon '[chosen_dungeon]' at coordinates [spawn_location.x], [spawn_location.y], [spawn_location.z].")
				maploader.load_map(map_file,spawn_location.x,spawn_location.y,spawn_location.z)
				dungeons_placed += 1
			else
				log_ss("map_finalization","ERROR: Something weird happened with the file: [chosen_dungeon].")

			if(dd_hassuffix(chosen_dungeon,"_unique.dmm")) //Unique dungeons should only spawn once.
				files -= chosen_dungeon

	log_ss("map_finalization","Loaded [dungeons_placed] asteroid dungeons in [(world.time - start_time)/10] seconds.")

	qdel(maploader)

/datum/controller/subsystem/finalize/proc/generate_contact_report()
	if(!selected_mission)
		return
	var/report_text = selected_mission.get_contact_report()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "Mission Paper")
			var/obj/item/paper/P = new /obj/item/paper(get_turf(C))
			P.name = "Icarus reading report"
			P.info = report_text
			P.update_icon()
