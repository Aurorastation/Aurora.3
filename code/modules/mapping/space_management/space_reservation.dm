//Yes, they can only be rectangular.
//Yes, I'm sorry.
/datum/turf_reservation
	/// All turfs that we've reserved
	var/list/reserved_turfs = list()

	/// Turfs around the reservation for cordoning
	var/list/cordon_turfs = list()

	/// Area of turfs next to the cordon to fill with pre_cordon_area's
	var/list/pre_cordon_turfs = list()

	/// The width of the reservation
	var/width = 0

	/// The height of the reservation
	var/height = 0

	/// The z stack size of the reservation. Note that reservations are ALWAYS reserved from the bottom up
	var/z_size = 0

	/// List of the bottom left turfs. Indexed by what their z index for this reservation is
	var/list/bottom_left_turfs = list()

	/// List of the top right turfs. Indexed by what their z index for this reservation is
	var/list/top_right_turfs = list()

	/// The turf type the reservation is initially made with
	var/turf_type = RESERVED_TURF_TYPE

	/// Do we override baseturfs with turf_type?
	var/turf_type_is_baseturf = TRUE

	///Distance away from the cordon where we can put a "sort-cordon" and run some extra code (see make_repel). 0 makes nothing happen
	var/pre_cordon_distance = 0

/datum/turf_reservation/transit
	turf_type = /turf/space/transit
	pre_cordon_distance = 7

/datum/turf_reservation/New()
	LAZYADD(SSmapping.turf_reservations, src)

/datum/turf_reservation/Destroy()
	Release()
	LAZYREMOVE(SSmapping.turf_reservations, src)
	return ..()

/datum/turf_reservation/proc/Release()
	bottom_left_turfs.Cut()
	top_right_turfs.Cut()

	var/list/release_turfs = list()
	release_turfs |= reserved_turfs
	release_turfs |= cordon_turfs

	reserved_turfs.Cut()
	cordon_turfs.Cut()

	for(var/turf/pre_cordon_turf as anything in pre_cordon_turfs)
		stop_repel(pre_cordon_turf)
	pre_cordon_turfs.Cut()

	for(var/turf/released_turf as anything in release_turfs)
		SSmapping.used_turfs -= released_turf
		SEND_SIGNAL(released_turf, COMSIG_TURF_RESERVATION_RELEASED, src)
		released_turf.blocks_air = TRUE

	// Makes the linter happy, even tho we don't await this
	INVOKE_ASYNC(SSmapping, TYPE_PROC_REF(/datum/controller/subsystem/mapping, reserve_turfs), release_turfs)

/datum/turf_reservation/proc/calculate_cordon_turfs(turf/bottom_left, turf/top_right)
	if(bottom_left.x < 2 || bottom_left.y < 2 || top_right.x > (world.maxx - 2) || top_right.y > (world.maxy - 2))
		return FALSE

	var/list/possible_turfs = CORNER_OUTLINE(bottom_left, width, height)
	possible_turfs -= cordon_turfs
	for(var/turf/cordon_turf as anything in possible_turfs)
		if(!(cordon_turf.turf_flags & UNUSED_RESERVATION_TURF))
			return FALSE

	cordon_turfs |= possible_turfs

	if(pre_cordon_distance && width > pre_cordon_distance * 2 && height > pre_cordon_distance * 2)
		var/turf/offset_turf = locate(bottom_left.x + pre_cordon_distance, bottom_left.y + pre_cordon_distance, bottom_left.z)
		var/list/to_add = CORNER_OUTLINE(offset_turf, width - pre_cordon_distance * 2, height - pre_cordon_distance * 2) //we step-by-stop move inwards from the outer cordon
		for(var/turf/turf_being_added as anything in to_add)
			pre_cordon_turfs |= turf_being_added //add one by one so we can filter out duplicates

	return TRUE

/datum/turf_reservation/proc/generate_cordon()
	var/area/space/space_area = locate(/area/space)
	var/list/prepared_cordon_turfs = list()
	for(var/turf/cordon_turf as anything in cordon_turfs)
		SSmapping.unused_turfs["[cordon_turf.z]"] -= cordon_turf
		cordon_turf = SSmapping.reset_turf_for_reservation(cordon_turf, space_area)
		if(!cordon_turf)
			continue
		cordon_turf.turf_flags &= ~UNUSED_RESERVATION_TURF
		SSmapping.used_turfs[cordon_turf] = src
		prepared_cordon_turfs += cordon_turf
	cordon_turfs = prepared_cordon_turfs

	for(var/turf/pre_cordon_turf as anything in pre_cordon_turfs)
		make_repel(pre_cordon_turf)

/// Register signals in the cordon "danger zone" to do something with whoever trespasses
/datum/turf_reservation/proc/make_repel(turf/pre_cordon_turf)
	SHOULD_CALL_PARENT(TRUE)
	//Okay so hear me out. If we place a special turf IN the reserved area, it will be overwritten, so we can't do that
	//But signals are preserved even between turf changes, so even if we register a signal now it will stay even if that turf is overriden by the template
	RegisterSignals(pre_cordon_turf, list(COMSIG_QDELETING, COMSIG_TURF_RESERVATION_RELEASED), PROC_REF(on_stop_repel))

/datum/turf_reservation/proc/on_stop_repel(turf/pre_cordon_turf)
	SHOULD_CALL_PARENT(TRUE)
	SIGNAL_HANDLER

	stop_repel(pre_cordon_turf)

/// Unregister all the signals we added in RegisterRepelSignals
/datum/turf_reservation/proc/stop_repel(turf/pre_cordon_turf)
	UnregisterSignal(pre_cordon_turf, list(COMSIG_QDELETING, COMSIG_TURF_RESERVATION_RELEASED))

