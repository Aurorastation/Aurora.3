var/datum/controller/subsystem/nightlight/SSnightlight

/datum/controller/subsystem/nightlight
	name = "Night Lighting"
	wait = 5 MINUTES
	init_order = SS_INIT_NIGHT
	flags = SS_BACKGROUND | SS_NO_TICK_CHECK
	priority = SS_PRIORITY_NIGHT

	var/isactive = 0

/datum/controller/subsystem/nightlight/New()
	NEW_SS_GLOBAL(SSnightlight)

/datum/controller/subsystem/nightlight/Initialize(timeofday)
	var/time = worldtime2hours()
	if (time <= 8 || time >= 19)
		activate()
	else
		deactivate()

	..(timeofday, silent = TRUE)

/datum/controller/subsystem/nightlight/stat_entry()
	..("A:[isactive] T:[worldtime2hours()] DT:[config.nl_start] NT:[config.nl_finish]")

/datum/controller/subsystem/nightlight/Recover()
	if (istype(SSnightlight))
		src.isactive = SSnightlight.isactive

/datum/controller/subsystem/nightlight/fire(resumed = FALSE)
	var/time = worldtime2hours()
	if (time <= 8 || time >= 19)
		if (!isactive)
			command_announcement.Announce("Good evening. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now dim lighting in the public hallways in order to accommodate the circadian rhythm of some species.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
			activate()
	else
		if (isactive)
			command_announcement.Announce("Good morning. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now return the public hallway lighting levels to normal.", "Automated Lighting System", new_sound = 'sound/misc/bosuns_whistle.ogg')
			deactivate()

// 'whitelisted' areas are areas that have nightmode explicitly enabled

/datum/controller/subsystem/nightlight/proc/activate(var/whitelisted_only = 1)
	isactive = 1
	for (var/obj/machinery/power/apc/APC in get_apc_list(whitelisted_only))
		APC.toggle_nightlight("on")

		CHECK_TICK

/datum/controller/subsystem/nightlight/proc/deactivate(var/whitelisted_only = 1)
	isactive = 0
	for (var/obj/machinery/power/apc/APC in get_apc_list(whitelisted_only))
		APC.toggle_nightlight("off")

		CHECK_TICK

/datum/controller/subsystem/nightlight/proc/get_apc_list(var/whitelisted_only = 1)
	var/list/obj/machinery/power/apc/lighting_apcs = list()

	for (var/A in all_areas)
		var/area/B = A
		if (B.no_light_control || (!(B.allow_nightmode) && whitelisted_only))
			continue
		if (B.apc && !B.apc.aidisabled)
			lighting_apcs += B.apc

		CHECK_TICK

	return lighting_apcs

/datum/controller/subsystem/nightlight/proc/is_active()
	return isactive
