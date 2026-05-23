/*
 * subtypes/smart.dm
 * Smart utility circuits such as pathfinding and higher-level automation helpers.
 */

/// smart: Integrated circuit component..
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/smart
	category_text = "Smart"
	spawn_flags = 0

/// basic pathfinder: Outputs the direction of the selected target.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/smart/basic_pathfinder
	name = "basic pathfinder"
	desc = "Outputs the direction of the selected target."
	extended_desc = "This circuit uses a miniaturized integrated camera to determine where the target is. If the machine \
	cannot see the target, it will not be able to calculate the correct direction."
	icon_state = "numberpad"
	complexity = 5
	inputs = list(
		"target" = IC_PINTYPE_REF,
		"ignore obstacles" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"dir" = IC_PINTYPE_DIR
	)
	activators = list(
		"calculate dir" = IC_PINTYPE_PULSE_IN,
		"on calculated" = IC_PINTYPE_PULSE_OUT,
		"not calculated" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 400

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/smart/basic_pathfinder/do_work()
	// Stores `I` state used by this integrated electronics object.
	var/datum/integrated_io/I = inputs[1]
	set_pin_data(IC_OUTPUT, 1, null)

	if(!isweakref(I.data))
		activate_pin(3)
		return

	var/datum/weakref/W = I.data
	// Stores `A` state used by this integrated electronics object.
	var/atom/A = W.resolve()

	if(!A)
		activate_pin(3)
		return

	if(!(A in view(get_turf(src))))
		push_data()
		activate_pin(3)
		return

	if(get_pin_data(IC_INPUT, 2))
		set_pin_data(IC_OUTPUT, 1, get_dir(get_turf(src), get_turf(A)))
	else
		set_pin_data(IC_OUTPUT, 1, get_dir(get_turf(src), get_step_towards2(get_turf(src), A)))

	push_data()
	activate_pin(2)

/// coordinate pathfinder: Outputs the direction of the selected target.
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/smart/coord_basic_pathfinder
	name = "coordinate pathfinder"
	desc = "Outputs the direction of the selected target."
	extended_desc = "This circuit uses absolute coordinates to determine where the target is. \
	This circuit will only work while inside an assembly."
	icon_state = "numberpad"
	complexity = 5
	inputs = list(
		"X" = IC_PINTYPE_NUMBER,
		"Y" = IC_PINTYPE_NUMBER,
		"ignore obstacles" = IC_PINTYPE_BOOLEAN
	)
	outputs = list(
		"dir" = IC_PINTYPE_DIR,
		"distance" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"calculate dir" = IC_PINTYPE_PULSE_IN,
		"on calculated" = IC_PINTYPE_PULSE_OUT,
		"not calculated" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 400

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/smart/coord_basic_pathfinder/do_work()
	if(!assembly)
		activate_pin(3)
		return

	var/turf/T = get_turf(assembly)
	if(!T)
		activate_pin(3)
		return

	var/target_x = round(clamp(get_pin_data(IC_INPUT, 1), 1, world.maxx))
	// Stores `target_y` state used by this integrated electronics object.
	var/target_y = round(clamp(get_pin_data(IC_INPUT, 2), 1, world.maxy))
	// Stores `A` state used by this integrated electronics object.
	var/turf/A = locate(target_x, target_y, T.z)

	set_pin_data(IC_OUTPUT, 1, null)

	if(!A || A == T)
		push_data()
		activate_pin(3)
		return

	if(get_pin_data(IC_INPUT, 3))
		set_pin_data(IC_OUTPUT, 1, get_dir(T, A))
	else
		set_pin_data(IC_OUTPUT, 1, get_dir(T, get_step_towards2(T, A)))

	set_pin_data(IC_OUTPUT, 2, sqrt((A.x - T.x) * (A.x - T.x) + (A.y - T.y) * (A.y - T.y)))
	push_data()
	activate_pin(2)

/// coordinate navigator: This complex circuit calculates a walkable path toward absolute coordinates. This circuit finds a walkable cardinal path toward absolute coordinates. It can route around walls, long barriers, and U-shaped obstructions....
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/smart/coordinate_navigator
	name = "coordinate navigator"
	desc = "This complex circuit calculates a walkable path toward absolute coordinates."
	extended_desc = "This circuit finds a walkable cardinal path toward absolute coordinates. It can route around walls, long barriers, and U-shaped obstructions within its search limit. It is intended for drones using a locomotion circuit."
	icon_state = "numberpad"
	complexity = 20
	w_class = WEIGHT_CLASS_TINY
	size = 3
	power_draw_per_use = 800
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	// Stores `current_path` state used by this integrated electronics object.
	var/list/current_path = list()
	// Stores `path_index` state used by this integrated electronics object.
	var/path_index = 1
	// Stores `last_target_x` state used by this integrated electronics object.
	var/last_target_x = null
	// Stores `last_target_y` state used by this integrated electronics object.
	var/last_target_y = null
	// Stores `max_search_nodes` state used by this integrated electronics object.
	var/max_search_nodes = 600

	inputs = list(
		"target X" = IC_PINTYPE_NUMBER,
		"target Y" = IC_PINTYPE_NUMBER,
		"recalculate if blocked" = IC_PINTYPE_BOOLEAN,
		"max search nodes" = IC_PINTYPE_NUMBER
	)

	outputs = list(
		"direction" = IC_PINTYPE_DIR,
		"distance remaining" = IC_PINTYPE_NUMBER,
		"path length" = IC_PINTYPE_NUMBER,
		"status" = IC_PINTYPE_STRING
	)

	activators = list(
		"calculate path" = IC_PINTYPE_PULSE_IN,
		"step path" = IC_PINTYPE_PULSE_IN,
		"clear path" = IC_PINTYPE_PULSE_IN,
		"on step ready" = IC_PINTYPE_PULSE_OUT,
		"on arrived" = IC_PINTYPE_PULSE_OUT,
		"on failed" = IC_PINTYPE_PULSE_OUT
	)

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/smart/coordinate_navigator/do_work(activator_id)
	if(!assembly)
		set_navigation_failure("Circuit is not installed in an assembly.")
		return

	var/active_pin = activator_id

	if(istype(active_pin, /datum/integrated_io))
		active_pin = activators.Find(active_pin)

	if(istext(active_pin))
		for(var/i = 1 to activators.len)
			var/datum/integrated_io/A = activators[i]
			if(A.name == active_pin)
				active_pin = i
				break

	if(!isnum(active_pin))
		active_pin = 1

	switch(active_pin)
		if(1)
			calculate_path()
			return
		if(2)
			step_path()
			return
		if(3)
			clear_path()
			return

	set_navigation_failure("Unknown navigation activator: [activator_id].")

/// Implements `clear_path` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/clear_path()
	current_path = list()
	path_index = 1
	last_target_x = null
	last_target_y = null

	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, 0)
	set_pin_data(IC_OUTPUT, 3, 0)
	set_pin_data(IC_OUTPUT, 4, "Path cleared.")
	push_data()

/// Implements `calculate_path` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/calculate_path()
	// Stores `start` state used by this integrated electronics object.
	var/turf/start = get_turf(assembly)
	if(!start)
		set_navigation_failure("No assembly turf.")
		return

	var/target_x = round(get_pin_data(IC_INPUT, 1))
	// Stores `target_y` state used by this integrated electronics object.
	var/target_y = round(get_pin_data(IC_INPUT, 2))

	if(!isnum(target_x) || !isnum(target_y))
		set_navigation_failure("Invalid target coordinates.")
		return

	target_x = clamp(target_x, 1, world.maxx)
	target_y = clamp(target_y, 1, world.maxy)

	// Stores `goal` state used by this integrated electronics object.
	var/turf/goal = locate(target_x, target_y, start.z)
	if(!goal)
		set_navigation_failure("Target turf does not exist.")
		return

	if(start == goal)
		current_path = list(start)
		path_index = 1
		last_target_x = target_x
		last_target_y = target_y

		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, 1)
		set_pin_data(IC_OUTPUT, 4, "Already at target.")
		push_data()
		activate_pin(5)
		return

	var/node_limit = round(get_pin_data(IC_INPUT, 4))
	if(!isnum(node_limit) || node_limit <= 0)
		node_limit = max_search_nodes

	// Stores `new_path` state used by this integrated electronics object.
	var/list/new_path = find_path_to_turf(start, goal, node_limit)

	if(!new_path || !new_path.len)
		set_navigation_failure("No path found within [node_limit] nodes.")
		return

	current_path = new_path
	path_index = 2
	last_target_x = target_x
	last_target_y = target_y

	output_next_step("Path calculated.")

