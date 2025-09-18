/atom/movable
	layer = OBJ_LAYER
	glide_size = 6
	animate_movement = SLIDE_STEPS
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | TILE_BOUND

	var/last_move = null
	/// A list containing arguments for Moved().
	VAR_PRIVATE/tmp/list/active_movement
	var/anchored = FALSE
	var/movable_flags

	///Used to scale icons up or down horizonally in update_transform().
	var/icon_scale_x = 1

	///Used to scale icons up or down vertically in update_transform().
	var/icon_scale_y = 1

	///Used to rotate icons in update_transform()
	var/icon_rotation = 0

	var/move_speed = 10
	var/l_move_time = 1
	var/datum/thrownthing/throwing = null
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

	///Are we moving with inertia? Mostly used as an optimization
	var/inertia_moving = FALSE
	///Delay in deciseconds between inertia based movement
	var/inertia_move_delay = 5

	///0: not doing a diagonal move. 1 and 2: doing the first/second step of the diagonal move
	var/moving_diagonally = 0

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

	/**
	 * In case you have multiple types, you automatically use the most useful one.
	 * IE: Skating on ice, flippers on water, flying over chasm/space, etc.
	 * I recommend you use the movetype_handler system and not modify this directly, especially for living mobs. -- this isn't in our codebase yet, however
	 */
	var/movement_type = GROUND

	var/datum/component/orbiter/orbiting

	/// Either [EMISSIVE_BLOCK_NONE], [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
	var/blocks_emissive = EMISSIVE_BLOCK_NONE
	///Internal holder for emissive blocker object, DO NOT USE DIRECTLY. Use blocks_emissive
	var/mutable_appearance/em_block

	/// Whether this atom should have its dir automatically changed when it moves. Setting this to FALSE allows for things such as directional windows to retain dir on moving without snowflake code all of the place.
	var/set_dir_on_move = TRUE

/atom/movable/Initialize(mapload, ...)
	. = ..()
	update_emissive_blocker()
	if (em_block)
		AddOverlays(em_block)

/atom/movable/Destroy(force)
	if(orbiting)
		stop_orbit()

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

	if(em_block)
		QDEL_NULL(em_block)

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

	RESOLVE_ACTIVE_MOVEMENT

// Make sure you know what you're doing if you call this
// You probably want CanPass()
/atom/movable/Cross(atom/movable/crossed_atom)
	. = TRUE
	SEND_SIGNAL(src, COMSIG_MOVABLE_CROSS, crossed_atom)
	SEND_SIGNAL(crossed_atom, COMSIG_MOVABLE_CROSS_OVER, src)
	// return CanPass(crossed_atom, get_dir(src, crossed_atom))
	return CanPass(crossed_atom, get_step(src, get_dir(src, crossed_atom)), 1, 0)

///default byond proc that is deprecated for us in lieu of signals. do not call
/atom/movable/Crossed(atom/movable/crossed_atom, oldloc)
	SHOULD_NOT_OVERRIDE(TRUE)
	CRASH("atom/movable/Crossed() was called!")

/**
 * `Uncross()` is a default BYOND proc that is called when something is *going*
 * to exit this atom's turf. It is prefered over `Uncrossed` when you want to
 * deny that movement, such as in the case of border objects, objects that allow
 * you to walk through them in any direction except the one they block
 * (think side windows).
 *
 * While being seemingly harmless, most everything doesn't actually want to
 * use this, meaning that we are wasting proc calls for every single atom
 * on a turf, every single time something exits it, when basically nothing
 * cares.
 *
 * This overhead caused real problems on Sybil round #159709, where lag
 * attributed to Uncross was so bad that the entire master controller
 * collapsed and people made Among Us lobbies in OOC.
 *
 * If you want to replicate the old `Uncross()` behavior, the most apt
 * replacement is [`/datum/element/connect_loc`] while hooking onto
 * [`COMSIG_ATOM_EXIT`].
 */
/atom/movable/Uncross()
	SHOULD_NOT_OVERRIDE(TRUE)

	. = TRUE
	CRASH("Uncross() should not be being called, please read the doc-comment for it for why.")

