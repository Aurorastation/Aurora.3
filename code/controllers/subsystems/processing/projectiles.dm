PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	stat_tag = "PROJ"
	priority = SS_PRIORITY_PROJECTILES
	flags = SS_TICKER|SS_NO_INIT
	wait = 1
	var/global_max_tick_moves = 10
