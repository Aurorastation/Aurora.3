var/roundstart_hour = 0
var/round_start_time

//Returns the world time in english
/proc/worldtime2text(time = world.time, timeshift = 1)
	if(!roundstart_hour) roundstart_hour = rand(0, 23)
	return timeshift ? time2text(time+(roundstart_hour HOURS), "hh:mm") : time2text(time, "hh:mm")

/proc/worldtime2hours()
	if (!roundstart_hour)
		worldtime2text()
	. = text2num(time2text(world.time + (roundstart_hour HOURS), "hh"))

/proc/worlddate2text()
	return num2text(game_year) + "-" + time2text(world.timeofday, "MM-DD")

/proc/time_stamp()
	return time2text(world.timeofday, "hh:mm:ss")

/* Returns 1 if it is the selected month and day */
/proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

var/real_round_start_time
/proc/get_round_duration() //Real time since round has started, in ticks.
	return real_round_start_time ? (REALTIMEOFDAY - real_round_start_time) : 0

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
	if (world.timeofday < rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		midnight_rollovers += 1
	rollovercheck_last_timeofday = world.timeofday
	return midnight_rollovers

//returns timestamp in a sql and ISO 8601 friendly format
/proc/SQLtime(timevar)
	if(!timevar)
		timevar = world.realtime
	return time2text(timevar, "YYYY-MM-DD hh:mm:ss")
