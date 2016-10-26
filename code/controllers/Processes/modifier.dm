/datum/controller/process/modifier/setup()
	name = "modifiers"
	schedule_interval = 10
	start_delay = 8

/datum/controller/process/modifier/started()
	..()
	if(!processing_modifiers)
		processing_modifiers = list()

/datum/controller/process/modifier/doWork()
	for(last_object in processing_modifiers)
		var/datum/modifier/O = last_object
		if(isnull(O.gcDestroyed))
			O.process()
		else
			catchBadType(O)
			processing_objects -= O

/datum/controller/process/modifier/statProcess()
	..()
	stat(null, "[processing_modifiers.len] modifiers")
