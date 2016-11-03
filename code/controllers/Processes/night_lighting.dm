/datum/controller/process/night_lighting/

	var/isactive = 0

	var/list/area/lighting_areas = list(
		                           /area/hallway/primary/fore,
		                           /area/hallway/primary/starboard,
		                           /area/hallway/primary/aft,
		                           /area/hallway/primary/port,
		                           /area/hallway/primary/central_one,
		                           /area/hallway/primary/central_two,
		                           /area/hallway/primary/central_three,
		                           /area/hallway/secondary/exit,
		                           /area/hallway/secondary/entry/fore,
		                           /area/hallway/secondary/entry/port,
		                           /area/hallway/secondary/entry/starboard,
		                           /area/hallway/secondary/entry/aft,
		                           /area/crew_quarters,
		                           /area/crew_quarters/locker,
		                           /area/crew_quarters/fitness,
		                           /area/crew_quarters/bar,
		                           /area/engineering/foyer,
		                           /area/security/lobby,
		                           /area/storage/tools,
		                           /area/storage/primary
		                           )

/datum/controller/process/night_lighting/setup()
	name = "night lighting controller"
	schedule_interval = 100 // every 5 seconds

	if (!config.night_lighting)
		del(src)

/datum/controller/process/night_lighting/onStart()

	switch (worldtime2ticks())
		if (0 to 1)
			deactivate()
		if (1 to TICKS_IN_DAY)
			activate()

/datum/controller/process/night_lighting/doWork()

	world << "DEBUG: night_lighting/doWork(). Ticks are [worldtime2ticks()]"
	switch (worldtime2ticks())
		if (0 to 1)
			if (isactive)
				command_announcement.Announce("Good morning. The time is [worldtime2text()]. The automated systems aboard the [station_name()] will now return the public hallway lighting levels to normal.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				deactivate()

		if (1 to TICKS_IN_DAY)
			if (!isactive)
				command_announcement.Announce("Good evening. The time is [worldtime2text()]. The automated systems aboard the [station_name()] will now dim lighting in the public hallways in order to accommodate the circadian rhythm of some species.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				activate()

		else
			if (isactive)
				deactivate()

/datum/controller/process/night_lighting/proc/activate()
	for (var/obj/machinery/power/apc/APC in get_apc_list())
		world << "Switched on APC: [APC.name]"
		APC.toggle_nightlight("on")
		isactive = 1

/datum/controller/process/night_lighting/proc/deactivate()
	for (var/obj/machinery/power/apc/APC in get_apc_list())
		world << "Switched off APC: [APC.name]"
		APC.toggle_nightlight("off")
		isactive = 0

/datum/controller/process/night_lighting/proc/get_apc_list()
	var/list/obj/machinery/power/apc/lighting_apcs = list()
	for (var/area/A in lighting_areas)
		for (var/obj/machinery/power/apc/B in A)
			B += lighting_apcs
	return lighting_apcs