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

var/next_duration_update = 0
var/last_round_duration = 0

/proc/format_time_lazy(var/input)
	var/mins = round((input % 36000) / 600)
	var/hours = round(input / 36000)

	mins = mins < 10 ? add_zero(mins, 1) : mins
	hours = hours < 10 ? add_zero(hours, 1) : hours

	return "[hours]:[mins]"

/proc/round_duration()

	if(last_round_duration && world.time < next_duration_update)
		return last_round_duration
	
	var/time_passed = world.time - round_start_time

	if (time_passed <= 0)
		last_round_duration = "00:00"
		next_duration_update = world.time + 1 MINUTE
		return last_round_duration

	last_round_duration = format_time_lazy(time_passed)

	next_duration_update = world.time + 1 MINUTES
	return last_round_duration

/var/midnight_rollovers = 0
/var/rollovercheck_last_timeofday = 0
/proc/update_midnight_rollover()
	if (world.timeofday < rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		return midnight_rollovers++
	return midnight_rollovers

//returns timestamp in a sql and ISO 8601 friendly format
/proc/SQLtime(timevar)
	if(!timevar)
		timevar = world.realtime
	return time2text(timevar, "YYYY-MM-DD hh:mm:ss")
