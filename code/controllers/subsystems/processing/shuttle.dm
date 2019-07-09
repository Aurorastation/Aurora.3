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
	var/list/settings

	// Escape shuttle.
	shuttle = new/datum/shuttle/ferry/emergency()
	settings = list(
					1, 10, locate(/area/shuttle/escape/centcom), locate(/area/shuttle/escape/station), locate(/area/shuttle/escape/transit), NORTH, SHUTTLE_TRANSIT_DURATION_RETURN,
					locate(/area/shuttle/escape/centcom),	/area/shuttle/escape/crashed, "escape_shuttle",
					"escape_dock", "centcom_dock"
	)
	shuttle.init_shuttle(settings)
	shuttles["Escape"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)
	if(!shuttle)
		log_debug("Escape shuttle does not exist!")
	else
		emergency_shuttle.shuttle = shuttle

	// Supply shuttle
	shuttle = new/datum/shuttle/ferry/supply()
	settings = list(
					1, 10, locate(/area/supply/dock), locate(/area/supply/station), null , NORTH, 0,
					locate(/area/supply/dock),	/area/shuttle/escape/crashed, "supply_shuttle",
					"cargo_bay", null
	)
	shuttle.init_shuttle(settings)
	shuttles["Supply"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	SScargo.shuttle = shuttle

	shuttle = new/datum/shuttle/ferry/arrival()
	settings = list(
					1, 5, locate(/area/shuttle/arrival/centcom), locate(/area/shuttle/arrival/station), locate(/area/shuttle/arrival/transit),
					EAST, 60, locate(/area/shuttle/arrival/centcom), null, "arrival_shuttle",
					"arrival_dock", "centcom_setup"
	)
	shuttle.init_shuttle(settings)
	shuttles["Arrival"] = shuttle
	START_PROCESSING(shuttle_controller, shuttle)

	SSarrivals.shuttle = shuttle

	current_map.setup_shuttles()
	..()
