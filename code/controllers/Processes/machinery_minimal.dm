/var/global/machinery_sort_required = 0

/datum/controller/process/machinery
	var/list/queue = list()
	var/normal_exit = TRUE

/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/controller/process/machinery/doWork()
	if (normal_exit)
		queue = machines.Copy()

	normal_exit = FALSE

	while (queue.len)
		var/obj/machinery/M = queue[queue.len]
		queue.len--

		if (!M || M.gcDestroyed)
			continue

		if (M.process() == PROCESS_KILL)
			machines.Remove(M)
			continue

		if (M.use_power)
			M.auto_use_power()

		SCHECK

	normal_exit = TRUE

/datum/controller/process/machinery/proc/internal_sort()
	if(machinery_sort_required)
		machinery_sort_required = 0
		machines = dd_sortedObjectList(machines)

/datum/controller/process/machinery/statProcess()
	..()
	stat(null, "[machines.len] machines, [queue.len] queued")
