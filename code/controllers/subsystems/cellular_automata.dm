GLOBAL_LIST_EMPTY(automata_cells)

SUBSYSTEM_DEF(cellular_automata)
	name = "Cellular Automata"
	wait = 1
	priority = SS_PRIORITY_EXPLOSIVES
	flags = SS_NO_INIT | SS_BACKGROUND | SS_POST_FIRE_TIMING
	runlevels = RUNLEVELS_PLAYING

	var/list/currentrun
	/// Inactive wave markers available for reuse.
	var/list/wave_visual_pool = list()
	/// Active fading markers indexed by the world.time at which they can be reclaimed.
	var/list/active_wave_visuals = list()
	/// Avoid retaining an unbounded number of objects after an unusually large explosion.
	var/max_pooled_wave_visuals = 512

/datum/controller/subsystem/cellular_automata/fire(resumed = FALSE)
	if(!resumed)
		reclaim_wave_visuals()
		currentrun = GLOB.automata_cells.Copy()

	while(length(currentrun))
		var/datum/automata_cell/cell = currentrun[currentrun.len]
		currentrun.len--

		if(QDELETED(cell))
			continue

		cell.update_state()

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/cellular_automata/proc/acquire_wave_visual(turf/location)
	var/obj/effect/cellular_explosion_wave/visual
	if(length(wave_visual_pool))
		visual = wave_visual_pool[wave_visual_pool.len]
		wave_visual_pool.len--
		visual.forceMove(location)
	else
		visual = new(location)
	return visual

/datum/controller/subsystem/cellular_automata/proc/release_wave_visual(obj/effect/cellular_explosion_wave/visual)
	if(!visual || QDELETED(visual))
		return
	animate(visual, alpha = 0, time = 0.3 SECONDS, flags = ANIMATION_END_NOW)
	active_wave_visuals[visual] = world.time + 0.4 SECONDS

/datum/controller/subsystem/cellular_automata/proc/reclaim_wave_visuals()
	for(var/obj/effect/cellular_explosion_wave/visual as anything in active_wave_visuals)
		if(active_wave_visuals[visual] > world.time)
			continue
		active_wave_visuals -= visual
		if(QDELETED(visual))
			continue
		visual.forceMove(null)
		if(length(wave_visual_pool) < max_pooled_wave_visuals)
			wave_visual_pool += visual
		else
			qdel(visual)

/datum/controller/subsystem/cellular_automata/stat_entry(msg)
	msg = "C:[length(GLOB.automata_cells)] V:[length(active_wave_visuals)] P:[length(wave_visual_pool)]"
	return ..()
