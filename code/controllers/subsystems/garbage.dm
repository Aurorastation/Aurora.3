SUBSYSTEM_DEF(garbage)
	name = "Garbage"
	priority = SS_PRIORITY_GARBAGE
	wait = 2 SECONDS
	flags = SS_POST_FIRE_TIMING|SS_BACKGROUND|SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	init_stage = INITSTAGE_EARLY

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

	#ifdef REFERENCE_TRACKING
	var/list/qdel_list = list()	// list of all types that have been qdel()eted
	#endif

	#ifdef REFERENCE_TRACKING
	var/list/reference_find_on_fail = list()
	#ifdef REFERENCE_TRACKING_DEBUG
	//Should we save found refs. Used for unit testing
	var/should_save_refs = FALSE
	#endif
	#endif

/datum/controller/subsystem/garbage/stat_entry(msg)
	msg = "W:[tobequeued.len]|Q:[queue.len]|D:[delslasttick]|G:[gcedlasttick]|"
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
	return ..()

/datum/controller/subsystem/garbage/fire()
	HandleToBeQueued()
	if(state == SS_RUNNING)
		HandleQueue()

	if (state == SS_PAUSED)
		state = SS_RUNNING

//If you see this proc high on the profile, what you are really seeing is the garbage collection/soft delete overhead in byond.
//Don't attempt to optimize, not worth the effort.
/datum/controller/subsystem/garbage/proc/HandleToBeQueued()
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

/datum/controller/subsystem/garbage/proc/HandleQueue()
	delslasttick = 0
	gcedlasttick = 0
	var/time_to_kill = world.time - collection_timeout // Anything qdel() but not GC'd BEFORE this time needs to be manually del()
	var/list/queue = src.queue
	var/starttime = world.time
	var/starttimeofday = world.timeofday
	var/idex = 1
	#ifdef REFERENCE_TRACKING
	var/ref_searching = FALSE
	#endif
	while((queue.len - (idex - 1)) && starttime == world.time && starttimeofday == world.timeofday)
		if (MC_TICK_CHECK)
			break
		#ifdef REFERENCE_TRACKING
		if (ref_searching)
			break
		#endif
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
			#ifdef REFERENCE_TRACKING
			if(reference_find_on_fail[text_ref(A)])
				INVOKE_ASYNC(A, TYPE_PROC_REF(/datum, find_references))
				ref_searching = TRUE
			#ifdef GC_FAILURE_HARD_LOOKUP
			else
				INVOKE_ASYNC(A, TYPE_PROC_REF(/datum, find_references))
				ref_searching = TRUE
			#endif
			reference_find_on_fail -= text_ref(A)
			#endif

			// Something's still referring to the qdel'd object.  Kill it.
			var/type = A.type
			log_subsystem_garbage_harddel("-- \ref[A] | [type] was unable to be GC'd and was deleted --", type)
			didntgc["[type]"]++

			#ifdef REFERENCE_TRACKING
			if(ref_searching)
				continue //ref searching intentionally cancels all further fires while running so things that hold references don't end up getting deleted, so we want to return here instead of continue
			#endif

			HardDelete(A)

			++delslasttick
			++totaldels
		else
			++gcedlasttick
			++totalgcs
			#ifdef REFERENCE_TRACKING
			reference_find_on_fail -= text_ref(A)
			#endif

	if (idex > 1)
		queue.Cut(1, idex)

