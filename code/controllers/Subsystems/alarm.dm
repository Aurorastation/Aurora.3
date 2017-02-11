var/datum/subsystem/alarm/alarm_manager

/var/global/datum/alarm_handler/atmosphere/atmosphere_alarm	= new()
/var/global/datum/alarm_handler/camera/camera_alarm			= new()
/var/global/datum/alarm_handler/fire/fire_alarm				= new()
/var/global/datum/alarm_handler/motion/motion_alarm			= new()
/var/global/datum/alarm_handler/power/power_alarm			= new()

/datum/subsystem/alarm
	name = "Alarms"
	wait = 2 SECONDS
	
	var/list/datum/alarm/all_handlers
	var/tmp/list/current = list()

	var/tmp/list/active_alarm_cache = list()

/datum/subsystem/alarm/New()
	NEW_SS_GLOBAL(alarm_manager)

/datum/subsystem/alarm/Initialize(timeofday)
	all_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)
	
/datum/subsystem/alarm/fire(resumed = FALSE)
	if (!resumed)
		current = all_handlers.Copy()
		active_alarm_cache = list()

	while (current.len)
		var/datum/alarm_handler/AH = current[current.len]
		current.len--

		AH.process()

		active_alarm_cache += AH.alarms

		if (MC_CHECK_TICK)
			return

/datum/subsystem/alarm/proc/active_alarms()
	return active_alarm_cache.Copy()

/datum/subsystem/alarm/proc/number_of_active_alarms()
	return active_alarm_cache.len

/datum/subsystem/alarm/stat_entry()
	..("A:[active_alarm_cache.len]")
