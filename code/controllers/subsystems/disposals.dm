/var/datum/subsystem/processing/disposals/SSdisposals

/datum/subsystem/processing/disposals
	name = "Disposals"
	wait = 1	// ticks
	flags = SS_NO_INIT | SS_TICKER

/datum/subsystem/disposals/New()
	NEW_SS_GLOBAL(SSdisposals)
