/* THIS IS ONLY A PLACEHOLDER AND DOESN'T WORK */

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
	var/turf_type = /turf/space

	///Distance away from the cordon where we can put a "sort-cordon" and run some extra code (see make_repel). 0 makes nothing happen
	var/pre_cordon_distance = 0

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
