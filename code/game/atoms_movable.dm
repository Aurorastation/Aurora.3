/atom/movable
	layer = OBJ_LAYER
	glide_size = 6
	animate_movement = SLIDE_STEPS

	var/last_move = null
	var/anchored = 0
	var/movable_flags

	///Used to scale icons up or down horizonally in update_transform().
	var/icon_scale_x = 1

	///Used to scale icons up or down vertically in update_transform().
	var/icon_scale_y = 1

	///Used to rotate icons in update_transform()
	var/icon_rotation = 0

	var/move_speed = 10
	var/l_move_time = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/atom/movable/pulledby = null

	///Base name of the image used for when the item is in someone's hand. Suffixes are added to this. Doubles as legacy overlay_state.
	var/item_state = null

	///Base name of the image used for when the item is worn. Suffixes are added to this. Important for icon flipping as _flip is added at the end of the value.
	var/overlay_state = null

	///Also used on holdable mobs for the same info related to their held version
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)

	var/can_hold_mob = FALSE
	var/list/contained_mobs
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | TILE_BOUND

	///Holds information about any movement loops currently running/waiting to run on the movable. Lazy, will be null if nothing's going on
	var/datum/movement_packet/move_packet

	/**
	 * an associative lazylist of relevant nested contents by "channel", the list is of the form: list(channel = list(important nested contents of that type))
	 * each channel has a specific purpose and is meant to replace potentially expensive nested contents iteration
	 * do NOT add channels to this for little reason as it can add considerable memory usage.
	 */
	var/list/important_recursive_contents

	/// String representing the spatial grid groups we want to be held in.
	/// acts as a key to the list of spatial grid contents types we exist in via SSspatial_grid.spatial_grid_categories.
	/// We do it like this to prevent people trying to mutate them and to save memory on holding the lists ourselves
	var/spatial_grid_key

/atom/movable/Destroy()
	GLOB.moved_event.unregister_all_movement(loc, src)

	//Recalculate opacity
	var/turf/T = loc
	if(opacity && istype(T))
		T.recalc_atom_opacity()
		T.reconsider_lights()

	if(move_packet)
		if(!QDELETED(move_packet))
			qdel(move_packet)
		move_packet = null

	if(spatial_grid_key)
		SSspatial_grid.force_remove_from_grid(src)

	QDEL_LAZYLIST(contained_mobs)

	. = ..()

	for(var/movable_content in contents)
		qdel(movable_content)

	//Pretend this is moveToNullspace()
	moveToNullspace()
	loc = null

	//This absolutely must be after moveToNullspace()
	//We rely on Entered and Exited to manage this list, and the copy of this list that is on any /atom/movable "Containers"
	//If we clear this before the nullspace move, a ref to this object will be hung in any of its movable containers
	LAZYNULL(important_recursive_contents)


	vis_locs = null //clears this atom out of all viscontents

	// Checking length(vis_contents) before cutting has significant speed benefits
	if (length(vis_contents))
		vis_contents.Cut()

	screen_loc = null
	if(ismob(pulledby))
		var/mob/M = pulledby
		if(M.pulling == src)
			M.pulling = null
		pulledby = null

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

/atom/movable/proc/moveToNullspace()
	. = TRUE

	var/atom/oldloc = loc

	if (oldloc)
		loc = null
		var/area/old_area = get_area(oldloc)
		if(isturf(oldloc)) //This checked if it's a multitile, which i have no clue what would be here, so just check for turf
			for(var/atom/old_loc as anything in locs)
				old_loc.Exited(src, NONE)
		else
			oldloc.Exited(src, NONE)

		if(old_area)
			old_area.Exited(src, NONE)

	Moved(oldloc, TRUE)

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
/atom/movable/proc/hit_check(var/speed, var/target)
	if(throwing)
		for(var/atom/A in get_turf(src))
			if(A == src)
				continue
			if(isliving(A))
				var/mob/living/M = A
				if(M.lying && M != target)
					continue
				throw_impact(A, speed)
			if(isobj(A))
				if(A.density && !A.throwpass && !A.CanPass(src, target))
					src.throw_impact(A,speed)

