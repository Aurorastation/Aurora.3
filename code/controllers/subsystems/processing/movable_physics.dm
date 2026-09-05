/// Fast-ticking subsystem for moving atoms by adjusting their pixel offsets.
PROCESSING_SUBSYSTEM_DEF(movable_physics)
	name = "Movable Physics"
	wait = 0.05 SECONDS
	stat_tag = "MP"
	priority = FIRE_PRIORITY_MOVABLE_PHYSICS
	flags = SS_BACKGROUND | SS_POST_FIRE_TIMING | SS_NO_INIT

