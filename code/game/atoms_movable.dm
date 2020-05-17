/atom/movable
	layer = 3
	var/last_move = null
	var/anchored = 0
	var/movable_flags

	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
	var/item_state = null // Base name of the image used for when the item is in someone's hand. Suffixes are added to this. Doubles as legacy overlay_state.
	var/overlay_state = null // Base name of the image used for when the item is worn. Suffixes are added to this. Important for icon flipping as _flip is added at the end of the value.
	//Also used on holdable mobs for the same info related to their held version
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)

	var/can_hold_mob = FALSE
	var/list/contained_mobs

// We don't really need this, and apparently defining it slows down GC.
/*/atom/movable/Del()
	if(!QDELING(src) && loc)
		testing("GC: -- [type] was deleted via del() rather than qdel() --")
		crash_with("GC: -- [type] was deleted via del() rather than qdel() --") // stick a stack trace in the runtime logs
	..()*/

/atom/movable/Destroy()
	. = ..()
	for(var/atom/movable/AM in contents)
		qdel(AM)
	loc = null
	screen_loc = null
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

// This is called when this atom is prevented from moving by atom/A.
/atom/movable/proc/Collide(atom/A)
	if(airflow_speed > 0 && airflow_dest)
		airflow_hit(A)
	else
		airflow_speed = 0
		airflow_time = 0

	if (throwing)
		throwing = FALSE
		. = TRUE
		if (!QDELETED(A))
			throw_impact(A)
			A.CollidedWith(src)

	else if (!QDELETED(A))
		A.CollidedWith(src)

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		throwing = 0
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(src.last_move, 180))
			if(isliving(src))
				var/mob/living/M = src
				M.turf_collision(T, speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(throwing)
		for(var/atom/A in get_turf(src))
			if(A == src)
				continue
			if(isliving(A))
				var/mob/living/M = A
				if(M.lying)
					continue
				throw_impact(A, speed)
			if(isobj(A))
				if(A.density && !A.throwpass)	// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
					src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower, var/do_throw_animation = TRUE)
	if(!target || !src)	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	src.throwing = 1
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf

	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!

	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = get_area(src.loc)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH
	var/error
	var/major_dir
	var/major_dist
	var/minor_dir
	var/minor_dist
	if(dist_x > dist_y)
		error = dist_x/2 - dist_y
		major_dir = dx
		major_dist = dist_x
		minor_dir = dy
		minor_dist = dist_y
	else
		error = dist_y/2 - dist_x
		major_dir = dy
		major_dist = dist_y
		minor_dir = dx
		minor_dist = dist_x

	while(src && target && src.throwing && istype(src.loc, /turf) \
		  && ((abs(target.x - src.x)+abs(target.y - src.y) > 0 && dist_travelled < range) \
		  	   || (a && a.has_gravity == 0) \
			   || istype(src.loc, /turf/space)))
		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
		var/atom/step
		if(error >= 0)
			step = get_step(src, major_dir)
			error -= minor_dist
		else
			step = get_step(src, minor_dir)
			error += major_dist
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break
		src.Move(step)
		hit_check(speed)
		dist_travelled++
		dist_since_sleep++
		if(dist_since_sleep >= speed)
			dist_since_sleep = 0
			sleep(1)
		a = get_area(src.loc)
		// and yet it moves
		if(do_throw_animation)
			if(src.does_spin)
				src.SpinAnimation(speed = 4, loops = 1)

	//done throwing, either because it hit something or it finished moving
	if(isobj(src)) src.throw_impact(get_turf(src),speed)
	src.throwing = 0
	src.thrower = null
	src.throw_source = null

	if (isturf(loc))
		var/turf/Tloc = loc
		Tloc.Entered(src)

/atom/movable/proc/throw_at_random(var/include_own_turf, var/maxrange, var/speed)
	var/list/turfs = RANGE_TURFS(maxrange, src)
	if(!maxrange)
		maxrange = 1

	if(!include_own_turf)
		turfs -= get_turf(src)
	src.throw_at(pick(turfs), maxrange, speed)

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	verbs.Cut()
	..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(z in current_map.sealed_levels)
		return

	var/move_to_z = src.get_transit_zlevel()
	if(move_to_z)
		z = move_to_z

		if(x <= TRANSITIONEDGE)
			x = world.maxx - TRANSITIONEDGE - 2
			y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			x = TRANSITIONEDGE + 1
			y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			y = world.maxy - TRANSITIONEDGE -2
			x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			y = TRANSITIONEDGE + 1
			x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		if(istype(SSticker.mode, /datum/game_mode/nuclear)) //only really care if the game mode is nuclear
			var/datum/game_mode/nuclear/G = SSticker.mode
			G.check_nuke_disks()

		spawn(0)
			if(loc) loc.Entered(src)

//by default, transition randomly to another zlevel
/atom/movable/proc/get_transit_zlevel()
	return current_map.get_transit_zlevel()

// Parallax stuff.

/atom/movable/proc/update_client_hook(atom/destination)
	. = isturf(destination)
	if (.)
		for (var/thing in contained_mobs)
			var/mob/M = thing
			if (!M.client || !M.hud_used)
				continue

			if (get_turf(M.client.eye) == destination)
				M.hud_used.update_parallax_values()

/mob/update_client_hook(atom/destination)
	. = ..()
	if (. && hud_used && client && get_turf(client.eye) == destination)
		hud_used.update_parallax_values()

// Core movement hooks & procs.
/atom/movable/proc/forceMove(atom/destination)
	if(destination)
		if(loc)
			loc.Exited(src)
		loc = destination
		loc.Entered(src)
		if (contained_mobs)
			update_client_hook(loc)
		return 1
	if (contained_mobs)
		update_client_hook(loc)
	return 0

/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	if (.)
		// Events.
		if (moved_event.listeners_assoc[src])
			moved_event.raise_event(src, old_loc, loc)

		// Parallax.
		if (contained_mobs)
			update_client_hook(loc)

		// Lighting.
		if (light_sources)
			var/datum/light_source/L
			var/thing
			for (thing in light_sources)
				L = thing
				L.source_atom.update_light()

		// Openturf.
		if (bound_overlay)
			// The overlay will handle cleaning itself up on non-openspace turfs.
			bound_overlay.forceMove(get_step(src, UP))
			if (bound_overlay.dir != dir)
				bound_overlay.set_dir(dir)

/atom/movable/proc/do_simple_ranged_interaction(var/mob/user)
	return FALSE

/atom/movable/proc/get_bullet_impact_effect_type()
	return BULLET_IMPACT_NONE
