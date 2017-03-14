// Pretty much just a shim for global iterator, because fuck rewriting that.

/var/datum/subsystem/iterator/SSiterator

/datum/subsystem/iterator
	name = "Iterator"
	flags = SS_KEEP_TIMING | SS_NO_INIT | SS_FIRE_IN_LOBBY
	wait = 1
	var/list/datum/global_iterator/iterators
	var/datum/global_iterator/head
	var/rebuild_count = 0
	var/queue_count = 0

/datum/subsystem/iterator/New()
	NEW_SS_GLOBAL(SSiterator)
	iterators = list()

/datum/subsystem/iterator/stat_entry()
	..("I:[iterators.len] R:[rebuild_count] Q:[queue_count]")

/datum/subsystem/iterator/fire()
	while (head && !MC_TICK_CHECK)
		if (QDELETED(head))
			// Something has gone horribly wrong and we deleted our head!
			rebuild()
			return
		
		if (!head.isprocessing)
			dequeue(head)
			continue

		if (head.next_fire <= world.time)
			// Hit it.
			var/datum/global_iterator/curr = head
			head = curr.next
			curr.fire()
			
			add(curr)
	
/datum/subsystem/iterator/proc/add(datum/global_iterator/iter)
	if (QDELETED(iter))
		return

	queue_count++

	iter.next_fire = iter.delay + world.time
	iter.isprocessing = TRUE

	if (!head && !iterators.len)
		head = iter
		iterators += iter

	else if (!head)
		iterators += iter
		rebuild()
		return
			
	var/datum/global_iterator/curr_loc = head
	while (curr_loc.next && iter.next_fire < curr_loc.next_fire)
		curr_loc = curr_loc.next

	if (!curr_loc.next)
		// End of the line, don't need to do anything special.
		curr_loc.next = iter
		iterators += iter
		return

	// Inserting mid-way into the queue, shift everything down.
	iter.next = curr_loc.next
	iter.prev = curr_loc
	curr_loc.next = iter
	iterators += iter

/datum/subsystem/iterator/proc/remove(datum/global_iterator/iter)
	if (head == iter)
		head = iter.next
		iter.next = null
		return

	var/datum/global_iterator/prev = iter.prev
	var/datum/global_iterator/next = iter.next
	iter.next = null
	iter.prev = null
	prev.next = next
	next.prev = prev

/datum/subsystem/iterator/proc/rebuild()
	var/list/old = iterators
	iterators = list()
	rebuild_count++

	if (!old.len)
		log_debug("iterator: No iterators in queue; aborting rebuild.")
		return

	for (var/thing in old)
		var/datum/global_iterator/iter = thing
		if (QDELETED(iter))
			old -= iter
			continue

		iter.next_fire = iter.delay + world.time

		if (!head || head.next_fire > iter.next_fire)
			head = iter

	if (QDELETED(head))
		log_debug("iterator: unable to find head! Purging iterators!")
		for (var/datum/thing in old)
			if (QDELETED(thing))
				continue

			qdel(thing)

		head = null
		return

	iterators += head
	old -= head

	for (var/thing in old)
		var/datum/global_iterator/iter = thing

		add(iter)

	log_debug("iterator: queue rebuild successful.")


// "Fuck rewriting that" I said.
// "Just a shim" I said.
/datum/global_iterator
	var/datum/global_iterator/next
	var/datum/global_iterator/prev
	var/next_fire

	var/delay

	var/list/the_arguments

/datum/global_iterator/New(list/arguments = list(), autostart = TRUE)
	delay = delay > 0 ? delay : 1

	the_arguments = arguments

	if (autostart)
		start()

/datum/global_iterator/proc/stop()
	isprocessing = FALSE
	SSiterator.remove(src)

/datum/global_iterator/proc/toggle()
	if (isprocessing)
		stop()
	else
		start()

	return isprocessing

/datum/global_iterator/proc/start(list/arguments = null)
	if (arguments)
		the_arguments = arguments

	SSiterator.add(src)

/datum/global_iterator/proc/set_delay(new_delay)
	if (new_delay && new_delay != src.delay)
		delay = new_delay
		stop()
		start()

/datum/global_iterator/process(list/the_args)
	return

/datum/global_iterator/proc/fire()
	process(arglist(the_arguments))

/datum/global_iterator/proc/active()
	return isprocessing

/datum/global_iterator/Destroy()
	stop()
	next = null
	prev = null
	return QDEL_HINT_QUEUE

/datum/global_iterator/proc/set_process_args(list/arguments = list())
	the_arguments = arguments
