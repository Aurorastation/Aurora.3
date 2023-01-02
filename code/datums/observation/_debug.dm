/****************
* Debug Support *
****************/
var/singleton/all_observable_events/all_observable_events = new()

/singleton/all_observable_events
	var/list/events

/singleton/all_observable_events/New()
	events = list()
	..()
