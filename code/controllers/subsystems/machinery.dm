#define SSMACHINERY_PIPENETS 1
#define SSMACHINERY_MACHINERY 2
#define SSMACHINERY_POWERNETS 3
#define SSMACHINERY_POWER_OBJECTS 4


#define START_PROCESSING_IN_LIST(Datum, List) \
if (Datum.isprocessing) {\
	if(Datum.isprocessing != "SSmachinery.[#List]")\
	{\
		crash_with("Failed to start processing. [log_info_line(Datum)] is already being processed by [Datum.isprocessing] but queue attempt occured on SSmachinery.[#List]."); \
	}\
} else {\
	Datum.isprocessing = "SSmachinery.[#List]";\
	SSmachinery.List += Datum;\
}

#define STOP_PROCESSING_IN_LIST(Datum, List) \
if(Datum.isprocessing) {\
	if(SSmachinery.List.Remove(Datum)) {\
		Datum.isprocessing = null;\
	} else {\
		crash_with("Failed to stop processing. [log_info_line(Datum)] is being processed by [isprocessing] and not found in SSmachinery.[#List]"); \
	}\
}

#define START_PROCESSING_PIPENET(Datum) START_PROCESSING_IN_LIST(Datum, pipenets)
#define STOP_PROCESSING_PIPENET(Datum) STOP_PROCESSING_IN_LIST(Datum, pipenets)

#define START_PROCESSING_POWERNET(Datum) START_PROCESSING_IN_LIST(Datum, powernets)
#define STOP_PROCESSING_POWERNET(Datum) STOP_PROCESSING_IN_LIST(Datum, powernets)

#define START_PROCESSING_POWER_OBJECT(Datum) START_PROCESSING_IN_LIST(Datum, power_objects)
#define STOP_PROCESSING_POWER_OBJECT(Datum) STOP_PROCESSING_IN_LIST(Datum, power_objects)

/var/datum/controller/subsystem/machinery/SSmachinery

/datum/controller/subsystem/machinery
	name = "Machinery"
	priority = SS_PRIORITY_MACHINERY
	init_order = SS_INIT_MACHINERY
	flags = SS_POST_FIRE_TIMING

	var/static/tmp/current_step = SSMACHINERY_PIPENETS
	var/static/tmp/cost_pipenets = 0
	var/static/tmp/cost_machinery = 0
	var/static/tmp/cost_powernets = 0
	var/static/tmp/cost_power_objects = 0
	var/static/tmp/list/pipenets = list()
	var/static/tmp/list/machinery = list()
	var/static/tmp/list/powernets = list()
	var/static/tmp/list/power_objects = list()
	var/static/tmp/list/processing = list()
	var/static/tmp/list/queue = list()

	var/list/all_cameras = list()
	var/list/obj/machinery/hologram/holopad/all_holopads = list()
	var/list/all_status_displays = list()	// Note: This contains both ai_status_display and status_display.
	var/list/gravity_generators = list()
	var/list/obj/machinery/telecomms/all_telecomms = list()
	var/list/obj/machinery/telecomms/all_receivers = list()

	var/list/rcon_smes_units = list()
	var/list/rcon_smes_units_by_tag = list()
	var/list/rcon_breaker_units = list()
	var/list/rcon_breaker_units_by_tag = list()

	var/list/breaker_boxes = list()
	var/list/smes_units = list()
	var/list/all_sensors = list()

	var/list/slept_in_process = list()

	// Cooking stuff. Not substantial enough to get its own SS, so it's shoved in here.
	var/list/recipe_datums = list()

/datum/controller/subsystem/machinery/Recover()
	all_cameras = SSmachinery.all_cameras
	all_holopads = SSmachinery.all_holopads
	recipe_datums = SSmachinery.recipe_datums
	breaker_boxes = SSmachinery.breaker_boxes
	all_sensors = SSmachinery.all_sensors
	all_telecomms = SSmachinery.all_telecomms
	all_receivers = SSmachinery.all_receivers
	current_step = SSMACHINERY_PIPENETS

/datum/controller/subsystem/machinery/New()
	NEW_SS_GLOBAL(SSmachinery)

/datum/controller/subsystem/machinery/Initialize(timeofday)
	makepowernets()
	build_rcon_lists()
	setup_atmos_machinery(machinery)
	fire(FALSE, TRUE)	// Tick machinery once to pare down the list so we don't hammer the server on round-start.
	..(timeofday)

/datum/controller/subsystem/machinery/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/timer
	if (!resumed || current_step == SSMACHINERY_PIPENETS)
		timer = world.tick_usage
		process_pipenets(resumed, no_mc_tick)
		cost_pipenets = MC_AVERAGE(cost_pipenets, TICK_DELTA_TO_MS(world.tick_usage - timer))
		if (state != SS_RUNNING && init_state == SS_INITSTATE_DONE)
			return
		current_step = SSMACHINERY_MACHINERY
		resumed = FALSE
	if (current_step == SSMACHINERY_MACHINERY)
		timer = world.tick_usage
		process_machinery(resumed, no_mc_tick)
		cost_machinery = MC_AVERAGE(cost_machinery, TICK_DELTA_TO_MS(world.tick_usage - timer))
		if(state != SS_RUNNING && init_state == SS_INITSTATE_DONE)
			return
		current_step = SSMACHINERY_POWERNETS
		resumed = FALSE
	if (current_step == SSMACHINERY_POWERNETS)
		timer = world.tick_usage
		process_powernets(resumed, no_mc_tick)
		cost_powernets = MC_AVERAGE(cost_powernets, TICK_DELTA_TO_MS(world.tick_usage - timer))
		if(state != SS_RUNNING && init_state == SS_INITSTATE_DONE)
			return
		current_step = SSMACHINERY_POWER_OBJECTS
		resumed = FALSE
	if (current_step == SSMACHINERY_POWER_OBJECTS)
		timer = world.tick_usage
		process_power_objects(resumed, no_mc_tick)
		cost_power_objects = MC_AVERAGE(cost_power_objects, TICK_DELTA_TO_MS(world.tick_usage - timer))
		if (state != SS_RUNNING && init_state == SS_INITSTATE_DONE)
			return
		current_step = SSMACHINERY_PIPENETS

