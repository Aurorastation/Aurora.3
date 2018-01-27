var/datum/controller/subsystem/garbage_collector/SSgarbage

/datum/controller/subsystem/garbage_collector
	name = "Garbage"
	priority = SS_PRIORITY_GARBAGE
	wait = 2 SECONDS
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
	var/list/sleptDestroy = list()	//Same as above but these are paths that slept during their Destroy call

	var/list/noqdelhint = list()// list of all types that do not return a QDEL_HINT
	// all types that did not respect qdel(A, force=TRUE) and returned one
	// of the immortality qdel hints
	var/list/noforcerespect = list()

#ifdef TESTING
	var/list/qdel_list = list()	// list of all types that have been qdel()eted
#endif

/datum/controller/subsystem/garbage_collector/New()
	NEW_SS_GLOBAL(SSgarbage)

/datum/controller/subsystem/garbage_collector/stat_entry(msg)
	msg += "W:[tobequeued.len]|Q:[queue.len]|D:[delslasttick]|G:[gcedlasttick]|"
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

/datum/controller/subsystem/garbage_collector/fire()
	HandleToBeQueued()
	if(state == SS_RUNNING)
		HandleQueue()

	if (state == SS_PAUSED)
		state = SS_RUNNING

//If you see this proc high on the profile, what you are really seeing is the garbage collection/soft delete overhead in byond.
//Don't attempt to optimize, not worth the effort.
/datum/controller/subsystem/garbage_collector/proc/HandleToBeQueued()
	var/list/tobequeued = src.tobequeued
	var/starttime = world.time
	var/starttimeofday = world.timeofday
	var/idex = 1
	while((tobequeued.len - (idex - 1)) && starttime == world.time && starttimeofday == world.timeofday)
		if (MC_TICK_CHECK)
			break
		var/ref = tobequeued[idex]
		tobequeued[idex++] = null	// Clear this ref to assist hard deletes in Queue().
		Queue(ref)

	if (idex > 1)
		tobequeued.Cut(1, idex)

