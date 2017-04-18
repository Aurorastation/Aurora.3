/var/datum/controller/subsystem/icon/SSicon

/datum/controller/subsystem/icon
	name = "Icon Updates"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 1	// ds
	var/list/queue = list()
	var/list/currentrun

/datum/controller/subsystem/icon/New()
	NEW_SS_GLOBAL(SSicon)

/datum/controller/subsystem/icon/stat_entry()
	..("Q:[queue.len] P:[LAZYLEN(currentrun)]")

/datum/controller/subsystem/icon/fire(resumed = FALSE)
	if (!resumed)
		currentrun = queue
		queue = list()

	var/list/curr = currentrun

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
	if (!icon_update_queued && (world.time + icon_update_delay < world.time))
		icon_update_queued = TRUE
		SSicon.queue += src
