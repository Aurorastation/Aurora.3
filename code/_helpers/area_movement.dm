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
	for (var/x = xmin; x <= xmax; x++)
		for (var/y = ymin; y <= ymax; y++)
			var/turf/T = locate(x, y, z)
			if (T.loc != src || T.type == ignore_type)
				// Not ours or ignored type, we don't give a crap.
				// Add a null to keep the list a predictable size.
				. += null
			else
				// Turf matches, add it.
				. += T

/area/proc/move_contents_to(area/A, turf_to_leave = null, direction = null)
	var/list/source_turfs = src.build_ordered_turf_list(turf_to_leave)
	var/list/target_turfs = A.build_ordered_turf_list(turf_to_leave)

	//log_debug("move_contents_to: source_turfs.len=[source_turfs.len],target_turfs.len=[target_turfs.len]")

	ASSERT(source_turfs.len == target_turfs.len)

	var/list/simulated_turfs = list()

	for (var/i = 1; i <= source_turfs.len; i++)
		var/turf/ST = source_turfs[i]
		if (!ST)	// Excluded turfs are null to keep the list ordered.
			continue

		var/turf/TT = ST.copy_turf(target_turfs[i])
		
		for (var/thing in ST)
			var/atom/movable/AM = thing
			AM.shuttle_move(TT)

		ST.ChangeTurf(get_base_turf_by_area(ST))

		if (istype(TT, /turf/simulated))
			simulated_turfs += TT

	for (var/thing in simulated_turfs)
		var/turf/simulated/T = thing

		T.update_icon()
		if (istype(T.above))
			T.above.queue_icon_update()

// Called when a movable area wants to move this object.
/atom/movable/proc/shuttle_move(turf/loc)
	forceMove(loc)
