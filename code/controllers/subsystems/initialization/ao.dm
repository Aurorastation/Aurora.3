/var/datum/controller/subsystem/ao/SSocclusion

/datum/controller/subsystem/ao
	name = "Ambient Occlusion"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_AO

	var/setup_complete = FALSE

/datum/controller/subsystem/ao/New()
	NEW_SS_GLOBAL(SSocclusion)

/datum/controller/subsystem/ao/Initialize()
	var/thing
	var/turf/T
	for (var/zlevel in 1 to world.maxz)
		for (thing in block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
			T = thing
			if (T.permit_ao)
				T.calculate_ao_neighbours()
				T.update_ao()

			CHECK_TICK

	setup_complete = TRUE

	..()
