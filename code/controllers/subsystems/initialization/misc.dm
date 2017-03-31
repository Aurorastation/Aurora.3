/datum/controller/subsystem/misc_late
	name = "Late Miscellaneous Init"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/misc_late/Initialize(timeofday)
	populate_antag_type_list()
	populate_spawn_points()
	setupgenetics()

	..(timeofday, TRUE)

/datum/controller/subsystem/misc_early
	name = "Early Miscellaneous Init"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/misc_early/Initialize(timeofday)
	// Setup the global HUD.
	global_hud = new
	global_huds = list(
		global_hud.druggy,
		global_hud.blurry,
		global_hud.vimpaired,
		global_hud.darkMask,
		global_hud.nvg,
		global_hud.thermal,
		global_hud.meson,
		global_hud.science
	)

	// Sort the area list.
	sortTim(all_areas, /proc/cmp_name_asc)
	
	var/turf/picked
	// Setup the teleport locs.
	for (var/thing in all_areas)
		var/area/AR = thing
		picked = null
		if(!(istype(AR, /area/shuttle) || istype(AR, /area/syndicate_station) || istype(AR, /area/wizard_station))) 
			picked = pick_area_turf(AR.type, list(/proc/is_station_turf))
			if (picked)
				teleportlocs += AR.name
				teleportlocs[AR.name] = AR

		if(istype(AR, /area/turret_protected/aisat) || istype(AR, /area/derelict) || istype(AR, /area/tdome) || istype(AR, /area/shuttle/specops/centcom))
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

		picked = pick_area_turf(AR.type, list(/proc/is_station_turf))
		if (picked)
			ghostteleportlocs += AR.name
			ghostteleportlocs[AR.name] = AR

	sortTim(teleportlocs, /proc/cmp_text_asc)
	sortTim(ghostteleportlocs, /proc/cmp_text_asc)
	
	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	// Create autolathe recipes, as above.
	populate_lathe_recipes()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	if(config.ToRban)
		ToRban_autoupdate()

	// Setup the job controller.
	job_master = new /datum/controller/occupations()
	job_master.SetupOccupations()
	job_master.LoadJobs("config/jobs.txt")
	
	..(timeofday, TRUE)
