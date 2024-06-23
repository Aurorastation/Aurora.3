var/list/escape_pods = list()
var/list/escape_pods_by_name = list()

/datum/shuttle/autodock/ferry/escape_pod
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/arming_controller
	category = /datum/shuttle/autodock/ferry/escape_pod
	move_time = 100

/datum/shuttle/autodock/ferry/escape_pod/New()
	..()
	var/arming_controller_tag = arming_controller
	arming_controller = SSshuttle.docking_registry[arming_controller_tag]
	if(!istype(arming_controller))
		CRASH("Could not find arming controller for escape pod \"[name]\", tag was '[arming_controller_tag]'.")

	escape_pods += src
	escape_pods_by_name[name] = src
	move_time = evacuation_controller.evac_transit_delay + rand(-30, 60)
	if(dock_target)
		var/datum/computer/file/embedded_program/docking/simple/own_target = SSshuttle.docking_registry[dock_target]
		if(own_target)
			var/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/own_target_master = own_target.master
			if(own_target_master)
				own_target_master.pod = src

/datum/shuttle/autodock/ferry/escape_pod/can_launch()
	if(arming_controller && !arming_controller.armed)	//must be armed
		return 0
	if(location)
		return 0	//it's a one-way trip.
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_force()
	if(arming_controller.emagged && next_location && moving_status == SHUTTLE_IDLE && process_state <= WAIT_LAUNCH)
		return TRUE
	if(arming_controller.eject_time && world.time < arming_controller.eject_time + 50)
		return FALSE	//dont allow force launching until 5 seconds after the arming controller has reached it's countdown
	return ..()

/datum/shuttle/autodock/ferry/escape_pod/can_cancel()
	return 0

//This controller goes on the escape pod itself
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod
	name = "escape pod controller"
	var/datum/shuttle/autodock/ferry/escape_pod/pod

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EscapePodConsole", name, ui_x=470, ui_y=270)
		ui.open()

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_data(mob/user)
	return list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"door_state" = 	docking_program.memory["door_status"]["state"],
		"door_lock" = 	docking_program.memory["door_status"]["lock"],
		"can_force" = pod.can_force() || (evacuation_controller.has_evacuated() && pod.can_launch()),	//allow players to manually launch ahead of time if the shuttle leaves
		"is_armed" = pod.arming_controller.armed
	)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(action == "command")
		if(params["command"] == "manual_arm")
			pod.arming_controller.arm()
			return TRUE
		if(params["command"] == "force_launch")
			if (pod.can_force())
				pod.force_launch(src)
			else if (evacuation_controller.has_evacuated() && pod.can_launch())	//allow players to manually launch ahead of time if the shuttle leaves
				pod.launch(src)
			return TRUE

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod/emag_act(var/remaining_charges, var/mob/user)
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/pod_program = pod.arming_controller
	if(pod_program)
		if(pod_program.emagged)
			to_chat(user, SPAN_WARNING("The pod has already been emagged!"))
			return
		to_chat(user, SPAN_NOTICE("You emag \the [src], arming the escape pod!"))
		pod_program.emagged = TRUE
		if(!pod_program.armed)
			pod_program.arm()
		return 1


//This controller is for the escape pod berth (station side)
/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth
	name = "escape pod berth controller"

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/Initialize()
	. = ..()
	docking_program = new/datum/computer/file/embedded_program/docking/simple/escape_pod(src)
	program = docking_program

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EscapePodBerthConsole", name, ui_x=470, ui_y=200)
		ui.open()

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/ui_data(mob/user)
	var/armed = FALSE
	if (istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		var/datum/computer/file/embedded_program/docking/simple/escape_pod/P = docking_program
		armed = P.armed

	return list(
		"docking_status" = docking_program.get_docking_status(),
		"override_enabled" = docking_program.override_enabled,
		"armed" = armed
	)

/obj/machinery/embedded_controller/radio/simple_docking_controller/escape_pod_berth/emag_act(var/remaining_charges, var/mob/user)
	var/datum/computer/file/embedded_program/docking/simple/escape_pod/pod_program
	if(istype(docking_program, /datum/computer/file/embedded_program/docking/simple/escape_pod))
		pod_program = docking_program
	if(pod_program)
		if(pod_program.emagged)
			to_chat(user, SPAN_WARNING("The pod has already been emagged!"))
			return
		to_chat(user, SPAN_NOTICE("You emag \the [src], arming the escape pod!"))
		pod_program.emagged = TRUE
		if(!pod_program.armed)
			pod_program.arm()
		return 1

//A docking controller program for a simple door based docking port
/datum/computer/file/embedded_program/docking/simple/escape_pod
	var/armed = FALSE
	var/emagged = FALSE
	var/eject_delay = 10	//give latecomers some time to get out of the way if they don't make it onto the pod
	var/eject_time = null
	var/closing = FALSE

/datum/computer/file/embedded_program/docking/simple/escape_pod/proc/arm()
	if(!armed)
		armed = 1
		open_door()


/datum/computer/file/embedded_program/docking/simple/escape_pod/receive_user_command(command)
	if (!armed)
		return
	..(command)

/datum/computer/file/embedded_program/docking/simple/escape_pod/process()
	..()
	if (eject_time && world.time >= eject_time && !closing)
		close_door()
		closing = 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_docking()
	return

/datum/computer/file/embedded_program/docking/simple/escape_pod/ready_for_docking()
	return 1

/datum/computer/file/embedded_program/docking/simple/escape_pod/finish_docking()
	return		//don't do anything - the doors only open when the pod is armed.

/datum/computer/file/embedded_program/docking/simple/escape_pod/prepare_for_undocking()
	eject_time = world.time + eject_delay*10


/* Escape pods */

#define AURORA_ESCAPE_POD(NUMBER) \
/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod##NUMBER { \
	name = "Escape Pod " + #NUMBER; \
	shuttle_area = /area/shuttle/escape_pod/pod##NUMBER; \
	location = 0; \
	dock_target = "escape_pod_" + #NUMBER; \
	arming_controller = "escape_pod_"+ #NUMBER +"_berth"; \
	waypoint_station = "escape_pod_"+ #NUMBER +"_start"; \
	landmark_transition = "escape_pod_"+ #NUMBER +"_interim"; \
	waypoint_offsite = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/start/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_start"; \
	docking_controller = "escape_pod_" + #NUMBER +"_berth"; \
} \
/obj/effect/shuttle_landmark/escape_pod/out/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_out"; \
} \
/obj/effect/shuttle_landmark/escape_pod/transit/pod##NUMBER { \
	landmark_tag = "escape_pod_"+ #NUMBER +"_interim"; \
}