// Prevents robots dropping their modules
/atom/movable/proc/dropsafety()
	if(!istype(src.loc))
		return TRUE

	if (issilicon(src.loc))
		return FALSE

	if (istype(src.loc, /obj/item/rig_module))
		return FALSE

	return TRUE

/atom/movable/proc/throw_at(atom/target, range, speed, thrower, var/do_throw_animation = TRUE)
	if(!target || !src)	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	src.throwing = 1
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf

	if(usr && (usr.mutations & HULK))
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
		hit_check(speed, target)
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
	if(isturf(loc) && isobj(src))
		throw_impact(loc, speed)
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

/atom/movable/overlay/Destroy(force)
	master = null
	. = ..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(z in SSatlas.current_map.sealed_levels)
		return

	if(anchored)
		return

	if(!GLOB.universe.OnTouchMapEdge(src))
		return

	if(SSatlas.current_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
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
			if(loc)
				var/turf/T = loc
				loc.Entered(src)
				if(!T.is_hole)
					fall_impact(text2num(pickweight(list("1" = 60, "2" = 30, "3" = 10))))

//by default, transition randomly to another zlevel
/atom/movable/proc/get_transit_zlevel()
	return SSatlas.current_map.get_transit_zlevel()

// Returns the current scaling of the sprite.
// Note this DOES NOT measure the height or width of the icon, but returns what number is being multiplied with to scale the icons, if any.
/atom/movable/proc/get_icon_scale_x()
	return icon_scale_x

/atom/movable/proc/get_icon_scale_y()
	return icon_scale_y

/atom/movable/proc/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Turn(icon_rotation)
	src.transform = M

// Use this to set the object's scale.
/atom/movable/proc/adjust_scale(new_scale_x, new_scale_y)
	if(isnull(new_scale_y))
		new_scale_y = new_scale_x
	if(new_scale_x != 0)
		icon_scale_x = new_scale_x
	if(new_scale_y != 0)
		icon_scale_y = new_scale_y
	update_transform()

/atom/movable/proc/adjust_rotation(new_rotation)
	icon_rotation = new_rotation
	update_transform()

// Core movement hooks & procs.
/atom/movable/proc/forceMove(atom/destination)
	if(!destination)
		return FALSE
	if(loc)
		loc.Exited(src, destination)
	var/old_loc = loc
	loc = destination
	loc.Entered(src, old_loc)
	Moved(old_loc, TRUE)
	return TRUE

/atom/movable/proc/Moved(atom/old_loc, forced)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, forced)

	update_grid_location(old_loc, src)

/atom/movable/proc/update_grid_location(atom/old_loc)
	if(!HAS_SPATIAL_GRID_CONTENTS(src) || !SSspatial_grid.initialized)
		return

	var/turf/old_turf = get_turf(old_loc)
	var/turf/new_turf = get_turf(src)

	if(old_turf && new_turf && (old_turf.z != new_turf.z \
		|| ROUND_UP(old_turf.x / SPATIAL_GRID_CELLSIZE) != ROUND_UP(new_turf.x / SPATIAL_GRID_CELLSIZE) \
		|| ROUND_UP(old_turf.y / SPATIAL_GRID_CELLSIZE) != ROUND_UP(new_turf.y / SPATIAL_GRID_CELLSIZE)))

		SSspatial_grid.exit_cell(src, old_turf)
		SSspatial_grid.enter_cell(src, new_turf)

	else if(old_turf && !new_turf)
		SSspatial_grid.exit_cell(src, old_turf)

	else if(new_turf && !old_turf)
		SSspatial_grid.enter_cell(src, new_turf)

