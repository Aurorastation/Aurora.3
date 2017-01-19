/datum/controller/process/pipenet
	var/list/queue = list()
	var/normal_exit = TRUE

/datum/controller/process/pipenet/setup()
	name = "pipenet"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/controller/process/pipenet/doWork()
	if (normal_exit)
		queue = pipe_networks.Copy()

	normal_exit = FALSE

	while (queue.len)
		var/datum/pipe_network/PN = queue[queue.len]
		queue.len--

		if (!PN || PN.gcDestroyed)
			continue

		PN.process()
		SCHECK

/datum/controller/process/pipenet/statProcess()
	..()
	stat(null, "[pipe_networks.len] pipenets, [queue.len] queued")