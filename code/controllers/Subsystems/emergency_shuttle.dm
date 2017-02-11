var/datum/subsystem/emergency_shuttle/SSemergency

/datum/subsystem/emergency_shuttle
	name = "Emergency Shuttle"
	wait = 2 SECONDS
	flags = SS_NO_TICK_CHECK

/datum/subsystem/emergency_shuttle/Initialize(timeofday)
	if(!emergency_shuttle)
		emergency_shuttle = new

/datum/subsystem/emergency_shuttle/fire(resumed = 0)
	emergency_shuttle.process()
