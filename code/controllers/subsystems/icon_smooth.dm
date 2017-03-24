var/datum/controller/subsystem/icon_smooth/SSicon_smooth

/datum/controller/subsystem/icon_smooth
	name = "Icon Smoothing"
	init_order = SS_INIT_SMOOTHING
	wait = 1
	priority = SS_PRIORITY_SMOOTHING
	flags = SS_TICKER | SS_FIRE_IN_LOBBY

	var/list/smooth_queue = list()

/datum/controller/subsystem/icon_smooth/New()
	NEW_SS_GLOBAL(SSicon_smooth)

/datum/controller/subsystem/icon_smooth/fire()
	while(smooth_queue.len)
		var/atom/A = smooth_queue[smooth_queue.len]
		smooth_queue.len--
		smooth_icon(A)
		if (MC_TICK_CHECK)
			return
	if (!smooth_queue.len)
		can_fire = 0

/datum/controller/subsystem/icon_smooth/Initialize()
	for (var/zlevel = 1 to world.maxz)
		smooth_zlevel(zlevel, FALSE)
		
	/*var/queue = smooth_queue
	smooth_queue = list()
	for(var/V in queue)
		var/atom/A = V
		if(!A || A.z <= 2)
			continue
		smooth_icon(A)
		CHECK_TICK*/

	..()
