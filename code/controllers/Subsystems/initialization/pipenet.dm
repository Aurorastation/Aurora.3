/datum/subsystem/pipenet
	name = "Pipe network"
	init_order = SS_INIT_PIPENET
	flags = SS_NO_FIRE

/datum/subsystem/pipenet/Initialize(timeofday)
	for (var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()

	..()
