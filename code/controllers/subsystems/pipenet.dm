/datum/subsystem/pipenet
	name = "Pipenet"
	init_order = SS_INIT_PIPENET
	priority = SS_PRIORITY_MACHINERY
	display_order = SS_DISPLAY_PIPENET

	var/tmp/list/processing_pipenets = list()

/datum/subsystem/pipenet/Initialize(timeofday)
	for (var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()

	..()

/datum/subsystem/pipenet/fire(resumed = FALSE)
	if (!resumed)
		src.processing_pipenets = pipe_networks.Copy()

	var/list/curr_pipenets = src.processing_pipenets

	while (curr_pipenets.len)
		var/datum/pipe_network/PN = curr_pipenets[curr_pipenets.len]
		curr_pipenets.len--

		if (!PN || PN.gcDestroyed)
			continue

		PN.process()
		
		if (MC_TICK_CHECK)
			return

/datum/subsystem/pipenet/stat_entry()
	..("P:[pipe_networks.len]")
