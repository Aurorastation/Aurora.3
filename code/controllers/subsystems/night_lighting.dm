var/datum/controller/subsystem/nightlight/SSnightlight

/datum/controller/subsystem/nightlight
	name = "Night Lighting"
	wait = 5 MINUTES
	init_order = SS_INIT_NIGHT
	flags = SS_BACKGROUND | SS_NO_TICK_CHECK
	priority = SS_PRIORITY_NIGHT

	var/isactive = FALSE
	var/disable_type = NL_NOT_DISABLED

/datum/controller/subsystem/nightlight/New()
	NEW_SS_GLOBAL(SSnightlight)

/datum/controller/subsystem/nightlight/Initialize(timeofday)
	if (!config.night_lighting)
		can_fire = FALSE
		flags |= SS_NO_FIRE
		return

	fire(FALSE, FALSE)

	..()

/datum/controller/subsystem/nightlight/stat_entry()
	..("A:[isactive] T:[worldtime2hours()] DT:[config.nl_start] NT:[config.nl_finish] D:[disable_type]")

/datum/controller/subsystem/nightlight/Recover()
	src.isactive = SSnightlight.isactive
	src.disable_type = SSnightlight.disable_type

/datum/controller/subsystem/nightlight/proc/temp_disable(time = -1)
	if (disable_type != NL_PERMANENT_DISABLE)
		disable_type = NL_TEMPORARY_DISABLE
		suspend()
		deactivate(FALSE)
		if (time > 0)
			addtimer(CALLBACK(src, .proc/end_temp_disable), time, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/controller/subsystem/nightlight/proc/end_temp_disable()
	if (disable_type == NL_TEMPORARY_DISABLE)
		wake()

/datum/controller/subsystem/nightlight/fire(resumed = FALSE, announce = TRUE)
	if (disable_type)
		log_debug("SSnightlight: disable_type was [disable_type] but can_fire was TRUE! Disabling self.")
		suspend()
		return

	var/time = worldtime2hours()
	if (time <= config.nl_finish || time >= config.nl_start)
		if (!isactive)
			activate()
			if (announce)
				command_announcement.Announce("Good evening. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now dim lighting in the public hallways in order to accommodate the circadian rhythm of some species.", "Automated Lighting System", new_sound = 'sound/misc/nightlight.ogg')
	else
		if (isactive)
			deactivate()
			if (announce)
				command_announcement.Announce("Good morning. The time is [worldtime2text()]. \n\nThe automated systems aboard the [station_name()] will now return the public hallway lighting levels to normal.", "Automated Lighting System", new_sound = 'sound/misc/nightlight.ogg')

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

/datum/controller/subsystem/nightlight/enable()
	..()
	disable_type = NL_NOT_DISABLED

/datum/controller/subsystem/nightlight/disable()
	..()
	disable_type = NL_PERMANENT_DISABLE
