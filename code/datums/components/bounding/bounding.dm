/// Represents a bounding box drawn from a (not necessarily) central atom. Used for shuttles and their LZs, but potentially other implementations.
/datum/component/bounding
	///the atom drawing this bounding box
	var/atom/parent_atom
	///size of covered area, perpendicular to dir.
	var/width = 0
	///size of covered area, parallel to dir.
	var/height = 0
	///position relative to covered area, perpendicular to dir.
	var/w_offset = 0
	///position relative to covered area, parallel to dir.
	var/h_offset = 0

#define WORLDMAXX_CUTOFF (world.maxx + 1)
#define WORLDMAXY_CUTOFF (world.maxy + 1)

/datum/component/bounding/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	parent_atom = parent
	rebuild_bounding_box()

	RegisterSignal(parent_atom, COMSIG_QDELETING, PROC_REF(stop_bounding))
	RegisterSignal(parent_atom, COMSIG_MOVABLE_MOVED, PROC_REF(rebuild_bounding_box))

/datum/component/bounding/Destroy(force)
	if(parent || parent_atom)
		UnregisterSignal(parent_atom, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
		stop_bounding()
	return ..()

/datum/component/bounding/proc/stop_bounding()
	parent.RemoveComponentSource(src)
	parent_atom = null
	if(!QDELETED(src))
		qdel(src)

/datum/component/bounding/proc/rebuild_bounding_box()
	return

/datum/component/bounding/area/rebuild_bounding_box()
	var/min_x = WORLDMAXX_CUTOFF
	var/min_y = WORLDMAXY_CUTOFF
	var/max_x = -1
	var/max_y = -1

	for(var/area/subarea as anything in bounding_areas)
		for(var/turf/T as anything in subarea.get_turfs_from_all_zlevels())
			min_x = min(T.x, min_x)
			max_x = max(T.x, max_x)
			min_y = min(T.y, min_y)
			max_y = max(T.y, max_y)
		CHECK_TICK

	if(min_x == WORLDMAXX_CUTOFF || max_x == -1)
		CRASH("Failed to locate boundaries when iterating through bounded areas.")
	if(min_y == WORLDMAXY_CUTOFF || max_y == -1)
		CRASH("Failed to locate boundaries when iterating through bounded areas.")

	var/width = (max_x - min_x) + 1
	var/height = (max_y - min_y) + 1
	var/x_offset = parent_atom.x - min_x + 1
	var/y_offset = parent_atom.y - min_y + 1

	if(parent_atom.dir in list(EAST, WEST))
		src.width = height
		src.height = width
	else
		src.width = width
		src.height = height

	switch(parent_atom.dir)
		if(NORTH)
			w_offset = x_offset - 1
			h_offset = y_offset - 1
		if(EAST)
			w_offset = height - y_offset
			h_offset = x_offset - 1
		if(SOUTH)
			w_offset = width - x_offset
			h_offset = height - y_offset
		if(WEST)
			w_offset = y_offset - 1
			h_offset = width - x_offset

#undef WORLDMAXX_CUTOFF
#undef WORLDMAXY_CUTOFF

///returns a list(x0,y0, x1,y1) where points 0 and 1 are bounding corners of the projected rectangle
/datum/component/bounding/proc/return_coords(_x, _y, _dir)
	if(_dir == null)
		_dir = parent_atom.dir
	if(_x == null)
		_x = parent_atom.x
	if(_y == null)
		_y = parent_atom.y

	//byond's sin and cos functions are inaccurate. This is faster and perfectly accurate
	var/cos = 1
	var/sin = 0
	switch(_dir)
		if(WEST)
			cos = 0
			sin = 1
		if(SOUTH)
			cos = -1
			sin = 0
		if(EAST)
			cos = 0
			sin = -1

	return list(
		_x + (-w_offset*cos) - (-h_offset*sin),
		_y + (-w_offset*sin) + (-h_offset*cos),
		_x + (-w_offset+width-1)*cos - (-h_offset+height-1)*sin,
		_y + (-w_offset+width-1)*sin + (-h_offset+height-1)*cos,
	)

///returns turfs within our projected rectangle in no particular order
/datum/component/bounding/proc/return_turfs()
	var/list/coords = return_coords()
	return block(
		coords[1], coords[2], parent_atom.z,
		coords[3], coords[4], parent_atom.z
	)

///returns turfs within our projected rectangle in a specific order.this ensures that turfs are copied over in the same order, regardless of any rotation
/datum/component/bounding/proc/return_ordered_turfs(_x, _y, _z, _dir)
	var/cos = 1
	var/sin = 0
	switch(_dir)
		if(WEST)
			cos = 0
			sin = 1
		if(SOUTH)
			cos = -1
			sin = 0
		if(EAST)
			cos = 0
			sin = -1

	. = list()

	for(var/dx in 0 to width-1)
		var/compX = dx-w_offset
		for(var/dy in 0 to height-1)
			var/compY = dy-h_offset
			var/turf/T = locate(_x + compX*cos - compY*sin, _y + compY*cos + compX*sin, _z)
			.[T] = NONE

/// Bounding box governed by bespoke areas
/datum/component/bounding/area
	///areas making up our bounding box
	var/list/bounding_areas

/datum/component/bounding/area/Initialize(bounding_areas = list())
	if(!islist(bounding_areas) && isarea(bounding_areas))
		bounding_areas = list(bounding_areas)
	else if(!LAZYLEN(bounding_areas))
		return COMPONENT_INCOMPATIBLE

	src.bounding_areas = bounding_areas
	return ..()

/datum/component/bounding/area/Destroy(force)
	if(bounding_areas)
		stop_bounding()
	return ..()

/datum/component/bounding/area/stop_bounding()
	bounding_areas = null
	return ..()

/// Flood-fill BFS to build a bounding box
/datum/component/bounding/bfs
	var/bounding_max_height = LANDING_ZONE_RADIUS * 4
	var/bounding_max_width = LANDING_ZONE_RADIUS * 4

/datum/component/bounding/bfs/Initialize(max_w, max_h)
	if(max_w)
		bounding_max_width = max_w
	if(max_h)
		bounding_max_height = max_h
	return ..()

/datum/component/bounding/bfs/rebuild_bounding_box()
	var/turf/T = get_turf(parent_atom)
	var/list/queue = list(T)
	var/list/visited = list(T)
	var/min_x = T.x
	var/min_y = T.y
	var/max_x = T.x
	var/max_y = T.y

	var/_width
	var/_height

	while(queue.len)
		CHECK_TICK
		var/turf/dequeued = queue[1]
		queue.Remove(dequeued)
		_width = max_x - min_x + 1
		_height = max_y - min_y + 1

		for(var/turf/neighbor as anything in TURF_NEIGHBORS(dequeued))
			if(neighbor in visited)
				continue
			visited.Add(neighbor)
			if(neighbor.density == TRUE)
				continue
			// we do not need 100*100 landing zones :1984:
			if(_height >= bounding_max_height && (neighbor.y > max_y || neighbor.y < min_y))
				continue
			if(_width >= bounding_max_width && (neighbor.x > max_x || neighbor.x < min_x))
				continue

			min_x = min(neighbor.x, min_x)
			min_y = min(neighbor.y, min_y)
			max_x = max(neighbor.x, max_x)
			max_y = max(neighbor.y, max_y)
			queue.Add(neighbor)

	var/mark_x_offset = T.x - min_x + 1
	var/mark_y_offset = T.y - min_y + 1

	if(parent_atom.dir in list(EAST, WEST))
		width = _height
		height = _width
	else
		width = _width
		height = _height

	switch(parent_atom.dir)
		if(NORTH)
			w_offset = mark_x_offset - 1
			h_offset = mark_y_offset - 1
		if(EAST)
			w_offset = height - mark_y_offset
			h_offset = mark_x_offset - 1
		if(SOUTH)
			w_offset = width - mark_x_offset
			h_offset = height - mark_y_offset
		if(WEST)
			w_offset = mark_y_offset - 1
			h_offset = width - mark_x_offset
