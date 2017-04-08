#define STAGE_NONE 0
#define STAGE_SOURCE 1
#define STAGE_CORNER 2
#define STAGE_OVERLAY 3

/var/list/lighting_update_lights    = list()    // List of lighting sources  queued for update.
/var/list/lighting_update_corners   = list()    // List of lighting corners  queued for update.
/var/list/lighting_update_overlays  = list()    // List of lighting overlays queued for update.

// Probably slow.
/var/lighting_profiling = FALSE

/var/datum/controller/process/lighting/lighting_process

/datum/controller/process/lighting
	schedule_interval = LIGHTING_INTERVAL

/datum/controller/process/lighting/setup()
	name = "lighting"
	lighting_process = src

/datum/controller/process/lighting/statProcess()
	..()
	stat(null, "Server tick usage is [world.tick_usage].")
	stat(null, "[all_lighting_overlays.len] overlays ([all_lighting_corners.len] corners)")
	stat(null, "Lights: [lighting_update_lights.len] queued")
	stat(null, "Corners: [lighting_update_corners.len] queued")
	stat(null, "Overlays: [lighting_update_overlays.len] queued")

/datum/controller/process/lighting/doWork()
	var/list/curr_lights = lighting_update_lights
	var/list/curr_corners = lighting_update_corners
	var/list/curr_overlays = lighting_update_overlays

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

		F_SCHECK

	while (curr_corners.len)
		var/datum/lighting_corner/C = curr_corners[curr_corners.len]
		curr_corners.len--

		C.update_overlays()

		C.needs_update = FALSE

		F_SCHECK

	while (curr_overlays.len)
		var/atom/movable/lighting_overlay/O = curr_overlays[curr_overlays.len]
		curr_overlays.len--

		O.update_overlay()
		O.needs_update = FALSE
		
		F_SCHECK

#undef STAGE_NONE
#undef STAGE_SOURCE
#undef STAGE_CORNER
#undef STAGE_OVERLAY
