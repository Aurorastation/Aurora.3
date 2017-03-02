/var/datum/controller/process/scheduler/scheduler

/************
* Scheduler *
************/
/datum/controller/process/scheduler
	var/list/datum/scheduled_task/tasks = list()
	var/datum/scheduled_task/head

/datum/controller/process/scheduler/setup()
	name = "scheduler"
	schedule_interval = 2 SECONDS
	scheduler = src

/datum/controller/process/scheduler/doWork()
	var/datum/scheduled_task/curr = head
	while (curr && !PSCHED_CHECK_TICK)
		if (curr.destroyed)
			head = curr.next
			tasks -= curr
			curr.kill()
			continue
		if (curr.trigger_time >= world.time)
			return	// Nothing after this will be ready to fire.

		// This one's ready to fire, process it.
		curr.pre_process()
		curr.process()
		curr.post_process()
		if (curr.destroyed)	// post_process probably destroyed it.
			tasks -= curr
			curr.kill()
		curr = curr.next
		head = curr

/datum/controller/process/scheduler/proc/queue(datum/scheduled_task/task)
	if (!task || !task.trigger_time || task.trigger_time + 100 < world.time)
		warning("scheduler: Invalid task queued! Ignoring.")
		return
	if (!head && !tasks.len)
		head = task
		tasks += task
		return
	else if (!head)	// Head's missing but we still have tasks, rebuild.
		tasks += task
		rebuild_queue()

	var/datum/scheduled_task/curr = head
	while (curr.next && curr.trigger_time < task.trigger_time)
		curr = head.next

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
	var/list/old_tasks = tasks
	tasks = list()
	for (var/thing in old_tasks)
		var/datum/scheduled_task/task = thing
		if (QDELETED(task) || task.destroyed)
			continue

		queue(task)

/datum/controller/process/scheduler/statProcess()
	..()
	stat(null, "[tasks.len] task\s")

/datum/controller/process/scheduler/proc/schedule(var/datum/scheduled_task/st)
	queue(st)
	destroyed_event.register(st, src, /datum/controller/process/scheduler/proc/unschedule)

/datum/controller/process/scheduler/proc/unschedule(var/datum/scheduled_task/st)
	st.destroyed = TRUE

/**********
* Helpers *
**********/
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

/*************
* Task Datum *
*************/
/datum/scheduled_task
	var/trigger_time
	var/procedure
	var/list/arguments
	var/task_after_process
	var/list/task_after_process_args
	var/datum/scheduled_task/next
	var/destroyed = FALSE

/datum/scheduled_task/New(var/trigger_time, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	..()
	src.trigger_time = trigger_time
	src.procedure = procedure
	src.arguments = arguments ? arguments : list()
	src.task_after_process = task_after_process ? task_after_process : /proc/destroy_scheduled_task
	src.task_after_process_args = istype(task_after_process_args) ? task_after_process_args : list()
	task_after_process_args += src

/datum/scheduled_task/Destroy()
	procedure = null
	arguments.Cut()
	task_after_process = null
	task_after_process_args.Cut()
	return ..()

/datum/scheduled_task/proc/pre_process()
	task_triggered_event.raise_event(list(src))

/datum/scheduled_task/proc/process()
	if(procedure)
		call(procedure)(arglist(arguments))

/datum/scheduled_task/proc/post_process()
	call(task_after_process)(arglist(task_after_process_args))

// Resets the trigger time, has no effect if the task has already triggered
/datum/scheduled_task/proc/trigger_task_in(var/trigger_in)
	src.trigger_time = world.time + trigger_in

/datum/scheduled_task/proc/kill()
	if (!destroyed)
		warning("scheduler: Non-destroyed task was killed!")
		destroyed = TRUE

	if (src in scheduler.tasks)
		warning("scheduler: Task was not cleaned up correctly, rebuilding scheduler queue!")
		scheduler.rebuild_queue()

	qdel(src)

/datum/scheduled_task/source
	var/datum/source

/datum/scheduled_task/source/New(var/trigger_time, var/datum/source, var/procedure, var/list/arguments, var/proc/task_after_process, var/list/task_after_process_args)
	src.source = source
	destroyed_event.register(src.source, src, /datum/scheduled_task/source/proc/source_destroyed)
	..(trigger_time, procedure, arguments, task_after_process, task_after_process_args)

/datum/scheduled_task/source/Destroy()
	source = null
	return ..()

/datum/scheduled_task/source/process()
	call(source, procedure)(arglist(arguments))

/datum/scheduled_task/source/proc/source_destroyed()
	destroyed = TRUE

/proc/destroy_scheduled_task(var/datum/scheduled_task/st)
	st.destroyed = TRUE

/proc/repeat_scheduled_task(var/trigger_delay, var/datum/scheduled_task/st)
	st.trigger_time = world.time + trigger_delay
	scheduler.schedule(st)
