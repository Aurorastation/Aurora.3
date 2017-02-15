var/datum/subsystem/lighting/SSlighting

/var/lighting_profiling = FALSE

/datum/subsystem/lighting
	name = "Lighting"
	wait = LIGHTING_INTERVAL

	flags = SS_FIRE_IN_LOBBY
	priority = SS_PRIORITY_LIGHTING
	display_order = SS_DISPLAY_LIGHTING

	var/list/light_queue   = list() // lighting sources  queued for update.
	var/list/corner_queue  = list() // lighting corners  queued for update.
	var/list/overlay_queue = list() // lighting overlays queued for update.

	var/list/processing_lights   = list()	// lighting sources  actively processing
	var/list/processing_corners  = list()	// lighting corners  actively processing
	var/list/processing_overlays = list()	// lighting overlays actively processing

/datum/subsystem/lighting/New()
	NEW_SS_GLOBAL(SSlighting)

datum/subsystem/lighting/stat_entry()
	..()
	stat(null, "Server tick usage is [world.tick_usage].")
	stat(null, "[all_lighting_overlays.len] overlays ([all_lighting_corners.len] corners)")
	stat(null, "Lights: [light_queue.len] queued, [processing_lights.len] processing")
	stat(null, "Corners: [corner_queue.len] queued, [processing_corners.len] processing")
	stat(null, "Overlays: [overlay_queue.len] queued, [processing_overlays.len] processing")

/datum/subsystem/lighting/Initialize(timeofday)
	// Generate overlays.
	for (var/zlevel = 1 to world.maxz)
		for (var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
			if (!T.dynamic_lighting)
				continue

			var/area/A = T.loc
			if (!A.dynamic_lighting)
				continue

			getFromPool(/atom/movable/lighting_overlay, T, TRUE)

	..()

/datum/subsystem/lighting/fire(resumed = FALSE)
	if (!resumed)
		processing_lights = light_queue
		light_queue = list()
		processing_corners = corner_queue
		corner_queue = list()
		processing_overlays = overlay_queue
		overlay_queue = list()

	var/list/curr_lights = processing_lights
	var/list/curr_corners = processing_corners
	var/list/curr_overlays = processing_overlays

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

/datum/subsystem/lighting/Recover()
	src.light_queue = SSlighting.light_queue
	src.corner_queue = SSlighting.corner_queue
	src.overlay_queue = SSlighting.overlay_queue
	
	// Just stick the lights that were processing back in the queue.
	src.light_queue += SSlighting.processing_lights
	src.corner_queue += SSlighting.processing_corners
	src.overlay_queue += SSlighting.processing_overlays
