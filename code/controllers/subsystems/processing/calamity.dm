// This is a separate processor so the MC can schedule singuloth/tesla/Nar-sie independent from other objects.

var/datum/controller/subsystem/processing/SScalamity
/datum/controller/subsystem/processing/calamity
	name = "Calamity"
	flags = SS_NO_INIT | SS_POST_FIRE_TIMING
	priority = SS_PRIORITY_CALAMITY

/datum/controller/subsystem/processing/calamity/New()
	NEW_SS_GLOBAL(SScalamity)
