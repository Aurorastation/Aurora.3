var/datum/controller/subsystem/processing/projectiles/SSprojectiles

/datum/controller/subsystem/processing/projectiles
	name = "Projectiles"
	stat_tag = "PROJ"
	priority = SS_PRIORITY_PROJECTILES
	flags = SS_TICKER|SS_NO_INIT
	wait = 1
	var/global_max_tick_moves = 10

/datum/controller/subsystem/processing/projectiles/New()
	NEW_SS_GLOBAL(SSprojectiles)
