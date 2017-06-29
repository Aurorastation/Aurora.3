#define CELL_ALIVE(VAL) (VAL == cell_live_value)
#define KILL_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_dead_value;
#define REVIVE_CELL(CELL, NEXT_MAP) NEXT_MAP[CELL] = cell_live_value;

/datum/random_map/automata
	descriptor = "generic caves"
	initial_wall_cell = 55
	var/iterations = 0               // Number of times to apply the automata rule.
	var/cell_live_value = WALL_CHAR  // Cell is alive if it has this value.
	var/cell_dead_value = FLOOR_CHAR // As above for death.
	var/cell_threshold = 5           // Cell becomes alive with this many live neighbors.

// Automata-specific procs and processing.
/datum/random_map/automata/generate_map()
	for(var/i = 1 to iterations)
		var/list/next_map[limit_x*limit_y]
		var/current_cell
		var/count
		var/is_not_border_left
		var/is_not_border_right

		if (!islist(map))
			set_map_size()

		for(var/x = 1 to limit_x)
			for(var/y = 1 to limit_y)
				current_cell = TRANSLATE_COORD(x, y)	// No validation done on this one; loop should be sane.
				count = 0

				is_not_border_left = (x != 1)
				is_not_border_right = (x != limit_x)

				if (CELL_ALIVE(map[current_cell])) // Center row.
					++count
				if (is_not_border_left && CELL_ALIVE(map[TRANSLATE_COORD(x - 1, y)]))
					++count
				if (is_not_border_right && CELL_ALIVE(map[TRANSLATE_COORD(x + 1, y)]))
					++count

				if (y != 1) // top row
					if (CELL_ALIVE(map[TRANSLATE_COORD(x, y - 1)]))
						++count
					if (is_not_border_left && CELL_ALIVE(map[TRANSLATE_COORD(x - 1, y - 1)]))
						++count
					if (is_not_border_right && CELL_ALIVE(map[TRANSLATE_COORD(x + 1, y - 1)]))
						++count

				if (y != limit_y) // bottom row
					if (CELL_ALIVE(map[TRANSLATE_COORD(x, y + 1)]))
						++count
					if (is_not_border_left && CELL_ALIVE(map[TRANSLATE_COORD(x - 1, y + 1)]))
						++count
					if (is_not_border_right && CELL_ALIVE(map[TRANSLATE_COORD(x + 1, y + 1)]))
						++count

				if(count >= cell_threshold)
					REVIVE_CELL(current_cell, next_map)
				else	// Nope. Can't be alive. Kill it.
					KILL_CELL(current_cell, next_map)

			CHECK_TICK

		map = next_map

/datum/random_map/automata/get_additional_spawns(value, turf/T)
	return

#undef KILL_CELL
#undef REVIVE_CELL
