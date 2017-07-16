var/datum/controller/subsystem/processing/modifiers/SSmodifiers
/datum/controller/subsystem/processing/modifiers
	name = "Modifiers"
	wait = 1 SECOND
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MODIFIER

/datum/controller/subsystem/processing/modifiers/New()
	NEW_SS_GLOBAL(SSmodifiers)
