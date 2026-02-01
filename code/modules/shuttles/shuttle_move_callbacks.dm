/turf/proc/shuttle_move_from(turf/new_turf, move_mode)
	if(!(move_mode & MOVE_AREA) || !is_shuttle_turf(src))
		return move_mode

	return move_mode | MOVE_TURF | MOVE_CONTENTS

/turf/proc/shuttle_move_to(turf/old_turf, move_mode, datum/shuttle/shuttle)
	. = move_mode
	if(!(. & MOVE_TURF))
		return

	if(shuttle.landing_type == LAND_NOTHING || old_turf.is_open())
		return

	for(var/atom/movable/thing as anything in contents)
		if(thing.movable_flags & MOVABLE_FLAG_DEL_SHUTTLE)
			qdel(thing)
			continue
		if(!thing.simulated)
			continue
		if(isliving(thing))
			var/mob/living/living_thing = thing
			if(living_thing.incorporeal_move)
				continue
			if(shuttle.landing_type == LAND_CRUSH)
				living_thing.gib()
			else if(shuttle.landing_type == LAND_FALL)
				living_thing.visible_message(
							SPAN_WARNING("[living_thing] falls down the cargo elevator hatch!"),
							SPAN_WARNING("You fall down the cargo elevator hatch!")
						)
				shake_camera(living_thing, 10, 1)
				living_thing.fall_impact(1)
				living_thing.apply_damage(20, DAMAGE_PAIN)
		else if(!ismob(thing) && shuttle.landing_type == LAND_CRUSH)
			if(!thing.anchored)
				step(thing, shuttle.overmap_shuttle.dir)
			else
				qdel(thing)

/turf/proc/on_shuttle_move(turf/new_turf, list/movement_force, move_dir, ignore_area_change = FALSE)
	if(new_turf == src) // in-place rotation
		return

	var/shuttle_depth = depth_to_find_baseturf(/turf/baseturf_skipover/shuttle)
	if(!shuttle_depth)
		CRASH("A turf queued to move via shuttle somehow had no skipover in baseturfs. [src] ([type]): [loc]")

	new_turf.copy_on_top(src, 1, shuttle_depth, TRUE, ignore_area_change ? CHANGETURF_NO_AREA_CHANGE : NONE)

	SEND_SIGNAL(src, COMSIG_TURF_ON_SHUTTLE_MOVE, new_turf)

	return TRUE

/turf/proc/after_shuttle_move(turf/old_turf, rotation)
	old_turf.TransferComponents(src)

	var/shuttle_depth = depth_to_find_baseturf(/turf/baseturf_skipover/shuttle)

	if(shuttle_depth)
		old_turf.scrape_away(shuttle_depth)

	if(rotation)
		shuttle_rotate(rotation)

	SEND_SIGNAL(src, COMSIG_TURF_AFTER_SHUTTLE_MOVE, old_turf)

	return TRUE

/turf/proc/late_shuttle_move(turf/old_turf)
	return

/atom/movable/proc/hypothetical_shuttle_move(rotation, move_mode, datum/shuttle/shuttle)
	return move_mode

/atom/movable/proc/before_shuttle_move(turf/new_turf, rotation, move_mode, datum/shuttle/shuttle)
	SHOULD_CALL_PARENT(TRUE)
	return SEND_SIGNAL(src, COMSIG_ATOM_BEFORE_SHUTTLE_MOVE, new_turf, rotation, move_mode, shuttle) || move_mode

/atom/movable/proc/on_shuttle_move(turf/new_turf, turf/old_turf, list/movement_force, move_dir, obj/effect/shuttle_landmark/old_dock, datum/shuttle/shuttle)
	if(new_turf == old_turf || loc != old_turf)
		return

	forceMove(new_turf)

	return TRUE

/atom/movable/proc/after_shuttle_move(turf/old_turf, list/movement_force, shuttle_dir, shuttle_preferred_dir, move_dir, rotation)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_AFTER_SHUTTLE_MOVE, old_turf)
	if(light)
		update_light()
	if(rotation)
		shuttle_rotate(rotation)

	return TRUE

/atom/movable/proc/late_shuttle_move(turf/old_turf, list/movement_force, move_dir)
	if(!movement_force || anchored)
		return
	var/throw_force = movement_force["THROW"]
	if(!throw_force)
		return
	var/turf/target = get_edge_target_turf(src, move_dir)
	var/range = throw_force * 10
	range = CEILING(rand(range - (range * 0.1), range+(range*0.1)), 10) / 10
	var/speed = range / 5
	throw_at(target, range, speed, force = MOVE_FORCE_EXTREMELY_STRONG)

