//Used to create small industrial-esque lifts used between two floors
/datum/shuttle/autodock/ferry/lift
	warmup_time = 3
	knockdown = FALSE
	squishes = FALSE
	ceiling_type = null
	sound_takeoff = 'sound/effects/lift_heavy_start.ogg'
	sound_landing = 'sound/effects/lift_heavy_stop.ogg'
	category = /datum/shuttle/autodock/ferry/lift
	var/obj/machinery/computer/shuttle_control/assigned_controller

/datum/shuttle/autodock/ferry/lift/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	..()
	for(var/obj/machinery/computer/shuttle_control/lift/controller in shuttle_area[1])
		assigned_controller = controller
		break

/datum/shuttle/autodock/ferry/lift/Destroy()
	assigned_controller = null
	..()

/datum/shuttle/autodock/ferry/lift/short_jump(var/obj/effect/shuttle_landmark/destination)
	var/obj/effect/shuttle_landmark/start_location = current_location
	if(!obstruction_check(start_location, destination))
		if(assigned_controller)
			assigned_controller.audible_message("\The [assigned_controller] buzzes loudly: <i>Obstruction detected!</i>")
			playsound(assigned_controller.loc, "sound/machines/buzz-two.ogg", 50, 1)
		return FALSE
	..()

/datum/shuttle/autodock/ferry/lift/proc/obstruction_check(var/obj/effect/shuttle_landmark/start, var/obj/effect/shuttle_landmark/destination)
	var/list/translation = list()
	for(var/area/A in shuttle_area)
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)

	for(var/turf/src_turf in translation)
		var/turf/dst_turf = translation[src_turf]

		if(dst_turf.density)
			return FALSE
		if(!location)
			if(!istype(dst_turf, /turf/simulated/open))
				return FALSE
		else
			for(var/atom/A in dst_turf)
				if(A.density)
					return FALSE
				if(istype(A, /mob/living))
					var/mob/living/blockage = A
					if(blockage.mob_size > MOB_SMALL)
						return FALSE
	if(location)
		squishes = TRUE
	else
		squishes = FALSE

	return TRUE

/obj/machinery/computer/shuttle_control/lift
	name = "lift controller"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon = 'icons/obj/computer.dmi'
	icon_state = "lift"
	icon_screen = null
	density = FALSE

/obj/machinery/computer/shuttle_control/lift/wall
	icon_state = "lift_wall"
