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

/datum/subsystem/lighting/New()
	NEW_SS_GLOBAL(SSlighting)

datum/subsystem/lighting/stat_entry()
	..("L:[light_queue.len] C:[corner_queue.len] O:[overlay_queue.len]")
	stat(null, "[all_lighting_overlays.len] overlays ([all_lighting_corners.len] corners)")

/datum/subsystem/lighting/Initialize(timeofday)
	// Generate overlays.
	for (var/zlevel = 1 to world.maxz)
		for (var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
			if (!T.dynamic_lighting)
				continue

			var/area/A = T.loc
			if (!A.dynamic_lighting)
				continue

			new /atom/movable/lighting_overlay(T, TRUE)

	..()

/datum/subsystem/lighting/fire(resumed = FALSE)
	var/list/curr_lights = light_queue
	var/list/curr_corners = corner_queue
	var/list/curr_overlays = overlay_queue

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
	if (istype(SSlighting))
		src.light_queue = SSlighting.light_queue
		src.corner_queue = SSlighting.corner_queue
		src.overlay_queue = SSlighting.overlay_queue
