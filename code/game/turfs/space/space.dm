/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	desc = "The final frontier."
	icon_state = "0"
	footstep_sound = null //Override to make sure because yeah
	tracks_footprint = FALSE

	plane = SPACE_PLANE

	temperature = T20C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No.
	is_hole = TRUE

	z_eventually_space = TRUE
	turf_flags = TURF_FLAG_BACKGROUND
	explosion_resistance = 3

	var/use_space_appearance = TRUE

/turf/space/dynamic //For use in edge cases where you want the turf to not be completely lit, like in places where you have placed lattice.
	//todomatt: this is useless now

// Copypaste of parent for performance.
/turf/space/Initialize()
	SHOULD_CALL_PARENT(FALSE)

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	if(use_space_appearance)
		appearance = SSskybox.space_appearance_cache[(((x + y) ^ ~(x * y) + z) % 25) + 1]

	if(GLOB.config.starlight)
		update_starlight()

	for(var/atom/movable/AM as mob|obj in src)
		src.Entered(AM, AM.loc)

	// if (is_station_level(z))
	// 	GLOB.station_turfs += src

	return INITIALIZE_HINT_NORMAL

// Handles starlight logic unique to space turfs.
/turf/space/update_starlight()
	. = ..() // We also run the parent proc here, since space may also require starlight from needs_starlight!

	// Our parent proc already handled starlight for us, we don't have to do our own checks
	if(.)
		return

	// Otherwise, if a space turf borders a simulated turf, it should be producing starlight.
	if(locate(/turf/simulated) in RANGE_TURFS(1, src))
		set_light(SSatlas.current_sector.starlight_range, SSatlas.current_sector.starlight_power, l_color = SSskybox.background_color)

// We don't want this doing anything on space, otherwise update_starlight() would run set_light on space turfs twice.
/turf/space/set_default_lighting()
	return

/turf/space/Destroy()
	// Cleanup cached z_eventually_space values above us.
	if (above)
		var/turf/T = src
		while ((T = GET_TURF_ABOVE(T)))
			T.z_eventually_space = FALSE
	return ..()

/turf/space/is_space()
	return 1

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/space/can_have_cabling()
	if (locate(/obj/structure/lattice/catwalk) in src)
		return 1

	return 0

/turf/space/attackby(obj/item/attacking_item, mob/user)

	if (istype(attacking_item, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = attacking_item
		if (R.use(1))
			to_chat(user, SPAN_NOTICE("Constructing support lattice ..."))
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(attacking_item, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = attacking_item
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))

	..()

// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	if(movement_disabled)
		to_chat(usr, SPAN_WARNING("Movement is admin-disabled.")) //This is to identify lag problems)
		return
	..(A, A.loc)
	if ((!(A) || src != A.loc))	return

	inertial_drift(A)

	if(SSticker.mode)

		// Okay, so let's make it so that people can travel z levels but not nuke disks!
		// if(ticker.mode.name == "mercenary")	return
		if (A.x <= TRANSITIONEDGE || A.x >= (world.maxx - TRANSITIONEDGE + 1) || A.y <= TRANSITIONEDGE || A.y >= (world.maxy - TRANSITIONEDGE + 1))
			A.touch_map_edge()

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||GLOB.global_map.len)
		y_arr = GLOB.global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > GLOB.global_map.len ? 1 : cur_x)
		y_arr = GLOB.global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOB.global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOB.global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return

/turf/space/is_open()
	return TRUE

/turf/space/srom_space
	name = "srom space"
	blocks_air = TRUE
	density = TRUE
	use_starlight = FALSE
