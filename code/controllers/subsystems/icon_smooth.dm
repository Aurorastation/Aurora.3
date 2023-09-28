/**
 * Adds an atom to the smoothing queue
 *
 * Used only internally to save on proc calls, eg. for `add_to_queue_neighbors`
 *
 * * thing - An `/atom` to add to the queue
 */
#define SSICONSMOOTH_ADD_TO_QUEUE(thing) \
	if(thing.smoothing_flags & SMOOTH_QUEUED){ \
		return; \
	}\
	thing.smoothing_flags |= SMOOTH_QUEUED; \
	smooth_queue += thing; \
	if(!can_fire){ \
		can_fire = TRUE; \
	}

var/datum/controller/subsystem/icon_smooth/SSicon_smooth

/datum/controller/subsystem/icon_smooth
	name = "Icon Smoothing"
	init_order = SS_INIT_SMOOTHING
	wait = 1
	priority = SS_PRIORITY_SMOOTHING
	flags = SS_TICKER
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/smooth_queue = list()
	var/list/typecachecache = list()

	var/explosion_in_progress = FALSE

/datum/controller/subsystem/icon_smooth/New()
	NEW_SS_GLOBAL(SSicon_smooth)

/datum/controller/subsystem/icon_smooth/Recover()
	smooth_queue = SSicon_smooth.smooth_queue

/datum/controller/subsystem/icon_smooth/stat_entry(msg)
	msg = "Q:[smooth_queue.len]"
	return ..()

/datum/controller/subsystem/icon_smooth/fire()
	if(SSatoms.initializing_something())
		return

	if (explosion_in_progress)
		return

	var/list/smooth_queue_cache = smooth_queue
	while(length(smooth_queue_cache))
		var/atom/smoothing_atom = smooth_queue_cache[length(smooth_queue_cache)]
		smooth_queue_cache.len--

		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED))
			continue

		smooth_icon(smoothing_atom)

		if (MC_TICK_CHECK)
			return

	if (!length(smooth_queue_cache))
		can_fire = FALSE

/datum/controller/subsystem/icon_smooth/ExplosionStart()
	explosion_in_progress = TRUE

/datum/controller/subsystem/icon_smooth/ExplosionEnd()
	explosion_in_progress = FALSE

/datum/controller/subsystem/icon_smooth/Initialize()
	for (var/zlevel = 1 to world.maxz)
		smooth_zlevel(zlevel, FALSE)

	if (config.fastboot)
		LOG_DEBUG("icon_smoothing: Skipping prebake, fastboot enabled.")
		return ..()

	var/list/queue = smooth_queue
	smooth_queue = list()

	while(length(queue))
		var/atom/smoothing_atom = queue[length(queue)]
		queue.len--

		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED) || !smoothing_atom.z)
			continue

		smooth_icon(smoothing_atom)

		CHECK_TICK

	. = ..()

/datum/controller/subsystem/icon_smooth/proc/add_to_queue(atom/thing)
	SHOULD_NOT_SLEEP(TRUE)

	if(thing.smoothing_flags & SMOOTH_QUEUED)
		return
	thing.smoothing_flags |= SMOOTH_QUEUED
	smooth_queue += thing

	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/add_to_queue_neighbors(atom/thing)
	SHOULD_NOT_SLEEP(TRUE)

	for(var/atom/neighbor as anything in orange(1,thing))
		if(neighbor.smoothing_flags)
			SSICONSMOOTH_ADD_TO_QUEUE(neighbor)

/datum/controller/subsystem/icon_smooth/proc/remove_from_queues(atom/thing)
	SHOULD_NOT_SLEEP(TRUE)

	thing.smoothing_flags &= ~SMOOTH_QUEUED
	smooth_queue -= thing

#undef SSICONSMOOTH_ADD_TO_QUEUE
