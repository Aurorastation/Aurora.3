/var/lighting_profiling = FALSE
/var/lighting_overlays_initialized = FALSE

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = LIGHTING_INTERVAL
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_LIGHTING

	var/total_lighting_overlays = 0
	var/total_lighting_sources = 0
	var/list/lighting_corners = list()	// List of all lighting corners in the world.

	var/list/light_queue   = list() // lighting sources  queued for update.
	var/lq_idex = 1
	var/list/corner_queue  = list() // lighting corners  queued for update.
	var/cq_idex = 1
	var/list/overlay_queue = list() // lighting overlays queued for update.
	var/oq_idex = 1

	var/tmp/processed_lights = 0
	var/tmp/processed_corners = 0
	var/tmp/processed_overlays = 0

	var/total_ss_updates = 0
	var/total_instant_updates = 0

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
	var/force_queued = TRUE
	var/force_override = FALSE	// For admins.
#endif

/datum/controller/subsystem/lighting/stat_entry(msg)
	var/list/out = list(
#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
		"IUR: [total_ss_updates ? round(total_instant_updates/(total_instant_updates+total_ss_updates)*100, 0.1) : "NaN"]%\n",
#endif
		"\tT:{L:[total_lighting_sources] C:[lighting_corners.len] O:[total_lighting_overlays]}\n",
		"\tP:{L:[light_queue.len - (lq_idex - 1)]|C:[corner_queue.len - (cq_idex - 1)]|O:[overlay_queue.len - (oq_idex - 1)]}\n",
		"\tL:{L:[processed_lights]|C:[processed_corners]|O:[processed_overlays]}\n"
	)
	msg = out.Join()
	return ..()

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES

/datum/controller/subsystem/lighting/ExplosionStart()
	force_queued = TRUE
	can_fire = FALSE

/datum/controller/subsystem/lighting/ExplosionEnd()
	can_fire = TRUE
	if (!force_override)
		force_queued = FALSE


/datum/controller/subsystem/lighting/proc/handle_roundstart()
	force_queued = FALSE
	total_ss_updates = 0
	total_instant_updates = 0

#endif

/datum/controller/subsystem/lighting/Initialize(timeofday)
	var/overlaycount = 0
	var/starttime = REALTIMEOFDAY
	// Generate overlays.
	var/turf/T
	var/thing
	for (var/zlevel = 1 to world.maxz)
		for (thing in Z_ALL_TURFS(zlevel))
			T = thing
			if(GLOB.config.starlight)
				var/turf/space/S = T
				if(istype(S) && S.use_starlight)
					S.update_starlight()

			if (!T.dynamic_lighting)
				continue

			var/area/A = T.loc
			if (!A.dynamic_lighting)
				continue

			T.lighting_build_overlay()
			overlaycount++

			CHECK_TICK

	lighting_overlays_initialized = TRUE

	admin_notice(SPAN_DANGER("Created [overlaycount] lighting overlays in [(REALTIMEOFDAY - starttime)/10] seconds."), R_DEBUG)

	starttime = REALTIMEOFDAY
	// Tick once to clear most lights.
	fire(FALSE, TRUE)

	admin_notice(SPAN_DANGER("Processed [processed_lights] light sources."), R_DEBUG)
	admin_notice(SPAN_DANGER("Processed [processed_corners] light corners."), R_DEBUG)
	admin_notice(SPAN_DANGER("Processed [processed_overlays] light overlays."), R_DEBUG)
	admin_notice(SPAN_DANGER("Lighting pre-bake completed in [(REALTIMEOFDAY - starttime)/10] seconds."), R_DEBUG)

	log_subsystem("lighting", "NOv:[overlaycount] L:[processed_lights] C:[processed_corners] O:[processed_overlays]")

#ifdef USE_INTELLIGENT_LIGHTING_UPDATES
	SSticker.OnRoundstart(CALLBACK(src, PROC_REF(handle_roundstart)))
#endif

	return SS_INIT_SUCCESS

/datum/controller/subsystem/lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		processed_lights = 0
		processed_corners = 0
		processed_overlays = 0

	MC_SPLIT_TICK_INIT(3)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_lights = light_queue
	var/list/curr_corners = corner_queue
	var/list/curr_overlays = overlay_queue

	while (lq_idex <= curr_lights.len)
		var/datum/light_source/L = curr_lights[lq_idex++]
		if(QDELETED(L))
			continue

		if (L.needs_update != LIGHTING_NO_UPDATE)
			total_ss_updates += 1
			L.update_corners()

			L.needs_update = LIGHTING_NO_UPDATE

			processed_lights++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (lq_idex > 1)
		curr_lights.Cut(1, lq_idex)
		lq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (cq_idex <= curr_corners.len)
		var/datum/lighting_corner/C = curr_corners[cq_idex++]
		if(QDELETED(C))
			continue

		if (C.needs_update)
			C.update_overlays()

			C.needs_update = FALSE

			processed_corners++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (cq_idex > 1)
		curr_corners.Cut(1, cq_idex)
		cq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (oq_idex <= curr_overlays.len)
		var/atom/movable/lighting_overlay/O = curr_overlays[oq_idex++]

		if (!QDELETED(O) && O.needs_update)
			O.update_overlay()
			O.needs_update = FALSE

			processed_overlays++

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (oq_idex > 1)
		curr_overlays.Cut(1, oq_idex)
		oq_idex = 1

/datum/controller/subsystem/lighting/Recover()
	lighting_corners = SSlighting.lighting_corners
	total_lighting_overlays = SSlighting.total_lighting_overlays
	total_lighting_sources = SSlighting.total_lighting_sources

	light_queue = SSlighting.light_queue
	corner_queue = SSlighting.corner_queue
	overlay_queue = SSlighting.overlay_queue

	lq_idex = SSlighting.lq_idex
	cq_idex = SSlighting.cq_idex
	oq_idex = SSlighting.oq_idex

	if (lq_idex > 1)
		light_queue.Cut(1, lq_idex)
		lq_idex = 1

	if (cq_idex > 1)
		corner_queue.Cut(1, cq_idex)
		cq_idex = 1

	if (oq_idex > 1)
		overlay_queue.Cut(1, oq_idex)
		oq_idex = 1
