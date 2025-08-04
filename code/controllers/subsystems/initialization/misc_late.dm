// This subsystem loads later in the init process. Not last, but after most major things are done.

SUBSYSTEM_DEF(misc_late)
	name = "Late Miscellaneous Init"
	init_order = INIT_ORDER_MISC
	flags = SS_NO_FIRE | SS_NO_DISPLAY

	/// this is a list of things that fire when late misc init is called
	var/list/late_misc_firers

/datum/controller/subsystem/misc_late/Initialize(timeofday)
	// Setup the teleport locs.
	for(var/area/AR as anything in GLOB.the_station_areas)
		if(AR.area_flags & AREA_FLAG_NO_GHOST_TELEPORT_ACCESS)
			continue
		var/list/area_turfs = AR.contents
		if (area_turfs.len) // Check the area is mapped
			GLOB.ghostteleportlocs += AR.name
			GLOB.ghostteleportlocs[AR.name] = AR
	if(SSatlas.current_map.use_overmap && GLOB.map_overmap)
		GLOB.ghostteleportlocs[GLOB.map_overmap.name] = GLOB.map_overmap

	sortTim(GLOB.ghostteleportlocs, GLOBAL_PROC_REF(cmp_text_asc))

	setupgenetics()

	if (GLOB.config.fastboot)
		admin_notice(SPAN_NOTICE("<b>Fastboot is enabled; some features may not be available.</b>"), R_DEBUG)

	populate_code_phrases()

	// this covers mapped in drone fabs
	for(var/atom/thing as anything in late_misc_firers)
		thing.do_late_fire()
		LAZYREMOVE(late_misc_firers, thing)

	if (GLOB.config.use_forumuser_api)
		update_admins_from_api(TRUE)

	// Load outfits here so that the verb isn't laggy as balls.
	for(var/outfit_type in subtypesof(/obj/outfit))
		var/obj/outfit/new_outfit = new outfit_type()
		GLOB.outfit_cache[new_outfit.name] = new_outfit

	return SS_INIT_SUCCESS
