/proc/create_lighting_overlays_zlevel(var/zlevel)
	ASSERT(zlevel)

	for (var/turf/T in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if (!T.dynamic_lighting)
			continue

		var/area/A = T.loc
		if (!A.dynamic_lighting)
			continue

		getFromPool(/atom/movable/lighting_overlay, T, TRUE)

// This repeats a bit of code from the lighting process.
/proc/initialize_lighting()
	admin_notice(span("danger", "Generating lighting overlays (1/4)..."))
	for (var/zlevel = 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)
		CHECK_TICK

	admin_notice(span("danger", "Initializing light sources (2/4)..."))
	var/num_lights = 0
	var/list/lights = lighting_update_lights
	lighting_update_lights = list()

	while (lights.len)
		var/datum/light_source/L = lights[lights.len]
		lights.len--

		if (!L) continue

		if (L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE
		num_lights++
		CHECK_TICK

	admin_notice(span("danger", "Processed [num_lights] light sources."))

	admin_notice(span("danger", "Initializing lighting corners (3/4)..."))
	var/num_corners = 0
	var/list/corners = lighting_update_corners
	lighting_update_corners = list()

	while (corners.len)
		var/datum/lighting_corner/C = corners[corners.len]
		corners.len--

		if (!C) continue

		C.update_overlays()

		C.needs_update = FALSE
		num_corners++

		CHECK_TICK

	admin_notice(span("danger", "Processed [num_corners] light corners."))
	admin_notice(span("danger", "Initializing lighting overlays (4/4)..."))
	var/num_overlays = 0
	var/list/overlays = lighting_update_overlays
	lighting_update_overlays = list()

	while (overlays.len)
		var/atom/movable/lighting_overlay/O = overlays[overlays.len]
		overlays.len--

		if (!O) continue

		O.update_overlay()
		O.needs_update = FALSE

		num_overlays++
		CHECK_TICK

	admin_notice(span("danger", "Processed [num_overlays] light overlays."))
