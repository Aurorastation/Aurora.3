/datum/random_map/automata/cave_system
	iterations = 5
	descriptor = "moon caves"
	wall_type =  /turf/simulated/mineral
	floor_type = /turf/unsimulated/floor/asteroid/ash/rocky
	target_turf_type = /turf/unsimulated/mask
	var/mineral_sparse =  /turf/simulated/mineral/random
	var/mineral_rich = /turf/simulated/mineral/random/high_chance
	var/list/ore_turfs = list()

/datum/random_map/automata/cave_system/get_appropriate_path(var/value)
	switch(value)
		if(DOOR_CHAR)
			return mineral_sparse
		if(EMPTY_CHAR)
			return mineral_rich
		if(FLOOR_CHAR)
			return floor_type
		if(WALL_CHAR)
			return wall_type

/datum/random_map/automata/cave_system/get_map_char(var/value)
	switch(value)
		if(DOOR_CHAR)
			return "x"
		if(EMPTY_CHAR)
			return "X"
	return ..(value)

// Create ore turfs.
/datum/random_map/automata/cave_system/cleanup()
	for (var/i = 1 to (limit_x * limit_y))
		if (CELL_ALIVE(map[i]))
			ore_turfs += i

	game_log("ASGEN", "Found [ore_turfs.len] ore turfs.")
	var/ore_count = round(map.len/20)
	var/door_count = 0
	var/empty_count = 0
	while((ore_count>0) && (ore_turfs.len>0))

		if(!priority_process)
			CHECK_TICK

		var/check_cell = pick(ore_turfs)
		ore_turfs -= check_cell
		if(prob(75))
			map[check_cell] = DOOR_CHAR  // Mineral block
			door_count += 1
		else
			map[check_cell] = EMPTY_CHAR // Rare mineral block.
			empty_count += 1
		ore_count--

	game_log("ASGEN", "Set [door_count] turfs to random minerals.")
	game_log("ASGEN", "Set [empty_count] turfs to high-chance random minerals.")
	return 1

/datum/random_map/automata/cave_system/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1

	var/tmp_cell
	var/new_path
	var/num_applied = 0
	for (var/thing in block(locate(origin_x, origin_y, origin_z), locate(limit_x, limit_y, origin_z)))
		var/turf/T = thing
		new_path = null
		if (!T || (target_turf_type && !istype(T, target_turf_type)))
			continue

		tmp_cell = TRANSLATE_COORD(T.x, T.y)

		switch (map[tmp_cell])
			if(DOOR_CHAR)
				new_path = mineral_sparse
			if(EMPTY_CHAR)
				new_path = mineral_rich
			if(FLOOR_CHAR)
				new_path = floor_type
			if(WALL_CHAR)
				new_path = wall_type

		if (!new_path)
			continue

		num_applied += 1
		new new_path(T)

		CHECK_TICK

	game_log("ASGEN", "Applied [num_applied] turfs.")

/datum/random_map/automata/cave_system/high_yield
	descriptor = "high yield caves"
	wall_type = /turf/simulated/mineral
	mineral_sparse =  /turf/simulated/mineral/random/high_chance
	mineral_rich = /turf/simulated/mineral/random/higher_chance

/datum/random_map/automata/cave_system/chasms
	descriptor = "chasm caverns"
	wall_type =  /turf/unsimulated/mask
	floor_type = /turf/simulated/open/airless
	target_turf_type = /turf/unsimulated/chasm_mask
	mineral_sparse =  /turf/unsimulated/mask
	mineral_rich = /turf/unsimulated/mask

/datum/random_map/automata/cave_system/chasms/apply_to_map()
	if(!origin_x) origin_x = 1
	if(!origin_y) origin_y = 1
	if(!origin_z) origin_z = 1

	var/tmp_cell
	var/new_path
	var/num_applied = 0
	for (var/thing in block(locate(origin_x, origin_y, origin_z), locate(limit_x, limit_y, origin_z)))
		var/turf/T = thing
		new_path = null
		if (!T || (target_turf_type && !istype(T, target_turf_type)))
			continue

		tmp_cell = TRANSLATE_COORD(T.x, T.y)

		switch (map[tmp_cell])
			if(DOOR_CHAR)
				new_path = mineral_sparse
			if(EMPTY_CHAR)
				new_path = mineral_rich
			if(FLOOR_CHAR)
				var/turf/below = GET_BELOW(T)
				if(below)
					var/area/below_area = below.loc		// Let's just assume that the turf is not in nullspace.
					if(below_area.station_area)
						new_path = wall_type
					else if(below.density)
						new_path = wall_type
					else
						new_path = floor_type

			if(WALL_CHAR)
				new_path = wall_type

		if (!new_path)
			continue

		num_applied += 1
		new new_path(T)

		CHECK_TICK

	game_log("ASGEN", "Applied [num_applied] turfs.")

/datum/random_map/automata/cave_system/chasms/cleanup()
	return

/datum/random_map/automata/cave_system/chasms/surface
	descriptor = "chasm surface"
	wall_type = /turf/unsimulated/floor/asteroid/ash
	floor_type = /turf/simulated/open/airless
	target_turf_type = /turf/unsimulated/chasm_mask
	mineral_sparse = /turf/unsimulated/floor/asteroid/ash
	mineral_rich = /turf/unsimulated/floor/asteroid/ash
