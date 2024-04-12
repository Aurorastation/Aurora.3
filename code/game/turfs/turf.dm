/turf
	icon = 'icons/turf/floors.dmi'
	level = 1

	layer = TURF_LAYER

	var/turf_flags
	var/holy = 0

	// Initial air contents (in moles)
	var/list/initial_gas

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

	var/footstep_sound = /singleton/sound_category/tiles_footstep

	var/list/decals
	var/list/blueprints

	var/is_hole		// If true, turf will be treated as space or a hole
	var/tmp/turf/baseturf

	var/roof_type = null // The turf type we spawn as a roof.
	var/tmp/roof_flags = 0

	var/movement_cost = 0 // How much the turf slows down movement, if any.

	// Footprint info
	var/tracks_footprint = TRUE // Whether footprints will appear on this turf
	var/does_footprint = FALSE // Whether stepping on this turf will dirty your shoes or feet with the below
	var/footprint_color // The hex color produced by the turf
	var/track_distance = 12 // How far the tracks last

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources
	var/image/resource_indicator

	// Plating data.
	var/base_name = "plating"
	var/base_desc = "The naked hull."
	var/base_icon = 'icons/turf/flooring/plating.dmi'
	var/base_icon_state = "plating"
	var/base_color = null

	var/last_clean //for clean log spam.

	///what /mob/oranges_ear instance is already assigned to us as there should only ever be one.
	///used for guaranteeing there is only one oranges_ear per turf when assigned, speeds up view() iteration
	var/mob/oranges_ear/assigned_oranges_ear

	/// How pathing algorithm will check if this turf is passable by itself (not including content checks). By default it's just density check.
	/// WARNING: Currently to use a density shortcircuiting this does not support dense turfs with special allow through function
	var/pathing_pass_method = TURF_PATHING_PASS_DENSITY

	// Some quick notes on the vars below: is_outside should be left set to OUTSIDE_AREA unless you
	// EXPLICITLY NEED a turf to have a different outside state to its area (ie. you have used a
	// roofing tile). By default, it will ask the area for the state to use, and will update on
	// area change. When dealing with weather, it will check the entire z-column for interruptions
	// that will prevent it from using its own state, so a floor above a level will generally
	// override both area is_outside, and turf is_outside. The only time the base value will be used
	// by itself is if you are dealing with a non-multiz level, or the top level of a multiz chunk.

	// Weather relies on is_outside to determine if it should apply to a turf or not and will be
	// automatically updated on ChangeTurf set_outside etc. Don't bother setting it manually, it will
	// get overridden almost immediately.

	// TL;DR: just leave these vars alone.
	var/tmp/obj/abstract/weather_system/weather
	var/tmp/is_outside = OUTSIDE_AREA
	var/tmp/last_outside_check = OUTSIDE_UNCERTAIN

// Parent code is duplicated in here instead of ..() for performance reasons.
// There's ALSO a copy of this in mine_turfs.dm!
/turf/Initialize(mapload, ...)
	SHOULD_CALL_PARENT(FALSE)

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	for(var/atom/movable/AM as mob|obj in src)
		Entered(AM, src)

	if (isStationLevel(z))
		GLOB.station_turfs += src

	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if (smoothing_flags)
		SSicon_smooth.add_to_queue(src)

	if (light_range && light_power)
		update_light()

	if (opacity)
		has_opaque_atom = TRUE

	if (mapload && permit_ao)
		queue_ao()

	var/area/A = loc

	if(!baseturf)
		// Hard-coding this for performance reasons.
		baseturf = A.base_turf || SSatlas.current_map.base_turf_by_z["[z]"] || /turf/space

	if (A.area_flags & AREA_FLAG_SPAWN_ROOF)
		spawn_roof()

	if (z_flags & ZM_MIMIC_BELOW)
		setup_zmimic(mapload)

	return INITIALIZE_HINT_NORMAL

/turf/Destroy()
	if (!changing_turf)
		crash_with("Improper turf qdeletion.")

	changing_turf = FALSE

	if (isStationLevel(z))
		GLOB.station_turfs -= src

	remove_cleanables()
	cleanup_roof()

	if (ao_queued)
		SSao.queue -= src
		ao_queued = 0

	if (z_flags & ZM_MIMIC_BELOW)
		cleanup_zmimic()

	if (z_flags & ZM_MIMIC_BELOW)
		cleanup_zmimic()

	resource_indicator = null

	..()
	return QDEL_HINT_IWILLGC

/turf/proc/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.appearance = src
	underlay_appearance.dir = adjacency_dir
	return TRUE

/turf/ex_act(severity)
	return 0

