/var/datum/subsystem/processing/disposals/SSdisposals

/datum/subsystem/processing/disposals
	name = "Disposals"
	wait = 1	// ticks
	flags = SS_NO_INIT | SS_TICKER

	// Reference list for disposal sort junctions. Filled by sorting junctions' initialize().
	var/list/tagger_locations

/datum/subsystem/processing/disposals/New()
	NEW_SS_GLOBAL(SSdisposals)
	tagger_locations = list()
