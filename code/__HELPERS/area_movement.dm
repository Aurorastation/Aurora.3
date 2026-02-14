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

	//LOG_DEBUG("build_ordered_turf_list([DEBUG_REF(src)]): xmax=[xmax],xmin=[xmin],ymax=[ymax],ymin=[ymin],z=[z]")

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

/// Copies turfs and their contents from src area to target area. Turfs are copied over using the baseturf system; movables are duplicated and forceMoved
/area/proc/copy_contents_to(area/tgt)
	var/list/source_turfs = src.build_ordered_turf_list()
	var/list/target_turfs = tgt.build_ordered_turf_list()

	. = list()

	ASSERT(source_turfs.len == target_turfs.len)

	for(var/i in 1 to target_turfs.len)
		var/turf/T = target_turfs[i]
		var/turf/S = source_turfs[i]
		var/turf/NT = T.copy_on_top(S, TRUE, 1, TRUE, CHANGETURF_NO_AREA_CHANGE)
		for(var/atom/movable/thing as anything in S)
			var/atom/movable/copy = DuplicateObject(thing, TRUE)
			copy.forceMove(NT)
			. += copy
		SSair.mark_for_update(NT)

/// DEPRECATED. If you need to do this, look into how shuttles do it.
/area/proc/move_contents_to(var/area/A)

	if(!A || !src) return

	var/list/turfs_src = get_turfs_from_all_zlevels()

	if(!turfs_src.len)
		return

	var/src_origin = locate(src.x, src.y, src.z)
	var/trg_origin = locate(A.x, A.y, A.z)

	if(src_origin && trg_origin)
		var/translation = get_turf_translation(src_origin, trg_origin, turfs_src)
		translate_turfs(translation, null)

/// DEPRECATED. If you need to do this, use a bounding component
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			log_world("ERROR: Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map

/// DEPRECATED. If you need to do this, look into how shuttles do it.
/proc/translate_turfs(var/list/translation, var/area/base_area = null, var/turf/base_turf, var/ignore_background)
	. = list()
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			if(base_area)
				target.change_area(target.loc, get_area(source))
				. += transport_turf_contents(source, target, ignore_background)
				source.change_area(source.loc, base_area)
			else
				. += transport_turf_contents(source, target, ignore_background)

	//change the old turfs
	for(var/turf/source in translation)
		if(ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND))
			continue
		source.scrape_away()

/// DEPRECATED. If you need to do this, look into shuttle_move_callbacks.dm
/proc/transport_turf_contents(turf/source, turf/target, ignore_background)
	var/turf/new_turf

	var/is_background = ignore_background && (source.turf_flags & TURF_FLAG_BACKGROUND)
	var/supported = FALSE // Whether or not there's an object in the turf which can support other objects.
	if(is_background)
		new_turf = target
	else
		new_turf = target.ChangeTurf(source.type, 1, 1)
		new_turf.transport_properties_from(source)

	for(var/obj/O in source)
		if(O.obj_flags & OBJ_FLAG_NOFALL)
			supported = TRUE
			break

	for(var/obj/O in source)
		if(O.simulated && (!is_background || supported || O.obj_flags & OBJ_FLAG_MOVES_UNSUPPORTED))
			O.forceMove(new_turf)
		else if(istype(O,/obj/effect)) // This is used for non-game objects like spawnpoints, so ignore the background check.
			var/obj/effect/E = O
			if(E.movable_flags & MOVABLE_FLAG_EFFECTMOVE)
				E.forceMove(new_turf)

	for(var/mob/M in source)
		if(is_background && !supported)
			continue
		if(isEye(M))
			continue // If we need to check for more mobs, I'll add a variable
		M.forceMove(new_turf)

	if(is_background)
		return list(new_turf, source)

	return new_turf