/area/proc/before_shuttle_move(list/shuttle_areas)
	if(!shuttle_areas[src])
		return NONE
	return MOVE_AREA

/area/proc/on_shuttle_move(turf/old_turf, turf/new_turf, datum/shuttle/shuttle, area/fallback_area)
	if(old_turf == new_turf)
		return

	var/area/underlying_area = shuttle.underlying_areas_by_turf[old_turf]
	old_turf.change_area(src, underlying_area || fallback_area)
	shuttle.underlying_areas_by_turf -= old_turf

	var/area/old_dest_area = new_turf.loc
	new_turf.change_area(old_dest_area, src)
	shuttle.underlying_areas_by_turf[new_turf] = old_dest_area
	return TRUE

/area/proc/after_shuttle_move()
	return TRUE

/area/proc/late_shuttle_move()
	return

/obj/on_shuttle_move(turf/new_turf, turf/old_turf, list/movement_force, move_dir, obj/effect/shuttle_landmark/old_dock, datum/shuttle/shuttle)
	var/is_background = (old_turf.turf_flags & TURF_FLAG_BACKGROUND) // this might break turbolifts WILDTODO
	var/supported = (obj_flags & OBJ_FLAG_MOVES_UNSUPPORTED)
	if(simulated && (!is_background || supported))
		return ..()

/obj/effect/energy_field/on_shuttle_move(turf/new_turf, turf/old_turf, list/movement_force, move_dir, obj/effect/shuttle_landmark/old_dock, datum/shuttle/shuttle)
	qdel(src)
	return

// wildtodo i dont think we need this anymore but maybe we do lol
	// for(var/area/sub_area in shuttle_area)
	// 	for(var/turf/T as anything in sub_area.get_turfs_from_all_zlevels())
	// 		for(var/obj/structure/shuttle_part/part in T)
	// 			var/turf/target_turf = get_turf(part)
	// 			if(part.outside_part)
	// 				target_turf.ChangeTurf(destination.base_turf)
	// 		for(var/obj/structure/window/shuttle/unique/SW in T)
	// 			if(SW.outside_window)
	// 				var/turf/target_turf = get_turf(SW)
	// 				target_turf.ChangeTurf(destination.base_turf)

/obj/structure/cable/on_shuttle_move(turf/new_turf, turf/old_turf, list/movement_force, move_dir, obj/effect/shuttle_landmark/old_dock, datum/shuttle/shuttle)
	. = ..()
	if(. && powernet)
		if(!QDELETED(powernet))
			qdel(powernet)
		powernet = null

/obj/structure/cable/late_shuttle_move(turf/old_turf, list/movement_force, move_dir)
	. = ..()
	if(. && !powernet)
		powernet = new
		powernet.cables |= src
		propagate_network(src, powernet)

/obj/effect/on_shuttle_move(turf/new_turf, turf/old_turf, list/movement_force, move_dir, obj/effect/shuttle_landmark/old_dock, datum/shuttle/shuttle)
	if(movable_flags & MOVABLE_FLAG_EFFECTMOVE)
		forceMove(new_turf)
		return TRUE

/mob/on_shuttle_move(turf/new_turf, turf/old_turf, list/movement_force, move_dir, obj/effect/shuttle_landmark/old_dock, datum/shuttle/shuttle)
	return ..()

/mob/abstract/eye/on_shuttle_move(turf/new_turf, turf/old_turf, list/movement_force, move_dir, obj/effect/shuttle_landmark/old_dock, datum/shuttle/shuttle)
	return

/mob/late_shuttle_move(turf/old_turf, list/movement_force, move_dir)
	if(client && movement_force)
		var/shake_force = max(movement_force["THROW"], movement_force["KNOCKDOWN"])
		if(buckled_to)
			to_chat(src, SPAN_WARNING("Sudden acceleration presses you into your chair!"))
			shake_force *= 0.25
		else if(Check_Shoegrip(FALSE))
			to_chat(src, SPAN_WARNING("You feel immense pressure in your feet as you cling to the floor!"))
			shake_force *= 0.5
			if(isliving(src))
				var/mob/living/living_src = src
				living_src.apply_damage(10, DAMAGE_PAIN, BP_L_FOOT)
				living_src.apply_damage(10, DAMAGE_PAIN, BP_R_FOOT)
		else
			to_chat(src, SPAN_WARNING("The floor lurches beneath you!"))
			visible_message(SPAN_WARNING("[src.name] is tossed around by the sudden acceleration!"))
			..() // chuck 'em
			Weaken(3)
		shake_camera(src, shake_force, 1)
