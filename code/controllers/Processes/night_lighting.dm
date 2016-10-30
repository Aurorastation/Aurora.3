/datum/controller/process/night_lighting/setup()
	name = "night lighting controller"
	schedule_interval = 100 // every 5 seconds

	if (!config.night_lighting)
		qdel(src)

/datum/controller/process/night_lighting/doWork()
	night_lighting.process()