#define SPRITE_EDITOR_COORD(x, y) "[x]:[y]"
#define SPRITE_EDITOR_IN_BOUNDS(x, y) (x > 0 && x <= width && y > 0 && y <= height)
#define SPRITE_EDITOR_COLORS_EQUAL(a, b) ((a == b) || (endswith(a, "00") && endswith(b, "00")))
#define SPRITE_EDITOR_SHOULD_ADD(x, y) (!coord_cache[SPRITE_EDITOR_COORD(x, y)] && SPRITE_EDITOR_IN_BOUNDS(x, y) && SPRITE_EDITOR_COLORS_EQUAL(grid[y][x], target_color))
#define SPRITE_EDITOR_ADD(x, y) \
	points += list(list((x) - 1, (y) - 1, target_color)); \
	coord_cache[SPRITE_EDITOR_COORD(x, y)] = TRUE

/// Scanline flood fill. Returned coordinates are zero-indexed for the UI.
/proc/sprite_editor_flood_fill(list/grid, x, y, width, height)
	var/target_color = grid[y][x]
	var/list/coord_cache = list()
	var/list/points = list()
	var/list/coord_queue = list(x, x, y, 1, x, x, y - 1, -1)
	while(length(coord_queue))
		var/span_start = coord_queue[1]
		var/column = span_start
		var/span_end = coord_queue[2]
		var/row = coord_queue[3]
		var/row_shift = coord_queue[4]
		coord_queue.Cut(1, 5)
		if(SPRITE_EDITOR_SHOULD_ADD(column, row))
			while(SPRITE_EDITOR_SHOULD_ADD(column - 1, row))
				SPRITE_EDITOR_ADD(column - 1, row)
				column--
			if(column < span_start)
				coord_queue += list(column, span_start - 1, row - row_shift, -row_shift)
		while(span_start <= span_end)
			while(SPRITE_EDITOR_SHOULD_ADD(span_start, row))
				SPRITE_EDITOR_ADD(span_start, row)
				span_start++
			if(span_start > column)
				coord_queue += list(column, span_start - 1, row + row_shift, row_shift)
			if(span_start - 1 > span_end)
				coord_queue += list(span_end + 1, span_start - 1, row - row_shift, -row_shift)
			span_start++
			while(span_start < span_end && !SPRITE_EDITOR_SHOULD_ADD(span_start, row))
				span_start++
			column = span_start
	return points

#undef SPRITE_EDITOR_ADD
#undef SPRITE_EDITOR_SHOULD_ADD
#undef SPRITE_EDITOR_COLORS_EQUAL
#undef SPRITE_EDITOR_IN_BOUNDS
#undef SPRITE_EDITOR_COORD