/atom/movable/Exited(atom/movable/gone, direction)
	. = ..()

	if(!LAZYLEN(gone.important_recursive_contents))
		return
	var/list/nested_locs = get_nested_locs(src) + src
	for(var/channel in gone.important_recursive_contents)
		for(var/atom/movable/location as anything in nested_locs)
			LAZYINITLIST(location.important_recursive_contents)
			var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
			LAZYINITLIST(recursive_contents[channel])
			recursive_contents[channel] -= gone.important_recursive_contents[channel]
			switch(channel)
				if(RECURSIVE_CONTENTS_CLIENT_MOBS, RECURSIVE_CONTENTS_HEARING_SENSITIVE)
					if(!length(recursive_contents[channel]))
						// This relies on a nice property of the linked recursive and gridmap types
						// They're defined in relation to each other, so they have the same value
						SSspatial_grid.remove_grid_awareness(location, channel)
			ASSOC_UNSETEMPTY(recursive_contents, channel)
			UNSETEMPTY(location.important_recursive_contents)

	if(LAZYLEN(gone.stored_chat_text))
		return_floating_text(gone)

/atom/movable/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()

	if(!LAZYLEN(arrived.important_recursive_contents))
		return
	var/list/nested_locs = get_nested_locs(src) + src
	for(var/channel in arrived.important_recursive_contents)
		for(var/atom/movable/location as anything in nested_locs)
			LAZYINITLIST(location.important_recursive_contents)
			var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
			LAZYINITLIST(recursive_contents[channel])
			switch(channel)
				if(RECURSIVE_CONTENTS_CLIENT_MOBS, RECURSIVE_CONTENTS_HEARING_SENSITIVE)
					if(!length(recursive_contents[channel]))
						SSspatial_grid.add_grid_awareness(location, channel)
			recursive_contents[channel] |= arrived.important_recursive_contents[channel]

	if (LAZYLEN(arrived.stored_chat_text))
		give_floating_text(arrived)

///allows this movable to hear and adds itself to the important_recursive_contents list of itself and every movable loc its in
/atom/movable/proc/become_hearing_sensitive(trait_source = TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEARING_SENSITIVE, trait_source)
	if(!HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE))
		return

	for(var/atom/movable/location as anything in get_nested_locs(src) + src)
		LAZYINITLIST(location.important_recursive_contents)
		var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
		if(!length(recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE]))
			SSspatial_grid.add_grid_awareness(location, SPATIAL_GRID_CONTENTS_TYPE_HEARING)
		recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE] += list(src)

	var/turf/our_turf = get_turf(src)
	SSspatial_grid.add_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_HEARING)

/**
 * removes the hearing sensitivity channel from the important_recursive_contents list of this and all nested locs containing us if there are no more sources of the trait left
 * since RECURSIVE_CONTENTS_HEARING_SENSITIVE is also a spatial grid content type, removes us from the spatial grid if the trait is removed
 *
 * * trait_source - trait source define or ALL, if ALL, force removes hearing sensitivity. if a trait source define, removes hearing sensitivity only if the trait is removed
 */
/atom/movable/proc/lose_hearing_sensitivity(trait_source = TRAIT_GENERIC)
	if(!HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE))
		return
	REMOVE_TRAIT(src, TRAIT_HEARING_SENSITIVE, trait_source)
	if(HAS_TRAIT(src, TRAIT_HEARING_SENSITIVE))
		return

	var/turf/our_turf = get_turf(src)
	/// We get our awareness updated by the important recursive contents stuff, here we remove our membership
	SSspatial_grid.remove_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_HEARING)

	for(var/atom/movable/location as anything in get_nested_locs(src) + src)
		var/list/recursive_contents = location.important_recursive_contents // blue hedgehog velocity
		recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE] -= src
		if(!length(recursive_contents[RECURSIVE_CONTENTS_HEARING_SENSITIVE]))
			SSspatial_grid.remove_grid_awareness(location, SPATIAL_GRID_CONTENTS_TYPE_HEARING)
		ASSOC_UNSETEMPTY(recursive_contents, RECURSIVE_CONTENTS_HEARING_SENSITIVE)
		UNSETEMPTY(location.important_recursive_contents)