/// Implements `step_path` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/step_path()
	// Stores `start` state used by this integrated electronics object.
	var/turf/start = get_turf(assembly)
	if(!start)
		set_navigation_failure("No assembly turf.")
		return

	var/target_x = round(get_pin_data(IC_INPUT, 1))
	// Stores `target_y` state used by this integrated electronics object.
	var/target_y = round(get_pin_data(IC_INPUT, 2))

	if(!isnum(target_x) || !isnum(target_y))
		set_navigation_failure("Invalid target coordinates.")
		return

	target_x = clamp(target_x, 1, world.maxx)
	target_y = clamp(target_y, 1, world.maxy)

	if(!current_path || !current_path.len)
		calculate_path()
		return

	if(target_x != last_target_x || target_y != last_target_y)
		calculate_path()
		return

	advance_path_index(start)

	if(path_index > current_path.len)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, current_path.len)
		set_pin_data(IC_OUTPUT, 4, "Arrived.")
		push_data()
		activate_pin(5)
		return

	var/turf/next_turf = current_path[path_index]
	if(!next_turf || turf_is_blocked_for_navigation(next_turf))
		if(get_pin_data(IC_INPUT, 3))
			calculate_path()
			return

		set_navigation_failure("Next path turf is blocked.")
		return

	output_next_step("Step ready.")

