/proc/count_drones()
	var/drones = 0
	for(var/mob/living/silicon/robot/drone/D in silicon_mob_list)
		if(D.key && D.client)
			drones++
	return drones

/obj/machinery/drone_fabricator
	name = "drone fabricator"
	desc = "A large automated factory for producing maintenance drones."

	icon = 'icons/obj/machines/drone_fab.dmi'
	icon_state = "drone_fab_idle"

	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 20
	active_power_usage = 5000

	var/fabricator_tag = "Aurora"
	var/drone_progress = 0
	var/produce_drones = 1
	var/time_last_drone = 500
	var/drone_type = /mob/living/silicon/robot/drone

/obj/machinery/drone_fabricator/derelict
	name = "construction drone fabricator"
	fabricator_tag = "Derelict"
	drone_type = /mob/living/silicon/robot/drone/construction

/obj/machinery/drone_fabricator/power_change()
	..()
	if(stat & NOPOWER)
		icon_state = "drone_fab_nopower"

/obj/machinery/drone_fabricator/machinery_process()
	if(!ROUND_IS_STARTED)
		return

	if(stat & NOPOWER || !produce_drones)
		if(icon_state != "drone_fab_nopower")
			icon_state = "drone_fab_nopower"
		return

	if(drone_progress >= 100)
		icon_state = "drone_fab_idle"
		return

	icon_state = "drone_fab_active"
	var/elapsed = world.time - time_last_drone
	drone_progress = round((elapsed/config.drone_build_time) * 100)

	if(drone_progress >= 100)
		visible_message(SPAN_NOTICE("\The [src] voices a strident beep, indicating a drone chassis is prepared."))

/obj/machinery/drone_fabricator/examine(mob/user)
	..(user)
	if(produce_drones && drone_progress >= 100 && istype(user,/mob/abstract) && config.allow_drone_spawn && count_drones() < config.max_maint_drones)
		to_chat(user, SPAN_NOTICE("<B>A drone is prepared. use 'Ghost Roles' from the Ghost tab to spawn as a maintenance drone.</B>"))

/obj/machinery/drone_fabricator/proc/create_drone(var/client/player)
	if(stat & NOPOWER)
		return
	if(!produce_drones || !config.allow_drone_spawn || count_drones() >= config.max_maint_drones)
		return
	if(!player || !istype(player.mob, /mob/abstract))
		return

	announce_ghost_joinleave(player, 0, "They have taken control over a maintenance drone.")
	visible_message(SPAN_NOTICE("\The [src] churns and grinds as it lurches into motion, disgorging a shiny new drone after a few moments."))
	flick("h_lathe_leave", src)

	time_last_drone = world.time
	if(player.mob?.mind)
		player.mob.mind.reset()

	var/mob/living/silicon/robot/drone/new_drone = new drone_type(get_turf(src))
	new_drone.transfer_personality(player)
	new_drone.master_fabricator = src

	drone_progress = 0

	return new_drone