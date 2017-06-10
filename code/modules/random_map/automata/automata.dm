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
	for(var/i=1;i<=iterations;i++)
		iterate(i)

/datum/random_map/automata/get_additional_spawns(var/value, var/turf/T)
	return

/datum/random_map/automata/proc/iterate(var/iteration)
	var/list/next_map[limit_x*limit_y]
	var/tmp_cell
	var/current_cell
	var/count
	if (!islist(map))
		set_map_size()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			PREPARE_CELL(x,y)
			current_cell = tmp_cell
			next_map[current_cell] = map[current_cell]
			count = 0

			// Every attempt to place this in a proc or a list has resulted in
			// the generator being totally bricked and useless. Fuck it. We're
			// hardcoding this shit. Feel free to rewrite and PR a fix. ~ Z
			PREPARE_CELL(x,y)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x+1,y+1)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x-1,y-1)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x+1,y-1)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x-1,y+1)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x-1,y)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x,y-1)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x+1,y)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++
			PREPARE_CELL(x,y+1)
			if (tmp_cell && CELL_ALIVE(map[tmp_cell])) 
				count++

			if(count >= cell_threshold)
				REVIVE_CELL(current_cell, next_map)
			else
				KILL_CELL(current_cell, next_map)
				
		CHECK_TICK

	map = next_map

/datum/random_map/automata/proc/revive_cell(var/target_cell, var/list/use_next_map, var/final_iter)
	if(!use_next_map)
		use_next_map = map
	use_next_map[target_cell] = cell_live_value

/datum/random_map/automata/proc/kill_cell(var/target_cell, var/list/use_next_map, var/final_iter)
	if(!use_next_map)
		use_next_map = map
	use_next_map[target_cell] = cell_dead_value

#undef KILL_CELL
#undef REVIVE_CELL
