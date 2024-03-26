//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/list/shuttle_area //can be both single area type or a list of areas
	var/obj/effect/shuttle_landmark/current_location //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/list/shuttle_computers = list()

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = 0
	var/process_state = IDLE_STATE //Used with SHUTTLE_FLAGS_PROCESS, as well as to store current state.
	var/category = /datum/shuttle
	var/multiz = 0	//how many multiz levels, starts at 0

	var/ceiling_type = /turf/simulated/floor/airless/ceiling

	var/sound_takeoff = 'sound/effects/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttle_landing.ogg'

	var/knockdown = TRUE //whether shuttle downs non-buckled_to people when it moves

	/**
	 * This shuttle will/won't be initialised automatically.
	 * If set to `TRUE`, you are responsible for initialzing the shuttle manually.
	 * Useful for shuttles that are initialed by map_template loading, or shuttles that are created in-game or not used.
	 */
	var/defer_initialisation = FALSE
	var/logging_home_tag   //Whether in-game logs will be generated whenever the shuttle leaves/returns to the landmark with this landmark_tag.
	var/logging_access     //Controls who has write access to log-related stuff; should correlate with pilot access.

	var/mothershuttle //tag of mothershuttle
	var/motherdock    //tag of mothershuttle landmark, defaults to starting location

	var/squishes = TRUE //decides whether or not things get squished when it moves.

