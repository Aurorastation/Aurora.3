/datum/controller/process/powernet
	var/list/queue = list()
	var/normal_exit = TRUE

/datum/controller/process/powernet/setup()
	name = "powernet"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/controller/process/powernet/doWork()
	if (normal_exit)
		queue = powernets.Copy()

	normal_exit = FALSE

	while (queue.len)
		var/datum/powernet/PN = queue[queue.len]
		queue.len--

		if (!PN || PN.gcDestroyed)
			continue

		PN.reset()
		SCHECK

	// Currently only used by powersinks. These items get priority processed before machinery
	for(last_object in processing_power_items)
		var/obj/item/I = last_object
		if(!I.pwr_drain()) // 0 = Process Kill, remove from processing list.
			processing_power_items.Remove(I)
		SCHECK

/datum/controller/process/powernet/statProcess()
	..()
	stat(null, "[powernets.len] powernets, [queue.len] queued")