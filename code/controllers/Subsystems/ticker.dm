var/datum/subsystem/ticker/tickerProcess

/datum/subsystem/ticker
	name = "Ticker"

	priority = SS_PRIORITY_TICKER
	flags = SS_FIRE_IN_LOBBY|SS_KEEP_TIMING
	init_order = SS_INIT_TICKER

	var/lastTickerTimeDuration
	var/lastTickerTime

/datum/subsystem/ticker/New()
	NEW_SS_GLOBAL(tickerProcess)

/datum/subsystem/ticker/Initialize(timeofday)
	if(!ticker)
		ticker = new

	spawn(0)
		if(ticker)
			ticker.pregame()

	..()

/datum/subsystem/ticker/fire(resumed = FALSE)
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	ticker.process()

/datum/subsystem/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration
