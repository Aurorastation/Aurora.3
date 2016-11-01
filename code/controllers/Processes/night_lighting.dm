/datum/controller/process/night_lighting/setup()
	name = "night lighting controller"
	schedule_interval = 100 // every 5 seconds

	if (!config.night_lighting)
		del src

/datum/controller/process/night_lighting/started()
	switch (world.timeofday)
		if (0 to MORNING_LIGHT_RESET)
			night_lighting.deactivate()
		if (NIGHT_LIGHT_ACTIVE to TICKS_IN_DAY)
			night_lighting.activate()

/datum/controller/process/night_lighting/doWork()
	night_lighting.process()