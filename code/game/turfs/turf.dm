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

	var/footstep_sound = "tiles"

	var/list/decals

	var/is_hole		// If true, turf will be treated as space or a hole
	var/tmp/turf/baseturf

	var/roof_type = null // The turf type we spawn as a roof.
	var/tmp/roof_flags = 0

	var/movement_cost = 0 // How much the turf slows down movement, if any.

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/base_icon_state = "plating"
	var/last_clean //for clean log spam.

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

/turf/proc/is_solid_structure()
	return 1

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

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems)
		return

	..()

	if (!mover || !isturf(mover.loc))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.flags & ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Collide(obstacle)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Collide(border_obstacle)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Collide(border_obstacle)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Collide(src)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.flags & ON_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Collide(obstacle)
				return 0
	return 1 //Nothing found to block so return success!

var/const/enterloopsanity = 100

/turf/Entered(atom/movable/AM)
	if(movement_disabled)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems)
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
	if (can_lay_cable() && C.iscoil())
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
				if(!R.invisibility)
					to_chat(user, span("warning", "No matter how well you wash, the bloody symbols remain!"))
	else
		if( !(last_clean && world.time < last_clean + 100) )
			to_chat(user, span("warning", "\The [source] is too dry to wash that."))
			last_clean = world.time
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
	var/turf/above = GetAbove(src)
	if (!above)
		return FALSE

	if ((isopenturf(above) || (flags & ROOF_FORCE_SPAWN)) && get_roof_type() && above)
		above.ChangeTurf(get_roof_type())
		roof_flags |= flags
		return TRUE

	return FALSE

/**
 * Returns the roof type of the current turf
 */
/turf/proc/get_roof_type()
	return roof_type

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

// CRAWLING + MOVING STUFF
/turf/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	var/turf/T = get_turf(user)
	var/area/A = T.loc
	if((istype(A) && !(A.has_gravity())) || (istype(T,/turf/space)))
		return
	if(istype(O, /obj/screen))
		return
	if(user.restrained() || user.stat || user.incapacitated(INCAPACITATION_KNOCKOUT) || !user.lying)
		return
	if((!(istype(O, /atom/movable)) || O.anchored || !Adjacent(user) || !Adjacent(O) || !user.Adjacent(O)))
		return
	if(!isturf(O.loc) || !isturf(user.loc))
		return
	if(isanimal(user) && O != user)
		return

	var/tally = 0

	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		var/obj/item/organ/external/rhand = H.organs_by_name[BP_R_HAND]
		tally += limbCheck(rhand)

		var/obj/item/organ/external/lhand = H.organs_by_name[BP_L_HAND]
		tally += limbCheck(lhand)

		var/obj/item/organ/external/rfoot = H.organs_by_name[BP_R_FOOT]
		tally += limbCheck(rfoot)

		var/obj/item/organ/external/lfoot = H.organs_by_name[BP_L_FOOT]
		tally += limbCheck(lfoot)

	if(tally >= 120)
		to_chat(user, span("notice", "You're too injured to do this!"))
		return

	var/finaltime = 25 + (5 * (user.weakened * 1.5))
	if(tally >= 45) // If you have this much missing, you'll crawl slower.
		finaltime += tally

	if(do_after(user, finaltime) && !user.stat)
		step_towards(O, src)

// Checks status of limb, returns an amount to
/turf/proc/limbCheck(var/obj/item/organ/external/limb)
	if(!limb) // Limb is null, thus missing. Add 3 seconds.
		return 30
	else if(!limb.is_usable() || limb.is_broken()) // You can't use the limb, but it's still there to manoevre yourself
		return 15
	else
		return 0