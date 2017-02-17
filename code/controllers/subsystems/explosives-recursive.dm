var/datum/subsystem/explosives_recursive/SSkaboom

/datum/subsystem/explosives_recursive
	name = "Explosives (R)"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 1 SECONDS

	var/tmp/list/queued_explosives = list()



/datum/subsystem/explosives_recursive/New()
	NEW_SS_GLOBAL(SSkaboom)

/datum/subsystem/explosives_recursive/fire(resumed = FALSE)
	if (!resumed)
		// do things



/turf
	var/tmp/last_ex_pow = 0
