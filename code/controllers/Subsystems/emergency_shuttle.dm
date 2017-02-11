var/datum/subsystem/emergency_shuttle/SSemergency

/datum/subsystem/emergency_shuttle
	name = "Emergency Shuttle"

/datum/subsystem/emergency_shuttle/Initialize(timeofday)
	if(!emergency_shuttle)
		emergency_shuttle = new

/datum/subsystem/emergency_shuttle/fire(resumed = 0)
	emergency_shuttle.process()