/turf/proc/is_solid_structure()
	return !(turf_flags & TURF_FLAG_BACKGROUND) || locate(/obj/structure/lattice, src)

/turf/proc/is_space()
	return 0

/turf/proc/is_intact()
	return 0

/turf/attack_hand(mob/user)
	if(!(user.canmove) || user.restrained())
		return FALSE
	if(user.pulling)
		if(user.pulling.anchored || !isturf(user.pulling.loc))
			return FALSE
		if(user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1)
			return FALSE
		if(ismob(user.pulling))
			var/mob/M = user.pulling
			var/atom/movable/t = M.pulling
			M.stop_pulling()
			step(user.pulling, get_dir(user.pulling.loc, src))
			M.start_pulling(t)
		else
			step(user.pulling, get_dir(user.pulling.loc, src))

	. = handle_hand_interception(user)
	if (!.)
		return TRUE
	return TRUE

/turf/proc/handle_hand_interception(var/mob/user)
	var/datum/component/turf_hand/THE
	for (var/atom/A in src)
		var/datum/component/turf_hand/TH = A.GetComponent(/datum/component/turf_hand)
		if (istype(TH) && TH.priority > THE?.priority) //Only overwrite if the new one is higher. For matching values, its first come first served
			THE = TH

	if (THE)
		return THE.OnHandInterception(user)

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems)
		return

	..()

	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return 1

	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Collide(obstacle)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Collide(border_obstacle)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Collide(border_obstacle)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Collide(src)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Collide(obstacle)
				return 0
	return 1 //Nothing found to block so return success!

var/const/enterloopsanity = 100

/turf/Entered(atom/movable/AM, atom/old_loc)
	if(movement_disabled)
		to_chat(usr, "<span class='warning'>Movement is admin-disabled.</span>") //This is to identify lag problems)
		return

	ASSERT(istype(AM))

	if(ismob(AM))
		var/mob/M = AM
		if(!M.lastarea)
			M.lastarea = get_area(M.loc)

		var/has_gravity = M.lastarea.has_gravity()
		if(!has_gravity)
			inertial_drift(M)

		// Footstep SFX logic moved to human_movement.dm - Move().

		else if(!is_hole)
			M.inertia_dir = 0

		if(!M.is_floating && (is_hole || !has_gravity))
			M.update_floating()
		else if(M.is_floating && !is_hole && has_gravity)
			M.update_floating()

	if(does_footprint && footprint_color && ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/obj/item/organ/external/l_foot = H.get_organ(BP_L_FOOT)
		var/obj/item/organ/external/r_foot = H.get_organ(BP_R_FOOT)
		var/has_feet = TRUE
		if((!l_foot || l_foot.is_stump()) && (!r_foot || r_foot.is_stump()))
			has_feet = FALSE
		if(!H.buckled_to && !H.lying && has_feet)
			if(H.shoes) //Adding ash to shoes
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.blood_color = footprint_color
					S.track_footprint = max(track_distance, S.track_footprint)

					if(!S.blood_overlay)
						S.generate_blood_overlay()
					if(S.blood_overlay?.color != footprint_color)
						S.cut_overlay(S.blood_overlay, TRUE)

					S.blood_overlay.color = footprint_color
					S.add_overlay(S.blood_overlay, TRUE)
			else
				H.footprint_color = footprint_color
				H.track_footprint = max(track_distance, H.track_footprint)

		H.update_inv_shoes(TRUE)

	if(tracks_footprint && ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.species.deploy_trail(H, src)

	..(AM, old_loc)

	var/objects = 0
	if(AM && (AM.movable_flags & MOVABLE_FLAG_PROXMOVE) && AM.simulated)
		for(var/atom/movable/oAM in range(1))
			if(objects > enterloopsanity)
				break
			objects++

			if (oAM.simulated && (oAM.movable_flags & MOVABLE_FLAG_PROXMOVE))
				AM.proximity_callback(oAM)

/turf/proc/add_tracks(var/typepath, var/footprint_DNA, var/comingdir, var/goingdir, var/footprint_color="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.add_tracks(footprint_DNA, comingdir, goingdir, footprint_color)

/atom/movable/proc/proximity_callback(atom/movable/AM)
	SHOULD_NOT_SLEEP(TRUE)

	HasProximity(AM, TRUE)
	if (!QDELETED(AM) && !QDELETED(src) && (AM.movable_flags & MOVABLE_FLAG_PROXMOVE))
		AM.HasProximity(src, TRUE)

/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return 0

/turf/proc/can_have_cabling()
	return FALSE

/turf/proc/can_lay_cable()
	return can_have_cabling()

/turf/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/grab))
		var/obj/item/grab/grab = attacking_item
		step(grab.affecting, get_dir(grab.affecting, src))
	if (can_lay_cable() && attacking_item.iscoil())
		var/obj/item/stack/cable_coil/coil = attacking_item
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

/turf/proc/AdjacentTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/turf/t in orange(src,1))
		if(check_blockage)
			if(!t.density)
				if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
					. += t
		else
			. += t

