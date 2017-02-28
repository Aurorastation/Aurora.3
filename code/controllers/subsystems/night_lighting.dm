#define NL_TIME (world.time + 60 MINUTES * roundstart_hour)

var/datum/subsystem/nightlight/SSnightlight

/datum/subsystem/nightlight
	name = "Night Lighting"
	wait = 5 MINUTES
	init_order = -1	// after ticker.
	flags = SS_BACKGROUND | SS_NO_TICK_CHECK
	display_order = SS_DISPLAY_NIGHT_LIGHTING

	var/isactive = 0

/datum/subsystem/nightlight/New()
	NEW_SS_GLOBAL(SSnightlight)

/datum/subsystem/nightlight/Initialize(timeofday)
	if (!roundstart_hour)
		worldtime2text()

	switch (NL_TIME)
		if (0 to config.nl_finish)
			deactivate()
		if (config.nl_start to TICKS_IN_DAY)
			activate()

	..(timeofday, silent = TRUE)

/datum/subsystem/nightlight/stat_entry()
	..("A:[isactive] T:[NL_TIME] DT:[config.nl_start] NT:[config.nl_finish]")

/datum/subsystem/nightlight/Recover()
	if (istype(SSnightlight))
		src.isactive = SSnightlight.isactive

/datum/subsystem/nightlight/fire(resumed = FALSE)
	switch (NL_TIME)
		if (0 to config.nl_finish)
			if (isactive)
				command_announcement.Announce("Good morning. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now return the public hallway lighting levels to normal.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				deactivate()

		if (config.nl_start to TICKS_IN_DAY)
			if (!isactive)
				command_announcement.Announce("Good evening. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now dim lighting in the public hallways in order to accommodate the circadian rhythm of some species.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
				activate()

		else
			if (isactive)
				deactivate()

// 'whitelisted' areas are areas that have nightmode explicitly enabled

/datum/subsystem/nightlight/proc/activate(var/whitelisted_only = 1)
	isactive = 1
	for (var/obj/machinery/power/apc/APC in get_apc_list(whitelisted_only))
		APC.toggle_nightlight("on")

/datum/subsystem/nightlight/proc/deactivate(var/whitelisted_only = 1)
	isactive = 0
	for (var/obj/machinery/power/apc/APC in get_apc_list(whitelisted_only))
		APC.toggle_nightlight("off")

/datum/subsystem/nightlight/proc/get_apc_list(var/whitelisted_only = 1)
	var/list/obj/machinery/power/apc/lighting_apcs = list()

	for (var/A in all_areas)
		var/area/B = A
		if (B.no_light_control || (!(B.allow_nightmode) && whitelisted_only))
			continue
		if (B.apc && !B.apc.aidisabled)
			lighting_apcs += B.apc

	return lighting_apcs

/datum/subsystem/nightlight/proc/is_active()
	return isactive

#undef NL_TIME
