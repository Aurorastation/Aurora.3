//Used to create small industrial-esque lifts used between two floors
/datum/shuttle/ferry/lift
	warmup_time = 3 SECONDS
	movement_force = list(
		"KNOCKDOWN" = 0,
		"THROW" = 0,
	)
	landing_type = LAND_NOTHING
	ceiling_baseturf = null
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	category = /datum/shuttle/ferry/lift
	var/obj/machinery/computer/shuttle_control/assigned_controller

/datum/shuttle/ferry/lift/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	..()
	for(var/turf/T as anything in shuttle_area[1].get_turfs_from_all_zlevels())
		for(var/obj/machinery/computer/shuttle_control/lift/controller in T)
			assigned_controller = controller
			break

/datum/shuttle/ferry/lift/Destroy()
	assigned_controller = null
	..()

/datum/shuttle/ferry/lift/spoolup(obj/effect/shuttle_landmark/destination)
	if(check_landing_zone(destination) != DOCKING_SUCCESS)
		if(assigned_controller)
			assigned_controller.audible_message("\The [assigned_controller] buzzes loudly: <i>Obstruction detected!</i>")
			playsound(assigned_controller.loc, 'sound/machines/buzz-two.ogg', 50, 1)
		return FALSE
	..()

/datum/shuttle/ferry/lift/check_landing_turf(turf/T, list/overlappers)
	. = ..()
	if(. == DOCKING_SUCCESS)
		for(var/mob/blockage in T)
			if(blockage.mob_size > MOB_SMALL)
				return DOCKING_BLOCKED

/datum/shuttle/ferry/lift/process_arrived()
	. = ..()
	landing_type = location ? LAND_CRUSH : LAND_NOTHING

/obj/machinery/computer/shuttle_control/lift
	name = "lift controller"
	ui_template = "ShuttleControlConsoleLift"
	icon = 'icons/obj/computer.dmi'
	icon_state = "lift"
	icon_screen = null
	density = FALSE

/obj/machinery/computer/shuttle_control/lift/wall
	icon_state = "lift_wall"