/turf/proc/CardinalTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/ad in AdjacentTurfs(check_blockage))
		var/turf/T = ad
		if(T.x == src.x || T.y == src.y)
			. += T

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
		if(A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			return 1
	return 0

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user)
	if(source.reagents.has_reagent(/singleton/reagent/water, 1) || source.reagents.has_reagent(/singleton/reagent/spacecleaner, 1))
		clean_blood()

		for(var/obj/effect/O in src)
			if(istype(O, /obj/effect/decal/cleanable))
				qdel(O)

			if(istype(O, /obj/effect/overlay))
				var/obj/effect/overlay/OV = O
				if(OV.no_clean)
					continue
				else
					qdel(OV)

			if(istype(O, /obj/effect/rune))
				var/obj/effect/rune/R = O
				// Only show message for visible runes
				if(!R.invisibility)
					to_chat(user, SPAN_WARNING("No matter how well you wash, the bloody symbols remain!"))
	else
		if(!(last_clean && world.time < last_clean + 100))
			to_chat(user, SPAN_WARNING("\The [source] is too dry to wash that."))
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

/turf/proc/is_wall()
	return FALSE

/turf/proc/is_open()
	return FALSE

/turf/proc/is_floor()
	return FALSE

/turf/proc/is_outside()

	// Can't rain inside or through solid walls.
	// TODO: dense structures like full windows should probably also block weather.
	if(density)
		return OUTSIDE_NO

	if(last_outside_check != OUTSIDE_UNCERTAIN)
		return last_outside_check

	// What is our local outside value?
	// Some turfs can be roofed irrespective of the turf above them in multiz.
	// I have the feeling this is redundat as a roofed turf below max z will
	// have a floor above it, but ah well.
	. = is_outside
	if(. == OUTSIDE_AREA)
		var/area/A = get_area(src)
		. = A ? A.is_outside : OUTSIDE_NO

	// If we are in a multiz volume and not already inside, we return
	// the outside value of the highest unenclosed turf in the stack.
	if(HasAbove(z))
		. =  OUTSIDE_YES // assume for the moment we're unroofed until we learn otherwise.
		var/turf/top_of_stack = src
		while(HasAbove(top_of_stack.z))
			var/turf/next_turf = GetAbove(top_of_stack)
			if(!next_turf.is_open())
				return OUTSIDE_NO
			top_of_stack = next_turf
		// If we hit the top of the stack without finding a roof, we ask the upmost turf if we're outside.
		. = top_of_stack.is_outside()
	last_outside_check = . // Cache this for later calls.

/turf/proc/set_outside(var/new_outside, var/skip_weather_update = FALSE)
	if(is_outside == new_outside)
		return FALSE

	is_outside = new_outside
	if(!skip_weather_update)
		update_weather()

	last_outside_check = OUTSIDE_UNCERTAIN

	if(!HasBelow(z))
		return TRUE

	// Invalidate the outside check cache for turfs below us.
	var/turf/checking = src
	while(HasBelow(checking.z))
		checking = GetBelow(checking)
		if(!isturf(checking))
			break
		checking.last_outside_check = OUTSIDE_UNCERTAIN
		if(!checking.is_open())
			break
	return TRUE

/turf/proc/update_weather(var/obj/abstract/weather_system/new_weather, var/force_update_below = FALSE)

	if(isnull(new_weather))
		new_weather = SSweather.weather_by_z["[z]"]

	// We have a weather system and we are exposed to it; update our vis contents.
	if(istype(new_weather) && is_outside())
		if(weather != new_weather)
			if(weather)
				remove_vis_contents(weather.vis_contents_additions)
			weather = new_weather
			add_vis_contents(weather.vis_contents_additions)
			. = TRUE

	// We are indoors or there is no local weather system, clear our vis contents.
	else if(weather)
		remove_vis_contents(weather.vis_contents_additions)
		weather = null
		. = TRUE

	// Propagate our weather downwards if we permit it.
	if(force_update_below || (is_open() && .))
		var/turf/below = GetBelow(src)
		if(below)
			below.update_weather(new_weather)

/turf/proc/remove_cleanables()
	for(var/obj/effect/O in src)
		if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable))
			qdel(O)
	clean_blood()
