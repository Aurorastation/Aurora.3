/datum/controller/process/obj
	var/normal_exit = TRUE
	var/list/queue = list()

/datum/controller/process/obj/setup()
	name = "obj"
	schedule_interval = 2 SECONDS
	start_delay = 8

/datum/controller/process/obj/started()
	..()
	if(!processing_objects)
		processing_objects = list()

/datum/controller/process/obj/doWork()
	if (normal_exit)
		queue = processing_objects.Copy()
		normal_exit = FALSE

	while (queue.len)
		var/datum/O = queue[queue.len]
		queue.len--

		if (!O || O.gcDestroyed)
			processing_objects -= O
			continue

		O:process()
		F_SCHECK

	normal_exit = TRUE

/datum/controller/process/obj/statProcess()
	..()
	stat(null, "[processing_objects.len] objects, [queue.len] queued")
