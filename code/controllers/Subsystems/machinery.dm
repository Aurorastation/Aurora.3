var/global/machinery_sort_required 		= 0
var/global/list/power_using_machines	= list()
var/global/list/ticking_machines		= list()

/datum/subsystem/machinery
	name = "Machinery"
	wait = 2 SECONDS
	priority = SS_PRIORITY_MACHINERY
	flags = SS_NO_INIT

	var/tmp/list/processing_machinery = list()
	var/tmp/list/processing_power_users = list()
	var/tmp/list/processing_powersinks = list()
	var/tmp/list/processing_pipenets = list()

/datum/subsystem/machinery/fire(resumed = 0)
	if (!resumed)
		src.processing_machinery = machines.Copy()
		src.processing_power_users = power_using_machines.Copy()
		src.processing_powersinks = processing_power_items.Copy()
		src.processing_pipenets = pipe_networks.Copy()

		for (var/datum/powernet/PN in powernets)
			PN.reset()

	var/list/curr_machinery = src.processing_machinery
	var/list/curr_power_users = src.processing_power_users
	var/list/curr_powersinks = src.processing_powersinks
	var/list/curr_pipenets = src.processing_pipenets

	while (curr_machinery.len)
		var/obj/machinery/M = curr_machinery[curr_machinery.len]
		curr_machinery.len--

		if (NULL_OR_GC(M))
			remove_machine(M)
			continue

		switch (M.process())
			if (PROCESS_KILL)
				remove_machine(M)

			if (M_NO_PROCESS)
				ticking_machines -= M

		if (MC_TICK_CHECK)
			return

	while (curr_power_users.len)
		var/obj/machinery/M = processing_power_users[processing_power_users.len]
		processing_power_users.len--

		if (NULL_OR_GC(M))
			remove_machine(M)
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
	stat(null, "[machines.len] total machines")
	stat(null, "[ticking_machines.len] ticking machines, [processing_machinery.len] queued")
	stat(null, "[power_using_machines.len] power-using machines, [processing_power_users.len] queued")
	stat(null, "[processing_power_items.len] power items, [processing_powersinks.len] queued")
	stat(null, "[pipe_networks.len] pipenets, [processing_pipenets.len] queued")