/// Implements `output_next_step` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/output_next_step(status)
	// Stores `start` state used by this integrated electronics object.
	var/turf/start = get_turf(assembly)
	if(!start)
		set_navigation_failure("No assembly turf.")
		return

	advance_path_index(start)

	if(path_index > current_path.len)
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, 0)
		set_pin_data(IC_OUTPUT, 3, current_path.len)
		set_pin_data(IC_OUTPUT, 4, "Arrived.")
		push_data()
		activate_pin(5)
		return

	var/turf/next_turf = current_path[path_index]
	if(!next_turf)
		set_navigation_failure("Path index points to no turf.")
		return

	if(get_dist(start, next_turf) > 1)
		if(get_pin_data(IC_INPUT, 3))
			calculate_path()
			return

		set_navigation_failure("Path is stale.")
		return

	if(turf_is_blocked_for_navigation(next_turf))
		if(get_pin_data(IC_INPUT, 3))
			calculate_path()
			return

		set_navigation_failure("Next path turf is blocked.")
		return

	var/dir_to_next = get_dir(start, next_turf)
	// Stores `distance_remaining` state used by this integrated electronics object.
	var/distance_remaining = max(0, current_path.len - path_index + 1)

	set_pin_data(IC_OUTPUT, 1, dir_to_next)
	set_pin_data(IC_OUTPUT, 2, distance_remaining)
	set_pin_data(IC_OUTPUT, 3, current_path.len)
	set_pin_data(IC_OUTPUT, 4, status)
	push_data()
	activate_pin(4)

