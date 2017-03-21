// This is a separate processor so the MC can schedule singuloth/tesla/Nar-sie independent from other objects.

var/datum/controller/subsystem/processing/SSingulo
/datum/controller/subsystem/processing/singularity
	name = "Singularity"
	flags = SS_NO_INIT

/datum/controller/subsystem/processing/singularity/New()
	NEW_SS_GLOBAL(SSingulo)

/datum/controller/subsystem/processing/singularity/stop_processing(datum/D)
	STOP_PROCESSING(SSingulo, D)
