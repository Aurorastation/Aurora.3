/var/datum/controller/subsystem/machinery/SSmachinery

/datum/controller/subsystem/machinery
	name = "Machinery"
	priority = SS_PRIORITY_MACHINERY
	init_order = SS_INIT_MACHINERY
	flags = SS_POST_FIRE_TIMING

	var/tmp/list/processing_machinery = list()
	var/tmp/list/processing_powersinks = list()
	var/tmp/powernets_reset_yet

	var/tmp/processes_this_tick = 0
	var/tmp/powerusers_this_tick = 0

	var/list/all_cameras = list()

	var/rcon_update_queued = FALSE
	var/powernet_update_queued = FALSE

	var/list/slept_in_process = list()

/datum/controller/subsystem/machinery/Recover()
	all_cameras = SSmachinery.all_cameras

/datum/controller/subsystem/machinery/proc/queue_rcon_update()
	rcon_update_queued = TRUE

/datum/controller/subsystem/machinery/New()
	NEW_SS_GLOBAL(SSmachinery)

/datum/controller/subsystem/machinery/Initialize(timeofday)
	fire(FALSE, TRUE)	// Tick machinery once to pare down the list so we don't hammer the server on round-start.
	..(timeofday)

/datum/controller/subsystem/machinery/fire(resumed = 0, no_mc_tick = FALSE)
	if (!resumed)
		src.processing_machinery = machines.Copy()
		src.processing_powersinks = processing_power_items.Copy()
		powernets_reset_yet = FALSE

		// Reset accounting vars.
		processes_this_tick = 0
		powerusers_this_tick = 0

		if (rcon_update_queued)
			rcon_update_queued = FALSE
			SSpower.build_rcon_lists()

		if (powernet_update_queued)
			makepowernets()
			powernet_update_queued = FALSE

		if (cameranet.cameras_unsorted)
			sortTim(cameranet.cameras, /proc/cmp_camera)
			cameranet.cameras_unsorted = FALSE

	var/list/curr_machinery = src.processing_machinery
	var/list/curr_powersinks = src.processing_powersinks

	while (curr_machinery.len)
		var/obj/machinery/M = curr_machinery[curr_machinery.len]
		curr_machinery.len--

		if (QDELETED(M))
			log_debug("SSmachinery: QDELETED machine [DEBUG_REF(M)] found in machines list! Removing.")
			remove_machine(M)
			continue

		var/start_tick = world.time

		if (M.isprocessing)
			processes_this_tick++
			switch (M.process())
				if (PROCESS_KILL)
					remove_machine(M)
				if (M_NO_PROCESS)
					M.isprocessing = FALSE

		if (start_tick != world.time)
			// Slept.
			if (!slept_in_process[M.type])
				log_debug("SSmachinery: Type '[M.type]' slept during process().")
				slept_in_process[M.type] = TRUE

		if (M.use_power)
			powerusers_this_tick++
			M.auto_use_power()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	if (!powernets_reset_yet)
		SSpower.reset_powernets()
		powernets_reset_yet = TRUE

	while (curr_powersinks.len)
		var/obj/item/I = curr_powersinks[curr_powersinks.len]
		curr_powersinks.len--

		if (QDELETED(I) || !I.pwr_drain())
			processing_power_items -= I
			log_debug("SSmachinery: QDELETED item [DEBUG_REF(I)] found in processing power items list.")
		
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/machinery/stat_entry()
	..("M:[machines.len] PI:[processing_power_items.len]\n\tLT:{T:[processes_this_tick]|P:[powerusers_this_tick]}")

/proc/add_machine(obj/machinery/M)
	if (QDELETED(M))
		return

	M.isprocessing = TRUE
	machines += M

/proc/remove_machine(obj/machinery/M)
	if (M)
		M.isprocessing = FALSE
	machines -= M
	SSmachinery.processing_machinery -= M
