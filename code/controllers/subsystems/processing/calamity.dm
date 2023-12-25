// This is a separate processor so the MC can schedule singuloth/tesla/Nar-sie independent from other objects.

PROCESSING_SUBSYSTEM_DEF(calamity)
	name = "Calamity"
	flags = SS_NO_INIT | SS_POST_FIRE_TIMING
	priority = SS_PRIORITY_CALAMITY

	var/list/singularities = list()
