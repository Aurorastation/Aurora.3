/datum/submap
	var/name
	var/pref_name
	var/decl/submap_archetype/archetype
	var/associated_z

/datum/submap/New(var/existing_z)
	SSmapping.submaps[src] = TRUE
	associated_z = existing_z

/datum/submap/Destroy()
	SSmapping.submaps -= src
	. = ..()

/datum/submap/proc/setup_submap(var/decl/submap_archetype/_archetype)

	if(!istype(_archetype))
		log_game( "Submap error - [name] - null or invalid archetype supplied ([_archetype]).")
		qdel(src)
		return

	// Not much point doing this when it has presumably been done already.
	if(_archetype == archetype)
		log_game( "Submap error - [name] - submap already set up.")
		return

	archetype = _archetype
	if(!pref_name)
		pref_name = archetype.descriptor

	log_game("Starting submap setup - '[name]', [archetype], [associated_z]z.")

	if(!associated_z)
		log_game( "Submap error - [name]/[archetype ? archetype.descriptor : "NO ARCHETYPE"] could not find an associated z-level for spawnpoint placement.")
		qdel(src)
		return

	var/obj/effect/overmap/visitable/cell = map_sectors["[associated_z]"]
	if(istype(cell))
		sync_cell(cell)

/datum/submap/proc/sync_cell(var/obj/effect/overmap/visitable/cell)
	name = cell.name

/datum/submap/proc/available()
	return TRUE