/**
 * default byond proc that is normally called on everything inside the previous turf
 * a movable was in after moving to its current turf
 * this is wasteful since the vast majority of objects do not use Uncrossed
 * use connect_loc to register to COMSIG_ATOM_EXITED instead
 */
/atom/movable/Uncrossed(atom/movable/uncrossed_atom)
	SHOULD_NOT_OVERRIDE(TRUE)
	CRASH("/atom/movable/Uncrossed() was called")

/**
 * Pretend this is `Bump()`
 */
/atom/movable/proc/Collide(atom/bumped_atom)
	SHOULD_NOT_SLEEP(TRUE)

	if(!bumped_atom)
		CRASH("Bump was called with no argument.")
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, bumped_atom)
	// . = ..() when we turn it into Bump()
	if(!QDELETED(throwing))
		throwing.finalize(hit = TRUE, target = bumped_atom)
		. = TRUE
		if(QDELETED(bumped_atom))
			return
	bumped_atom.CollidedWith(src)

	//Aurora snowflake atom airflow hit
	if(airflow_speed > 0 && airflow_dest)
		airflow_hit(bumped_atom)
	else
		airflow_speed = 0
		airflow_time = 0


/atom/movable/proc/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/hitpush = TRUE
	var/impact_signal = SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_IMPACT, hit_atom, throwingdatum)
	if(impact_signal & COMPONENT_MOVABLE_IMPACT_FLIP_HITPUSH)
		hitpush = FALSE // hacky, tie this to something else or a proper workaround later

	if(impact_signal && (impact_signal & COMPONENT_MOVABLE_IMPACT_NEVERMIND))
		return // in case a signal interceptor broke or deleted the thing before we could process our hit
	if(SEND_SIGNAL(hit_atom, COMSIG_ATOM_PREHITBY, src, throwingdatum) & COMSIG_HIT_PREVENTED)
		return
	SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
	return hit_atom.hitby(src, throwingdatum=throwingdatum, hitpush=hitpush)

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
				if(A.density && !A.CanPass(src, target))
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

