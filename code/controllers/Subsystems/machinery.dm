/var/datum/subsystem/machinery/SSmachinery

/datum/subsystem/machinery
	name = "Machinery"
	flags = SS_KEEP_TIMING | SS_NO_INIT
	wait = 2 SECONDS

	var/tmp/list/processing_machinery = list()
	var/tmp/list/processing_powernets = list()
	var/tmp/list/processing_powersinks = list()
	var/tmp/list/processing_pipenets = list()

/datum/subsystem/machinery/New()
	NEW_SS_GLOBAL(SSmachinery)

/datum/subsystem/machinery/fire(resumed = 0)
	if (!resumed)
		processing_machinery = machines.Copy()
		processing_powernets = powernets.Copy()
		processing_powersinks = processing_power_items.Copy()
		processing_pipenets = pipe_networks.Copy()

	while (processing_machinery.len)
		var/obj/machinery/M = processing_machinery[processing_machinery.len]
		processing_machinery.len--

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

	while (processing_powernets.len)
		var/datum/powernet/PN = processing_powernets[processing_powernets.len]
		processing_powernets.len--

		if (!PN || PN.gcDestroyed)
			powernets -= PN
			continue

		PN.reset()
		
		if (MC_TICK_CHECK)
			return

	while (processing_powersinks.len)
		var/obj/item/I = processing_powersinks[processing_powersinks.len]
		processing_powersinks.len--

		if (!I || !I.pwr_drain())
			processing_power_items -= I
		
		if (MC_TICK_CHECK)
			return

	while (processing_pipenets.len)
		var/datum/pipe_network/PN = processing_pipenets[processing_pipenets.len]
		processing_pipenets.len--

		if (!PN || PN.gcDestroyed)
			continue

		PN.process()
		
		if (MC_TICK_CHECK)
			return

/datum/subsystem/machinery/stat_entry()
	..("M:[machines.len]|PoN:[powernets.len]|PS:[processing_power_items.len]|PiN:[pipe_networks.len]")
