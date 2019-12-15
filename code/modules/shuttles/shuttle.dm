#define DO_BOOT 1
#define DO_BUCKLE 2

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

	var/area/area_current
	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/sound_takeoff = "ship_takeoff"
	var/sound_landing = "ship_landing"
	var/sound_crash = "ship_crash"
	// Vars for crashing
	var/transit_direction = null	//needed for area/move_contents_to() to properly handle shuttle corners - not exactly sure how it works.
	var/engines_count = 0 //Used to determine if shuttle should crash
	var/engines_checked = FALSE
	var/area_crash
	var/list/crash_offset = list(-10, 10)
	var/ship_size = 0
	var/walls_count = 0
	var/list/exterior_walls_and_engines = list()
	var/list/center = list()
	var/length = 0
	var/width = 0

/datum/shuttle/proc/init_shuttle()
	return

/datum/shuttle/proc/scan_shuttle()
	//Calculating size and integrity
	var/min_x = INFINITY
	var/min_y = INFINITY
	var/max_x = -1
	var/max_y = -1
	for(var/A in area_current.contents)
		if(isturf(A))
			var/turf/T = A
			min_x = min(T.x, min_x)
			min_y = min(T.y, min_y)
			max_x = max(T.x, max_x)
			max_y = max(T.y, max_y)
			ship_size += 1
			if(istype(T, /turf/simulated/shuttle) && exterior_wall(T))
				exterior_walls_and_engines += list(list(T.x, T.y, T.z))
				if(integrity_check(T))
					walls_count += 1
		else if(istype(A, /obj/structure/shuttle/engine/propulsion))
			engines_count += 1
			var/obj/structure/shuttle/engine/propulsion/P = A
			var/turf/simulated/shuttle/e_turf = get_turf(P)
			e_turf.name = "engine mount"
			e_turf.destructible = FALSE
			e_turf.dir = P.dir
			e_turf.update_icon()
			e_turf.add_overlay("engine_mount")
		else if(istype(A, /obj/machinery/door/airlock/external))
			var/turf/T = get_turf(A)
			exterior_walls_and_engines += list(list(T.x, T.y, T.z))

	center = list((max_x + min_x) / 2, (max_y + min_y) / 2)
	length = max_x - min_x
	width = max_y - min_y

/datum/shuttle/proc/exterior_wall(var/turf/simulated/shuttle/T)
	for(var/v in list(NORTH, SOUTH, EAST, WEST))
		var/turf/n_T = get_step(T, v)
		if(!n_T)
			continue
		if(!istype(n_T, /turf/simulated/shuttle))
			return TRUE
	return FALSE

/datum/shuttle/proc/integrity_check(var/V)
	if(!isturf(V))
		return FALSE
	var/turf/T = V
	return istype(T, /turf/simulated/wall) || istype(T, /turf/simulated/shuttle/wall) || istype(T, /turf/unsimulated/wall)

/datum/shuttle/proc/announce(var/message)
	var/area/A = area_current
	if(!A)
		return
	for(var/mob/living/L in A.contents)
		to_chat(L, message)

/datum/shuttle/proc/play_sound_shuttle(var/sound_name, var/area/A, volume = 100)
	var/turf/T = get_turf(locate(center[1], center[2], A.z))
	for(var/mob/M in range("[length + 5]x[width+5]", T))
		M << sound("sound/effects/ship/[sound_name].ogg", volume = volume)

/datum/shuttle/proc/init_docking_controllers()
	if(docking_controller_tag)
		docking_controller = locate(docking_controller_tag)
		if(!istype(docking_controller))
			to_world("<span class='danger'>warning: shuttle with docking tag [docking_controller_tag] could not find it's controller!</span>")

