SUBSYSTEM_DEF(icon_update)
	name = "Icon Updates"
	wait = 1	// ticks
	flags = SS_TICKER
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE

	/**
	 * Associative list of atoms -> callback params
	 * A list of `/atoms` that are waiting to have its icon updated
	 */
	VAR_PRIVATE/list/icon_update_queue = list()

	///Deferred list, contains atoms that were not ready to be processed in the previous run
	VAR_PRIVATE/list/deferred = list()

/datum/controller/subsystem/icon_update/New()
	NEW_SS_GLOBAL(SSicon_update)

/datum/controller/subsystem/icon_update/stat_entry(msg)
	msg = "QU:[icon_update_queue.len]"
	return ..()

/datum/controller/subsystem/icon_update/Initialize()
	fire(FALSE, TRUE)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/icon_update/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/icon_update_queue_cache = icon_update_queue

	while (length(icon_update_queue_cache))
		var/atom/A = icon_update_queue_cache[length(icon_update_queue_cache)]
		var/list/argv = icon_update_queue_cache[A]
		icon_update_queue_cache.len--

		if(A.flags_1 & INITIALIZED_1)
			A.icon_update_queued = FALSE

			//Do not target qdeleted atoms
			if(QDELETED(A))
				continue

			if (islist(argv))
				A.update_icon(arglist(argv))
			else
				A.update_icon()
			A.update_above()
			A.last_icon_update = world.time

		else
			src.deferred[A] = argv

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	if (!length(icon_update_queue_cache))
		if(deferred.len)
			icon_update_queue = deferred
			deferred = icon_update_queue_cache
		else
			can_fire = FALSE
/**
 * Adds an atom to the queue to have its icon updated
 *
 * * item - An `/atom` to add to the queue
 * * parameters - Parameters that will be passed to `update_icon()` on callback
 */
/datum/controller/subsystem/icon_update/proc/add_to_queue(var/atom/item, ...)
	SHOULD_NOT_SLEEP(TRUE)

	var/atom/item_cache = item

	//Skip atoms that are being deleted
	if(QDELETED(item_cache))
		return

	if(!item_cache.icon_update_queued && (!item_cache.icon_update_delay || (item_cache.last_icon_update + item_cache.icon_update_delay < world.time)))
		item_cache.icon_update_queued = TRUE

		//Determine if we got any parameter, and if we do set it in the associative list, otherwise just set it to TRUE
		var/list/calling_arguments = length(args) > 1 ? args.Copy(2) : TRUE
		src.icon_update_queue[item_cache] = calling_arguments

		if(!src.can_fire)
			can_fire = TRUE

/**
 * Removes an atom from the queue of atoms waiting to have its icon updated
 *
 * * item - An `/atom` to add to the queue
 * * VARIPARAM - Parameters that will be passed to `update_icon()` on callback
 */
/datum/controller/subsystem/icon_update/proc/remove_from_queue(var/atom/item)
	SHOULD_NOT_SLEEP(TRUE)
	var/atom/item_cache = item

	if(item_cache.icon_update_queued)
		item_cache.icon_update_queued = FALSE
		src.icon_update_queue -= item_cache
		src.deferred -= item_cache

/atom
	///When was the last time (in `world.time`) that the icon of this atom was updated via `SSicon_update`
	var/tmp/last_icon_update = null

	///If the atom is currently queued to have it's icon updated in `SSicon_update`
	var/tmp/icon_update_queued = FALSE

	///Delay to apply before updating the icon in `SSicon_update`
	var/icon_update_delay = null

/atom/proc/update_icon()

/**
 * DO NOT USE
 *
 * Left for backward compatibility, use `SSicon_update.add_to_queue(thing)`
 */
/atom/proc/queue_icon_update()
	//Skip if we're being deleted
	if(QDELETED(src))
		return

	SSicon_update.add_to_queue(src)
