// This subsystem loads later in the init process. Not last, but after most major things are done.

SUBSYSTEM_DEF(misc_late)
	name = "Late Miscellaneous Init"
	init_order = SS_INIT_MISC
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
	if(current_map.use_overmap && map_overmap)
		GLOB.ghostteleportlocs[map_overmap.name] = map_overmap

	sortTim(GLOB.ghostteleportlocs, GLOBAL_PROC_REF(cmp_text_asc))

	setupgenetics()

	if (GLOB.config.fastboot)
		admin_notice("<span class='notice'><b>Fastboot is enabled; some features may not be available.</b></span>", R_DEBUG)

	populate_code_phrases()

	// this covers mapped in drone fabs
	for(var/atom/thing as anything in late_misc_firers)
		thing.do_late_fire()
		LAZYREMOVE(late_misc_firers, thing)

	if (GLOB.config.use_forumuser_api)
		update_admins_from_api(TRUE)

	return SS_INIT_SUCCESS

/proc/sorted_add_area(area/A)
	GLOB.all_areas += A

	sortTim(GLOB.all_areas, GLOBAL_PROC_REF(cmp_name_asc))
