var/datum/controller/subsystem/processing/disease/SSdisease

/datum/controller/subsystem/processing/disease
	name = "Diseases"
	flags = SS_KEEP_TIMING | SS_NO_INIT
	priority = SS_PRIORITY_DISEASE

/datum/controller/subsystem/processing/disease/New()
	NEW_SS_GLOBAL(SSdisease)
