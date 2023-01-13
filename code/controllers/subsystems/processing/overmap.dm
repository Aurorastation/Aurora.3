var/datum/controller/subsystem/processing/overmap/SSovermap

/datum/controller/subsystem/processing/overmap
	name = "Overmap"
	stat_tag = "OVRM"
	priority = SS_PRIORITY_OVERMAP
	flags = SS_TICKER|SS_NO_INIT
	wait = 5

/datum/controller/subsystem/processing/overmap/New()
	NEW_SS_GLOBAL(SSovermap)