/atom/movable/proc/throw_at(atom/target, range, speed, mob/thrower, spin = TRUE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_STRONG, gentle = FALSE, quickstart = TRUE)
	. = FALSE

	if(QDELETED(src))
		CRASH("Qdeleted thing being thrown around.")

	if (!target || speed <= 0)
		return

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_THROW, args) & COMPONENT_CANCEL_THROW)
		return

	// if (pulledby)
	// 	pulledby.stop_pulling()

	//They are moving! Wouldn't it be cool if we calculated their momentum and added it to the throw?
	if (thrower && thrower.last_move && thrower.client && thrower.client.move_delay >= world.time + world.tick_lag*2)
		var/user_momentum = thrower.cached_multiplicative_slowdown
		if (!user_momentum) //no movement_delay, this means they move once per byond tick, lets calculate from that instead.
			user_momentum = world.tick_lag

		user_momentum = 1 / user_momentum // convert from ds to the tiles per ds that throw_at uses.

		if (get_dir(thrower, target) & last_move)
			user_momentum = user_momentum //basically a noop, but needed
		else if (get_dir(target, thrower) & last_move)
			user_momentum = -user_momentum //we are moving away from the target, lets slowdown the throw accordingly
		else
			user_momentum = 0


		if (user_momentum)
			//first lets add that momentum to range.
			range *= (user_momentum / speed) + 1
			//then lets add it to speed
			speed += user_momentum
			if (speed <= 0)
				return//no throw speed, the user was moving too fast.

	. = TRUE // No failure conditions past this point.

	var/target_zone
	if(QDELETED(thrower))
		thrower = null //Let's not pass a qdeleting reference if any.
	else
		target_zone = thrower.zone_sel

	var/datum/thrownthing/thrown_thing = new(src, target, get_dir(src, target), range, speed, thrower, diagonals_first, force, gentle, callback, target_zone)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dx = (target.x > src.x) ? EAST : WEST
	var/dy = (target.y > src.y) ? NORTH : SOUTH

	if (dist_x == dist_y)
		thrown_thing.pure_diagonal = 1

	else if(dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx
	thrown_thing.dist_x = dist_x
	thrown_thing.dist_y = dist_y
	thrown_thing.dx = dx
	thrown_thing.dy = dy
	thrown_thing.diagonal_error = dist_x/2 - dist_y
	thrown_thing.start_time = world.time

	// if(pulledby)
	// 	pulledby.stop_pulling()
	if (quickstart && (throwing || SSthrowing.state == SS_RUNNING)) //Avoid stack overflow edgecases.
		quickstart = FALSE
	throwing = thrown_thing
	if(spin)
		SpinAnimation(5, 1)

	SEND_SIGNAL(src, COMSIG_MOVABLE_POST_THROW, thrown_thing, spin)
	SSthrowing.processing[src] = thrown_thing
	if (SSthrowing.state == SS_PAUSED && length(SSthrowing.currentrun))
		SSthrowing.currentrun[src] = thrown_thing
	if (quickstart)
		thrown_thing.tick()

/atom/movable/proc/throw_at_random(var/include_own_turf, var/maxrange, var/speed)
	var/list/turfs = RANGE_TURFS(maxrange, src)
	if(!maxrange)
		maxrange = 1

	if(!include_own_turf)
		turfs -= get_turf(src)
	src.throw_at(pick(turfs), maxrange, speed)

/atom/movable/proc/update_emissive_blocker()
	switch (blocks_emissive)
		if (EMISSIVE_BLOCK_GENERIC)
			em_block = fast_emissive_blocker(src)
		if (EMISSIVE_BLOCK_UNIQUE)
			if (!em_block && !QDELING(src))
				appearance_flags |= KEEP_TOGETHER
				render_target = REF(src)
				em_block = emissive_blocker(
					icon = icon,
					icon_state = icon_state,
					appearance_flags = appearance_flags,
					source = render_target
				)
	return em_block

/atom/movable/update_icon()
	..()
	UPDATE_OO_IF_PRESENT
	if (em_block)
		CutOverlays(em_block)
	update_emissive_blocker()
	if (em_block)
		AddOverlays(em_block)

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

/atom/movable/overlay/attackby(obj/item/attacking_item, mob/user, params)
	if (src.master)
		return src.master.attackby(arglist(args))
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
		INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(overmap_spacetravel), get_turf(src), src)
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
	. = FALSE
	RESOLVE_ACTIVE_MOVEMENT

	if(!destination)
		return FALSE
	if(loc)
		loc.Exited(src, destination)
	var/oldloc = loc

	SET_ACTIVE_MOVEMENT(oldloc, NONE, TRUE, null)

	loc = destination
	loc.Entered(src, oldloc)
	Moved(oldloc, get_dir(oldloc, destination), TRUE)

	//Zmimic
	if(bound_overlay)
		// The overlay will handle cleaning itself up on non-openspace turfs.
		if (isturf(destination))
			bound_overlay.forceMove(get_step(src, UP))
			if (dir != bound_overlay.dir)
				bound_overlay.set_dir(dir)
		else	// Not a turf, so we need to destroy immediately instead of waiting for the destruction timer to proc.
			qdel(bound_overlay)

	if(opacity)
		updateVisibility(src)

	//Lighting recalculation
	var/datum/light_source/L
	var/thing
	for (thing in light_sources)
		L = thing
		L.source_atom.update_light()

	RESOLVE_ACTIVE_MOVEMENT

	return TRUE

/**
 * Called after a successful Move(). By this point, we've already moved.
 * Arguments:
 * * old_loc is the location prior to the move. Can be null to indicate nullspace.
 * * movement_dir is the direction the movement took place. Can be NONE if it was some sort of teleport.
 * * The forced flag indicates whether this was a forced move, which skips many checks of regular movement.
 * * The old_locs is an optional argument, in case the moved movable was present in multiple locations before the movement.
 **/
/atom/movable/proc/Moved(atom/old_loc, movement_dir, forced, list/old_locs)
	SHOULD_CALL_PARENT(TRUE)

	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, forced)

	/* START Spatial grid stuffs */
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
	/* END Spatial grid stuffs */