/datum/turf_reservation/transit/make_repel(turf/pre_cordon_turf)
	..()
	// this does dump_in_space stuff in tg

/datum/turf_reservation/proc/prepare_reserved_turf(turf/T)
	RETURN_TYPE(/turf)
	if(!istype(T))
		return
	if(T.type != turf_type)
		T = T.ChangeTurf(turf_type, TRUE, FALSE, TRUE)
	if(!T)
		return
	if(turf_type_is_baseturf)
		T.baseturf = turf_type
	T.blocks_air = TRUE
	return T

/datum/turf_reservation/turf_not_baseturf
	turf_type_is_baseturf = FALSE

/// Internal proc which handles reserving the area for the reservation.
/datum/turf_reservation/proc/reserve_area(width, height, zlevel)
	src.width = width
	src.height = height
	if(width > world.maxx || height > world.maxy || width < 1 || height < 1)
		return FALSE

	var/list/available_turfs = SSmapping.unused_turfs["[zlevel]"]
	if(!length(available_turfs))
		return FALSE

	var/turf/bottom_left
	var/turf/top_right
	var/list/final_turfs = list()
	var/passing = FALSE

	for(var/candidate in available_turfs)
		CHECK_TICK
		bottom_left = candidate
		if(!(bottom_left.turf_flags & UNUSED_RESERVATION_TURF))
			continue
		if(bottom_left.x + width > world.maxx || bottom_left.y + height > world.maxy)
			continue

		top_right = locate(bottom_left.x + width - 1, bottom_left.y + height - 1, bottom_left.z)
		if(!(top_right.turf_flags & UNUSED_RESERVATION_TURF))
			continue

		final_turfs = block(bottom_left, top_right)
		if(!length(final_turfs))
			continue

		passing = TRUE
		for(var/turf/checking as anything in final_turfs)
			if(!(checking.turf_flags & UNUSED_RESERVATION_TURF))
				passing = FALSE
				break

		if(passing)
			passing = calculate_cordon_turfs(bottom_left, top_right)
		if(passing)
			break

	if(!passing || !istype(bottom_left) || !istype(top_right))
		cordon_turfs.Cut()
		pre_cordon_turfs.Cut()
		return FALSE

	for(var/turf/T as anything in final_turfs)
		SSmapping.unused_turfs["[T.z]"] -= T
		var/turf/reserved_turf = prepare_reserved_turf(T)
		if(!reserved_turf)
			continue
		reserved_turfs |= reserved_turf
		SSmapping.used_turfs[reserved_turf] = src
		reserved_turf.turf_flags = (reserved_turf.turf_flags | RESERVATION_TURF) & ~UNUSED_RESERVATION_TURF
		if(T == bottom_left)
			bottom_left = reserved_turf
		if(T == top_right)
			top_right = reserved_turf

	bottom_left_turfs += bottom_left
	top_right_turfs += top_right
	return TRUE

/datum/turf_reservation/proc/reserve(width, height, z_size, z_reservation)
	src.z_size = z_size
	var/failed_reservation = FALSE
	for(var/i = 1 to z_size)
		if(!reserve_area(width, height, z_reservation))
			failed_reservation = TRUE
			break

	if(failed_reservation)
		Release()
		return FALSE

	generate_cordon()
	return TRUE

/// Calculates the effective bounds information for the given turf. Returns a list of the information, or null if not applicable.
/datum/turf_reservation/proc/calculate_turf_bounds_information(turf/target)
	for(var/z_idx in 1 to z_size)
		var/turf/bottom_left = bottom_left_turfs[z_idx]
		var/turf/top_right = top_right_turfs[z_idx]
		var/bl_x = bottom_left.x
		var/bl_y = bottom_left.y
		var/tr_x = top_right.x
		var/tr_y = top_right.y

		if(target.x < bl_x)
			continue

		if(target.y < bl_y)
			continue

		if(target.x > tr_x)
			continue

		if(target.y > tr_y)
			continue

		var/list/return_information = list()
		return_information["z_idx"] = z_idx
		return_information["offset_x"] = target.x - bl_x
		return_information["offset_y"] = target.y - bl_y
		return return_information
	return null

/// Gets the turf below the given target. Returns null if there is no turf below the target
/datum/turf_reservation/proc/get_turf_below(turf/target)
	var/list/bounds_info = calculate_turf_bounds_information(target)
	if(isnull(bounds_info))
		return null

	var/z_idx = bounds_info["z_idx"]
	// check what z level, if its the max, then there is no turf below
	if(z_idx == z_size)
		return null

	var/offset_x = bounds_info["offset_x"]
	var/offset_y = bounds_info["offset_y"]
	var/turf/bottom_left = bottom_left_turfs[z_idx + 1]
	return locate(bottom_left.x + offset_x, bottom_left.y + offset_y, bottom_left.z)

/// Gets the turf above the given target. Returns null if there is no turf above the target
/datum/turf_reservation/proc/get_turf_above(turf/target)
	var/list/bounds_info = calculate_turf_bounds_information(target)
	if(isnull(bounds_info))
		return null

	var/z_idx = bounds_info["z_idx"]
	// check what z level, if its the min, then there is no turf above
	if(z_idx == 1)
		return null

	var/offset_x = bounds_info["offset_x"]
	var/offset_y = bounds_info["offset_y"]
	var/turf/bottom_left = bottom_left_turfs[z_idx - 1]
	return locate(bottom_left.x + offset_x, bottom_left.y + offset_y, bottom_left.z)
