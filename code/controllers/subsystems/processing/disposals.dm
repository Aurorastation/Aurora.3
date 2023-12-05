PROCESSING_SUBSYSTEM_DEF(disposals)
	name = "Disposals"
	wait = 1	// deciseconds
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = SS_PRIORITY_DISPOSALS

	// Reference list for disposal sort junctions. Filled by sorting junctions' initialize().
	var/list/tagger_locations

/datum/controller/subsystem/processing/disposals/PreInit()
	LAZYINITLIST(tagger_locations)
