#define MACHINERY_GO_TO_NEXT if (no_mc_tick) { CHECK_TICK; } else if (MC_TICK_CHECK) { return; } else { continue; }

/var/datum/controller/subsystem/machinery/SSmachinery

/datum/controller/subsystem/machinery
	name = "Machinery"
	priority = SS_PRIORITY_MACHINERY
	init_order = SS_INIT_MACHINERY
	flags = SS_POST_FIRE_TIMING

	var/tmp/list/all_machines = list()        // A list of all machines. Including the non-processing ones.
	var/tmp/list/processing_machines = list() // A list of machines that process.

	var/tmp/list/working_machinery = list()   // A list of machinery left to process this work cycle.
	var/tmp/list/working_powersinks = list()  // A list of machinery draining power to process this work cycle.
	var/tmp/powernets_reset_yet

	var/tmp/processes_this_tick = 0
	var/tmp/powerusers_this_tick = 0

	var/list/all_cameras = list()
	var/list/all_status_displays = list()	// Note: This contains both ai_status_display and status_display.
	var/list/gravity_generators = list()

	var/rcon_update_queued = FALSE
	var/powernet_update_queued = FALSE

	var/list/slept_in_process = list()

	// Cooking stuff. Not substantial enough to get its own SS, so it's shoved in here.
	var/list/recipe_datums = list()

/datum/controller/subsystem/machinery/Recover()
	all_cameras = SSmachinery.all_cameras
	recipe_datums = SSmachinery.recipe_datums

/datum/controller/subsystem/machinery/proc/queue_rcon_update()
	rcon_update_queued = TRUE

/datum/controller/subsystem/machinery/New()
	NEW_SS_GLOBAL(SSmachinery)

#define ADD_TO_RDATUMS(i,t) if (R.appliance & i) { LAZYADD(recipe_datums["[i]"], t); added++; }

/datum/controller/subsystem/machinery/Initialize(timeofday)
	for (var/type in subtypesof(/datum/recipe))
		var/datum/recipe/R = new type
		var/added = 0
		ADD_TO_RDATUMS(MICROWAVE, R)
		ADD_TO_RDATUMS(FRYER, R)
		ADD_TO_RDATUMS(OVEN, R)
		ADD_TO_RDATUMS(CANDYMAKER, R)
		ADD_TO_RDATUMS(CEREALMAKER, R)
		ADD_TO_RDATUMS(POT, R)
		ADD_TO_RDATUMS(SKEWER, R)
		if (!added)
			log_debug("SSmachinery: warning: type '[type]' does not have a valid machine type.")
			qdel(R)

	fire(FALSE, TRUE)	// Tick machinery once to pare down the list so we don't hammer the server on round-start.
	..(timeofday)

#undef ADD_TO_RDATUMS

/datum/controller/subsystem/machinery/fire(resumed = 0, no_mc_tick = FALSE)
	if (!resumed)
		src.working_machinery = processing_machines.Copy()
		src.working_powersinks = processing_power_items.Copy()
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

	var/list/curr_machinery = working_machinery
	var/list/curr_powersinks = working_powersinks

	while (curr_machinery.len)
		var/obj/machinery/M = curr_machinery[curr_machinery.len]
		curr_machinery.len--

		if (QDELETED(M))
			log_debug("SSmachinery: QDELETED machine [DEBUG_REF(M)] found in machines list! Removing.")
			remove_machine(M, TRUE)
			continue

		var/start_tick = world.time

		if (M.machinery_processing)
			processes_this_tick++
			switch (M.machinery_process())
				if (PROCESS_KILL)
					remove_machine(M, FALSE)
				if (M_NO_PROCESS)
					M.machinery_processing = FALSE

		if (start_tick != world.time)
			// Slept.
			if (!slept_in_process[M.type])
				log_debug("SSmachinery: Type '[M.type]' slept during machinery_process().")
				slept_in_process[M.type] = TRUE

		// I'm sorry.
		if (M.use_power && isturf(M.loc))
			powerusers_this_tick++
			if (M.has_special_power_checks)
				M.auto_use_power()
			else
				var/area/A = M.loc.loc
				var/chan = M.power_channel
				if ((A.has_weird_power && !A.powered(chan)))
					MACHINERY_GO_TO_NEXT
				if (A.requires_power)
					if (A.always_unpowered)
						MACHINERY_GO_TO_NEXT
					switch (chan)
						if (EQUIP)
							if (!A.power_equip)
								MACHINERY_GO_TO_NEXT
						if (LIGHT)
							if (!A.power_light)
								MACHINERY_GO_TO_NEXT
						if (ENVIRON)
							if (!A.power_environ)
								MACHINERY_GO_TO_NEXT
						else	// ?!
							log_debug("SSmachinery: Type '[M.type]' has insane channel [chan] (expected value in range 1-3).")
							M.use_power = FALSE
							MACHINERY_GO_TO_NEXT

				if (A.has_weird_power)
					A.use_power(M.use_power == 2 ? M.active_power_usage : M.idle_power_usage, chan)
				else
					switch (chan)
						if (EQUIP)
							A.used_equip += M.use_power == 2 ? M.active_power_usage : M.idle_power_usage
						if (LIGHT)
							A.used_light += M.use_power == 2 ? M.active_power_usage : M.idle_power_usage
						if (ENVIRON)
							A.used_environ += M.use_power == 2 ? M.active_power_usage : M.idle_power_usage
						else // ?!
							log_debug("SSmachinery: Type '[M.type]' has insane channel [chan] (expected value in range 1-3).")
							M.use_power = FALSE

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
	var/list/out = list()
	out += "AM:[all_machines.len] PM:[processing_machines.len] PI:[processing_power_items.len]"
	out += "LT:{T:[processes_this_tick]|P:[powerusers_this_tick]}"
	..(out.Join("\n\t"))

/datum/controller/subsystem/machinery/proc/setup_template_powernets(list/cables)
	for(var/A in cables)
		var/obj/structure/cable/PC = A
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC, PC.powernet)

/**
 * @brief Adds a machine to the SSmachinery.processing_machines and the SSmachinery.all_machines list.
 *
 * Must be called in every machine's Initialize(). Is called in the parent override of that proc
 * by default.
 *
 * @param M The machine we want to add.
 */
/proc/add_machine(obj/machinery/M)
	if (QDELETED(M))
		crash_with("Attempted add of QDELETED machine [M ? M : "NULL"] to machines list, ignoring.")
		return

	M.machinery_processing = TRUE
	if (SSmachinery.processing_machines[M])
		crash_with("Type [M.type] was added to the processing machines list twice! Ignoring duplicate.")

	SSmachinery.processing_machines[M] = TRUE
	SSmachinery.all_machines[M] = TRUE

/**
 * @brief Removes a machine from all of the default global lists it's in.
 *
 * @param M The machine we want to remove.
 * @param remove_from_global Boolean to indicate wether or not the machine should
 * also be removed from the all_machines list. Defaults to FALSE.
 */
/proc/remove_machine(obj/machinery/M, remove_from_global = FALSE)
	if (M)
		M.machinery_processing = FALSE

	SSmachinery.processing_machines -= M
	SSmachinery.working_machinery -= M

	if (remove_from_global)
		SSmachinery.all_machines -= M

#undef MACHINERY_GO_TO_NEXT
