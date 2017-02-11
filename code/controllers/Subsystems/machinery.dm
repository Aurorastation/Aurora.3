var/machinery_sort_required

/datum/subsystem/machinery
	name = "Machinery"
	flags = SS_KEEP_TIMING
	wait = 2 SECONDS
	priority = SS_PRIORITY_MACHINERY

	var/tmp/list/processing_machinery = list()
	var/tmp/list/processing_powersinks = list()
	var/tmp/list/processing_pipenets = list()


/datum/subsystem/machinery/Initialize(timeofday)
	makepowernets()
	fire()
	..()

/datum/subsystem/machinery/fire(resumed = 0)
	if (!resumed)
		src.processing_machinery = machines.Copy()
		src.processing_powersinks = processing_power_items.Copy()
		src.processing_pipenets = pipe_networks.Copy()

		for (var/datum/powernet/PN in powernets)
			PN.reset()

	var/curr_machinery = src.processing_machinery
	var/curr_powersinks = src.processing_powersinks
	var/curr_pipenets = src.processing_pipenets

	while (curr_machinery.len)
		var/obj/machinery/M = curr_machinery[curr_machinery.len]
		curr_machinery.len--

		if (!M || M.gcDestroyed)
			machines -= M
			continue

		if (M.process() == PROCESS_KILL)
			machines -= M
			continue

		if (M.use_power)
			M.auto_use_power()

		if (MC_TICK_CHECK)
			return

	while (curr_powersinks.len)
		var/obj/item/I = curr_powersinks[curr_powersinks.len]
		curr_powersinks.len--

		if (!I || !I.pwr_drain())
			processing_power_items -= I
		
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
	stat(null, "[machines.len] machines")
	stat(null, "[powernets.len] powernets")
	stat(null, "[processing_power_items.len] power items")
	stat(null, "[pipe_networks.len] pipenets")
