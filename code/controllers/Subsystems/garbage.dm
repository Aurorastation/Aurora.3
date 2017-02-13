var/datum/subsystem/garbage_collector/garbage_collector

/datum/subsystem/garbage_collector
	name = "Garbage"
	priority = 15
	wait = 5
	display_order = 2
	flags = SS_FIRE_IN_LOBBY|SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT

	var/collection_timeout = 3000// deciseconds to wait to let running procs finish before we just say fuck it and force del() the object
	var/delslasttick = 0		// number of del()'s we've done this tick
	var/gcedlasttick = 0		// number of things that gc'ed last tick
	var/totaldels = 0
	var/totalgcs = 0

	var/highest_del_time = 0
	var/highest_del_tickusage = 0

	var/list/queue = list() 	// list of refID's of things that should be garbage collected
								// refID's are associated with the time at which they time out and need to be manually del()
								// we do this so we aren't constantly locating them and preventing them from being gc'd

	var/list/tobequeued = list()	//We store the references of things to be added to the queue seperately so we can spread out GC overhead over a few ticks

	var/list/didntgc = list()	// list of all types that have failed to GC associated with the number of times that's happened.
								// the types are stored as strings

	var/list/noqdelhint = list()// list of all types that do not return a QDEL_HINT
	// all types that did not respect qdel(A, force=TRUE) and returned one
	// of the immortality qdel hints
	var/list/noforcerespect = list()

#ifdef TESTING
	var/list/qdel_list = list()	// list of all types that have been qdel()eted
#endif

/datum/subsystem/garbage_collector/New()
	NEW_SS_GLOBAL(garbage_collector)

/datum/subsystem/garbage_collector/stat_entry(msg)
	msg += "Q:[queue.len]|D:[delslasttick]|G:[gcedlasttick]|"
	msg += "GR:"
	if (!(delslasttick+gcedlasttick))
		msg += "n/a|"
	else
		msg += "[round((gcedlasttick/(delslasttick+gcedlasttick))*100, 0.01)]%|"

	msg += "TD:[totaldels]|TG:[totalgcs]|"
	if (!(totaldels+totalgcs))
		msg += "n/a|"
	else
		msg += "TGR:[round((totalgcs/(totaldels+totalgcs))*100, 0.01)]%"
	..(msg)

/datum/subsystem/garbage_collector/fire()
	HandleToBeQueued()
	if(state == SS_RUNNING)
		HandleQueue()

//If you see this proc high on the profile, what you are really seeing is the garbage collection/soft delete overhead in byond.
//Don't attempt to optimize, not worth the effort.
/datum/subsystem/garbage_collector/proc/HandleToBeQueued()
	var/list/tobequeued = src.tobequeued
	var/starttime = world.time
	var/starttimeofday = world.timeofday
	while(tobequeued.len && starttime == world.time && starttimeofday == world.timeofday)
		if (MC_TICK_CHECK)
			break
		var/ref = tobequeued[1]
		Queue(ref)
		tobequeued.Cut(1, 2)

