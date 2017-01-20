/datum/controller/process/mob
	var/tmp/datum/updateQueue/updateQueueInstance
	var/tmp/list/queue = list()
	var/normal_exit = TRUE

/datum/controller/process/mob/setup()
	name = "mob"
	schedule_interval = 2 SECONDS // every 2 seconds
	start_delay = 16

/datum/controller/process/mob/started()
	..()
	if(!mob_list)
		mob_list = list()

/datum/controller/process/mob/doWork()
	if (normal_exit)
		queue = mob_list.Copy()

	normal_exit = FALSE

	while (queue.len)
		var/mob/M = queue[queue.len]
		queue.len--

		if (!M || M.gcDestroyed)
			mob_list -= M
			continue

		M.Life()
		SCHECK

	normal_exit = TRUE

/datum/controller/process/mob/statProcess()
	..()
	stat(null, "[mob_list.len] mobs, [queue.len] queued")
