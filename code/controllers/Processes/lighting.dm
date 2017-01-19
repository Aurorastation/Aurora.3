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
	var/list/curr_lights = list()
	var/list/curr_corners = list()
	var/list/curr_overlays = list()
	var/list/resume_pos = 0

/datum/controller/process/lighting/setup()
	name = "lighting"

	lighting_process = src

	create_all_lighting_overlays()

/datum/controller/process/lighting/statProcess()
	..()
	stat(null, "[all_lighting_overlays.len] overlays (~[all_lighting_overlays.len * 4] corners)")
	stat(null, "Lights: [lighting_update_lights.len] queued, [curr_lights.len] processing")
	stat(null, "Corners: [lighting_update_corners.len] queued, [curr_corners.len] processing")
	stat(null, "Overlays: [lighting_update_overlays.len] queued, [curr_overlays.len] processing")

/datum/controller/process/lighting/doWork()
	// -- SOURCES --
	if (resume_pos == STAGE_NONE)
		curr_lights = lighting_update_lights
		lighting_update_lights = list()

		resume_pos = STAGE_SOURCE

	while (curr_lights.len)
		var/datum/light_source/L = curr_lights[curr_lights.len]
		curr_lights.len--

		if(L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		sleepCheck()	// Can't use macro, it's not defined when this is included.

	// -- CORNERS --
	if (resume_pos == STAGE_SOURCE)
		curr_corners = lighting_update_corners
		lighting_update_corners = list()

		resume_pos = STAGE_CORNER

	while (curr_corners.len)
		var/datum/lighting_corner/C = curr_corners[curr_corners.len]
		curr_corners.len--

		C.update_overlays()

		C.needs_update = FALSE

		sleepCheck()

	if (resume_pos == STAGE_CORNER)
		curr_overlays = lighting_update_overlays
		lighting_update_overlays = list()

		resume_pos = STAGE_OVERLAY

	while (curr_overlays.len)
		var/atom/movable/lighting_overlay/O = curr_overlays[curr_overlays.len]
		curr_overlays.len--

		O.update_overlay()
		O.needs_update = FALSE
		
		sleepCheck()

	resume_pos = 0

#undef STAGE_NONE
#undef STAGE_SOURCE
#undef STAGE_CORNER
#undef STAGE_OVERLAY