/datum/controller/subsystem/garbage/proc/QueueForQueuing(datum/A)
	if (istype(A) && A.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		tobequeued += A
		A.gcDestroyed = GC_QUEUED_FOR_QUEUING

/datum/controller/subsystem/garbage/proc/Queue(datum/A)
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
/datum/controller/subsystem/garbage/proc/HardDelete(datum/A)
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
		log_subsystem_garbage_error("Error: [type]([refID]) took longer then 1 second to delete (took [time/10] seconds to delete)", type, TRUE)
		message_admins("Error: [type]([refID]) took longer then 1 second to delete (took [time/10] seconds to delete).")
		postpone(time/5)

/datum/controller/subsystem/garbage/proc/HardQueue(datum/A)
	if (istype(A) && A.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		tobequeued += A
		A.gcDestroyed = GC_QUEUED_FOR_HARD_DEL

/datum/controller/subsystem/garbage/Recover()
	if (istype(SSgarbage.queue))
		queue |= SSgarbage.queue
	if (istype(SSgarbage.tobequeued))
		tobequeued |= SSgarbage.tobequeued

// Should be treated as a replacement for the 'del' keyword.
// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(datum/D, force=FALSE)
	if(!D)
		return
#ifdef REFERENCE_TRACKING
	SSgarbage.qdel_list += "[D.type]"
#endif
	if(!istype(D))
		del(D)
	else if(isnull(D.gcDestroyed))
		if (SEND_SIGNAL(D, COMSIG_PARENT_PREQDELETED, force)) // Give the components a chance to prevent their parent from being deleted
			return
		// this SEND_SIGNAL should be above Destroy because Destroy sets signal_enabled to FALSE
		SEND_SIGNAL(D, COMSIG_QDELETING, force) // Let the (remaining) components know about the result of Destroy
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
					log_subsystem_garbage_warning("WARNING: [D.type] has been force deleted, but is \
						returning an immortal QDEL_HINT, indicating it does \
						not respect the force flag for qdel(). It has been \
						placed in the queue, further instances of this type \
						will also be queued.")
				SSgarbage.QueueForQueuing(D)
			if (QDEL_HINT_HARDDEL)		//qdel should assume this object won't gc, and queue a hard delete using a hard reference to save time from the locate()
				SSgarbage.HardQueue(D)
			if (QDEL_HINT_HARDDEL_NOW)	//qdel should assume this object won't gc, and hard del it post haste.
				SSgarbage.HardDelete(D)
			if (QDEL_HINT_FINDREFERENCE)//qdel will, if REFERENCE_TRACKING is enabled, display all references to this object, then queue the object for deletion.
				SSgarbage.QueueForQueuing(D)
				#ifdef REFERENCE_TRACKING
				INVOKE_ASYNC(D, TYPE_PROC_REF(/datum, find_references), TRUE)
				#endif
			if (QDEL_HINT_IFFAIL_FINDREFERENCE) // qdel will, if REFERENCE_TRACKING is enabled and the object fails to collect, display all references to this object
				SSgarbage.QueueForQueuing(D)
				#ifdef REFERENCE_TRACKING
				SSgarbage.reference_find_on_fail[text_ref(D)] = TRUE
				#endif
			else
				if(!SSgarbage.noqdelhint["[D.type]"])
					SSgarbage.noqdelhint["[D.type]"] = "[D.type]"
					log_subsystem_garbage_warning("WARNING: [D.type] is not returning a qdel hint. It is being placed in the queue. Further instances of this type will also be queued.")
				SSgarbage.QueueForQueuing(D)
	else if(D.gcDestroyed == GC_CURRENTLY_BEING_QDELETED)
		CRASH("[D.type] destroy proc was called multiple times, likely due to a qdel loop in the Destroy logic")

/client/Destroy()
	..()
	return QDEL_HINT_HARDDEL_NOW


// REFERENCE TRACKING (the old garbage-debug file) //
// Only present if the appropriate define is set   //
#ifdef REFERENCE_TRACKING

/datum/verb/find_refs()
	set category = "Debug"
	set name = "Find References"
	set background = 1
	set src in world

	find_references(FALSE)

/client/verb/show_qdeleted()
	set category = "Debug"
	set name = "Show qdel() Log"
	set desc = "Render the qdel() log and display it"

	var/dat = "<B>List of things that have been qdel()eted this round</B><BR><BR>"

	var/tmplist = list()
	for(var/elem in SSgarbage.qdel_list)
		if(!(elem in tmplist))
			tmplist[elem] = 0
		tmplist[elem]++

	sortTim(tmplist, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)

	for(var/path in tmplist)
		dat += "[path] - [tmplist[path]] times<BR>"

	usr << browse(dat, "window=qdeletedlog")

/datum/proc/find_references(skip_alert)
	running_find_references = type
	if(usr?.client)
		if(usr.client.running_find_references)
			testing("CANCELLED search for references to a [usr.client.running_find_references].")
			usr.client.running_find_references = null
			running_find_references = null
			SSgarbage.enable()
			return

		if(!skip_alert && alert(usr, "Running this will lock everything up for 5+ minutes. Would you like to begin the search?", "Find References", "Yes", "No") != "Yes")
			running_find_references = null
			return

	SSgarbage.disable() // Keeps the GC from failing to collect objects being searched for here

	if(usr?.client)
		usr.client.running_find_references = type

	//Time to search the whole game for our ref
	testing("Beginning search for references to a [type].")
	var/starting_time = world.time

	//Yes we do actually need to do this. The searcher refuses to read weird lists
	//And global.vars is a really weird list
	var/global_vars = list()
	for(var/key in global.vars)
		global_vars[key] = global.vars[key]

	search_var(global_vars, "Native Global", search_time = starting_time)
	testing("Finished searching native globals")

	for(var/datum/thing in world) // atoms (don't believe its lies)
		search_var(thing, "World -> [thing.type]", search_time = starting_time)
	testing("Finished searching atoms")

	for(var/datum/thing) // datums
		search_var(thing, "Datums -> [thing.type]", search_time = starting_time)
	testing("Finished searching datums")

	//Warning, attempting to search clients like this will cause crashes if done on live. Watch yourself
	for(var/client/thing) // clients
		search_var(thing, "Clients -> [thing.type]", search_time = starting_time)
	testing("Finished searching clients")

	testing("Completed all searches for references to a [type].")

	if(usr?.client)
		usr.client.running_find_references = null
	running_find_references = null

	SSgarbage.enable() //restart the garbage collector

/datum/proc/search_var(potential_container, container_name, recursive_limit = 64, search_time = world.time)
	//If we are performing a search without a check tick, we should avoid sleeping
	#if defined(FIND_REF_NO_CHECK_TICK)
	SHOULD_NOT_SLEEP(TRUE)
	#endif

	#ifdef REFERENCE_TRACKING_DEBUG
	if(SSgarbage.should_save_refs && !found_refs)
		found_refs = list()
	#endif

	if(usr?.client && !usr.client.running_find_references)
		return

	if(!recursive_limit)
		testing("Recursion limit reached. [container_name]")
		return

	//Check each time you go down a layer. This makes it a bit slow, but it won't effect the rest of the game at all
	#ifndef FIND_REF_NO_CHECK_TICK
	CHECK_TICK
	#endif

	if(isdatum(potential_container))
		var/datum/datum_container = potential_container
		if(datum_container.last_find_references == search_time)
			return

		datum_container.last_find_references = search_time
		var/list/vars_list = datum_container.vars

		for(var/varname in vars_list)
			#ifndef FIND_REF_NO_CHECK_TICK
			CHECK_TICK
			#endif
			if (varname == "vars" || varname == "vis_locs") //Fun fact, vis_locs don't count for references
				continue
			var/variable = vars_list[varname]

			if(variable == src)
				#ifdef REFERENCE_TRACKING_DEBUG
				if(SSgarbage.should_save_refs)
					found_refs[varname] = TRUE
					continue //End early, don't want these logging
				#endif
				testing("Found [type] [text_ref(src)] in [datum_container.type]'s [text_ref(datum_container)] [varname] var. [container_name]")
				continue

			if(islist(variable))
				search_var(variable, "[container_name] [text_ref(datum_container)] -> [varname] (list)", recursive_limit - 1, search_time)

	else if(islist(potential_container))
		var/normal = IS_NORMAL_LIST(potential_container)
		var/list/potential_cache = potential_container
		for(var/element_in_list in potential_cache)
			#ifndef FIND_REF_NO_CHECK_TICK
			CHECK_TICK
			#endif
			// Check normal entries
			if(element_in_list == src)
				#ifdef REFERENCE_TRACKING_DEBUG
				if(SSgarbage.should_save_refs)
					found_refs[potential_cache] = TRUE
					continue //End early, don't want these logging
				#endif
				testing("Found [type] [text_ref(src)] in list [container_name]\[[element_in_list]\]")
				continue

			var/assoc_val = null
			if(!isnum(element_in_list) && normal)
				assoc_val = potential_cache[element_in_list]
			// Check assoc entries
			if(assoc_val == src)
				#ifdef REFERENCE_TRACKING_DEBUG
				if(SSgarbage.should_save_refs)
					found_refs[potential_cache] = TRUE
					continue //End early, don't want these logging
				#endif
				testing("Found [type] [text_ref(src)] in list [container_name]\[[element_in_list]\]")
				continue

			//We need to run both of these checks, since our object could be hiding in either of them
			// Check normal sublists
			if(islist(element_in_list))
				search_var(element_in_list, "[container_name] -> [element_in_list] (list)", recursive_limit - 1, search_time)
			// Check assoc sublists
			if(islist(assoc_val))
				search_var(potential_container[element_in_list], "[container_name]\[[element_in_list]\] -> [assoc_val] (list)", recursive_limit - 1, search_time)

/proc/qdel_and_find_ref_if_fail(datum/thing_to_qdel, force = FALSE)
	thing_to_qdel.qdel_and_find_ref_if_fail(force)

/datum/proc/qdel_and_find_ref_if_fail(force = FALSE)
	SSgarbage.reference_find_on_fail[text_ref(src)] = TRUE
	qdel(src, force)

#endif