/datum/subsystem/garbage_collector/proc/HandleQueue()
	delslasttick = 0
	gcedlasttick = 0
	var/time_to_kill = world.time - collection_timeout // Anything qdel() but not GC'd BEFORE this time needs to be manually del()
	var/list/queue = src.queue
	var/starttime = world.time
	var/starttimeofday = world.timeofday
	while(queue.len && starttime == world.time && starttimeofday == world.timeofday)
		if (MC_TICK_CHECK)
			break
		var/refID = queue[1]
		if (!refID)
			queue.Cut(1, 2)
			continue

		var/GCd_at_time = queue[refID]
		if(GCd_at_time > time_to_kill)
			break // Everything else is newer, skip them
		queue.Cut(1, 2)
		var/datum/A
		A = locate(refID)
		if (A && A.gcDestroyed == GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by mistake
			#ifdef GC_FAILURE_HARD_LOOKUP
			A.find_references()
			#endif

			// Something's still referring to the qdel'd object.  Kill it.
			var/type = A.type
			testing("GC: -- \ref[A] | [type] was unable to be GC'd and was deleted --")
			didntgc["[type]"]++
			var/time = world.timeofday
			var/tick = world.tick_usage
			var/ticktime = world.time
			del(A)
			tick = (world.tick_usage-tick+((world.time-ticktime)/world.tick_lag*100))

			if (tick > highest_del_tickusage)
				highest_del_tickusage = tick
			time = world.timeofday - time
			if (!time && TICK_DELTA_TO_MS(tick) > 1)
				time = TICK_DELTA_TO_MS(tick)/100
			if (time > highest_del_time)
				highest_del_time = time
			if (time > 10)
				log_game("Error: [type]([refID]) took longer then 1 second to delete (took [time/10] seconds to delete)")
				message_admins("Error: [type]([refID]) took longer then 1 second to delete (took [time/10] seconds to delete).")
				postpone(time/5)
				break
			++delslasttick
			++totaldels
		else
			++gcedlasttick
			++totalgcs

/datum/subsystem/garbage_collector/proc/QueueForQueuing(datum/A)
	if (istype(A) && A.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		tobequeued += A
		A.gcDestroyed = GC_QUEUED_FOR_QUEUING

/datum/subsystem/garbage_collector/proc/Queue(datum/A)
	if (!istype(A) || (!isnull(A.gcDestroyed) && A.gcDestroyed >= 0))
		return
	if (A.gcDestroyed == GC_QUEUED_FOR_HARD_DEL)
		del(A)
		return
	var/gctime = world.time
	var/refid = "\ref[A]"

	A.gcDestroyed = gctime

	if (queue[refid])
		queue -= refid // Removing any previous references that were GC'd so that the current object will be at the end of the list.

	queue[refid] = gctime

/datum/subsystem/garbage_collector/proc/HardQueue(datum/A)
	if (istype(A) && A.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		tobequeued += A
		A.gcDestroyed = GC_QUEUED_FOR_HARD_DEL

/datum/subsystem/garbage_collector/Recover()
	if (istype(garbage_collector.queue))
		queue |= garbage_collector.queue
	if (istype(garbage_collector.tobequeued))
		tobequeued |= garbage_collector.tobequeued

// Should be treated as a replacement for the 'del' keyword.
// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(datum/D, force=FALSE)
	if(!D)
		return
#ifdef TESTING
	garbage_collector.qdel_list += "[D.type]"
#endif
	if(!istype(D))
		del(D)
	else if(isnull(D.gcDestroyed))
		D.gcDestroyed = GC_CURRENTLY_BEING_QDELETED
		var/hint = D.Destroy(force) // Let our friend know they're about to get fucked up.
		if(!D)
			return
		switch(hint)
			if (QDEL_HINT_QUEUE)		//qdel should queue the object for deletion.
				garbage_collector.QueueForQueuing(D)
			if (QDEL_HINT_IWILLGC)
				return
			if (QDEL_HINT_LETMELIVE)	//qdel should let the object live after calling destory.
				if(!force)
					D.gcDestroyed = null //clear the gc variable (important!)
					return
				// Returning LETMELIVE after being told to force destroy
				// indicates the objects Destroy() does not respect force
				if(!garbage_collector.noforcerespect["[D.type]"])
					garbage_collector.noforcerespect["[D.type]"] = "[D.type]"
					testing("WARNING: [D.type] has been force deleted, but is \
						returning an immortal QDEL_HINT, indicating it does \
						not respect the force flag for qdel(). It has been \
						placed in the queue, further instances of this type \
						will also be queued.")
				garbage_collector.QueueForQueuing(D)
			if (QDEL_HINT_HARDDEL)		//qdel should assume this object won't gc, and queue a hard delete using a hard reference to save time from the locate()
				garbage_collector.HardQueue(D)
			if (QDEL_HINT_HARDDEL_NOW)	//qdel should assume this object won't gc, and hard del it post haste.
				del(D)
			if (QDEL_HINT_FINDREFERENCE)//qdel will, if TESTING is enabled, display all references to this object, then queue the object for deletion.
				garbage_collector.QueueForQueuing(D)
				#ifdef TESTING
				D.find_references()
				#endif
			else
				garbage_collector.QueueForQueuing(D)
				/*if(!garbage_collector.noqdelhint["[D.type]"])
					garbage_collector.noqdelhint["[D.type]"] = "[D.type]"
					testing("WARNING: [D.type] is not returning a qdel hint. It is being placed in the queue. Further instances of this type will also be queued.")
				garbage_collector.QueueForQueuing(D)*/
	else if(D.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		CRASH("[D.type] destroy proc was called multiple times, likely due to a qdel loop in the Destroy logic")

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	tag = null
	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)
	return QDEL_HINT_QUEUE

/datum/var/gcDestroyed //Time when this object was destroyed.

#ifdef TESTING
/datum/var/running_find_references 
/datum/var/last_find_references = 0

/datum/verb/find_refs()
	set category = "Debug"
	set name = "Find References"
	set background = 1
	set src in world

	find_references(FALSE)

/datum/proc/find_references(skip_alert)
	running_find_references = type
	if(usr && usr.client)
		if(usr.client.running_find_references)
			testing("CANCELLED search for references to a [usr.client.running_find_references].")
			usr.client.running_find_references = null
			running_find_references = null
			//restart the garbage collector
			garbage_collector.can_fire = 1
			garbage_collector.next_fire = world.time + world.tick_lag
			return

		if(!skip_alert)
			if(alert("Running this will lock everything up for about 5 minutes.  Would you like to begin the search?", "Find References", "Yes", "No") == "No")
				running_find_references = null
				return

	//this keeps the garbage collector from failing to collect objects being searched for in here
	garbage_collector.can_fire = 0

	if(usr && usr.client)
		usr.client.running_find_references = type

	testing("Beginning search for references to a [type].")
	last_find_references = world.time
	find_references_in_globals()
	for(var/datum/thing in world)
		DoSearchVar(thing, "WorldRef: [thing]")
	testing("Completed search for references to a [type].")
	if(usr && usr.client)
		usr.client.running_find_references = null
	running_find_references = null

	//restart the garbage collector
	garbage_collector.can_fire = 1
	garbage_collector.next_fire = world.time + world.tick_lag

/client/verb/purge_all_destroyed_objects()
	set category = "Debug"
	if(garbage_collector)
		while(garbage_collector.queue.len)
			var/datum/o = locate(garbage_collector.queue[1])
			if(istype(o) && o.gcDestroyed)
				del(o)
				garbage_collector.totaldels++
			garbage_collector.queue.Cut(1, 2)

/datum/verb/qdel_then_find_references()
	set category = "Debug"
	set name = "qdel() then Find References"
	set background = 1
	set src in world

	qdel(src)
	if(!running_find_references)
		find_references(TRUE)

/client/verb/show_qdeleted()
	set category = "Debug"
	set name = "Show qdel() Log"
	set desc = "Render the qdel() log and display it"

	var/dat = "<B>List of things that have been qdel()eted this round</B><BR><BR>"

	var/tmplist = list()
	for(var/elem in garbage_collector.qdel_list)
		if(!(elem in tmplist))
			tmplist[elem] = 0
		tmplist[elem]++

	for(var/path in tmplist)
		dat += "[path] - [tmplist[path]] times<BR>"

	usr << browse(dat, "window=qdeletedlog")

#define SearchVar(X) DoSearchVar(X, "Global: " + #X)

/datum/proc/DoSearchVar(X, Xname)
	if(usr && usr.client && !usr.client.running_find_references) return
	if(istype(X, /datum))
		var/datum/D = X
		if(D.last_find_references == last_find_references)
			return
		D.last_find_references = last_find_references
		for(var/V in D.vars)
			for(var/varname in D.vars)
				var/variable = D.vars[varname]
				if(variable == src)
					testing("Found [src.type] \ref[src] in [D.type]'s [varname] var. [Xname]")
				else if(islist(variable))
					if(src in variable)
						testing("Found [src.type] \ref[src] in [D.type]'s [varname] list var. Global: [Xname]")
#ifdef GC_FAILURE_HARD_LOOKUP
					for(var/I in variable)
						DoSearchVar(I, TRUE)
				else
					DoSearchVar(variable, "[Xname]: [varname]")
#endif
	else if(islist(X)) 
		if(src in X)
			testing("Found [src.type] \ref[src] in list [Xname].")
#ifdef GC_FAILURE_HARD_LOOKUP
		for(var/I in X)
			DoSearchVar(I, Xname + ": list")
#else
	CHECK_TICK
#endif

#endif

/proc/deleted(atom/A)
	return QDELETED(A)

/icon/Destroy()
	return QDEL_HINT_HARDDEL

/image/Destroy()
	return QDEL_HINT_HARDDEL

/mob/Destroy()
	return QDEL_HINT_HARDDEL

/turf/Destroy()
	return QDEL_HINT_HARDDEL