///allows this movable to know when it has "entered" another area no matter how many movable atoms its stuffed into, uses important_recursive_contents
/atom/movable/proc/become_area_sensitive(trait_source = TRAIT_GENERIC)
	if(!HAS_TRAIT(src, TRAIT_AREA_SENSITIVE))
		for(var/atom/movable/location as anything in get_nested_locs(src) + src)
			LAZYADDASSOCLIST(location.important_recursive_contents, RECURSIVE_CONTENTS_AREA_SENSITIVE, src)
	ADD_TRAIT(src, TRAIT_AREA_SENSITIVE, trait_source)

///removes the area sensitive channel from the important_recursive_contents list of this and all nested locs containing us if there are no more source of the trait left
/atom/movable/proc/lose_area_sensitivity(trait_source = TRAIT_GENERIC)
	if(!HAS_TRAIT(src, TRAIT_AREA_SENSITIVE))
		return
	REMOVE_TRAIT(src, TRAIT_AREA_SENSITIVE, trait_source)
	if(HAS_TRAIT(src, TRAIT_AREA_SENSITIVE))
		return

	for(var/atom/movable/location as anything in get_nested_locs(src) + src)
		LAZYREMOVEASSOC(location.important_recursive_contents, RECURSIVE_CONTENTS_AREA_SENSITIVE, src)

///propogates ourselves through our nested contents, similar to other important_recursive_contents procs
///main difference is that client contents need to possibly duplicate recursive contents for the clients mob AND its eye
/mob/proc/enable_client_mobs_in_contents()
	for(var/atom/movable/movable_loc as anything in get_nested_locs(src) + src)
		LAZYINITLIST(movable_loc.important_recursive_contents)
		var/list/recursive_contents = movable_loc.important_recursive_contents // blue hedgehog velocity
		if(!length(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS]))
			SSspatial_grid.add_grid_awareness(movable_loc, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
		LAZYINITLIST(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS])
		recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] |= src

	var/turf/our_turf = get_turf(src)
	/// We got our awareness updated by the important recursive contents stuff, now we add our membership
	SSspatial_grid.add_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)

///Clears the clients channel of this mob
/mob/proc/clear_important_client_contents()
	var/turf/our_turf = get_turf(src)
	SSspatial_grid.remove_grid_membership(src, our_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)

	for(var/atom/movable/movable_loc as anything in get_nested_locs(src) + src)
		LAZYINITLIST(movable_loc.important_recursive_contents)
		var/list/recursive_contents = movable_loc.important_recursive_contents // blue hedgehog velocity
		LAZYINITLIST(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS])
		recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS] -= src
		if(!length(recursive_contents[RECURSIVE_CONTENTS_CLIENT_MOBS]))
			SSspatial_grid.remove_grid_awareness(movable_loc, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)
		ASSOC_UNSETEMPTY(recursive_contents, RECURSIVE_CONTENTS_CLIENT_MOBS)
		UNSETEMPTY(movable_loc.important_recursive_contents)

// This proc adds atom/movables to the AI targetable list, i.e. things that the AI (turrets, hostile animals) will attempt to target
/atom/movable/proc/add_to_target_grid()
	for (var/atom/movable/location as anything in get_nested_locs(src) + src)
		LAZYADDASSOCLIST(location.important_recursive_contents, RECURSIVE_CONTENTS_AI_TARGETS, src)

	var/turf/our_turf = get_turf(src)
	if(our_turf && SSspatial_grid.initialized)
		SSspatial_grid.add_grid_awareness(src, RECURSIVE_CONTENTS_AI_TARGETS)
		SSspatial_grid.add_grid_membership(src, our_turf, RECURSIVE_CONTENTS_AI_TARGETS)

	else if(our_turf && !SSspatial_grid.initialized)//SSspatial_grid isnt init'd yet, add ourselves to the queue
		SSspatial_grid.enter_pre_init_queue(src, RECURSIVE_CONTENTS_AI_TARGETS)

