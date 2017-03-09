var/datum/subsystem/processing/disease/SSdisease
/datum/subsystem/processing/disease

/datum/subsystem/processing/disease
	name = "Diseases"
	flags = SS_KEEP_TIMING | SS_NO_INIT
	priority = SS_PRIORITY_DISEASE

/datum/subsystem/processing/disease/New()
	NEW_SS_GLOBAL(SSdisease)
