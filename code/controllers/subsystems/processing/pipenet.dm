var/datum/subsystem/processing/pipenet/SSpipenet
/datum/subsystem/processing/pipenet
	name = "Pipenet"
	init_order = SS_INIT_PIPENET
	priority = SS_PRIORITY_MACHINERY
	display_order = SS_DISPLAY_PIPENET

/datum/subsystem/processing/pipenet/New()
	NEW_SS_GLOBAL(SSpipenet)

/datum/subsystem/processing/pipenet/Initialize(timeofday)
	for (var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()

		CHECK_TICK
	..()
