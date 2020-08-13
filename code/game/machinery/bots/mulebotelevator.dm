var/static/list/muleelevators = list()

/obj/machinery/mulebotelevator
	name = "Mulebot elevator"
	desc = "An elevator designed to be used particularly by mulebots."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "pad-idle"
	density = FALSE
	anchored = TRUE
	use_power = TRUE
	active_power_usage = 25

/obj/machinery/mulebotelevator/Initialize()
	. = ..()

	var/turf/current_turf = get_turf(src)
	muleelevators[current_turf] = src

/obj/machinery/mulebotelevator/Destroy()
	var/turf/current_turf = get_turf(src)
	muleelevators.Remove(current_turf)
	return ..()

/obj/machinery/mulebotelevator/Move(var/turf/destination)
	var/turf/current_turf = get_turf(src)

	muleelevators.Remove(current_turf)
	muleelevators[destination] = src

	. = ..()

/obj/machinery/mulebotelevator/proc/move_mule(var/obj/machinery/bot/mulebot/M, var/turf/target)
	if (!M)
		return FALSE
	
	if (stat & (BROKEN))
		return FALSE

	var/turf/current = get_turf(src)
	var/turf/target_turf
	
	// We are looking for elevator below
	if (current.z - target.z > 0)
		target_turf = get_turf(locate(current.x, current.y, current.z - 1))
	
	// We are looking for elevator above
	else if (current.z - target.z < 0)
		target_turf = get_turf(locate(current.x, current.y, current.z + 1))

	// This is our stop
	else
		M.forceMove(src.loc)
		return TRUE
	
	var/obj/machinery/mulebotelevator/destn_elevator = locate(/obj/machinery/mulebotelevator) in target_turf.contents

	if (!destn_elevator)
		return FALSE

	M.forceMove(destn_elevator.loc)
	return TRUE
