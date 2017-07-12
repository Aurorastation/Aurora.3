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
	var/list/all_status_displays = list()	// Note: This contains both ai_status_display and status_display.

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
		if (!added)
			log_debug("SSmachinery: warning: type '[type]' does not have a valid machine type.")
			qdel(R)

	fire(FALSE, TRUE)	// Tick machinery once to pare down the list so we don't hammer the server on round-start.
	..(timeofday)

#undef ADD_TO_RDATUMS

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

	var/list/curr_machinery = processing_machinery
	var/list/curr_powersinks = processing_powersinks

	while (curr_machinery.len)
		var/obj/machinery/M = curr_machinery[curr_machinery.len]
		curr_machinery.len--

		if (QDELETED(M))
			log_debug("SSmachinery: QDELETED machine [DEBUG_REF(M)] found in machines list! Removing.")
			remove_machine(M)
			continue

		var/start_tick = world.time

		if (M.machinery_processing)
			processes_this_tick++
			switch (M.machinery_process())
				if (PROCESS_KILL)
					remove_machine(M)
				if (M_NO_PROCESS)
					M.machinery_processing = FALSE

		if (start_tick != world.time)
			// Slept.
			if (!slept_in_process[M.type])
				log_debug("SSmachinery: Type '[M.type]' slept during machinery_process().")
				slept_in_process[M.type] = TRUE

		if (M.use_power)
			powerusers_this_tick++
			if (M.has_special_power_checks)
				M.auto_use_power()
			else
				var/area/A = M.loc ? M.loc.loc : null
				if (isarea(A))
					var/chan = M.power_channel
					if (A.powered(chan))
						var/usage = 0
						switch (M.use_power)
							if (1)
								usage = M.idle_power_usage
							if (2)
								usage = M.active_power_usage
						
						A.use_power(usage, chan)

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
	out += "M:[machines.len] PI:[processing_power_items.len]"
	out += "LT:{T:[processes_this_tick]|P:[powerusers_this_tick]}"
	..(out.Join("\n\t"))

/datum/controller/subsystem/machinery/proc/setup_template_powernets(list/cables)
	for(var/A in cables)
		var/obj/structure/cable/PC = A
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC, PC.powernet)

/proc/add_machine(obj/machinery/M)
	if (QDELETED(M))
		crash_with("Attempted add of QDELETED machine [M ? M : "NULL"] to machines list, ignoring.")
		return

	M.machinery_processing = TRUE
	if (machines[M])
		crash_with("Type [M.type] was added to machines list twice! Ignoring duplicate.")

	machines[M] = TRUE

/proc/remove_machine(obj/machinery/M)
	if (M)
		M.machinery_processing = FALSE
	machines -= M
	SSmachinery.processing_machinery -= M
