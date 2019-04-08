var/datum/controller/subsystem/icon_smooth/SSicon_smooth

/datum/controller/subsystem/icon_smooth
	name = "Icon Smoothing"
	init_order = SS_INIT_SMOOTHING
	wait = 1
	priority = SS_PRIORITY_SMOOTHING
	flags = SS_TICKER | SS_FIRE_IN_LOBBY

	var/list/smooth_queue = list()
	var/list/typecachecache = list()

	var/explosion_in_progress = FALSE

/datum/controller/subsystem/icon_smooth/New()
	NEW_SS_GLOBAL(SSicon_smooth)

/datum/controller/subsystem/icon_smooth/Recover()
	smooth_queue = SSicon_smooth.smooth_queue

/datum/controller/subsystem/icon_smooth/stat_entry()
	..("Q:[smooth_queue.len]")

/datum/controller/subsystem/icon_smooth/fire()
	if (explosion_in_progress)
		return
		
	while(smooth_queue.len)
		var/atom/A = smooth_queue[smooth_queue.len]
		smooth_queue.len--
		smooth_icon(A)
		if (MC_TICK_CHECK)
			return
	if (!smooth_queue.len)
		suspend()

/datum/controller/subsystem/icon_smooth/ExplosionStart()
	explosion_in_progress = TRUE

/datum/controller/subsystem/icon_smooth/ExplosionEnd()
	explosion_in_progress = FALSE

/datum/controller/subsystem/icon_smooth/Initialize()
	for (var/zlevel = 1 to world.maxz)
		smooth_zlevel(zlevel, FALSE)

	if (config.fastboot)
		log_debug("icon_smoothing: Skipping prebake, fastboot enabled.")
		..()
		return

	var/queue = smooth_queue
	smooth_queue = list()
	for(var/V in queue)
		var/atom/A = V
		if(!A)
			continue
		smooth_icon(A)
		CHECK_TICK

	..()