/datum/shuttle/proc/short_jump(var/area/origin, var/area/destination)
	if(moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP
	play_sound_shuttle(sound_takeoff, origin, 35)
	launching(max(50, warmup_time * 10))
	sleep(max(30, warmup_time * 10))
	if (moving_status == SHUTTLE_IDLE)
		return	//someone cancelled the launch

	callHook("shuttle_moved", list(origin,destination))

	moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
	play_sound_shuttle(sound_landing, origin, 25)
	play_sound_shuttle(sound_landing, destination, 20)
	sleep(10)
	move(origin, destination)
	launching(50)
	moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	if(moving_status != SHUTTLE_IDLE) return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	play_sound_shuttle(sound_takeoff, departing, 35)
	launching(max(70, warmup_time * 10))
	sleep(max(70, warmup_time*10))
	if (moving_status == SHUTTLE_IDLE)
		return	//someone cancelled the launch

	callHook("shuttle_moved", list(departing,destination))

	arrive_time = world.time + travel_time*10
	moving_status = SHUTTLE_INTRANSIT
	move(departing, interim)

	while (world.time < arrive_time)
		launching(5, /obj/effect/engine_exhaust/pulse)
		sleep(5)

	play_sound_shuttle(sound_landing, interim, 25)
	play_sound_shuttle(sound_landing, destination, 25)
	launching(15)
	sleep(10)
	move(interim, destination)
	launching(50)
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

	var/list/bugs_to_squish = list()
	for(var/v in dstturfs)
		var/turf/T = v
		var/turf/D =  get_turf(locate(T.x, throwy - 1, 1))
		for(var/atom/movable/AM as mob|obj in T)
			if(isliving(AM))
				var/mob/living/L = AM
				bugs_to_squish += L
			AM.Move(D)
		if(istype(T, /turf/unsimulated))
			T.ChangeTurf(/turf/space)

	for(var/v in bugs_to_squish)
		var/mob/living/bug = v
		bug.gib()

	move_shuttle_contents_to(origin, destination)

	var/range = rand(1, 4)
	var/speed = rand(1, 4)
	for(var/mob/M in destination)
		var/effect = FALSE

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.shoes, /obj/item/clothing/shoes/magboots))
				var/obj/item/clothing/shoes/magboots/boots = H.shoes
				if(boots.magpulse)
					effect = DO_BOOT
		if(!effect)
			if(M.buckled)
				effect = DO_BUCKLE

		if(effect == DO_BOOT)
			magboot_effect(M)
		else if(effect == DO_BUCKLE)
			buckled_effect(M)
		else // If they have neither of the former, then it'll always be loose (at the time of writing this, oh god)
			loose_effect(M)

	area_current = destination

/datum/shuttle/proc/move_shuttle_contents_to(area/A, area/B)
	var/list/source_turfs = A.build_ordered_turf_list()
	var/list/target_turfs = B.build_ordered_turf_list()

	message_admins(source_turfs.len)
	ASSERT(source_turfs.len == target_turfs.len)

	var/min_x = INFINITY
	var/min_y = INFINITY
	var/max_x = -1
	var/max_y = -1
	for (var/i = 1 to source_turfs.len)
		var/turf/ST = source_turfs[i]
		if (!ST)	// Excluded turfs are null to keep the list ordered.
			continue
		var/list/old_coord = list(ST.x, ST.y, ST.z)

		if(istype(ST, /turf/unsimulated))
			ST.ChangeTurf(/turf/space)

		var/turf/TT = ST.copy_turf(target_turfs[i])
		if(!TT)
			TT = target_turfs[i]
		
		for(var/thing in ST)
			var/atom/movable/AM = thing
			AM.shuttle_move(TT)

		ST.ChangeTurf(ST.baseturf)
		
		if(!TT)
			continue

		var/found = FALSE
		var/index = 0
		for(var/v in exterior_walls_and_engines)
			var/list/l = v
			index += 1

			if(old_coord[1] != l[1])
				continue
			if(old_coord[2] != l[2])
				continue
			if(old_coord[3] != l[3])
				continue

			found = TRUE
			break

		if(found)
			exterior_walls_and_engines[index] = list(TT.x, TT.y, TT.z)
		min_x = min(TT.x, min_x)
		min_y = min(TT.y, min_y)
		max_x = max(TT.x, max_x)
		max_y = max(TT.y, max_y)

		TT.update_icon()
		TT.update_above()

	center = list((max_x + min_x) / 2, (max_y + min_y) / 2)

/datum/shuttle/proc/magboot_effect(mob/M)
	to_chat(M, span("warning","You manage to maintain your footing with the magboots!"))
	shake_camera(M, 5, 1)

/datum/shuttle/proc/buckled_effect(mob/M)
	to_chat(M, span("warning","Sudden acceleration presses you into your chair!"))
	shake_camera(M, 3, 1)

