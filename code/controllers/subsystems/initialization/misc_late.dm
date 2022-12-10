// This subsystem loads later in the init process. Not last, but after most major things are done.

/datum/controller/subsystem/misc_late
	name = "Late Miscellaneous Init"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/misc_late/Initialize(timeofday)
	// Setup the teleport locs.
	for(var/area/AR as anything in the_station_areas)
		if(AR.flags & NO_GHOST_TELEPORT_ACCESS)
			continue
		var/list/area_turfs = AR.contents
		if (area_turfs.len) // Check the area is mapped
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR
	if(current_map.use_overmap)
		ghostteleportlocs[map_overmap.name] = map_overmap

	sortTim(ghostteleportlocs, /proc/cmp_text_asc)

	setupgenetics()

	if (config.fastboot)
		admin_notice("<span class='notice'><b>Fastboot is enabled; some features may not be available.</b></span>", R_DEBUG)

	populate_code_phrases()

	// this covers mapped in drone fabs
	for(var/atom/thing as anything in SSatoms.late_misc_firers)
		thing.do_late_fire()
		LAZYREMOVE(SSatoms.late_misc_firers, thing)

	if (config.use_forumuser_api)
		update_admins_from_api(TRUE)

	..(timeofday)

/proc/sorted_add_area(area/A)
	all_areas += A

	sortTim(all_areas, /proc/cmp_name_asc)
