/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen	= 5
	no_fake 		= 1
	endWhen			= 300 //Should be restored in 5 minutes.

/datum/event/grid_check/start()
	power_failure(1, severity)


/datum/event/grid_check/announce()
	//Don't need to announce as it is handled in the power_failure proc.

/datum/event/grid_check/end()
	power_restore(1)
