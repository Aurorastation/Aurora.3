// The area list is put together here, because some things need it early on. Turrets controls, for example.

/datum/controller/subsystem/finalize
	name = "Map Finalization"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_MAPFINALIZE

/datum/controller/subsystem/finalize/Initialize(timeofday)
	// Setup the global antag uplink. This needs to be done after SSatlas as it requires current_map.
	global.uplink = new

	var/time = world.time
	current_map.finalize_load()
	log_ss("map_finalization", "Finalized map in [(world.time - time)/10] seconds.")

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
	if(!SSatlas.selected_ruin)
		return
	var/report_text = SSatlas.selected_ruin.get_contact_report()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "Space Ruin Paper")
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(C))
			P.name = "Icarus reading report"
			P.info = report_text
			P.update_icon()