/datum/controller/process/night_lighting/

	var/isactive = 0
	var/firstrun = 1

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
		                           /area/crew_quarters/sleep,
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

/datum/controller/process/night_lighting/preStart()

	switch (worldtime2ticks())
		if (0 to MORNING_LIGHT_RESET)
			deactivate()
		if (NIGHT_LIGHT_ACTIVE to TICKS_IN_DAY)
			activate()


/datum/controller/process/night_lighting/doWork()

	switch (worldtime2ticks())
		if (0 to MORNING_LIGHT_RESET)
			if (isactive)
				command_announcement.Announce("Good morning. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now return the public hallway lighting levels to normal.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				deactivate()

		if (NIGHT_LIGHT_ACTIVE to TICKS_IN_DAY)
			if (!isactive)
				command_announcement.Announce("Good evening. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now dim lighting in the public hallways in order to accommodate the circadian rhythm of some species.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				activate()

		else
			if (isactive)
				deactivate()

/datum/controller/process/night_lighting/proc/activate()
	for (var/obj/machinery/power/apc/APC in get_apc_list())
		APC.toggle_nightlight("on")
		isactive = 1

/datum/controller/process/night_lighting/proc/deactivate()
	for (var/obj/machinery/power/apc/APC in get_apc_list())
		APC.toggle_nightlight("off")
		isactive = 0

/datum/controller/process/night_lighting/proc/get_apc_list()
	var/list/obj/machinery/power/apc/lighting_apcs = list()
	for (var/area/A in all_areas)
		if (!(A.type in lighting_areas))
			continue
		for (var/obj/machinery/power/apc/B in A)
			lighting_apcs += B
	return lighting_apcs