// verb/load_map(var/dmm_file as file, var/x_offset as num, var/y_offset as num, var/z_offset as num, var/cropMap as num, var/measureOnly as num, no_changeturf as num){
//Procs for map spawning.
var/datum/controller/subsystem/asteroid_spawns

/datum/controller/subsystem/asteroid_spawns
	name = "Asteroid Spawns"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MAPLOAD - 1 //Crude, but it needs to load after mapload but before asteroid generation.
	var/list/known_maps = list()
	var/static/dmm_suite/maploader = new
	var/map_directory = "maps/asteroid_spawns/"

/datum/controller/subsystem/asteroid_spawns/New()
	NEW_SS_GLOBAL(asteroid_spawns)

/datum/controller/subsystem/asteroid_spawns/Initialize(timeofday)
	place_maps()

/datum/controller/subsystem/asteroid_spawns/proc/place_maps()
	//Test this shit first.
	//117,77


	var/list/files = flist(map_directory)
	var/start_time = world.time

	var/dungeons_placed = 0

	log_ss("asteroid_spawns","Creating asteroid dungeons for [length(asteroid_spawn)] different areas, with [length(files)] possible dungeons.")

	for(var/turf/spawn_location in asteroid_spawn)

		if(length(files) <= 0) //Sanity
			log_ss("asteroid_spawns","There aren't enough dungeon map files to fill the entire dungeon map. You should put in some non-unique dungeons as filler!")
			break

		//if(prob(25))
		var/chosen_dungeon = pick(files)

		log_ss("asteroid_spawns", "Checking file: [map_directory][chosen_dungeon].")

		if(dd_hassuffix(chosen_dungeon,".txt")) //Don't read the readme! Only humans can read the readme!
			files -= chosen_dungeon
			continue

		var/map_file = file("[map_directory][chosen_dungeon]")

		if(isfile(map_file)) //Sanity
			log_ss("asteroid_spawns","Loading dungeon '[chosen_dungeon]' at coordinates [spawn_location.x],[spawn_location.y],[spawn_location.z].")
			maploader.load_map(map_file,spawn_location.x,spawn_location.y,spawn_location.z)
			dungeons_placed += 1
		else
			log_ss("asteroid_spawns","ERROR: Something fucking weird happened with the file: [chosen_dungeon].")

		if(dd_hassuffix(chosen_dungeon,"_unique.dmm")) //Unique dungeons should only spawn once.
			files -= chosen_dungeon

	log_ss("asteroid_spawns","Loaded [dungeons_placed] asteroid dungeons in [(world.time - start_time)/10] seconds.")