#define STAGE_NONE 0
#define STAGE_POWERNET 1
#define STAGE_POWERSINK 2

/var/global/powernet_update_pending = FALSE

/datum/controller/process/powernet
	var/list/pn_queue = list()
	var/list/pi_queue = list()
	var/stage = STAGE_NONE
	var/ticks_waiting = 0

/datum/controller/process/powernet/setup()
	name = "powernet"
	schedule_interval = 2 SECONDS
	start_delay = 15

/datum/controller/process/powernet/doWork()
	// Don't process if the machinery ticker hasn't completed its tick.
	if (!stage && !powernet_update_pending)
		ticks_waiting++
		return

	// If we're starting a new tick, setup.
	if (stage == STAGE_NONE)
		pn_queue = powernets.Copy()
		stage = STAGE_POWERNET
		ticks_waiting = 0

	// Process powernets.
	while (pn_queue.len)
		var/datum/powernet/PN = pn_queue[pn_queue.len]
		pn_queue.len--

		if (!PN || PN.gcDestroyed)
			powernets -= PN
			continue

		PN.reset()
		F_SCHECK

	// If we've finished processing powernet, start on powersinks.
	if (stage == STAGE_POWERNET)
		pi_queue = processing_power_items.Copy()
		stage = STAGE_POWERSINK

	// Process powersinks.
	while (pi_queue.len)
		var/obj/item/I = pi_queue[pi_queue.len]
		pi_queue.len--

		if (!I || !I.pwr_drain())
			processing_power_items -= I
		
		F_SCHECK

	stage = STAGE_NONE
	powernet_update_pending = FALSE

/datum/controller/process/powernet/statProcess()
	..()
	stat(null, "[powernets.len] powernets, [pn_queue.len] queued")
	stat(null, "[processing_power_items.len] power-drawing items, [pi_queue.len] queued")
	stat(null, "Currently [powernet_update_pending ? "processing" : "waiting for"] machinery, [ticks_waiting] ticks spent waiting")

#undef STAGE_NONE
#undef STAGE_POWERNET
#undef STAGE_POWERSINK
