var/datum/controller/subsystem/ticker/tickerProcess

/datum/controller/subsystem/ticker
	name = "Ticker"

	priority = SS_PRIORITY_TICKER
	flags = SS_NO_TICK_CHECK
	init_order = SS_INIT_TICKER

	wait = 2 SECONDS

	var/lastTickerTimeDuration
	var/lastTickerTime

/datum/controller/subsystem/ticker/New()
	NEW_SS_GLOBAL(tickerProcess)

/datum/controller/subsystem/ticker/Initialize(timeofday)
	if(!ticker)
		ticker = new

	spawn (0)
		if (ticker)
			ticker.pregame()

	..()

/datum/controller/subsystem/ticker/fire(resumed = FALSE)
	var/currentTime = REALTIMEOFDAY

	lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	ticker.process()

/datum/controller/subsystem/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration
