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

	..()

/proc/resort_all_areas()
	all_areas = list()
	for (var/area/A in world)
		all_areas += A

	sortTim(all_areas, /proc/cmp_name_asc)

/proc/place_dungeon_spawns()
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

/proc/create_space_ruin(var/X, var/Y, var/Z)
	var/map_directory = "maps/space_ruins/"
	var/list/files = flist(map_directory)
	var/start_time = world.time
	var/static/dmm_suite/maploader = new

	if(length(files) <= 0)
		log_ss("map_finalization","There are no space ruin map.")
		return

	var/chosen_ruin = pick(files)

	if(!dd_hassuffix(chosen_ruin,".dmm"))
		files -= chosen_ruin
		log_ss("map_finalization","ALERT: [chosen_ruin] is not a .dmm file! Skipping!")

	var/map_file = file("[map_directory][chosen_ruin]")

	if(isfile(map_file))
		log_ss("map_finalization","Loading space ruin '[chosen_ruin]' at coordinates [X], [Y], [Z].")
		maploader.load_map(map_file,X,Y,Z)

	else
		log_ss("map_finalization","ERROR: Something weird happened with the file: [chosen_ruin].")

	log_ss("map_finalization","Loaded [chosen_ruin] space ruin in [(world.time - start_time)/10] seconds.")
	create_space_ruin_report("chosen_ruin")
	qdel(maploader)

/proc/create_space_ruin_report(var/ruin_name)

	var/ruintext = "<center><img src = ntlogo.png></center><BR><FONT size = 3><BR><B>Icarus Reading Report</B><HR>"
	ruintext += "<B><font face='Courier New'>The Icarus sensors located a away site with the possible characteristics:</B><br>"

	switch(ruin_name)
		if("crashed_freighter")
			ruintext += "<B>Lifeform signals.</B><HR>"

		if("derelict" || "nt_cloneship")
			ruintext += "<B>NanoTrasen infrastructure.</B><HR>"

		if("pra_blockade_runner")
			ruintext += "<B>Large biomass signals.</B><HR>"

		if("sol_frigate")
			ruintext += "<B>Warp signal.</B><HR>"

		else
			ruintext += "<B>Unrecognizable signals.</B><HR>"

	if(prob(20))
		ruintext += "<B>Mineral concentration.</B><HR>"

	if(prob(20))
		ruintext += "<B>Bluespace signals.</B><HR>"

	ruintext += "<B><font face='Courier New'>This reading has been detected within shuttle range of the [current_map.station_name] and deemed safe for survey by [current_map.company_name] personnel. \
	The designated research director, or a captain level decision may determine the goal of any missions to this site. On-site command is deferred to any nearby command staff.</B><br>"

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "Space Ruin Paper")
			var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(C))
			P.name = "Icarus reading report"
			P.info = ruintext
			P.update_icon()