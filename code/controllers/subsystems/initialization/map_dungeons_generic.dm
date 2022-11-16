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
		var/datum/map_load_metadata/map_load_metadata =  maploader.load_map(map_file, spawn_location.x, spawn_location.y, spawn_location.z)

		var/list/atoms_to_initialise = map_load_metadata.atoms_to_initialise
		var/list/atoms_to_initialise_actually = list()
		for(var/atom/atom in atoms_to_initialise)
			if(atom!=null && istype(atom) && !atom.initialized)
				atoms_to_initialise_actually += atom
		map_template_init_atoms(atoms_to_initialise_actually)

		dungeons_placed += 1

		if(landmark.unique)
			blacklisted_map_files += chosen_dungeon

		qdel(landmark)

	log_ss("map_finalization","Loaded [dungeons_placed] generic dungeons in [(world.time - start_time)/10] seconds.")

	qdel(maploader)

// -------------------------------------------------------------------

// This is used to spawn "dungeons" on a map. Meaning, at map/z-level load, a sub-map is spawned on this landmark, ideally randomly picked from a list.
// The landmark is the bottom-left corner spawned dungeon.
// The loaded dungeon does not "replace" the part of map it is loaded into - it spawns on top of it.
// It only "replaces" turfs (walls, floors, etc) as a tile can have only one turf. Machines, items, objects, doors, etc, are not replaced.
/obj/effect/dungeon_generic_landmark
	name = "Generic Dungeon Landmark (blank)"
	icon = 'icons/mob/screen/generic.dmi'
	icon_state = "x3"
	// Percent chance for it to actually spawn a dungeon.
	var/spawn_chance = 100
	// If true, blacklists the spawned dungeon from ever spawning again.
	// If false, a single dungeon can be spawned at multiple landmarks potentially.
	// This setting does not work retroactively - if one landmark first spawns a dungeon with unique==FALSE, another with unique==TRUE will not un-spawn the first one.
	var/unique = FALSE
	// Either a list of dungeon map paths, or a path to a directory containing the maps; for example either:
	// - map_files = list("maps/away/ships/orion_freighter/containers/container_1.dmm", "maps/away/ships/orion_freighter/containers/container_2.dmm")
	// - map_files = "maps/away/ships/orion_freighter/containers/"
	// In case of a directory, all files in that directory will be considered for spawning.
	var/map_files = ""

/obj/effect/dungeon_generic_landmark/New()
	..()
	dungeon_generic_landmarks += src
	return 1

/obj/effect/dungeon_generic_landmark/Initialize()
	. = ..()
	place_dungeons_generic()


