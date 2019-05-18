var/datum/controller/subsystem/processing/shuttle/shuttle_controller

/datum/controller/subsystem/processing/shuttle
	name = "Shuttles"
	init_order = SS_INIT_SHUTTLE
	priority = SS_PRIORITY_SHUTTLE
	flags = 0	// Override parent.
	var/list/shuttles

/datum/controller/subsystem/processing/shuttle/New()
	NEW_SS_GLOBAL(shuttle_controller)
	shuttles = list()

/datum/controller/subsystem/processing/shuttle/Recover()
	src.shuttles = shuttle_controller.shuttles

/datum/controller/subsystem/processing/shuttle/proc/setup_shuttle_docks()
	for(var/shuttle_tag in shuttles)
		var/datum/shuttle/shuttle = shuttles[shuttle_tag]
		shuttle.init_docking_controllers()
		shuttle.dock() //makes all shuttles docked to something at round start go into the docked state

	for(var/obj/machinery/embedded_controller/C in SSmachinery.processing_machines)
		if(istype(C.program, /datum/computer/file/embedded_program/docking))
			C.program.tag = null //clear the tags, 'cause we don't need 'em anymore

/datum/controller/subsystem/processing/shuttle/Initialize(timeofday)
	var/datum/shuttle/ferry/shuttle

	// Escape shuttle.
	shuttle = new/datum/shuttle/ferry/emergency()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/shuttle/escape/centcom)
	shuttle.area_station = locate(/area/shuttle/escape/station)
	shuttle.area_transition = locate(/area/shuttle/escape/transit)
	shuttle.area_current = shuttle.area_offsite
	shuttle.area_crash = /area/shuttle/escape/station/crash
	shuttle.docking_controller_tag = "escape_shuttle"
	shuttle.dock_target_station = "escape_dock"
	shuttle.dock_target_offsite = "centcom_dock"
	shuttle.transit_direction = NORTH
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION_RETURN
	//shuttle.docking_controller_tag = "supply_shuttle"
	//shuttle.dock_target_station = "cargo_bay"
	shuttles["Escape"] = shuttle
	shuttle.init_engines()
	START_PROCESSING(shuttle_controller, shuttle)
	if(!shuttle)
		log_debug("Escape shuttle does not exist!")
	else
		emergency_shuttle.shuttle = shuttle

	// Supply shuttle
	shuttle = new/datum/shuttle/ferry/supply()
	shuttle.location = 1
	shuttle.warmup_time = 10
	shuttle.area_offsite = locate(/area/supply/dock)
	shuttle.area_station = locate(/area/supply/station)
	shuttle.area_current = shuttle.area_offsite
	shuttle.area_crash = /area/supply/station/crashed
	shuttle.docking_controller_tag = "supply_shuttle"
	shuttle.dock_target_station = "cargo_bay"
	shuttles["Supply"] = shuttle
	shuttle.init_engines()
	START_PROCESSING(shuttle_controller, shuttle)

	SScargo.shuttle = shuttle

	shuttle = new/datum/shuttle/ferry/arrival()
	shuttle.location = 1
	shuttle.warmup_time = 5
	shuttle.area_station = locate(/area/shuttle/arrival/station)
	shuttle.area_offsite = locate(/area/shuttle/arrival/centcom)
	shuttle.area_transition = locate(/area/shuttle/arrival/transit)
	shuttle.area_current = shuttle.area_offsite
	shuttle.docking_controller_tag = "arrival_shuttle"
	shuttle.dock_target_station = "arrival_dock"
	shuttle.dock_target_offsite = "centcom_setup"
	shuttle.transit_direction = EAST
	shuttle.move_time = 60
	shuttles["Arrival"] = shuttle
	shuttle.init_engines()
	START_PROCESSING(shuttle_controller, shuttle)

	SSarrivals.shuttle = shuttle

	current_map.setup_shuttles()
	..()
