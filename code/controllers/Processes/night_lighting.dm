var/datum/controller/process/night_lighting/nl_ctrl

/datum/controller/process/night_lighting/
	var/isactive = 0
	var/firstrun = 1
	var/manual_override = 0	
		// 0 -> No manual override
		// 1 -> Override via. player-set nightmode setting (like CE console)
		// 2 -> Red-alert override.

/datum/controller/process/night_lighting/proc/is_active()
	return isactive

/datum/controller/process/night_lighting/setup()
	name = "night lighting controller"
	schedule_interval = 5 MINUTES

	nl_ctrl = src

	if (!config.night_lighting)
		// Stop trying to delete processes. Not how it goes.
		disabled = 1

/datum/controller/process/night_lighting/preStart()
	doWork(FALSE)

/datum/controller/process/night_lighting/doWork(announce = TRUE)
	if (manual_override)	// don't automatically change lighting if it was manually changed in-game
		return

	var/time = worldtime2hours()
	if (time <= config.nl_finish || time >= config.nl_start)
		if (!isactive)
			activate()
			if (announce)
				command_announcement.Announce("Good evening. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now dim lighting in the public hallways in order to accommodate the circadian rhythm of some species.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
	else
		if (isactive)
			deactivate()
			if (announce)
				command_announcement.Announce("Good morning. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now return the public hallway lighting levels to normal.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')

// 'whitelisted' areas are areas that have nightmode explicitly enabled

/datum/controller/process/night_lighting/proc/activate(var/whitelisted_only = 1)
	isactive = 1
	for (var/obj/machinery/power/apc/APC in get_apc_list(whitelisted_only))
		APC.toggle_nightlight("on")

		F_SCHECK

/datum/controller/process/night_lighting/proc/deactivate(var/whitelisted_only = 1)
	isactive = 0
	for (var/obj/machinery/power/apc/APC in get_apc_list(whitelisted_only))
		APC.toggle_nightlight("off")

		F_SCHECK

/datum/controller/process/night_lighting/proc/get_apc_list(var/whitelisted_only = 1)
	var/list/obj/machinery/power/apc/lighting_apcs = list()

	for (var/A in all_areas)
		var/area/B = A
		if (B.no_light_control || (!(B.allow_nightmode) && whitelisted_only))
			continue
		if (B.apc && !B.apc.aidisabled)
			lighting_apcs += B.apc

		F_SCHECK

	return lighting_apcs
