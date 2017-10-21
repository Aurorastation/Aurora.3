/var/datum/controller/subsystem/icon/SSicon_update

/datum/controller/subsystem/icon
	name = "Icon Updates"
	wait = 1	// ticks
	flags = SS_TICKER
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE
	
	var/list/queue = list()

/datum/controller/subsystem/icon/New()
	NEW_SS_GLOBAL(SSicon_update)

/datum/controller/subsystem/icon/stat_entry()
	..("QU:[queue.len]")

/datum/controller/subsystem/icon/Initialize()
	fire(FALSE, TRUE)
	..()

/datum/controller/subsystem/icon/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queue

	if (!curr.len)
		suspend()
		return

	while (curr.len)
		var/atom/A = curr[curr.len]
		var/list/argv = curr[A]
		curr.len--

		A.icon_update_queued = FALSE
		if (islist(argv))
			A.update_icon(arglist(argv))
		else
			A.update_icon()
		A.update_above()
		A.last_icon_update = world.time

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/atom
	var/tmp/last_icon_update
	var/tmp/icon_update_queued
	var/icon_update_delay

/atom/proc/update_icon()

/atom/proc/queue_icon_update(...)
	if (!icon_update_queued && (!icon_update_delay || (last_icon_update + icon_update_delay < world.time)))
		icon_update_queued = TRUE
		SSicon_update.queue[src] = args.len ? args : TRUE
		if (SSicon_update.suspended)
			SSicon_update.wake()
