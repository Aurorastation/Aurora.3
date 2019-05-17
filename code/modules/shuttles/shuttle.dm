//These lists are populated in /datum/shuttle_controller/New()
//Shuttle controller is instantiated in master_controller.dm.

//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE
	var/lift = 0 //To make zlevel stuff work right
	var/lift_lowest_zlevel = 1 //At least 1 unless you always want open floor

	var/docking_controller_tag	//tag of the controller used to coordinate docking
	var/datum/computer/file/embedded_program/docking/docking_controller	//the controller itself. (micro-controller, not game controller)

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/engines_count = 0 //Used to determine if shuttle should crash
	var/engines_checked = FALSE

/datum/shuttle/Initialize()
	..()

	// counting engines
	for(var/obj/structure/shuttle/engine/propulsion/P in area_station.contents)
		engines_count += 1

/datum/shuttle/proc/init_docking_controllers()
	if(docking_controller_tag)
		docking_controller = locate(docking_controller_tag)
		if(!istype(docking_controller))
			to_world("<span class='danger'>warning: shuttle with docking tag [docking_controller_tag] could not find it's controller!</span>")

/datum/shuttle/proc/short_jump(var/area/origin,var/area/destination)
	if(moving_status != SHUTTLE_IDLE) return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		move(origin, destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	if(moving_status != SHUTTLE_IDLE) return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		move(departing, interim, direction)


		while (world.time < arrive_time)
			sleep(5)

		move(interim, destination, direction)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/dock()
	if (!docking_controller)
		return

	var/dock_target = current_dock_target()
	if (!dock_target)
		return

	docking_controller.initiate_docking(dock_target)

/datum/shuttle/proc/undock()
	if (!docking_controller)
		return
	docking_controller.initiate_undocking()

/datum/shuttle/proc/current_dock_target()
	return null

/datum/shuttle/proc/check_engines()
	var/engine_c = 0
	// counting engines
	for(var/obj/structure/shuttle/engine/propulsion/P in area_station.contents)
		engines_c += 1
	
	var/ratio = (1 - (engine_c / engines_count)) * 100
	if(ratio != 1 && !engines_checked)
		engines_checked = TRUE
		for(var/mob/living/L in area_station.contents)
			to_chat(L, span("danger", "Warning: shuttle propulsion system is damaged! There is a [ratio]% chance of crash!"))
	else if(ration != 1)
		process_state = CRASH_SHUTTLE
		to_chat(L, span("danger", "Warning: Not enough propulsion to gain velocity! Loosing altitude!"))
		undock()
		return
	else
		engines_checked = FALSE

/datum/shuttle/proc/skip_docking_checks()
	if (!docking_controller || !current_dock_target())
		return 1	//shuttles without docking controllers or at locations without docking ports act like old-style shuttles
	return 0

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. move() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump() or long_jump()
/datum/shuttle/proc/move(var/area/origin, var/area/destination)
	if(origin == destination)
		return

	if (docking_controller && !docking_controller.undocked())
		docking_controller.force_undock()

	var/list/dstturfs = list()
	var/throwy = world.maxy

	for(var/turf/T in destination)
		dstturfs += T
		if(T.y < throwy)
			throwy = T.y

	for(var/turf/T in dstturfs)
		var/turf/D = locate(T.x, throwy - 1, 1)
		for(var/atom/movable/AM as mob|obj in T)
			AM.Move(D)
		if(istype(T, /turf/simulated))
			T.ChangeTurf(/turf/space)

	for(var/mob/living/carbon/bug in destination)
		bug.gib()

	for(var/mob/living/simple_animal/pest in destination)
		pest.gib()

	origin.move_contents_to(destination)

	for(var/mob/M in destination)
		if(M.client)
			spawn(0)
				if(M.buckled)
					to_chat(M, "<span class='warning'>Sudden acceleration presses you into your chair!</span>")
					shake_camera(M, 3, 1)
				else
					to_chat(M, "<span class='warning'>The floor lurches beneath you!</span>")
					shake_camera(M, 10, 1)
		if(istype(M, /mob/living/carbon))
			if(!M.buckled)
				M.Weaken(3)

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)
