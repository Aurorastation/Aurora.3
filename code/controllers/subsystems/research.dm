var/global/datum/controller/subsystem/research/SSresearch

/datum/controller/subsystem/research
	name = "Research"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

	var/datum/research/global_research

/datum/controller/subsystem/research/New()
	NEW_SS_GLOBAL(SSresearch)

/datum/controller/subsystem/research/Initialize()
	global_research = new /datum/research/hightech(src)