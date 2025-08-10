#define TIME_OFFSET GLOB.config.time_offset

var/roundstart_hour = 0
var/round_start_time

//Returns the world time in english
/proc/worldtime2text(time = world.time, timeshift = 1)
	if(!roundstart_hour) roundstart_hour = REALTIMEOFDAY - (TIME_OFFSET HOURS)
	return timeshift ? time2text(time+roundstart_hour, "hh:mm") : time2text(time, "hh:mm")

/proc/worldtime2hours()
	if (!roundstart_hour)
		worldtime2text()
	. = text2num(time2text(world.time + (roundstart_hour HOURS), "hh"))

/proc/worlddate2text()
	return num2text(GLOB.game_year) + "-" + time2text(world.timeofday, "MM-DD")

/proc/time_stamp()
	return time2text(world.timeofday, "hh:mm:ss")

/**
 * Check if specific day of the year
 *
 * * month - month in integer form
 * * day - day in integer form
 *
 * Returns TRUE if the passed month/day is the current server world date
 */
/proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		// Get the current month
		var/MM = text2num(time2text(world.timeofday, "MM"))
		// Get the current day
		var/DD = text2num(time2text(world.timeofday, "DD"))
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

var/real_round_start_time

/**
 * Real time since round has started, in ticks.
 */
/proc/get_round_duration()
	return real_round_start_time ? (REALTIMEOFDAY - real_round_start_time) : 0

/**
 * Real time since round has started, in hours and minutes.
 */
/proc/get_round_duration_formatted()
	var/duration = get_round_duration()
	var/hour = "[ round(duration / ( 1 HOUR) ) ]"
	var/minute = "[ round(duration / (1 MINUTE) ) % 60 ]"
	if(length(hour) == 1)
		hour = "0" + hour
	if(length(minute) == 1)
		minute = "0" + minute

	return "[hour]:[minute]"

/var/midnight_rollovers = 0
/var/rollovercheck_last_timeofday = 0
/proc/update_midnight_rollover()
	// TIME IS GOING BACKWARDS!
	if (world.timeofday < rollovercheck_last_timeofday)
		midnight_rollovers += 1
	rollovercheck_last_timeofday = world.timeofday
	return midnight_rollovers

/**
 * Returns timestamp in a SQL- and ISO 8601-friendly format.
 */
/proc/SQLtime(timevar)
	if(!timevar)
		timevar = world.realtime
	return time2text(timevar, "YYYY-MM-DD hh:mm:ss")

/**
 * Returns "watch handle" (really just a timestamp :V)
 */
/proc/start_watch()
	return REALTIMEOFDAY

/**
 * Returns number of seconds elapsed.
 * @param wh number The "Watch Handle" from start_watch(). (timestamp)
 */
/proc/stop_watch(wh)
	return round(0.1 * (REALTIMEOFDAY - wh), 0.1)

/**
 * Returns a text value of a given # of deciseconds in hours, minutes, or seconds.
 */
/proc/DisplayTimeText(time_value, round_seconds_to = 0.1)
	var/second = FLOOR_FLOAT(time_value * 0.1, round_seconds_to)
	if(!second)
		return "right now"
	if(second < 60)
		return "[second] second[(second != 1)? "s":""]"
	var/minute = FLOOR_FLOAT(second / 60, 1)
	second = FLOOR_FLOAT(MODULUS(second, 60), round_seconds_to)
	var/secondT
	if(second)
		secondT = " and [second] second[(second != 1)? "s":""]"
	if(minute < 60)
		return "[minute] minute[(minute != 1)? "s":""][secondT]"
	var/hour = FLOOR_FLOAT(minute / 60, 1)
	minute = MODULUS(minute, 60)
	var/minuteT
	if(minute)
		minuteT = " and [minute] minute[(minute != 1)? "s":""]"
	if(hour < 24)
		return "[hour] hour[(hour != 1)? "s":""][minuteT][secondT]"
	var/day = FLOOR_FLOAT(hour / 24, 1)
	hour = MODULUS(hour, 24)
	var/hourT
	if(hour)
		hourT = " and [hour] hour[(hour != 1)? "s":""]"
	return "[day] day[(day != 1)? "s":""][hourT][minuteT][secondT]"
