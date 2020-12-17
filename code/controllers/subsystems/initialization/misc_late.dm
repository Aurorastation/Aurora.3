// This subsystem loads later in the init process. Not last, but after most major things are done.

/datum/controller/subsystem/misc_late
	name = "Late Miscellaneous Init"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/misc_late/Initialize(timeofday)
	var/turf/picked
	// Setup the teleport locs.
	for (var/thing in all_areas)
		var/area/AR = thing
		picked = null
		if(!(istype(AR, /area/shuttle) || istype(AR, /area/antag/wizard)))
			picked = pick_area_turf(AR.type, list(/proc/is_station_turf))
			if (picked)
				teleportlocs += AR.name
				teleportlocs[AR.name] = AR

		if(istype(AR, /area/turret_protected/aisat) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

		picked = pick_area_turf(AR.type, list(/proc/is_station_turf))
		if (picked)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	sortTim(teleportlocs, /proc/cmp_text_asc)
	sortTim(ghostteleportlocs, /proc/cmp_text_asc)

	setupgenetics()

	if (config.fastboot)
		admin_notice("<span class='notice'><b>Fastboot is enabled; some features may not be available.</b></span>", R_DEBUG)

	populate_code_phrases()

	// this covers mapped in drone fabs
	for(var/thing in SSatoms.late_misc_firers)
		if(istype(thing, /obj/machinery/drone_fabricator))
			var/obj/machinery/drone_fabricator/DF = thing
			DF.enable_drone_spawn()
		else if(istype(thing, /mob/living/silicon/robot/drone/mining))
			var/mob/living/silicon/robot/drone/mining/MD = thing
			MD.request_player()
		LAZYREMOVE(SSatoms.late_misc_firers, thing)

	if (config.use_forumuser_api)
		update_admins_from_api(TRUE)

	click_catchers = create_click_catcher()

	..(timeofday)

/proc/sorted_add_area(area/A)
	all_areas += A

	sortTim(all_areas, /proc/cmp_name_asc)
