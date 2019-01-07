/turf
	icon = 'icons/turf/floors.dmi'
	level = 1
	var/holy = 0

	// Initial air contents (in moles)
	var/oxygen = 0
	var/carbon_dioxide = 0
	var/nitrogen = 0
	var/phoron = 0

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old = null
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/footstep_sound = "defaultstep"

	var/list/decals

	var/is_hole		// If true, turf will be treated as space or a hole
	var/tmp/turf/baseturf

	var/roof_type = null // The turf type we spawn as a roof.
	var/tmp/roof_flags = 0

	var/movement_cost = 0 // How much the turf slows down movement, if any.

// Parent code is duplicated in here instead of ..() for performance reasons.
// There's ALSO a copy of this in mine_turfs.dm!
/turf/Initialize(mapload, ...)
	if (initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")

	initialized = TRUE

	for(var/atom/movable/AM as mob|obj in src)
		Entered(AM)

	turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if (smooth)
		queue_smooth(src)

	if (light_range && light_power)
		update_light()

	if (opacity)
		has_opaque_atom = TRUE

	if (mapload && permit_ao)
		queue_ao()

	var/area/A = loc

	if(!baseturf)
		// Hard-coding this for performance reasons.
		baseturf = A.base_turf || current_map.base_turf_by_z["[z]"] || /turf/space

	if (A.flags & SPAWN_ROOF)
		spawn_roof()

	if (flags & MIMIC_BELOW)
		setup_zmimic(mapload)

	return INITIALIZE_HINT_NORMAL

/turf/Destroy()
	if (!changing_turf)
		crash_with("Improper turf qdeletion.")

	changing_turf = FALSE
	turfs -= src

	cleanup_roof()

	if (ao_queued)
		SSocclusion.queue -= src
		ao_queued = 0

	if (flags & MIMIC_BELOW)
		cleanup_zmimic()

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	..()
	return QDEL_HINT_IWILLGC

/turf/proc/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.appearance = src
	underlay_appearance.dir = adjacency_dir
	return TRUE

/turf/ex_act(severity)
	return 0

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

/turf/attack_hand(mob/user)
	if(!(user.canmove) || user.restrained() || !(user.pulling))
		return 0
	if(user.pulling.anchored || !isturf(user.pulling.loc))
		return 0
	if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
		return 0
	if(ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return 1

/turf/CanPass(atom/movable/mover, turf/target)
	if(!target)
		return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	crash_with("Non movable passed to turf CanPass : [mover]")
	return FALSE

//There's a lot of QDELETED() calls here if someone can figure out how to optimize this but not runtime when something gets deleted by a Bump/CanPass/Cross call, lemme know or go ahead and fix this mess - kevinz000
/turf/Enter(atom/movable/mover, atom/oldloc)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "<span class='warning'>Movement is admin-disabled.</span>" //This is to identify lag problems
		return
	// Do not call ..()
	// Byond's default turf/Enter() doesn't have the behaviour we want with Bump()
	// By default byond will call Bump() on the first dense object in contents
	// Here's hoping it doesn't stay like this for years before we finish conversion to step_
	var/atom/firstbump
	var/CanPassSelf = CanPass(mover, src)
	if(CanPassSelf || CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
		for(var/i in contents)
			if(QDELETED(mover))
				return FALSE		//We were deleted, do not attempt to proceed with movement.
			if(i == mover || i == mover.loc) // Multi tile objects and moving out of other objects
				continue
			var/atom/movable/thing = i
			if(!thing.Cross(mover))
				if(QDELETED(mover))		//Mover deleted from Cross/CanPass, do not proceed.
					return FALSE
				if(CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
					mover.Bump(thing)
					continue
				else
					if(!firstbump || ((thing.layer > firstbump.layer || thing.flags & ON_BORDER) && !(firstbump.flags & ON_BORDER)))
						firstbump = thing
	if(QDELETED(mover))					//Mover deleted from Cross/CanPass/Bump, do not proceed.
		return FALSE
	if(!CanPassSelf)	//Even if mover is unstoppable they need to bump us.
		firstbump = src
	if(firstbump)
		mover.Bump(firstbump)
		return CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE)
	return TRUE

/turf/Exit(atom/movable/mover, atom/newloc)
	. = ..()
	if(!. || QDELETED(mover))
		return FALSE
	for(var/i in contents)
		if(i == mover)
			continue
		var/atom/movable/thing = i
		if(!thing.Uncross(mover, newloc))
			if(thing.flags & ON_BORDER)
				mover.Bump(thing)
			if(!CHECK_BITFIELD(mover.movement_type, UNSTOPPABLE))
				return FALSE
		if(QDELETED(mover))
			return FALSE		//We were deleted.

var/const/enterloopsanity = 100

/turf/Entered(atom/movable/AM)
	if(movement_disabled)
		usr << "<span class='warning'>Movement is admin-disabled.</span>" //This is to identify lag problems
		return

	ASSERT(istype(AM))

	if(ismob(AM))
		var/mob/M = AM
		if(!M.lastarea)
			M.lastarea = get_area(M.loc)
		if(M.lastarea.has_gravity() == 0)
			inertial_drift(M)

		// Footstep SFX logic moved to human_movement.dm - Move().

		else if (type != /turf/space)
			M.inertia_dir = 0
			M.make_floating(0)

	..()

	var/objects = 0
	if(AM && (AM.flags & PROXMOVE) && AM.simulated)
		for(var/atom/movable/oAM in range(1))
			if(objects > enterloopsanity)
				break
			objects++

			if (oAM.simulated)
				AM.proximity_callback(oAM)

/atom/movable/proc/proximity_callback(atom/movable/AM)
	set waitfor = FALSE
	sleep(0)
	HasProximity(AM, TRUE)
	if (!QDELETED(AM) && !QDELETED(src) && (AM.flags & PROXMOVE))
		AM.HasProximity(src, TRUE)

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/can_have_cabling()
	return FALSE

/turf/proc/can_lay_cable()
	return can_have_cabling()

/turf/attackby(obj/item/C, mob/user)
	if (can_lay_cable() && iscoil(C))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
	else
		..()

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Allow_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/CardinalTurfs()
	var/L[] = new()
	for(var/turf/simulated/T in AdjacentTurfs())
		if(T.x == src.x || T.y == src.y)
			L.Add(T)
	return L

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/process()
	STOP_PROCESSING(SSprocessing, src)

/turf/proc/contains_dense_objects()
	if(density)
		return 1
	for(var/atom/A in src)
		if(A.density && !(A.flags & ON_BORDER))
			return 1
	return 0

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user)
	if(source.reagents.has_reagent("water", 1) || source.reagents.has_reagent("cleaner", 1))
		clean_blood()
		if(istype(src, /turf/simulated))
			var/turf/simulated/T = src
			T.dirt = 0
			T.color = null
		for(var/obj/effect/O in src)
			if(istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
				qdel(O)
			if(istype(O,/obj/effect/rune))
				var/obj/effect/rune/R = O
				// Only show message for visible runes
				if (R.visibility)
					user << "<span class='warning'>No matter how well you wash, the bloody symbols remain!</span>"
	else
		user << "<span class='warning'>\The [source] is too dry to wash that.</span>"
	source.reagents.trans_to_turf(src, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/update_blood_overlays()
	return

/**
 * Will spawn a roof above the turf if it needs one.
 *
 * @param  flags The flags to assign to the turf which control roof spawning and
 * deletion by this turf. Refer to _defines/turfs.dm for a full list.
 *
 * @return TRUE if a roof has been spawned, FALSE if not.
 */
/turf/proc/spawn_roof(flags = 0)
	var/turf/simulated/open/above = GetAbove(src)
	if (!above)
		return FALSE

	if (((istype(above)) || (flags & ROOF_FORCE_SPAWN)) && roof_type && above)
		above.ChangeTurf(roof_type)
		roof_flags |= flags
		return TRUE

	return FALSE

/**
 * Cleans up the roof above a tile if there is one spawned and the ROOF_CLEANUP
 * flag is present on the source turf.
 */
/turf/proc/cleanup_roof()
	if (!HasAbove(z))
		return

	if (roof_flags & ROOF_CLEANUP)
		var/turf/above = GetAbove(src)
		if (!above || isopenturf(above))
			return

		above.ChangeToOpenturf()

/turf/proc/AdjacentTurfsRanged()
	var/static/list/allowed = typecacheof(list(
		/obj/structure/table,
		/obj/structure/closet,
		/obj/machinery/constructable_frame,
		/obj/structure/target_stake,
		/obj/structure/cable,
		/obj/structure/disposalpipe,
		/obj/machinery,
		/mob
	))

	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		var/add = 1
		if(t.density)
			add = 0
		if(add && LinkBlocked(src,t))
			add = 0
		if(add && TurfBlockedNonWindow(t))
			add = 0
			for(var/obj/O in t)
				if(!O.density)
					add = 1
					break
				if(istype(O, /obj/machinery/door))
					//not sure why this doesn't fire on LinkBlocked()
					add = 0
					break
				if(is_type_in_typecache(O, allowed))
					add = 1
					break
				if(!add)
					break
		if(add)
			L.Add(t)
	return L


/turf/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if((istype(A) && !(A.has_gravity())) || (istype(T,/turf/space)))
		return
	if(istype(O, /obj/screen))
		return
	if(user.restrained() || user.stat || user.stunned || user.paralysis || !user.lying)
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/has_right_hand = TRUE
		var/obj/item/organ/external/rhand = H.organs_by_name["r_hand"]
		if(!rhand || rhand.is_stump())
			has_right_hand = FALSE
		var/obj/item/organ/external/lhand = H.organs_by_name["l_hand"]
		if(!lhand || lhand.is_stump())
			if(!has_right_hand)
				return
	if (do_after(user, 25 + (5 * user.weakened)) && !(user.stat))
		step_towards(O, src)
