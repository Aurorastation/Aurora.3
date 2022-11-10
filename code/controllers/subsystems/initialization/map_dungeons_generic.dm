// -------------------------------------------------------------------

//
var/list/dungeon_generic_landmarks = list()
var/list/dungeon_generic_initialized = FALSE

// -------------------------------------------------------------------

//
proc/place_dungeons_generic()
	if(dungeon_generic_initialized)
		return

	var/start_time = world.time
	var/dungeons_placed = 0
	var/dmm_suite/maploader = new
	var/list/blacklisted_map_files = list()

	log_ss("map_finalization","Attempting to load generic dungeons for [length(dungeon_generic_landmarks)] different dungeon landmarks.")

	for(var/obj/effect/dungeon_generic_landmark/landmark in dungeon_generic_landmarks)

		if(!istype(landmark))
			continue
		
		var/turf/spawn_location = landmark.loc
		if(!istype(spawn_location) || !spawn_location)
			continue

		if(!prob(landmark.spawn_chance))
			continue

		var/list/files = landmark.map_files
		if(!istype(files))
			files = list()
			for(var/file in flist(landmark.map_files))
				files += "[landmark.map_files][file]"
		
		if(!istype(files) || files.len == 0)
			continue

		for(var/blacklisted in blacklisted_map_files)
			files -= blacklisted

		if(files.len == 0)
			continue

		var/chosen_dungeon = pick(files)

		if(!dd_hassuffix(chosen_dungeon,".dmm"))
			continue

		var/map_file = file(chosen_dungeon)

		if(!isfile(map_file))
			continue
		
		log_ss("map_finalization","Loading generic dungeon '[chosen_dungeon]' at coordinates [spawn_location.x], [spawn_location.y], [spawn_location.z].")
		maploader.load_map(map_file, spawn_location.x, spawn_location.y, spawn_location.z)
		// /datum/map_template/proc/init_atoms(var/list/atoms) /// ???
		// var/datum/controller/subsystem/atlas/SSatlas // ???
		dungeons_placed += 1
		
		if(landmark.unique)
			blacklisted_map_files += chosen_dungeon

		qdel(landmark)

	log_ss("map_finalization","Loaded [dungeons_placed] generic dungeons in [(world.time - start_time)/10] seconds.")

	qdel(maploader)

// -------------------------------------------------------------------

//
/obj/effect/dungeon_generic_landmark
	name = "Generic Dungeon Landmark (blank)"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x2"
	// Percent chance for it to actually spawn a dungeon
	var/spawn_chance = 100
	// If true, blacklists the spawned dungeon from ever spawning again
	var/unique = FALSE
	// Either a list of dungeon map paths, or a path to a directory containing the maps; for example either:
	// - map_files = list("maps/away/ships/ox_freighter/containers/container_1.dmm", "maps/away/ships/ox_freighter/containers/container_2.dmm")
	// - map_files = "maps/away/ships/ox_freighter/containers/"
	var/map_files = ""

/obj/effect/dungeon_generic_landmark/New()
	..()
	dungeon_generic_landmarks += src
	return 1

/obj/effect/dungeon_generic_landmark/Initialize()
	. = ..()
	place_dungeons_generic()

	
