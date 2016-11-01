var/global/datum/lighting_controller/night/night_lighting

/datum/lighting_controller/night

	var/isactive = 0

	var/list/lighting_areas = list(
		                           /area/hallway/primary/fore,
		                           /area/hallway/primary/starboard,
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

/datum/lighting_controller/night/proc/process()
	switch (world.timeofday)
		if (0 to MORNING_LIGHT_RESET)
			if (isactive)
				command_announcement.Announce("Good morning. The time is [time2text(world.timeofday, "hh:mm")]. The automated systems aboard the [station_name()] will now return the public hallway lighting levels to normal.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				deactivate()

		if (NIGHT_LIGHT_ACTIVE to TICKS_IN_DAY)
			if (!isactive)
				command_announcement.Announce("Good evening. The time is [time2text(world.timeofday, "hh:mm")]. The automated systems aboard the [station_name()] will now dim lighting in the public hallways in order to accommodate the circadian rhythm of some species.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				activate()

		else
			if (isactive)
				deactivate()

/datum/lighting_controller/night/proc/activate()
	var/time = world.time
	for (var/obj/machinery/power/apc/apc in station_apcs)
		for (var/area/A in lighting_areas)
			if (!ispath(A)) CRASH("An index in lighting_areas is not a valid path!")
			if (apc.area == A)
				apc.toggle_nightlight("on")
	var/delta_sec = round((world.time - time) / 10, 1.00)
	world << "DEBUG: Lighting activation took [delta_sec] seconds."

/datum/lighting_controller/night/proc/deactivate()
	var/time = world.time
	for (var/obj/machinery/power/apc/apc in station_apcs)
		for (var/area/A in lighting_areas)
			if (!ispath(A)) CRASH("An index in lighting_areas is not a valid path!")
			if (apc.area == A)
				apc.toggle_nightlight("off")
	var/delta_sec = round((world.time - time) / 10, 1.00)
	world << "DEBUG: Lighting deactivation took [delta_sec] seconds.