/datum/shuttle/proc/loose_effect(mob/M)
	to_chat(M, span("warning","You lose your footing as the floor lurches beneath you!"))
	shake_camera(M, 10, 1)
	M.throw_at(get_step(get_turf(locate(M.loc.x + rand(-3, 3), M.loc.y + rand(-3, 3), M.loc.z)), get_turf(M)), range, speed, M)

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/check_engines()
	var/engines_c = 0
	var/walls_c = 0
	// counting engines
	for(var/v in exterior_walls_and_engines)
		var/list/l = v
		var/turf/S = get_turf(locate(l[1], l[2], l[3]))
		if(!S)
			return
		for(var/a in S.contents)
			if(istype(a, /obj/structure/shuttle/engine/propulsion))
				var/obj/structure/shuttle/engine/propulsion/P = a
				if(P.dir == S.dir)
					engines_c += 1
		if(integrity_check(S))
			walls_c += 1
	
	var/ratio = round((1 - (engines_c / engines_count)) * 100)
	var/integrity = round((walls_c / walls_count) * 100)
	var/crash_chance = ratio + round((100 - integrity) * 0.25)
	if(crash_chance && !engines_checked)
		var/message = ""
		if(ratio == 100)
			announce(span("danger", "Flight computer states: \"Warning: shuttle's propulsion system is entirely destroyed! Unable to launch!\""))
			return FALSE

		if(area_current.z == 1 || area_current.z == 2)
			return TRUE
		else
			var/grav = SSmachinery.gravity_generators.len ? pick(SSmachinery.gravity_generators).charge_count : FALSE
			if(!grav)
				return TRUE

		engines_checked = TRUE
		message += span("danger", "Flight computer states: \"Warning: shuttle's propulsion system is damaged! There is a [crash_chance]% chance of crash!\nEngines integrity: [100-ratio]%, Shuttle integrity: [integrity]%\nDetails:\n [engines_c] out of [engines_count] engines, [walls_c] out of [walls_count] walls.\"\n")
		message += span("notice", "Flight computer states: \"Disabling artificial gravity will allow for safe escape!\"\n") 
		message += span("notice", "Flight computer states: \"Press Launch again within 5 seconds to continue!\"")
		announce(message)
		addtimer(CALLBACK(src, .proc/reset_engines_check), 5 SECONDS)
		return FALSE
	else if(crash_chance)
		if(ratio == 100)
			announce(span("danger", "Flight computer states: \"Warning: shuttle's propulsion system is entirely destroyed! Unable to launch!\""))
			return FALSE
		if(crash_chance > 10 && prob(crash_chance))
			undock()
			engines_checked = FALSE
			sleep(20)
			moving_status = SHUTTLE_INTRANSIT
			crash_shuttle()
			moving_status = SHUTTLE_IDLE
			return FALSE
		else
			engines_checked = FALSE
			return TRUE
	else
		engines_checked = FALSE
		return TRUE

/datum/shuttle/proc/crash_shuttle()
	var/area/A = area_current
	announce(span("danger", "Flight computer states: \"Warning: Not enough propulsion to gain velocity! Loosing altitude!\""))
	var/distance_x = pick(crash_offset[1], crash_offset[2])
	var/distance_y = pick(crash_offset[1], crash_offset[2])

	if(transit_direction == NORTH || transit_direction == SOUTH)
		distance_y = distance_y < 0 ? distance_y - width + 1 : distance_y + width + 1
	else
		distance_x = distance_x < 0 ? distance_x - length + 1 : distance_x + length + 1

	var/area/crash = new area_crash
	for(var/turf/T in A.contents)
		var/turf/T_n = get_turf(locate(T.x + distance_x, T.y + distance_y, T.z))

		// Making sure we remove everything on crash side
		for(var/a in T_n.contents)
			if(!ismob(a))
				qdel(a)
			CHECK_TICK
		if(T_n)
			crash.contents += T_n
		CHECK_TICK

	play_sound_shuttle(sound_crash, crash, 45)
	sleep(70) // Has to be 4 seconds less than how long is crash sound. Change if the sound is changed.
	for(var/mob/living/L in A.contents)
		shake_camera(L, 10, 1)
		if(!L.buckled)
			L.ex_act(2)
		else
			L.throw_at(get_step(get_turf(locate(L.loc.x + rand(-3, 3), L.loc.y + rand(-3, 3), L.loc.z)), get_turf(L)), 5, 5, L)
			L.ex_act(3)

	move(area_current, crash)
	var/num = round(ship_size * 0.15)
	while(num > 0)
		explosion(pick(crash.contents), 1, 0, 1, 1, 0) // explosion inside of the shuttle, as in we damaged it
		num -= 1
	area_current = crash

/datum/shuttle/proc/reset_engines_check()
	engines_checked = FALSE

/datum/shuttle/proc/launching(var/time, var/obj/effect/engine_exhaust/E = /obj/effect/engine_exhaust/blue)
	for(var/list/v in exterior_walls_and_engines)
		var/turf/S = get_turf(locate(v[1], v[2], v[3]))
		if(!S)
			return
		for(var/a in S.contents)
			if(istype(a, /obj/structure/shuttle/engine/propulsion))
				var/obj/structure/shuttle/engine/propulsion/P = a
				new E(get_step(P, P.dir), P.dir, 250, time)

/datum/shuttle/proc/custom_landing(var/mob/living/user)
	if(!user)
		return
	
	var/mob/abstract/observer/shuttle/O = new (pick(the_station_areas))
	O.client = user.client
	O.client.view = sqrt(ship_size)
	O.sight &= ~(SEE_MOBS|SEE_OBJS)
	O.S = src
	O.mainbody = WEAKREF(user)

#undef DO_BOOT
#undef DO_BUCKLE
