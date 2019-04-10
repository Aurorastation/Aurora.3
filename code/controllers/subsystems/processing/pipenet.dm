var/datum/controller/subsystem/processing/pipenet/SSpipenet
/datum/controller/subsystem/processing/pipenet
	name = "Pipenet"
	init_order = SS_INIT_PIPENET
	priority = SS_PRIORITY_MACHINERY
	flags = 0

/datum/controller/subsystem/processing/pipenet/New()
	NEW_SS_GLOBAL(SSpipenet)

/datum/controller/subsystem/processing/pipenet/Initialize(timeofday)
	for (var/obj/machinery/atmospherics/machine in SSmachinery.all_machines)
		machine.build_network()

		CHECK_TICK
	..()
