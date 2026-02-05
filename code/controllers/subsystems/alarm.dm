GLOBAL_DATUM_INIT(atmosphere_alarm, /datum/alarm_handler/atmosphere, new())
GLOBAL_DATUM_INIT(camera_alarm, /datum/alarm_handler/camera, new())
GLOBAL_DATUM_INIT(fire_alarm, /datum/alarm_handler/fire, new())
GLOBAL_DATUM_INIT(motion_alarm, /datum/alarm_handler/motion, new())
GLOBAL_DATUM_INIT(power_alarm, /datum/alarm_handler/power, new())

SUBSYSTEM_DEF(alarm)
	name = "Alarms"
	init_order = INIT_ORDER_MISC_FIRST
	priority = SS_PRIORITY_ALARMS
	runlevels = RUNLEVELS_PLAYING

	var/list/datum/alarm/all_handlers
	var/tmp/list/current = list()

	var/tmp/list/active_alarm_cache = list()

/datum/controller/subsystem/alarm/Initialize(timeofday)
	all_handlers = list(GLOB.atmosphere_alarm, GLOB.camera_alarm, GLOB.fire_alarm, GLOB.motion_alarm, GLOB.power_alarm)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/alarm/fire(resumed = FALSE)
	if (!resumed)
		current = all_handlers.Copy()
		active_alarm_cache.Cut()

	while (current.len)
		var/datum/alarm_handler/AH = current[current.len]
		current.len--

		AH.process()

		active_alarm_cache += AH.alarms

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/alarm/proc/active_alarms()
	return active_alarm_cache.Copy()

/datum/controller/subsystem/alarm/proc/number_of_active_alarms()
	return active_alarm_cache.len

/datum/controller/subsystem/alarm/stat_entry(msg)
	msg = "A:[active_alarm_cache.len]"
	return ..()