/datum/controller/subsystem/machinery/proc/makepowernets()
	for(var/datum/powernet/powernet as anything in powernets)
		qdel(powernet)
	powernets.Cut()
	setup_powernets_for_cables(cable_list)

/datum/controller/subsystem/machinery/proc/setup_powernets_for_cables(list/cables)
	for (var/obj/structure/cable/cable as anything in cables)
		if (cable.powernet)
			continue
		var/datum/powernet/network = new
		network.add_cable(cable)
		propagate_network(cable, cable.powernet)

/datum/controller/subsystem/machinery/proc/setup_atmos_machinery(list/machines)
	var/list/atmos_machines = list()
	for (var/obj/machinery/atmospherics/machine in machines)
		atmos_machines += machine
	admin_notice(SPAN_DANGER("Initializing atmos machinery."), R_DEBUG)
	log_ss("machinery", "Initializing atmos machinery.")
	for (var/obj/machinery/atmospherics/machine as anything in atmos_machines)
		machine.atmos_init()
		CHECK_TICK
	admin_notice(SPAN_DANGER("Initializing pipe networks."), R_DEBUG)
	log_ss("machinery", "Initializing pipe networks.")
	for (var/obj/machinery/atmospherics/machine as anything in atmos_machines)
		machine.build_network()
		CHECK_TICK

/datum/controller/subsystem/machinery/proc/process_pipenets(resumed, no_mc_tick)
	if (!resumed)
		queue = pipenets.Copy()
	var/datum/pipe_network/network
	for (var/i = queue.len to 1 step -1)
		network = queue[i]
		if (QDELETED(network))
			if (network)
				network.isprocessing = null
			pipenets -= network
			continue
		network.process()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return

/datum/controller/subsystem/machinery/proc/process_machinery(resumed, no_mc_tick)
	if (!resumed)
		queue = processing.Copy()
	var/obj/machinery/machine
	for (var/i = queue.len to 1 step -1)
		machine = queue[i]
		if (QDELETED(machine))
			if (machine)
				machine.isprocessing = null
			processing -= machine
			continue
		if (machine.process_all() == PROCESS_KILL)
			processing -= machine
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return

/datum/controller/subsystem/machinery/proc/process_powernets(resumed, no_mc_tick)
	if (!resumed)
		queue = powernets.Copy()
	var/datum/powernet/network
	for (var/i = queue.len to 1 step -1)
		network = queue[i]
		if (QDELETED(network))
			if (network)
				network.isprocessing = null
			powernets -= network
			continue
		network.reset(wait)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return

/datum/controller/subsystem/machinery/proc/process_power_objects(resumed, no_mc_tick)
	if (!resumed)
		queue = power_objects.Copy()
	var/obj/item/item
	for (var/i = queue.len to 1 step -1)
		item = queue[i]
		if (QDELETED(item))
			if (item)
				item.isprocessing = null
			power_objects -= item
			continue
		if (!item.pwr_drain(wait))
			item.isprocessing = null
			power_objects -= item
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return

/datum/controller/subsystem/machinery/stat_entry()
	..({"\n\
		Queues: \
		Pipes [pipenets.len] \
		Machines [processing.len] \
		Networks [powernets.len] \
		Objects [power_objects.len]\n\
		Costs: \
		Pipes [round(cost_pipenets, 1)] \
		Machines [round(cost_machinery, 1)] \
		Networks [round(cost_powernets, 1)] \
		Objects [round(cost_power_objects, 1)]\n\
		Overall [round(cost ? processing.len / cost : 0, 0.1)]
	"})

/datum/controller/subsystem/machinery/ExplosionStart()
	suspend()

/datum/controller/subsystem/machinery/ExplosionEnd()
	wake()

/datum/controller/subsystem/machinery/proc/build_rcon_lists()
	rcon_smes_units.Cut()
	rcon_breaker_units.Cut()
	rcon_breaker_units_by_tag.Cut()

	for(var/obj/machinery/power/smes/buildable/SMES in smes_units)
		if(SMES.RCon_tag && (SMES.RCon_tag != "NO_TAG") && SMES.RCon)
			rcon_smes_units += SMES
			rcon_smes_units_by_tag[SMES.RCon_tag] = SMES

	for(var/obj/machinery/power/breakerbox/breaker in breaker_boxes)
		if(breaker.RCon_tag != "NO_TAG")
			rcon_breaker_units += breaker
			rcon_breaker_units_by_tag[breaker.RCon_tag] = breaker

	sortTim(rcon_smes_units, /proc/cmp_rcon_smes)
	sortTim(rcon_breaker_units, /proc/cmp_rcon_bbox)

#undef SSMACHINERY_PIPENETS
#undef SSMACHINERY_MACHINERY
#undef SSMACHINERY_POWERNETS
#undef SSMACHINERY_POWER_OBJECTS
