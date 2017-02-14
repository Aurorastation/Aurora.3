var/global/machinery_sort_required 		= 0
var/global/list/ticking_machines		= list()

/datum/subsystem/machinery
	name = "Machinery"
	wait = 2 SECONDS
	priority = SS_PRIORITY_MACHINERY
	flags = SS_NO_INIT
	display_order = SS_DISPLAY_MACHINERY

	var/tmp/list/processing_machinery = list()
	var/tmp/list/processing_pipenets = list()

/datum/subsystem/machinery/fire(resumed = 0)
	if (!resumed)
		src.processing_machinery = machines.Copy()
		src.processing_pipenets = pipe_networks.Copy()

		for (var/datum/powernet/PN in powernets)
			PN.reset()

	var/list/curr_machinery = src.processing_machinery
	var/list/curr_pipenets = src.processing_pipenets

	while (curr_machinery.len)
		var/obj/machinery/M = curr_machinery[curr_machinery.len]
		curr_machinery.len--

		if (QDELETED(M))
			remove_machine(M)
			continue

		switch (M.process())
			if (PROCESS_KILL)
				remove_machine(M)

			if (M_NO_PROCESS)
				ticking_machines -= M

		if (MC_TICK_CHECK)
			return

	while (curr_pipenets.len)
		var/datum/pipe_network/PN = curr_pipenets[curr_pipenets.len]
		curr_pipenets.len--

		if (!PN || PN.gcDestroyed)
			continue

		PN.process()
		
		if (MC_TICK_CHECK)
			return

/datum/subsystem/machinery/stat_entry()
	..()
	stat(null, "[machines.len] total machines")
	stat(null, "[ticking_machines.len] ticking machines, [processing_machinery.len] queued")
	stat(null, "[pipe_networks.len] pipenets, [processing_pipenets.len] queued")