/// Implements `advance_path_index` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/advance_path_index(turf/current_turf)
	while(path_index <= current_path.len && current_path[path_index] == current_turf)
		path_index++

/// Sets `navigation_failure` and performs any required follow-up bookkeeping.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/set_navigation_failure(status)
	set_pin_data(IC_OUTPUT, 1, null)
	set_pin_data(IC_OUTPUT, 2, 0)
	set_pin_data(IC_OUTPUT, 3, current_path ? current_path.len : 0)
	set_pin_data(IC_OUTPUT, 4, status)
	push_data()
	activate_pin(6)

/// Implements `find_path_to_turf` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/find_path_to_turf(turf/start, turf/goal, node_limit)
	if(!start || !goal)
		return null

	if(turf_is_blocked_for_navigation(goal))
		return null

	var/list/queue = list(start)
	// Stores `visited` state used by this integrated electronics object.
	var/list/visited = list()
	// Stores `parents` state used by this integrated electronics object.
	var/list/parents = list()

	visited[start] = TRUE

	// Stores `head` state used by this integrated electronics object.
	var/head = 1
	// Stores `nodes_checked` state used by this integrated electronics object.
	var/nodes_checked = 0
	// Stores `found_goal` state used by this integrated electronics object.
	var/found_goal = FALSE

	while(head <= queue.len)
		var/turf/current = queue[head]
		head++
		nodes_checked++

		if(nodes_checked > node_limit)
			break

		if(current == goal)
			found_goal = TRUE
			break

		for(var/check_dir in get_prioritized_dirs(current, goal))
			var/turf/next_turf = get_step(current, check_dir)
			if(!next_turf)
				continue

			if(visited[next_turf])
				continue

			if(turf_is_blocked_for_navigation(next_turf))
				continue

			visited[next_turf] = TRUE
			parents[next_turf] = current
			queue += next_turf

	if(!found_goal)
		return null

	var/list/reversed_path = list()
	// Stores `walk` state used by this integrated electronics object.
	var/turf/walk = goal

	while(walk)
		reversed_path += walk

		if(walk == start)
			break

		walk = parents[walk]

	if(!walk)
		return null

	var/list/final_path = list()
	for(var/i = reversed_path.len, i >= 1, i--)
		final_path += reversed_path[i]

	return final_path

/// Returns the current `prioritized_dirs` value or object used by this electronics code.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/get_prioritized_dirs(turf/current, turf/goal)
	// Stores `dirs` state used by this integrated electronics object.
	var/list/dirs = list()

	if(!current || !goal)
		return GLOB.cardinals

	var/dx = goal.x - current.x
	// Stores `dy` state used by this integrated electronics object.
	var/dy = goal.y - current.y

	if(abs(dx) >= abs(dy))
		if(dx > 0)
			dirs += EAST
		else if(dx < 0)
			dirs += WEST

		if(dy > 0)
			dirs += NORTH
		else if(dy < 0)
			dirs += SOUTH
	else
		if(dy > 0)
			dirs += NORTH
		else if(dy < 0)
			dirs += SOUTH

		if(dx > 0)
			dirs += EAST
		else if(dx < 0)
			dirs += WEST

	for(var/D in GLOB.cardinals)
		if(!(D in dirs))
			dirs += D

	return dirs

/// Implements `turf_is_blocked_for_navigation` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_navigator/proc/turf_is_blocked_for_navigation(turf/T)
	if(!T)
		return TRUE

	if(T.density)
		return TRUE

	for(var/atom/movable/AM in T)
		if(AM == assembly)
			continue

		if(AM.density)
			return TRUE

	return FALSE

