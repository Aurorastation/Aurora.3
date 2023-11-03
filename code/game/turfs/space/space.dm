/turf/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	desc = "The final frontier."
	icon_state = "0"
	dynamic_lighting = 0
	footstep_sound = null //Override to make sure because yeah
	tracks_footprint = FALSE

	plane = PLANE_SPACE_BACKGROUND

	temperature = T20C
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No.
	is_hole = TRUE

	permit_ao = FALSE
	z_eventually_space = TRUE
	turf_flags = TURF_FLAG_BACKGROUND
	var/use_space_appearance = TRUE
	var/use_starlight = TRUE

/turf/space/dynamic //For use in edge cases where you want the turf to not be completely lit, like in places where you have placed lattice.
	dynamic_lighting = 1

// Copypaste of parent for performance.
/turf/space/Initialize()
	SHOULD_CALL_PARENT(FALSE)

	if(use_space_appearance)
		appearance = SSskybox.space_appearance_cache[(((x + y) ^ ~(x * y) + z) % 25) + 1]
	if(config.starlight && use_starlight && lighting_overlays_initialized)
		update_starlight()

	if (initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")

	initialized = TRUE

	for(var/atom/movable/AM as mob|obj in src)
		src.Entered(AM, AM.loc)

	if (isStationLevel(z))
		station_turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	return INITIALIZE_HINT_NORMAL

/turf/space/Destroy()
	// Cleanup cached z_eventually_space values above us.
	if (above)
		var/turf/T = src
		while ((T = GetAbove(T)))
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

/turf/space/proc/update_starlight()
	if(!config.starlight)
		return
	if(locate(/turf/simulated) in RANGE_TURFS(1, src))
		set_light(SSatlas.current_sector.starlight_range, SSatlas.current_sector.starlight_power, l_color = SSskybox.background_color)
	else
		set_light(0)

/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>Constructing support lattice ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			ReplaceWithLattice()
		return

	if (istype(C, /obj/item/stack/tile/floor))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless, keep_air = TRUE)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	..(C, user)

// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	if(movement_disabled)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems)
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
		next_x = (--cur_x||global_map.len)
		y_arr = global_map[next_x]
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
		next_x = (++cur_x > global_map.len ? 1 : cur_x)
		y_arr = global_map[next_x]
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
		y_arr = global_map[cur_x]
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
		y_arr = global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return

/turf/space/ChangeTurf(turf/N, tell_universe=TRUE, force_lighting_update = FALSE, ignore_override = FALSE, mapload = FALSE, keep_air = FALSE)
	return ..()

/turf/space/is_open()
	return TRUE
