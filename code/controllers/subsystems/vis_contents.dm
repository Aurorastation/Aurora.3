SUBSYSTEM_DEF(vis_contents_update)
	name = "Vis Contents"
	flags = SS_BACKGROUND
	wait = 1
	init_order = INIT_ORDER_VISCONTENTS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/queue_refs = list()

/datum/controller/subsystem/vis_contents_update/stat_entry()
	..("Queue: [queue_refs.len]")

/datum/controller/subsystem/vis_contents_update/Initialize()
	fire(FALSE, TRUE)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/vis_contents_update/StartLoadingMap()
	can_fire = FALSE

/datum/controller/subsystem/vis_contents_update/StopLoadingMap()
	can_fire = TRUE

// Largely copied from SSicon_update.
/datum/controller/subsystem/vis_contents_update/fire(resumed = FALSE, no_mc_tick = FALSE)
	if(!queue_refs.len)
		can_fire = FALSE
		return
	var/i = 0
	while (i < queue_refs.len)
		i++
		var/atom/A = queue_refs[i]
		if(QDELETED(A))
			continue
		if(Master.map_loading)
			queue_refs.Cut(1, i+1)
			return
		A.vis_update_queued = FALSE
		A.update_vis_contents(force_no_queue = TRUE)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue_refs.Cut(1, i+1)
			return
	queue_refs.Cut()

/atom
	var/vis_update_queued = FALSE

/atom/proc/queue_vis_contents_update()
	if(vis_update_queued)
		return
	vis_update_queued = TRUE
	SSvis_contents_update.queue_refs.Add(src)
	SSvis_contents_update.can_fire = TRUE

// Horrible colon syntax below is because vis_contents
// exists in /atom.vars, but will not compile. No idea why.
/atom/proc/add_vis_contents(adding)
	src:vis_contents |= adding

/atom/proc/remove_vis_contents(removing)
	src:vis_contents -= removing

/atom/proc/clear_vis_contents()
	src:vis_contents = null

/atom/proc/set_vis_contents(list/adding)
	src:vis_contents = adding

/atom/proc/get_vis_contents_to_add()
	return

/atom/proc/update_vis_contents(force_no_queue = FALSE)
	if(!force_no_queue && (!SSvis_contents_update.initialized || TICK_CHECK))
		queue_vis_contents_update()
		return
	vis_update_queued = FALSE
	var/new_vis_contents = get_vis_contents_to_add()
	if(length(new_vis_contents))
		set_vis_contents(new_vis_contents)
	else if(length(src:vis_contents))
		clear_vis_contents()

/image/proc/add_vis_contents(adding)
	vis_contents |= adding

/image/proc/remove_vis_contents(removing)
	vis_contents -= removing

/image/proc/clear_vis_contents()
	vis_contents.Cut()

/image/proc/set_vis_contents(list/adding)
	vis_contents = adding