/atom/movable/Exited(atom/movable/gone, direction)
	. = ..()

	if(LAZYLEN(gone.important_recursive_contents))
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

	GLOB.dir_set_event.unregister(src, gone, TYPE_PROC_REF(/atom, recursive_dir_set))

/atom/movable/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()

	if(LAZYLEN(arrived.important_recursive_contents))
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

	if(GLOB.dir_set_event.has_listeners(arrived))
		GLOB.dir_set_event.register(src, arrived, TYPE_PROC_REF(/atom, recursive_dir_set))

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
	return 8

/atom/movable/proc/can_attach_sticker(var/mob/user, var/obj/item/sticker/S)
	return TRUE

/atom/movable/proc/too_heavy_to_throw()
	return FALSE

/atom/movable/proc/begin_falling(var/lastloc, var/below)
	return

/atom/movable/proc/show_message(msg, type, alt, alt_type) //Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/**
 * Called whenever an object moves and by mobs when they attempt to move themselves through space
 * And when an object or action applies a force on src, see [newtonian_move][/atom/movable/proc/newtonian_move]
 *
 * Return FALSE to have src start/keep drifting in a no-grav area and TRUE to stop/not start drifting
 *
 * Mobs should return 1 if they should be able to move of their own volition, see [/client/proc/Move]
 *
 * Arguments:
 * * movement_dir - 0 when stopping or any dir when trying to move
 * * continuous_move - If this check is coming from something in the context of already drifting
 */
/atom/movable/proc/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	if(has_gravity())
		return TRUE

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_SPACEMOVE, movement_dir, continuous_move) & COMSIG_MOVABLE_STOP_SPACEMOVE)
		return TRUE

	if(pulledby && (pulledby.pulledby != src)) //Different from TG
		return TRUE

	if(throwing)
		return TRUE

	if(!isturf(loc))
		return TRUE

	if(locate(/obj/structure/lattice) in range(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return TRUE

	return FALSE

/// Only moves the object if it's under no gravity
/// Accepts the direction to move, if the push should be instant, and an optional parameter to fine tune the start delay
/atom/movable/proc/newtonian_move(direction, instant = FALSE, start_delay = 0)
	if(!isturf(loc) || Process_Spacemove(direction, continuous_move = TRUE))
		return FALSE

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_NEWTONIAN_MOVE, direction, start_delay) & COMPONENT_MOVABLE_NEWTONIAN_BLOCK)
		return TRUE

	AddComponent(/datum/component/drift, direction, instant, start_delay)

	return TRUE

/**
 * meant for movement with zero side effects. only use for objects that are supposed to move "invisibly" (like camera mobs or ghosts)
 * if you want something to move onto a tile with a beartrap or recycler or tripmine or mouse without that object knowing about it at all, use this
 * most of the time you want forceMove()
 */
/atom/movable/proc/abstract_move(atom/new_loc)
	RESOLVE_ACTIVE_MOVEMENT // This should NEVER happen, but, just in case...
	var/atom/old_loc = loc
	var/direction = get_dir(old_loc, new_loc)
	loc = new_loc

	//is Moved(old_loc, direction, TRUE, momentum_change = FALSE) in tg
	Moved(old_loc, direction, TRUE)