/datum/shuttle/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	..()
	if(_name)
		src.name = _name

	var/list/areas = list()
	if(!islist(shuttle_area))
		shuttle_area = list(shuttle_area)
	for(var/T in shuttle_area)
		var/area/A = locate(T)
		if(!istype(A))
			CRASH("Shuttle \"[name]\" couldn't locate area [T].")
		areas += A
	shuttle_area = areas

	if(initial_location)
		current_location = initial_location
	else
		current_location = SSshuttle.get_landmark(current_location)
	if(!istype(current_location))
		CRASH("Shuttle \"[name]\" could not find its starting location.")

	if(src.name in SSshuttle.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	SSshuttle.shuttles[src.name] = src
	for(var/obj/machinery/computer/shuttle_control/SC as anything in SSshuttle.lonely_shuttle_computers)
		if(SC.shuttle_tag == name)
			SSshuttle.lonely_shuttle_computers -= SC
			shuttle_computers += SC
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(SScargo.shuttle)
			CRASH("A supply shuttle is already defined.")
		SScargo.shuttle = src

/datum/shuttle/Destroy()
	current_location = null

	SSshuttle.shuttles -= src.name
	SSshuttle.process_shuttles -= src
	if(SScargo.shuttle == src)
		SScargo.shuttle = null

	. = ..()

/datum/shuttle/proc/short_jump(var/obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE) return

	var/obj/effect/shuttle_landmark/start_location = current_location

	moving_status = SHUTTLE_WARMUP
	callHook("shuttle_moved", list(start_location,destination))
	if(sound_takeoff)
		if(!fuel_check(TRUE)) // Check for fuel, but don't use any.
			return
		playsound(current_location, sound_takeoff, 25, 20)
	spawn(warmup_time*10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/S = src
			if(istype(S))
				S.cancel_launch(null)
			return

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		attempt_move(destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	if(moving_status != SHUTTLE_IDLE)
		return

	var/obj/effect/shuttle_landmark/start_location = current_location

	moving_status = SHUTTLE_WARMUP
	callHook("shuttle_moved", list(start_location, destination))
	if(sound_takeoff)
		if(!fuel_check(TRUE)) // Check for fuel, but don't use any.
			return
		playsound(current_location, sound_takeoff, 50, 20)
	spawn(warmup_time*10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if(!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/S = src
			if(istype(S))
				S.cancel_launch(null)
			return

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		if(attempt_move(interim))
			on_move_interim()
			var/fwooshed = 0
			destination.deploy_landing_indicators(src)
			while (world.time < arrive_time)
				if(!fwooshed && (arrive_time - world.time) < 100)
					fwooshed = 1
					playsound(destination, sound_landing, 50, 20)
				sleep(5)
			if(!attempt_move(destination))
				destination.clear_landing_indicators()
				attempt_move(start_location) //try to go back to where we started. If that fails, I guess we're stuck in the interim location

		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in non-overmap shuttles (they have magic engines)

/*****************
* Shuttle Moved Handling * (Observer Pattern Implementation: Shuttle Moved)
* Shuttle Pre Move Handling * (Observer Pattern Implementation: Shuttle Pre Move)
*****************/

/datum/shuttle/proc/attempt_move(var/obj/effect/shuttle_landmark/destination)
	if(current_location == destination)
		return FALSE

	if(!destination.is_valid(src))
		return FALSE
	if(current_location.cannot_depart(src))
		return FALSE
	testing("[src] moving to [destination]. Areas are [english_list(shuttle_area)]")
	var/list/translation = list()
	for(var/area/A in shuttle_area)
		testing("Moving [A]")
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), A.contents)
	var/old_location = current_location
	GLOB.shuttle_pre_move_event.raise_event(src, old_location, destination)
	shuttle_moved(destination, translation)
	GLOB.shuttle_moved_event.raise_event(src, old_location, destination)
	destination.shuttle_arrived(src)
	return TRUE

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. shuttle_moved() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump(), long_jump() or attempt_move()
/datum/shuttle/proc/shuttle_moved(var/obj/effect/shuttle_landmark/destination, var/list/turf_translation)

	if((flags & SHUTTLE_FLAGS_ZERO_G))
		var/new_grav = 1
		if(destination.landmark_flags & SLANDMARK_FLAG_ZERO_G)
			var/area/new_area = get_area(destination)
			new_grav = new_area.has_gravity
		for(var/area/our_area in shuttle_area)
			if(our_area.has_gravity != new_grav)
				our_area.gravitychange(new_grav)

	for(var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation[src_turf]
		if(squishes && src_turf.is_solid_structure()) //in case someone put a hole in the shuttle and you were lucky enough to be under it
			for(var/atom/movable/AM in dst_turf)
				if(AM.movable_flags & MOVABLE_FLAG_DEL_SHUTTLE)
					qdel(AM)
					continue
				if(!AM.simulated)
					continue
				if(isliving(AM))
					var/mob/living/bug = AM
					bug.gib()
				else
					qdel(AM) //it just gets atomized I guess? TODO throw it into space somewhere, prevents people from using shuttles as an atom-smasher
	var/list/powernets = list()
	for(var/area/A in shuttle_area)
		// if there was a zlevel above our origin, erase our ceiling now we're leaving
		if(HasAbove(current_location.z))
			for(var/turf/TO in A.contents)
				var/turf/TA = GetAbove(TO)
				if(istype(TA, ceiling_type))
					TA.ChangeTurf(get_base_turf_by_area(TA), 1, 1)
		if(knockdown)
			for(var/mob/living/carbon/M in A)
				spawn(0)
					if(M.buckled_to)
						to_chat(M, "<span class='warning'>Sudden acceleration presses you into your chair!</span>")
						shake_camera(M, 3, 1)
					else if(M.Check_Shoegrip(FALSE))
						to_chat(M, SPAN_WARNING("You feel immense pressure in your feet as you cling to the floor!"))
						M.apply_damage(10, DAMAGE_PAIN, BP_L_FOOT)
						M.apply_damage(10, DAMAGE_PAIN, BP_R_FOOT)
						shake_camera(M, 5, 1)
					else
						to_chat(M, "<span class='warning'>The floor lurches beneath you!</span>")
						shake_camera(M, 10, 1)
						M.visible_message("<span class='warning'>[M.name] is tossed around by the sudden acceleration!</span>")
						M.throw_at_random(FALSE, 4, 1)
						M.Weaken(3)

		for(var/obj/structure/cable/C in A)
			powernets |= C.powernet

	translate_turfs(turf_translation, current_location.base_area, current_location.base_turf, TRUE)
	current_location = destination

	// if there's a zlevel above our destination, paint in a ceiling on it so we retain our air
	if(HasAbove(current_location.z))
		for(var/area/A in shuttle_area)
			for(var/turf/TD in A.contents)
				TD.update_above()
				TD.update_icon()
				var/turf/TA = GetAbove(TD)
				if(istype(TA, get_base_turf_by_area(TA)) || (istype(TA) && TA.is_open()))
					if(get_area(TA) in shuttle_area)
						continue
					TA.ChangeTurf(ceiling_type, TRUE, TRUE, TRUE)

	for(var/area/sub_area in shuttle_area)
		for(var/obj/structure/shuttle_part/part in sub_area)
			var/turf/target_turf = get_turf(part)
			if(part.outside_part)
				target_turf.ChangeTurf(destination.base_turf)
		for(var/obj/structure/window/shuttle/unique/SW in sub_area)
			if(SW.outside_window)
				var/turf/target_turf = get_turf(SW)
				target_turf.ChangeTurf(destination.base_turf)
		for(var/obj/effect/energy_field/ef in sub_area)
			qdel(ef)

	// Remove all powernets that were affected, and rebuild them.
	var/list/cables = list()
	for(var/datum/powernet/P in powernets)
		cables |= P.cables
		qdel(P)
	for(var/obj/structure/cable/C in cables)
		if(!C.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(C)
			propagate_network(C,C.powernet)

	if(mothershuttle)
		var/datum/shuttle/mothership = SSshuttle.shuttles[mothershuttle]
		if(mothership)
			if(current_location.landmark_tag == motherdock)
				mothership.shuttle_area |= shuttle_area
			else
				mothership.shuttle_area -= shuttle_area

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/find_children()
	. = list()
	for(var/shuttle_name in SSshuttle.shuttles)
		var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_name]
		if(shuttle.mothershuttle == name)
			. += shuttle

//Returns those areas that are not actually child shuttles.
/datum/shuttle/proc/find_childfree_areas()
	. = shuttle_area.Copy()
	for(var/datum/shuttle/child in find_children())
		. -= child.shuttle_area

/datum/shuttle/autodock/proc/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return current_location.name

/datum/shuttle/autodock/proc/get_destination_name()
	if(!next_location)
		return "None"
	return next_location.name

/datum/shuttle/proc/set_process_state(var/new_state)
	process_state = new_state
	for(var/obj/machinery/computer/shuttle_control/SC as anything in shuttle_computers)
		SC.update_helmets(src)

/datum/shuttle/proc/on_move_interim()
	return
