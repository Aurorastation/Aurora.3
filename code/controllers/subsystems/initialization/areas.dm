/datum/controller/subsystem/areas
	name = "Areas"
	init_order = SS_INIT_AREA
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/areas/Initialize(timeofday)
	for (var/A in all_areas)
		var/area/area = A
		area.initialize()
		CHECK_TICK
	..()
