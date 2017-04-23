/var/datum/controller/subsystem/icon/SSicon_update

/datum/controller/subsystem/icon
	name = "Icon Updates"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 1	// ds
	priority = SS_PRIORITY_ICON_UPDATE
	
	var/list/queue = list()
	var/list/currentrun

/datum/controller/subsystem/icon/New()
	NEW_SS_GLOBAL(SSicon_update)

/datum/controller/subsystem/icon/stat_entry()
	..("Q:[queue.len] P:[LAZYLEN(currentrun)]")

/datum/controller/subsystem/icon/fire(resumed = FALSE)
	if (!resumed)
		currentrun = queue
		queue = list()

	var/list/curr = currentrun

	if (!curr.len)
		suspend()
		return

	while (curr.len)
		var/atom/A = curr[curr.len]
		curr.len--

		A.icon_update_queued = FALSE
		A.update_icon()
		A.last_icon_update = world.time

		if (MC_TICK_CHECK)
			return

/atom
	var/last_icon_update
	var/icon_update_queued
	var/icon_update_delay

/atom/proc/update_icon()

/atom/proc/queue_icon_update()
	if (!icon_update_queued && (!icon_update_delay || (last_icon_update + icon_update_delay < world.time)))
		icon_update_queued = TRUE
		SSicon_update.queue += src
		if (SSicon_update.suspended)
			SSicon_update.wake()
