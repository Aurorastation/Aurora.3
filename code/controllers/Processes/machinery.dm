/var/global/machinery_sort_required 	= 0
var/global/list/machinery_power			= list()
var/global/list/machinery_processing	= list()

#define STAGE_NONE 0
#define STAGE_MACHINERY_PROCESS 1
#define STAGE_MACHINERY_POWER 2
#define STAGE_POWERNET 3
#define STAGE_POWERSINK 4
#define STAGE_PIPENET 5

/proc/add_machine(var/obj/machinery/M)
	if (NULL_OR_GC(M))
		return

	var/type = M.get_process_type()
	if (type)
		machines += M
	if (type & M_PROCESSES)
		machinery_processing += M

	if (type & M_USES_POWER)
		machinery_power += M

/proc/remove_machine(var/obj/machinery/M)
	machines -= M
	machinery_power -= M
	machinery_processing -= M

/datum/controller/process/machinery
	var/tmp/list/processing_machinery_processing  = list()
	var/tmp/list/processing_machinery_power_users = list()
	var/tmp/list/processing_powernets             = list()
	var/tmp/list/processing_powersinks            = list()
	var/tmp/list/processing_pipenets              = list()
	var/stage = STAGE_NONE

/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/controller/process/machinery/doWork()
	// If we're starting a new tick, setup.
	if (stage == STAGE_NONE)
		processing_machinery_processing = machinery_processing.Copy()
		stage = STAGE_MACHINERY_PROCESS

	// Process machinery.
	while (processing_machinery_processing.len)
		var/obj/machinery/M = processing_machinery_processing[processing_machinery_processing.len]
		processing_machinery_processing.len--

		if (NULL_OR_GC(M))
			remove_machine(M)
			continue

		switch (M.process())
			if (PROCESS_KILL)
				remove_machine(M)

			if (M_NO_PROCESS)
				machinery_processing -= M

		F_SCHECK

	if (stage == STAGE_MACHINERY_PROCESS)
		processing_machinery_power_users = machinery_power.Copy()
		stage = STAGE_MACHINERY_POWER

	while (processing_machinery_power_users.len)
		var/obj/machinery/M = processing_machinery_power_users[processing_machinery_power_users.len]
		processing_machinery_power_users.len--

		if (NULL_OR_GC(M))
			remove_machine(M)
			continue

		if (M.use_power)
			M.auto_use_power()

		F_SCHECK

	if (stage == STAGE_MACHINERY_POWER)
		processing_powernets = powernets.Copy()
		stage = STAGE_POWERNET

	while (processing_powernets.len)
		var/datum/powernet/PN = processing_powernets[processing_powernets.len]
		processing_powernets.len--

		if (NULL_OR_GC(PN))
			powernets -= PN
			continue

		PN.reset()
		F_SCHECK

	if (stage == STAGE_POWERNET)
		processing_powersinks = processing_power_items.Copy()
		stage = STAGE_POWERSINK

	while (processing_powersinks.len)
		var/obj/item/I = processing_powersinks[processing_powersinks.len]
		processing_powersinks.len--

		if (NULL_OR_GC(I) || !I.pwr_drain())
			processing_power_items -= I
		
		F_SCHECK

	if (stage == STAGE_POWERSINK)
		processing_pipenets = pipe_networks.Copy()
		stage = STAGE_PIPENET

	while (processing_pipenets.len)
		var/datum/pipe_network/PN = processing_pipenets[processing_pipenets.len]
		processing_pipenets.len--

		if (NULL_OR_GC(PN))
			pipe_networks -= PN
			continue

		PN.process()
		F_SCHECK

	stage = STAGE_NONE

/datum/controller/process/machinery/proc/internal_sort()
	if(machinery_sort_required)
		machinery_sort_required = 0
		machines = dd_sortedObjectList(machines)

/datum/controller/process/machinery/statProcess()
	..()
	stat(null, "[machines.len] total machines")
	stat(null, "[machinery_processing.len] ticking machines, [processing_machinery_processing.len] queued")
	stat(null, "[machinery_power.len] power-using machines, [processing_machinery_power_users.len] queued")
	stat(null, "[powernets.len] powernets, [processing_powernets.len] queued")
	stat(null, "[processing_power_items.len] power items, [processing_powersinks.len] queued")
	stat(null, "[pipe_networks.len] pipenets, [processing_pipenets.len] queued")

#undef STAGE_NONE
#undef STAGE_MACHINERY_PROCESS
#undef STAGE_MACHINERY_POWER
#undef STAGE_POWERNET
#undef STAGE_POWERSINK
#undef STAGE_PIPENET
