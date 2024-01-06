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

SUBSYSTEM_DEF(icon_smooth)
	name = "Icon Smoothing"
	init_order = SS_INIT_SMOOTHING
	wait = 1
	priority = SS_PRIORITY_SMOOTHING
	flags = SS_TICKER
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/smooth_queue = list()

	///Like `smooth_queue`, but contains atoms that didn't initialize yet, to be reran
	var/list/deferred = list()

	var/list/typecachecache = list()

	var/explosion_in_progress = FALSE

/datum/controller/subsystem/icon_smooth/Recover()
	smooth_queue = SSicon_smooth.smooth_queue
	deferred = SSicon_smooth.deferred

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

		if((smoothing_atom.flags_1 & INITIALIZED_1) && !(smoothing_atom.icon_update_queued))
			smooth_icon(smoothing_atom)
		else
			deferred += smoothing_atom

		if (MC_TICK_CHECK)
			return

	if (!length(smooth_queue_cache))
		if(deferred.len)
			smooth_queue = deferred
			deferred = smooth_queue_cache
		else
			can_fire = FALSE

/datum/controller/subsystem/icon_smooth/ExplosionStart()
	explosion_in_progress = TRUE

/datum/controller/subsystem/icon_smooth/ExplosionEnd()
	explosion_in_progress = FALSE

/datum/controller/subsystem/icon_smooth/Initialize()
	for (var/zlevel = 1 to world.maxz)
		smooth_zlevel(zlevel, FALSE)

	if (GLOB.config.fastboot)
		LOG_DEBUG("icon_smoothing: Skipping prebake, fastboot enabled.")
		return SS_INIT_SUCCESS

	var/list/queue = smooth_queue
	smooth_queue = list()

	while(length(queue))
		var/atom/smoothing_atom = queue[length(queue)]
		queue.len--

		if(QDELETED(smoothing_atom) || !(smoothing_atom.smoothing_flags & SMOOTH_QUEUED) || !smoothing_atom.z)
			continue

		smooth_icon(smoothing_atom)

		CHECK_TICK

	return SS_INIT_SUCCESS

/datum/controller/subsystem/icon_smooth/proc/add_to_queue(atom/thing)
	SHOULD_NOT_SLEEP(TRUE)

	if(QDELETED(thing) || thing.smoothing_flags & SMOOTH_QUEUED)
		return

	thing.smoothing_flags |= SMOOTH_QUEUED
	smooth_queue += thing

	if(!can_fire)
		can_fire = TRUE

/datum/controller/subsystem/icon_smooth/proc/add_to_queue_neighbors(atom/thing)
	SHOULD_NOT_SLEEP(TRUE)

	for(var/atom/neighbor as anything in orange(1,thing))
		if(!QDELETED(neighbor) && neighbor.smoothing_flags)
			SSICONSMOOTH_ADD_TO_QUEUE(neighbor)

/datum/controller/subsystem/icon_smooth/proc/remove_from_queues(atom/thing)
	SHOULD_NOT_SLEEP(TRUE)

	thing.smoothing_flags &= ~SMOOTH_QUEUED
	smooth_queue -= thing
	deferred -= thing

#undef SSICONSMOOTH_ADD_TO_QUEUE
