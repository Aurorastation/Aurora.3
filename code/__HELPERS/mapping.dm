
#define WORLDMAXX_CUTOFF (world.maxx + 1 - TRANSITIONEDGE)
#define WORLDMAXY_CUTOFF (world.maxy + 1 - TRANSITIONEDGE)

/// Returns a heightmap (2D array) where heightmap[X][Y] = col_size, where col_size is 1 if the turf is clear, 0 if it is obstructed, and -1 if it is invalid
/proc/heightmap_from_turfs(list/turfs, x_buffer = TRANSITIONEDGE, y_buffer = TRANSITIONEDGE, ignore_density = FALSE)
	var/list/heightmap[world.maxx][world.maxy]
	var/maxx = world.maxx - x_buffer + 1
	var/maxy = world.maxy - y_buffer + 1
	for(var/turf/T as anything in turfs)
		heightmap[T.x][T.y] = (T.turf_flags & TURF_NORUINS || T.x <= x_buffer || T.y <= y_buffer || T.x >= maxx || T.y >= maxy) ? -1 : initial(T.density) && !ignore_density ? 0 : 1
	return heightmap

/// Given a heightmap (a 2D array representing X/Y coordinates), find the largest rectangular area where each coordinate point meets or exceeds the `want` value.
/proc/maximal_rectangle(list/heightmap, desired_height = LANDING_ZONE_RADIUS*2, desired_width = LANDING_ZONE_RADIUS*2)
	var/xcrds = heightmap.len
	var/ycrds = length(heightmap[1])

	var/list/widths[ycrds]
	var/max_area = 0

	var/min_x = INFINITY
	var/min_y = INFINITY
	var/max_x = -1
	var/max_y = -1

	for(var/xcrd in 1 to xcrds) // X: 1 to 255
		CHECK_TICK
		for(var/ycrd in 1 to ycrds) // Y: 1 to 255
			if(heightmap[xcrd][ycrd] == 1)
				widths[ycrd] += 1
			else
				widths[ycrd] = 0

		// get max area
		var/col_size = length(widths)
		var/list/stack = list()

		for(var/i in 1 to col_size)
			while(stack.len && widths[stack[stack.len]] >= widths[i])
				var/popped = stack[stack.len]
				stack.len--
				var/stack_empty = stack.len == 0

				var/height = stack_empty ? i : i - stack[stack.len]
				var/area = widths[popped] * height
				if(area > max_area)
					max_area = area
					min_y = stack_empty ? 1 : stack[stack.len] + 1
					max_y = i
					min_x = xcrd - widths[popped] + 1
					max_x = xcrd

			stack.Add(i)

		while(stack.len)
			var/popped = stack[stack.len]
			stack.len--
			var/stack_empty = stack.len == 0

			var/height = stack_empty ? col_size : col_size - stack[stack.len]
			var/area = widths[popped] * height
			if(area > max_area)
				max_area = area
				min_y = stack_empty ? 1 : stack[stack.len] + 1
				max_y = col_size
				min_x = xcrd - widths[popped] + 1
				max_x = xcrd

	var/found_width = (max_x - min_x + 1)
	var/found_height = (max_y - min_y + 1)
	var/should_clear = (found_width < desired_width || found_height < desired_height)
	if(min_x == INFINITY || min_y == INFINITY || max_x == -1 || max_y == -1)
		CRASH("Finding maximal rectangle failed. This should not happen.")

	return list("min_x" = min_x, "min_y" = min_y, "max_x" = max_x, "max_y" = max_y, "clearing" = should_clear)

#undef WORLDMAXX_CUTOFF
#undef WORLDMAXY_CUTOFF
