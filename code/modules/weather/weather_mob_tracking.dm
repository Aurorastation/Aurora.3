
GLOBAL_LIST_EMPTY(current_mob_ambience)
/obj/abstract/weather_system
	// Weakref lists used to track mobs within our weather
	// system; alternative to keeping big lists of actual mobs or
	// having mobs constantly poked by weather systems.

	var/tmp/list/mob_shown_weather =  list() // Has this mob been sent the summary message about the current weather?
	var/tmp/list/mob_shown_wind =     list() // Has this mob been sent the summary message about the current wind?
