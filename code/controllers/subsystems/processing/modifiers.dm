var/datum/subsystem/processing/modifiers/SSmodifiers
/datum/subsystem/processing/modifiers
	name = "Modifiers"
	wait = 1 SECOND
	flags = SS_NO_INIT

/datum/subsystem/processing/modifiers/New()
	NEW_SS_GLOBAL(SSmodifiers)

/datum/subsystem/processing/modifiers/stop_processing(datum/D)
	STOP_PROCESSING(SSmodifiers, D)