/// coordinate command parser: Parses simple coordinate commands into X and Y number outputs. This circuit parses text commands such as 'GOTO 25 56', '25 56', 'X 25 Y 56', or 'X=25 Y=56'. It outputs target X and Y coordinates for use with a coordin....
/// Wire inputs, pulse activators, and route outputs according to the pin definitions below.
/obj/item/integrated_circuit/smart/coordinate_command_parser
	name = "coordinate command parser"
	desc = "Parses simple coordinate commands into X and Y number outputs."
	extended_desc = "This circuit parses text commands such as 'GOTO 25 56', '25 56', 'X 25 Y 56', or 'X=25 Y=56'. It outputs target X and Y coordinates for use with a coordinate navigator."
	icon_state = "numberpad"
	complexity = 6
	w_class = WEIGHT_CLASS_TINY
	size = 1
	power_draw_per_use = 200
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

	inputs = list(
		"command" = IC_PINTYPE_STRING
	)

	outputs = list(
		"target X" = IC_PINTYPE_NUMBER,
		"target Y" = IC_PINTYPE_NUMBER,
		"valid" = IC_PINTYPE_BOOLEAN,
		"status" = IC_PINTYPE_STRING
	)

	activators = list(
		"parse command" = IC_PINTYPE_PULSE_IN,
		"on parsed" = IC_PINTYPE_PULSE_OUT,
		"on failed" = IC_PINTYPE_PULSE_OUT
	)

/// Performs the circuit operation: pull inputs, compute results, write outputs, and pulse activators as needed.
/obj/item/integrated_circuit/smart/coordinate_command_parser/do_work()
	pull_data()

	// Stores `command` state used by this integrated electronics object.
	var/command = get_pin_data(IC_INPUT, 1)

	if(!istext(command) || !length(command))
		set_parse_result(null, null, FALSE, "No command.")
		return

	var/list/numbers = extract_numbers_from_command(command)

	if(!numbers || numbers.len < 2)
		set_parse_result(null, null, FALSE, "Command needs two numbers.")
		return

	var/target_x = round(numbers[1])
	// Stores `target_y` state used by this integrated electronics object.
	var/target_y = round(numbers[2])

	target_x = clamp(target_x, 1, world.maxx)
	target_y = clamp(target_y, 1, world.maxy)

	set_parse_result(target_x, target_y, TRUE, "Parsed coordinates: [target_x], [target_y].")

/// Sets `parse_result` and performs any required follow-up bookkeeping.
/obj/item/integrated_circuit/smart/coordinate_command_parser/proc/set_parse_result(target_x, target_y, valid, status)
	set_pin_data(IC_OUTPUT, 1, target_x)
	set_pin_data(IC_OUTPUT, 2, target_y)
	set_pin_data(IC_OUTPUT, 3, valid)
	set_pin_data(IC_OUTPUT, 4, status)
	push_data()

	if(valid)
		activate_pin(2)
	else
		activate_pin(3)

/// Implements `extract_numbers_from_command` behavior for this integrated electronics type.
/obj/item/integrated_circuit/smart/coordinate_command_parser/proc/extract_numbers_from_command(command)
	// Stores `numbers` state used by this integrated electronics object.
	var/list/numbers = list()
	// Stores `current_number` state used by this integrated electronics object.
	var/current_number = ""
	// Stores `reading_number` state used by this integrated electronics object.
	var/reading_number = FALSE
	// Stores `allow_negative` state used by this integrated electronics object.
	var/allow_negative = TRUE

	for(var/i = 1 to length(command))
		var/char = copytext(command, i, i + 1)

		if(char >= "0" && char <= "9")
			current_number += char
			reading_number = TRUE
			allow_negative = FALSE
			continue

		if(char == "-" && allow_negative)
			current_number += char
			reading_number = TRUE
			allow_negative = FALSE
			continue

		if(reading_number)
			var/parsed = text2num(current_number)
			if(!isnull(parsed))
				numbers += parsed

			current_number = ""
			reading_number = FALSE

		allow_negative = TRUE

	if(reading_number)
		var/parsed = text2num(current_number)
		if(!isnull(parsed))
			numbers += parsed

	return numbers
