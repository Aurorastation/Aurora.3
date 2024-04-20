SUBSYSTEM_DEF(nightlight)
	name = "Night Lighting"
	wait = 5 MINUTES
	init_order = SS_INIT_NIGHT
	flags = SS_BACKGROUND | SS_NO_FIRE
	priority = SS_PRIORITY_NIGHT

	var/isactive = FALSE
	var/disable_type = NL_NOT_DISABLED

/datum/controller/subsystem/nightlight/Initialize(start_timeofday)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/nightlight/stat_entry(msg)
	msg = "A:[isactive] T:[worldtime2hours()] D:[disable_type]"
	return ..()

/datum/controller/subsystem/nightlight/Recover()
	src.isactive = SSnightlight.isactive
	src.disable_type = SSnightlight.disable_type

/datum/controller/subsystem/nightlight/proc/temp_disable(time = -1)
	if (disable_type != NL_PERMANENT_DISABLE)
		disable_type = NL_TEMPORARY_DISABLE
		can_fire = FALSE
		deactivate(FALSE)
		if (time > 0)
			addtimer(CALLBACK(src, PROC_REF(end_temp_disable)), time, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/controller/subsystem/nightlight/proc/end_temp_disable()
	if (disable_type == NL_TEMPORARY_DISABLE)
		can_fire = TRUE

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

	for (var/A in GLOB.all_areas)
		var/area/B = A
		if (B.no_light_control || (!(B.allow_nightmode) && whitelisted_only))
			continue
		if (B.apc && !B.apc.aidisabled)
			lighting_apcs += B.apc

		CHECK_TICK

	return lighting_apcs

/datum/controller/subsystem/nightlight/proc/is_active()
	return isactive

// /datum/controller/subsystem/nightlight/enable()
// 	..()
// 	disable_type = NL_NOT_DISABLED

// /datum/controller/subsystem/nightlight/disable()
// 	..()
// 	disable_type = NL_PERMANENT_DISABLE
