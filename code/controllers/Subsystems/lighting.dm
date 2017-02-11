var/datum/subsystem/lighting/SSlighting

/var/list/lighting_update_lights    = list()    // List of lighting sources  queued for update.
/var/list/lighting_update_corners   = list()    // List of lighting corners  queued for update.
/var/list/lighting_update_overlays  = list()    // List of lighting overlays queued for update.

/datum/subsystem/lighting
	name = "Lighting"
	wait = LIGHTING_INTERVAL

	flags = SS_FIRE_IN_LOBBY

	var/list/curr_lights = list()
	var/list/curr_corners = list()
	var/list/curr_overlays = list()

/datum/subsystem/lighting/New()
	NEW_SS_GLOBAL(SSlighting)

//datum/subsystem/lighting/stat_entry()
	//..("CO:[all_lighting_overlays.len],CC:[all_lighting_corners.len]|L:")

/datum/subsystem/lighting/Initialize(timeofday)
	// Generate overlays.
	for (var/zlevel = 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)

/datum/subsystem/lighting/fire(resumed = FALSE)
	if (!resumed)
		curr_lights = lighting_update_lights
		curr_corners = lighting_update_corners
		curr_overlays = lighting_update_overlays

	while (curr_lights.len)
		var/datum/light_source/L = curr_lights[curr_lights.len]
		curr_lights.len--

		if(L.destroyed || L.check() || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		if (MC_TICK_CHECK)
			return

	while (curr_corners.len)
		var/datum/lighting_corner/C = curr_corners[curr_corners.len]
		curr_corners.len--

		C.update_overlays()

		C.needs_update = FALSE

		if (MC_TICK_CHECK)
			return

	while (curr_overlays.len)
		var/atom/movable/lighting_overlay/O = curr_overlays[curr_overlays.len]
		curr_overlays.len--

		O.update_overlay()
		O.needs_update = FALSE
		
		if (MC_TICK_CHECK)
			return