/atom/movable/proc/clear_from_target_grid()
	var/turf/our_turf = get_turf(src)
	if(our_turf && SSspatial_grid.initialized)
		SSspatial_grid.exit_cell(src, our_turf, RECURSIVE_CONTENTS_AI_TARGETS)
	else if(our_turf && !SSspatial_grid.initialized)
		SSspatial_grid.remove_from_pre_init_queue(src, RECURSIVE_CONTENTS_AI_TARGETS)

	for(var/atom/movable/location as anything in get_nested_locs(src) + src)
		LAZYREMOVEASSOC(location.important_recursive_contents, RECURSIVE_CONTENTS_AI_TARGETS, src)

/atom/movable/proc/do_simple_ranged_interaction(var/mob/user)
	return FALSE

/atom/movable/proc/get_bullet_impact_effect_type()
	return BULLET_IMPACT_NONE

// /atom/movable/proc/do_pickup_animation(atom/target, var/image/pickup_animation = image(icon, loc, icon_state, ABOVE_ALL_MOB_LAYER, dir, pixel_x, pixel_y))
/obj/item/proc/do_pickup_animation(atom/target, turf/source)
	if(!source)
		if(!istype(loc, /turf))
			return
		source = loc
	var/image/pickup_animation = image(icon = src)
	pickup_animation.transform.Scale(0.75)
	pickup_animation.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	var/direction = get_dir(source, target)
	var/to_x = target.pixel_x
	var/to_y = target.pixel_y

	if(direction & NORTH)
		to_y += 32
	else if(direction & SOUTH)
		to_y -= 32
	if(direction & EAST)
		to_x += 32
	else if(direction & WEST)
		to_x -= 32
	if(!direction)
		to_y += 10
		pickup_animation.pixel_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	var/atom/movable/flick_visual/pickup = source.flick_overlay_view(pickup_animation, 0.4 SECONDS)
	var/matrix/animation_matrix = new(pickup.transform)
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.65)

	animate(pickup, alpha = 175, pixel_x = to_x, pixel_y = to_y, time = 0.3 SECONDS, transform = animation_matrix, easing = CUBIC_EASING)
	animate(alpha = 0, transform = matrix().Scale(0.7), time = 0.1 SECONDS)

/atom/movable/proc/do_drop_animation(atom/moving_from)
	if(!isturf(loc))
		return
	var/turf/current_turf = get_turf(src)
	var/direction = get_dir(moving_from, current_turf)
	var/from_x = 0
	var/from_y = 0

	if(direction & NORTH)
		from_y -= 32
	else if(direction & SOUTH)
		from_y += 32
	if(direction & EAST)
		from_x -= 32
	else if(direction & WEST)
		from_x += 32
	if(!direction)
		from_y += 10
		from_x += 6 * (prob(50) ? 1 : -1) //6 to the right or left, helps break up the straight upward move

	//We're moving from these chords to our current ones
	var/old_x = pixel_x
	var/old_y = pixel_y
	var/old_alpha = alpha
	var/matrix/old_transform = transform
	var/matrix/animation_matrix = new(old_transform)
	animation_matrix.Turn(pick(-30, 30))
	animation_matrix.Scale(0.7) // Shrink to start, end up normal sized

	pixel_x = from_x
	pixel_y = from_y
	alpha = 0
	transform = animation_matrix

	// This is instant on byond's end, but to our clients this looks like a quick drop
	animate(src, alpha = old_alpha, pixel_x = old_x, pixel_y = old_y, transform = old_transform, time = 3, easing = CUBIC_EASING)

/atom/movable/proc/get_floating_chat_x_offset()
	return 0

/atom/movable/proc/get_floating_chat_y_offset()
	return 0

/atom/movable/proc/can_attach_sticker(var/mob/user, var/obj/item/sticker/S)
	return TRUE

/atom/movable/proc/too_heavy_to_throw()
	return FALSE

/atom/movable/proc/begin_falling(var/lastloc, var/below)
	return

/atom/movable/proc/show_message(msg, type, alt, alt_type) //Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return