AURORA_ESCAPE_POD(1)
AURORA_ESCAPE_POD(2)
AURORA_ESCAPE_POD(3)
AURORA_ESCAPE_POD(4)

#undef AURORA_ESCAPE_POD

/datum/shuttle/autodock/ferry/specops/ert_aurora
	name = "Phoenix Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/specops
	dock_target = "specops_shuttle_port"
	waypoint_station = "nav_horizon_dock_deck_3_port_5"
	waypoint_offsite = "nav_ert_start"

/datum/shuttle/autodock/multi/legion
	name = "Legion Shuttle"
	current_location = "nav_legion_start"
	warmup_time = 10
	move_time = 75
	ceiling_type = /turf/simulated/shuttle_roof/legion
	shuttle_area = /area/shuttle/legion
	dock_target = "legion_shuttle"
	landmark_transition = "nav_legion_interim"
	destination_tags = list(
		"nav_legion_start",
		"nav_legion_green",
		"nav_legion_merchant",
		"nav_legion_medical"
		)
/obj/effect/shuttle_landmark/legion/start
	name = "BLV The Tower"
	landmark_tag = "nav_legion_start"
	docking_controller = "legion_hangar"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom/legion/hangar5

/obj/effect/shuttle_landmark/legion/interim
	name = "In Transit"
	landmark_tag = "nav_legion_interim"
	base_turf = /turf/space/transit/bluespace/west

/obj/effect/shuttle_landmark/legion/green
	name = "Third Deck Port Dock 1"
	landmark_tag = "nav_legion_green"
	docking_controller = "legion_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/legion/merchant
	name = "Merchant Dock"
	landmark_tag = "nav_legion_merchant"
	docking_controller = "merchant_shuttle_dock"
	special_dock_targets = list("Legion Shuttle" = "legion_shuttle_aft_airlock")
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/legion/medical
	name = "External Airlock by Medical"
	landmark_tag = "nav_legion_medical"
	landmark_flags = SLANDMARK_FLAG_AUTOSET



/datum/shuttle/autodock/multi/distress
	name = "Distress Shuttle"
	current_location = "nav_distress_away"
	warmup_time = 10
	move_time = 45
	dock_target = "distress_shuttle_aft"
	shuttle_area = /area/shuttle/distress
	landmark_transition = "nav_distress_interim"
	destination_tags = list(
		"nav_distress_away",
		"nav_distress_green",
		"nav_distress_blue"
		)

/obj/effect/shuttle_landmark/distress/start
	name = "Distress Preparation Wing"
	landmark_tag = "nav_distress_away"
	docking_controller = "distress_shuttle_origin"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom/distress_prep

/obj/effect/shuttle_landmark/distress/interim
	name = "In Transit"
	landmark_tag = "nav_distress_interim"
	base_turf = /turf/space/transit/bluespace/west

/obj/effect/shuttle_landmark/distress/green
	name = "Emergency Services Dock"
	landmark_tag = "nav_distress_green"
	docking_controller = "green_dock_west"
	special_dock_targets = list("Distress Shuttle" = "distress_shuttle_fore")
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/distress/blue
	name = "First Deck Port Hangar Bay 2b"
	landmark_tag = "nav_distress_blue"
	special_dock_targets = list("Distress Shuttle" = "distress_shuttle_fore")
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_turf = /turf/simulated/floor/plating



/datum/shuttle/autodock/ferry/merchant_aurora
	name = "ICV Enterprise"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/merchant
	move_time = 20
	dock_target = "merchant_shuttle"
	waypoint_station = "nav_merchant_dock"
	landmark_transition = "nav_merchant_interim"
	waypoint_offsite = "nav_merchant_start"

/obj/effect/shuttle_landmark/merchant/start
	name = "Merchant Shuttle Base"
	landmark_tag = "nav_merchant_start"
	docking_controller = "merchant_station"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/obj/effect/shuttle_landmark/merchant/interim
	name = "In Transit"
	landmark_tag = "nav_merchant_interim"
	base_turf = /turf/space/transit/bluespace/west

/obj/effect/shuttle_landmark/merchant/dock
	name = "Second Deck Starboard Dock 1"
	landmark_tag = "nav_merchant_dock"
	docking_controller = "merchant_shuttle_dock"
	base_turf = /turf/space
	base_area = /area/space

/datum/shuttle/autodock/ferry/autoreturn/ccia
	name = "SCC Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/transport1
	dock_target = "centcom_shuttle"
	waypoint_station = "nav_ccia_dock"
	waypoint_offsite = "nav_ccia_start"
	category = /datum/shuttle/autodock/ferry/autoreturn
