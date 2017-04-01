/var/datum/controller/process/scheduler/scheduler

/************
* Scheduler *
************/
/datum/controller/process/scheduler
	var/list/datum/scheduled_task/tasks = list()
	var/datum/scheduled_task/head

/datum/controller/process/scheduler/setup()
	name = "scheduler"
	schedule_interval = 2
	scheduler = src

/datum/controller/process/scheduler/doWork()
	while (head && !PSCHED_CHECK_TICK)
		if (head.destroyed)
			head.kill()
			head = head.next
			tasks -= head
			continue
		if (head.trigger_time >= world.time)
			return	// Nothing after this will be ready to fire.

		// This one's ready to fire, process it.
		var/datum/scheduled_task/task = head
		head = task.next
		task.pre_process()
		task.process()
		task.post_process()
		if (task.destroyed)	// post_process probably destroyed it.
			tasks -= task
			task.kill()

/datum/controller/process/scheduler/proc/queue(datum/scheduled_task/task)
	if (!task || !task.trigger_time)
		warning("scheduler: Invalid task queued! Ignoring.")
		return
	// Reset this in-case we're doing a rebuild.
	task.next = null
	if (!head && !tasks.len)
		head = task
		tasks += task
		return

	if (!head)	// Head's missing but we still have tasks, rebuild.
		tasks += task
		rebuild_queue()
		return

	var/datum/scheduled_task/curr = head
	while (curr.next && curr.trigger_time < task.trigger_time)
		curr = curr.next

	if (!curr.next)
		// We're at the end of the queue, just append.
		curr.next = task
		tasks += task
		return
	
	// Inserting midway into the list.
	var/old_next = curr.next
	curr.next = task
	task.next = old_next
	tasks += task

// Rebuilds the queue linked-list, removing invalid or destroyed entries.
/datum/controller/process/scheduler/proc/rebuild_queue()
	log_debug("scheduler: Rebuilding queue.")
	var/list/old_tasks = tasks
	tasks = list()
	if (!old_tasks.len)
		log_debug("scheduler: rebuild was called on empty queue! Aborting.")
		return

	// Find the head.
	for (var/thing in old_tasks)
		var/datum/scheduled_task/task = thing
		if (QDELETED(task))
			old_tasks -= task
			continue

		if (task.destroyed)
			old_tasks -= task
			task.kill()
			continue

		if (!head || task.trigger_time < head.trigger_time)
			head = task

	if (!head)
		log_debug("scheduler: unable to find head! Purging task queue.")
		for (var/thing in old_tasks)
			var/datum/scheduled_task/task = thing
			if (QDELETED(task))
				continue

			task.kill()

		head = null
		return

	// Don't queue the head.
	tasks += head
	old_tasks -= head

	// Now rebuild the queue.
	for (var/thing in old_tasks)
		var/datum/scheduled_task/task = thing

		queue(task)

	log_debug("scheduler: Queue diff is [old_tasks.len - tasks.len].")

/datum/controller/process/scheduler/statProcess()
	..()
	stat(null, "[tasks.len] task\s")

/datum/controller/process/scheduler/proc/schedule(var/datum/scheduled_task/st)
	queue(st)

/datum/controller/process/scheduler/proc/unschedule(var/datum/scheduled_task/st)
	st.destroyed = TRUE

/**********
* Helpers *
**********/
/proc/schedule(source, the_proc, time, ...)
	if (time < 0)
		return
	time += world.time
	var/list/the_args
	if (length(args) > 3)
		the_args = args.Copy(4)
	else
		the_args = list()
	if (source)
		return schedule_task_with_source(time, the_proc, the_args)
	else
		return schedule_task(time, the_proc, the_args)

/proc/schedule_task_in(var/in_time, var/procedure, var/list/arguments = list())
	return schedule_task(world.time + in_time, procedure, arguments)

/proc/schedule_task_with_source_in(var/in_time, var/source, var/procedure, var/list/arguments = list())
	return schedule_task_with_source(world.time + in_time, source, procedure, arguments)

/proc/schedule_task(var/trigger_time, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task(trigger_time, procedure, arguments, /proc/destroy_scheduled_task, list())
	scheduler.schedule(st)
	return st

/proc/schedule_task_with_source(var/trigger_time, var/source, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task/source(trigger_time, source, procedure, arguments, /proc/destroy_scheduled_task, list())
	scheduler.schedule(st)
	return st

/proc/schedule_repeating_task(var/trigger_time, var/repeat_interval, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task(trigger_time, procedure, arguments, /proc/repeat_scheduled_task, list(repeat_interval))
	scheduler.schedule(st)
	return st

/proc/schedule_repeating_task_with_source(var/trigger_time, var/repeat_interval, var/source, var/procedure, var/list/arguments)
	var/datum/scheduled_task/st = new/datum/scheduled_task/source(trigger_time, source, procedure, arguments, /proc/repeat_scheduled_task, list(repeat_interval))
	scheduler.schedule(st)
	return st