/datum/controller/subsystem/garbage_collector/proc/HandleQueue()
	delslasttick = 0
	gcedlasttick = 0
	var/time_to_kill = world.time - collection_timeout // Anything qdel() but not GC'd BEFORE this time needs to be manually del()
	var/list/queue = src.queue
	var/starttime = world.time
	var/starttimeofday = world.timeofday
	var/idex = 1
	while((queue.len - (idex - 1)) && starttime == world.time && starttimeofday == world.timeofday)
		if (MC_TICK_CHECK)
			break
		var/refID = queue[idex]
		if (!refID)
			idex++
			continue

		var/GCd_at_time = queue[refID]
		if(GCd_at_time > time_to_kill)
			break // Everything else is newer, skip them
		idex++
		var/datum/A
		A = locate(refID)
		if (A && A.gcDestroyed == GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by mistake
			#ifdef GC_FAILURE_HARD_LOOKUP
			A.find_references()
			#endif

			// Something's still referring to the qdel'd object.  Kill it.
			var/type = A.type
			log_gc("-- \ref[A] | [type] was unable to be GC'd and was deleted --", type)
			didntgc["[type]"]++

			HardDelete(A)

			++delslasttick
			++totaldels
		else
			++gcedlasttick
			++totalgcs

	if (idex > 1)
		queue.Cut(1, idex)

/datum/controller/subsystem/garbage_collector/proc/QueueForQueuing(datum/A)
	if (istype(A) && A.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		tobequeued += A
		A.gcDestroyed = GC_QUEUED_FOR_QUEUING

/datum/controller/subsystem/garbage_collector/proc/Queue(datum/A)
	if (!istype(A) || (!isnull(A.gcDestroyed) && A.gcDestroyed >= 0))
		return
	if (A.gcDestroyed == GC_QUEUED_FOR_HARD_DEL)
		HardDelete(A)
		return
	var/gctime = world.time
	var/refid = "\ref[A]"

	A.gcDestroyed = gctime

	if (queue[refid])
		queue -= refid // Removing any previous references that were GC'd so that the current object will be at the end of the list.

	queue[refid] = gctime

// For profiling.
/datum/controller/subsystem/garbage_collector/proc/HardDelete(datum/A)
	var/time = world.timeofday
	var/tick = world.tick_usage
	var/ticktime = world.time

	var/type = A.type
	var/refID = "\ref[A]"

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
		log_gc("Error: [type]([refID]) took longer then 1 second to delete (took [time/10] seconds to delete)", type, TRUE)
		message_admins("Error: [type]([refID]) took longer then 1 second to delete (took [time/10] seconds to delete).")
		postpone(time/5)

/datum/controller/subsystem/garbage_collector/proc/HardQueue(datum/A)
	if (istype(A) && A.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		tobequeued += A
		A.gcDestroyed = GC_QUEUED_FOR_HARD_DEL

/datum/controller/subsystem/garbage_collector/Recover()
	if (istype(SSgarbage.queue))
		queue |= SSgarbage.queue
	if (istype(SSgarbage.tobequeued))
		tobequeued |= SSgarbage.tobequeued

// Should be treated as a replacement for the 'del' keyword.
// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(datum/D, force=FALSE)
	if(!D)
		return
#ifdef TESTING
	SSgarbage.qdel_list += "[D.type]"
#endif
	if(!istype(D))
		del(D)
	else if(isnull(D.gcDestroyed))
		D.gcDestroyed = GC_CURRENTLY_BEING_QDELETED
		var/start_time = world.time
		var/hint = D.Destroy(force) // Let our friend know they're about to get fucked up.
		if(world.time != start_time)
			SSgarbage.sleptDestroy["[D.type]"]++
		if(!D)
			return
		switch(hint)
			if (QDEL_HINT_QUEUE)		//qdel should queue the object for deletion.
				SSgarbage.QueueForQueuing(D)
			if (QDEL_HINT_IWILLGC)
				D.gcDestroyed = world.time
				return
			if (QDEL_HINT_LETMELIVE)	//qdel should let the object live after calling destory.
				if(!force)
					D.gcDestroyed = null //clear the gc variable (important!)
					return
				// Returning LETMELIVE after being told to force destroy
				// indicates the objects Destroy() does not respect force
				if(!SSgarbage.noforcerespect["[D.type]"])
					SSgarbage.noforcerespect["[D.type]"] = "[D.type]"
					testing("WARNING: [D.type] has been force deleted, but is \
						returning an immortal QDEL_HINT, indicating it does \
						not respect the force flag for qdel(). It has been \
						placed in the queue, further instances of this type \
						will also be queued.")
				SSgarbage.QueueForQueuing(D)
			if (QDEL_HINT_HARDDEL)		//qdel should assume this object won't gc, and queue a hard delete using a hard reference to save time from the locate()
				SSgarbage.HardQueue(D)
			if (QDEL_HINT_HARDDEL_NOW)	//qdel should assume this object won't gc, and hard del it post haste.
				SSgarbage.HardDelete(D)
			if (QDEL_HINT_FINDREFERENCE)//qdel will, if TESTING is enabled, display all references to this object, then queue the object for deletion.
				SSgarbage.QueueForQueuing(D)
				#ifdef TESTING
				D.find_references()
				#endif
			else
				if(!SSgarbage.noqdelhint["[D.type]"])
					SSgarbage.noqdelhint["[D.type]"] = "[D.type]"
					testing("WARNING: [D.type] is not returning a qdel hint. It is being placed in the queue. Further instances of this type will also be queued.")
				SSgarbage.QueueForQueuing(D)
	else if(D.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		CRASH("[D.type] destroy proc was called multiple times, likely due to a qdel loop in the Destroy logic")

/client/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW

/image/Destroy()
	..()
	return QDEL_HINT_HARDDEL
