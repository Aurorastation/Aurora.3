/datum/controller/process/arrivalShuttle/setup()
	name = "arrival shuttle"
	schedule_interval = 20 // every 2 seconds

	if(!arrival_shuttle)
		arrival_shuttle = new

/datum/controller/process/arrivalShuttle/doWork()
	arrival_shuttle.process()