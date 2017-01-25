/var/global/machinery_sort_required = 0

#define STAGE_NONE 0
#define STAGE_MACHINERY 1
#define STAGE_POWERNET 2
#define STAGE_POWERSINK 3
#define STAGE_PIPENET 4

/datum/controller/process/machinery
	var/tmp/list/processing_machinery = list()
	var/tmp/list/processing_powernets = list()
	var/tmp/list/processing_powersinks = list()
	var/tmp/list/processing_pipenets = list()
	var/stage = STAGE_NONE

/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/controller/process/machinery/doWork()
	// If we're starting a new tick, setup.
	if (stage == STAGE_NONE)
		processing_machinery = machines.Copy()
		stage = STAGE_MACHINERY

	// Process machinery.
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

		F_SCHECK

	if (stage == STAGE_MACHINERY)
		processing_powernets = powernets.Copy()
		stage = STAGE_POWERNET

	while (processing_powernets.len)
		var/datum/powernet/PN = processing_powernets[processing_powernets.len]
		processing_powernets.len--

		if (!PN || PN.gcDestroyed)
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

		if (!I || !I.pwr_drain())
			processing_power_items -= I
		
		F_SCHECK

	if (stage == STAGE_POWERSINK)
		processing_pipenets = pipe_networks.Copy()
		stage = STAGE_PIPENET

	while (processing_pipenets.len)
		var/datum/pipe_network/PN = processing_pipenets[processing_pipenets.len]
		processing_pipenets.len--

		if (!PN || PN.gcDestroyed)
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
	stat(null, "[machines.len] machines, [processing_machinery.len] queued")
	stat(null, "[powernets.len] powernets, [processing_powernets.len] queued")
	stat(null, "[processing_power_items.len] power items, [processing_powersinks.len] queued")
	stat(null, "[pipe_networks.len] pipenets, [processing_pipenets.len] queued")

#undef STAGE_NONE
#undef STAGE_MACHINERY
#undef STAGE_POWERNET
#undef STAGE_POWERSINK
#undef STAGE_PIPENET
