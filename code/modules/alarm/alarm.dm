/// How long will the alarm/trigger remain active once origin/source has been found to be gone?
#define ALARM_RESET_DELAY 100

/datum/alarm_source
	//// The source trigger
	var/source		= null
	/// The name of the source should it be lost (for example a destroyed camera)
	var/source_name = ""
	/// How long this source will be alarming, 0 for indefinitely.
	var/duration	= 0
	/// How severe the alarm from this source is.
	var/severity 	= 1
	/// When this source began alarming.
	var/start_time	= 0
	/// Use to set when this trigger should clear, in case the source is lost.
	var/end_time	= 0

/datum/alarm_source/New(var/atom/source)
	src.source = source
	start_time = world.time
	source_name = source.get_source_name()

/datum/alarm
	/// Used to identify the alarm area.
	var/atom/origin
	/// List of sources triggering the alarm. Used to determine when the alarm should be cleared.
	var/list/sources = new()
	/// Associative list of source triggers. Used to efficiently acquire the alarm source.
	var/list/sources_assoc = new()
	/// List of cameras that can be switched to, if the player has that capability.
	var/list/cameras
	/// ID for camera cache, changed by invalidateCameraCache().
	var/cache_id
	/// The last acquired area, used should origin be lost (for example a destroyed borg containing an alarming camera).
	var/area/last_area
	/// The last acquired name, used should origin be lost.
	var/area/last_name
	/// The last area in which cameras where fetched, used to see if the camera list should be updated.
	var/area/last_camera_area
	/// Used to set when this alarm should clear, in case the origin is lost.
	var/end_time

/datum/alarm/New(var/atom/origin, var/atom/source, var/duration, var/severity)
	src.origin = origin
	// Sets up both cameras and last alarm area.
	cameras()
	set_source_data(source, duration, severity)

/datum/alarm/process()
	// Has origin gone missing?
	if(!origin && !end_time)
		end_time = world.time + ALARM_RESET_DELAY
	for(var/datum/alarm_source/AS in sources)
		// Has the alarm passed its best before date?
		if((AS.end_time && world.time > AS.end_time) || (AS.duration && world.time > (AS.start_time + AS.duration)))
			sources -= AS
		// Has the source gone missing?	Then reset the normal duration and set end_time.
		if(!AS.source && !AS.end_time) // end_time is used instead of duration to ensure the reset doesn't remain in the future indefinitely.
			AS.duration = 0
			AS.end_time = world.time + ALARM_RESET_DELAY

/datum/alarm/proc/set_source_data(var/atom/source, var/duration, var/severity)
	var/datum/alarm_source/AS = sources_assoc[source]
	if(!AS)
		AS = new/datum/alarm_source(source)
		sources += AS
		sources_assoc[source] = AS
	// Currently only non-0 durations can be altered (normal alarms VS EMP blasts).
	if(AS.duration)
		duration = SecondsToTicks(duration)
		AS.duration = duration
	AS.severity = severity

/datum/alarm/proc/clear(var/source)
	var/datum/alarm_source/AS = sources_assoc[source]
	sources -= AS
	sources_assoc -= source

/datum/alarm/proc/alarm_area()
	if(!origin)
		return last_area

	last_area = origin.get_alarm_area()
	return last_area

/datum/alarm/proc/alarm_name()
	if(!origin)
		return get_area_display_name(last_area)

	last_name = origin.get_alarm_name()
	return last_name

/**
 * Resets the alarm's camera cache and tries to repopulate it (sometimes cameras move/leave, like borgs etc.).
 */
/datum/alarm/proc/cameras()
	// Reset camera cache.
	if(GLOB.camera_repository.camera_cache_id != cache_id)
		cameras = null
		cache_id = GLOB.camera_repository.camera_cache_id
	// If the alarm origin has changed area, for example a borg containing an alarming camera, reset the list of cameras
	else if(cameras && (last_camera_area != alarm_area()))
		cameras = null

	// The list of cameras is also reset by /proc/invalidateCameraCache()
	if(!cameras)
		cameras = origin ? origin.get_alarm_cameras() : last_area.get_alarm_cameras()

	last_camera_area = last_area
	return cameras

/datum/alarm/proc/max_severity()
	var/max_severity = 0
	for(var/datum/alarm_source/AS in sources)
		max_severity = max(AS.severity, max_severity)

	return max_severity

/******************
* Assisting procs *
******************/
/**
 * Returns the src's area.
 */
/atom/proc/get_alarm_area()
	return get_area(src)

/area/get_alarm_area()
	return src

/**
 * Wrapper for get_area_display_name (no args).
 */
/atom/proc/get_alarm_name()
	var/area/A = get_area(src)
	var/display_name = get_area_display_name(A)
	return display_name

/area/get_alarm_name()
	var/display_name = get_area_display_name(src)
	return display_name

/mob/get_alarm_name()
	var/area/A = get_area(src)
	var/display_name = get_area_display_name(A)
	return display_name

/atom/proc/get_source_name()
	var/area/A = get_area(src)
	var/display_name = get_area_display_name(A)
	return display_name

/obj/machinery/camera/get_source_name()
	return c_tag

/atom/proc/get_alarm_cameras()
	var/area/A = get_area(src)
	return A.get_cameras()

/area/get_alarm_cameras()
	return get_cameras()

/mob/living/silicon/robot/get_alarm_cameras()
	var/list/cameras = ..()
	if(camera)
		cameras += camera

	return cameras

/mob/living/silicon/robot/combat/get_alarm_cameras()
	return list()

#undef ALARM_RESET_DELAY
