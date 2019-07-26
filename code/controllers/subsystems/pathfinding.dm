/var/datum/controller/subsystem/arrivals/SSpathfinding

/datum/controller/subsystem/arrivals
	name = "Arrivals"
	flags = SS_NO_INIT | SS_BACKGROUND | SS_NO_TICK_CHECK

	var/list/cached_path = list()

/datum/controller/subsystem/arrivals/New()
	NEW_SS_GLOBAL(SSpathfinding)