////////////////////////////////////////
// Here's where we rewrite how byond handles movement except slightly different
// To be removed on step_ conversion
// All this work to prevent a second bump
/atom/movable/Move(atom/newloc, direction, glide_size_override = 0, update_dir = TRUE) //Last 2 parameters are not used but they're caught
	CAN_BE_REDEFINED(TRUE)
	. = FALSE
	if(!newloc || newloc == loc)
		return

	// A mid-movement... movement... occurred, resolve that first.
	RESOLVE_ACTIVE_MOVEMENT

	if(!direction)
		direction = get_dir(src, newloc)

	// TEMPORARY OFF because i remember this giving some issues on something i don't quite remember
	if(set_dir_on_move && dir != direction && update_dir)
		set_dir(direction)

	//There should be some multitile code above, it was cut as we don't do multitile movement (yet)
	if(!loc.Exit(src, direction))
		return

	//There should be some multitile code above, it was cut as we don't do multitile movement (yet)
	if(!newloc.Enter(src))
		return
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, newloc) & COMPONENT_MOVABLE_BLOCK_PRE_MOVE)
		return

	var/atom/oldloc = loc
	var/area/oldarea = get_area(oldloc)
	var/area/newarea = get_area(newloc)

	SET_ACTIVE_MOVEMENT(oldloc, direction, FALSE, list()) //This is different from TG because we don't have multitile movement (yet)
	loc = newloc

	. = TRUE

	oldloc.Exited(src, direction)
	if(oldarea != newarea)
		oldarea.Exited(src, direction)

	newloc.Entered(src, oldloc) //This is different from TG because we don't have multitile movement (yet)
	if(oldarea != newarea)
		newarea.Entered(src, oldarea)

	// Lighting.
	if(light_sources)
		var/datum/light_source/L
		var/thing
		for(thing in light_sources)
			L = thing
			L.source_atom.update_light()

	// Openturf.
	if(bound_overlay)
		// The overlay will handle cleaning itself up on non-openspace turfs.
		bound_overlay.forceMove(get_step(src, UP))
		if(bound_overlay.dir != dir)
			bound_overlay.set_dir(dir)

	if(opacity)
		updateVisibility(src)

	//Mimics
	if(bound_overlay)
		bound_overlay.forceMove(get_step(src, UP))
		if(bound_overlay.dir != dir)
			bound_overlay.set_dir(dir)

	src.move_speed = world.time - src.l_move_time
	src.l_move_time = world.time
	if ((oldloc != src.loc && oldloc && oldloc.z == src.z))
		src.last_move = get_dir(oldloc, src.loc)

	RESOLVE_ACTIVE_MOVEMENT

////////////////////////////////////////

/atom/movable/Move(atom/newloc, direct, glide_size_override = 0, update_dir = TRUE)
	CAN_BE_REDEFINED(TRUE)
	// var/atom/movable/pullee = pulling
	// var/turf/current_turf = loc

	if(!loc || !newloc)
		return FALSE

	if(loc != newloc)
		if (!(direct & (direct - 1))) //Cardinal move
			. = ..()
		else //Diagonal move, split it into cardinal moves
			moving_diagonally = FIRST_DIAG_STEP
			var/first_step_dir
			// The `&& moving_diagonally` checks are so that a forceMove taking
			// place due to a Crossed, Bumped, etc. call will interrupt
			// the second half of the diagonal movement, or the second attempt
			// at a first half if step() fails because we hit something.
			if (direct & NORTH)
				if (direct & EAST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
				else if (direct & WEST)
					if (step(src, NORTH) && moving_diagonally)
						first_step_dir = NORTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, NORTH)
			else if (direct & SOUTH)
				if (direct & EAST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, EAST)
					else if (moving_diagonally && step(src, EAST))
						first_step_dir = EAST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
				else if (direct & WEST)
					if (step(src, SOUTH) && moving_diagonally)
						first_step_dir = SOUTH
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, WEST)
					else if (moving_diagonally && step(src, WEST))
						first_step_dir = WEST
						moving_diagonally = SECOND_DIAG_STEP
						. = step(src, SOUTH)
			if(moving_diagonally == SECOND_DIAG_STEP)
				if(!. && set_dir_on_move && update_dir)
					set_dir(first_step_dir)
				else if(!inertia_moving)
					newtonian_move(dir2angle(direct))

			moving_diagonally = 0
			return

	last_move = direct
	if(set_dir_on_move && dir != direct && update_dir)
		set_dir(direct)

/**
 * Adds the red drop-shadow filter when pointed to by a mob.
 * Override if the atom doesn't play nice with filters.
 */
/atom/movable/proc/add_point_filter()
	add_filter("pointglow", 1, list(type = "drop_shadow", x = 0, y = -1, offset = 1, size = 1, color = "#F00"))
	addtimer(CALLBACK(src, PROC_REF(remove_filter), "pointglow"), 2 SECONDS)
