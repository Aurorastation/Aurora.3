// Builds a list of turfs belonging to an area in a predictable order.
// Two areas of the same size should have directly comparable ordered turf lists.
// If ignore_type has a value, that turf will be excluded from the list.
// Excluded turfs are represented by null values in the list to maintain order.
/area/proc/build_ordered_turf_list(ignore_type)
	. = list()

	// Find the maximums and minimums of the area.
	var/xmax = -1
	var/ymax = -1
	var/xmin = INFINITY
	var/ymin = INFINITY
	var/z = -1
	for (var/turf/T in src)
		if (z == -1)
			z = T.z

		if (T.x > xmax)
			xmax = T.x

		if (T.x < xmin)
			xmin = T.x

		if (T.y > ymax)
			ymax = T.y

		if (T.y < ymin)
			ymin = T.y

	//log_debug("build_ordered_turf_list([DEBUG_REF(src)]): xmax=[xmax],xmin=[xmin],ymax=[ymax],ymin=[ymin],z=[z]")

	ASSERT(xmax > xmin)
	ASSERT(ymax > ymin)
	ASSERT(z != -1)

	// Now use our information to build an *ordered* list of turfs.
	for (var/x = xmin to xmax)
		for (var/y = ymin to ymax)
			var/turf/T = locate(x, y, z)
			if (T.loc != src || T.type == ignore_type)
				// Not ours or ignored type, we don't give a crap.
				// Add a null to keep the list a predictable size.
				. += null
			else
				// Turf matches, add it.
				. += T

/area/proc/move_contents_to(var/area/A)
	//Takes: Area.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner.

	if(!A || !src) return

	var/list/turfs_src = get_area_turfs("\ref[src]")

	if(!turfs_src.len)
		return

	//figure out a suitable origin - this assumes the shuttle areas are the exact same size and shape
	//might be worth doing this with a shuttle core object instead of areas, in the future
	var/src_origin = locate(src.x, src.y, src.z)
	var/trg_origin = locate(A.x, A.y, A.z)

	if(src_origin && trg_origin)
		var/translation = get_turf_translation(src_origin, trg_origin, turfs_src)
		translate_turfs(translation, null)

// Called when a movable area wants to move this object.
/atom/movable/proc/shuttle_move(turf/loc)
	forceMove(loc)

// In theory, this copies the contents of the area to another, and returns a list containing every new object it created.
// It's not tested because the holodeck doesn't work yet.
/area/proc/copy_contents_to(area/A, plating_required = FALSE)
	var/list/source_turfs = src.build_ordered_turf_list()
	var/list/target_turfs = A.build_ordered_turf_list()

	. = list()

	ASSERT(source_turfs.len == target_turfs.len)

	var/baseturf
	if (plating_required)
		baseturf = A.base_turf
		if (!baseturf)
			var/turf/T
			for (var/idex = 1; T == null; idex++)
				if (idex > target_turfs.len)
					CRASH("Empty target_turfs list!")

				T = target_turfs[idex]

			baseturf = T.baseturf

	for (var/i = 1 to source_turfs.len)
		var/turf/ST = source_turfs[i]
		var/turf/TTi = target_turfs[i]
		if (!ST || (plating_required && TTi.type == baseturf))	// Excluded turfs are null to keep the list ordered.
			continue


		var/turf/TT
		if(istype(ST, /turf/simulated))
			var/turf/simulated/ST_sim = ST
			TT = ST_sim.copy_turf(TTi, ignore_air = TRUE)
		else
			TT = ST.copy_turf(TTi)

		for (var/thing in ST)
			var/atom/movable/AM = thing
			var/atom/movable/copy = DuplicateObject(AM, 1)
			copy.forceMove(TT)
			. += copy

		SSair.mark_for_update(TT)
