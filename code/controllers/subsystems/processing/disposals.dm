/var/datum/controller/subsystem/processing/disposals/SSdisposals

/datum/controller/subsystem/processing/disposals
	name = "Disposals"
	wait = 1	// deciseconds
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = SS_PRIORITY_DISPOSALS

	// Reference list for disposal sort junctions. Filled by sorting junctions' initialize().
	var/list/tagger_locations

/datum/controller/subsystem/processing/disposals/New()
	NEW_SS_GLOBAL(SSdisposals)
	LAZYINITLIST(tagger_locations)
