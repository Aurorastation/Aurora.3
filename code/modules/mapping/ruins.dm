GLOBAL_LIST_EMPTY(banned_ruin_ids)

/proc/seedRuins(list/zlevels, budget, list/potentialRuins, allowed_area = /area/space, var/maxx = world.maxx, var/maxy = world.maxy, ignore_sector = FALSE)
	if (!length(zlevels))
		UNLINT(log_module_ruins_warning("No Z levels provided - Not generating ruins"))
		return

	for (var/z in zlevels)
		var/turf/check = locate(1, 1, z)
		if (!check)
			UNLINT(log_module_ruins_warning("Z level [z] does not exist - Not generating ruins"))
			return

	var/remaining = budget

	var/list/available = list()
	var/list/selected = list()
	var/list/force_spawn = list()

	var/list/selected_log = list()

	/// List of ruin paths we've already processed as potential ruins, so we don't get stuck in an infinite loop if there's a cross-reference
	var/list/handled_ruin_paths = list()
	while(length(potentialRuins) > 0)
		var/datum/map_template/ruin/ruin = pick(potentialRuins)

		if((ruin.id in GLOB.banned_ruin_ids) || (ruin.type in handled_ruin_paths))
			potentialRuins -= ruin
			handled_ruin_paths += ruin.type
			continue

		if((ruin.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED) && (ruin.spawns_in_current_sector()))
			force_spawn |= ruin
			for(var/ruin_path in ruin.force_ruins)
				var/datum/map_template/ruin/force_ruin = new ruin_path
				force_spawn |= force_ruin
			potentialRuins -= ruin
			handled_ruin_paths += ruin.type
			continue

		if(!(ruin.spawns_in_current_sector()) && !ignore_sector)
			potentialRuins -= ruin
			handled_ruin_paths += ruin.type
			continue

		if((ruin.template_flags & TEMPLATE_FLAG_PORT_SPAWN))
			if(SSmapping.is_port_call_day())
				force_spawn |= ruin
				for(var/ruin_path in ruin.force_ruins)
					var/datum/map_template/ruin/force_ruin = new ruin_path
					force_spawn |= force_ruin
			// No matter if it spawns or not, we want it removed from further consideration, it either spawns here or not at all
			potentialRuins -= ruin
			handled_ruin_paths += ruin.type
			continue

		available[ruin] = ruin.spawn_weight

		for(var/ruin_path in ruin.allow_ruins)
			var/datum/map_template/ruin/force_ruin = new ruin_path
			potentialRuins += force_ruin

		potentialRuins -= ruin
		handled_ruin_paths += ruin.type

	if(!length(available) && !length(force_spawn))
		UNLINT(log_module_ruins_warning("No ruins available - Not generating ruins"))

	while (remaining > 0 && length(available))
		var/datum/map_template/ruin/ruin = pickweight(available)
		if(ruin.id in GLOB.banned_ruin_ids)
			available -= ruin
			continue

		var/turf/choice = validate_ruin(ruin, zlevels, remaining, maxx, maxy)
		if(!choice)
			available -= ruin
			continue

		selected_log += "\t[ruin.name] ([ruin.width]x[ruin.height]) @ [choice.x], [choice.y], [choice.z]"
		load_ruin(choice, ruin)
		log_module_ruins("Ruin \"[ruin.name]\" ([ruin.type]) loaded with geometry: Lower X: [choice.x - round(ruin.width / 2)] - Lower Y [choice.y - round(ruin.height / 2)] -- Upper X: [choice.x + round(ruin.width / 2)] - Upper Y: [choice.y + round(ruin.height / 2)]")

		#if defined(UNIT_TEST)
		var/list/turf/affected_turfs = ruin.get_affected_turfs(choice, TRUE)
		GLOB.turfs_to_map_type["[ruin.type]"] = affected_turfs
		#endif

		selected += ruin

		for(var/ruin_path in ruin.force_ruins)
			var/datum/map_template/ruin/force_ruin = new ruin_path
			if(force_ruin.spawns_in_current_sector())
				force_spawn |= force_ruin

		for(var/datum/map_template/ruin/ban_ruin as anything in ruin.ban_ruins)
			var/ruin_id = initial(ban_ruin.id)
			GLOB.banned_ruin_ids += ruin_id

		if(ruin.spawn_cost > 0)
			remaining -= ruin.spawn_cost

		if(!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
			GLOB.banned_ruin_ids += ruin.id
			available -= ruin

	for(var/datum/map_template/ruin/ruin in force_spawn)
		if(ruin.id in GLOB.banned_ruin_ids)
			continue

		var/turf/choice = validate_ruin(ruin, zlevels, max_x = maxx, max_y = maxy)
		if(!choice)
			selected_log += "\t[SPAN_WARNING("[ruin.name] ([ruin.width]x[ruin.height]) failed to force-spawn in Z: [english_list(zlevels)]")]"
			continue

		selected_log += "\t[ruin.name] ([ruin.width]x[ruin.height]) @ [choice.x], [choice.y], [choice.z] [SPAN_WARNING("(forced)")]"
		load_ruin(choice, ruin)

		#if defined(UNIT_TEST)
		var/list/turf/affected_turfs = ruin.get_affected_turfs(choice, TRUE)
		GLOB.turfs_to_map_type["[ruin.type]"] = affected_turfs
		#endif

		selected += ruin

		if(!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
			GLOB.banned_ruin_ids += ruin.id

	var/message = "\t[selected.len] ruins selected using [budget - remaining] pts of [budget] budget."
	if (remaining)
		message = SPAN_WARNING(message)
	selected_log += message

	if (length(selected))
		log_module_ruins("Finished selecting planet ruins ([english_list(selected)]) for [budget - remaining] cost of [budget] budget.")

	return selected_log

/proc/validate_ruin(datum/map_template/ruin/ruin, list/zlevels, budget = 0, max_x = world.maxx, max_y = world.maxy)
	if(!istype(ruin) || !length(zlevels))
		return

	if(budget && (ruin.spawn_cost > budget))
		return

	var/z = pick(zlevels)

	var/width = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.width / 2)
	var/height = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.height / 2)
	var/list/planet_turfs = block(1, 1, z, max_x, max_y, z)

	if(width > max_x - width || height > max_y - height)
		return

	var/list/heightmap = heightmap_from_turfs(planet_turfs, x_buffer = width, y_buffer = height, ignore_density = TRUE)

	for(var/attempts = 20, attempts > 0, --attempts)
		var/list/spot = maximal_rectangle(heightmap, desired_height = ruin.height, desired_width = ruin.width)
		var/spot_min_x = spot["min_x"]
		var/spot_min_y = spot["min_y"]
		var/spot_max_x = spot["max_x"]
		var/spot_max_y = spot["max_y"]

		var/spot_width = spot_max_x - spot_min_x + 1
		var/spot_height = spot_max_y - spot_min_y + 1

		var/turf/spot_center = locate(spot_min_x + (spot_width / 2), spot_min_y + (spot_height / 2), zlevels[1])
		if(spot["should_clear"])
			heightmap[spot_center.x][spot_center.y] = -1
			continue

		return spot_center

/proc/load_ruin(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/turf/T as anything in template.get_affected_turfs(central_turf, 1))
		T.empty()
		if(LAZYLEN(T.decals))
			T.decals.Cut()
		T.ClearOverlays()
	template.load(central_turf, TRUE)
	var/datum/map_template/ruin = template
	if(istype(ruin))
		new /obj/effect/landmark/ruin(central_turf, ruin)
	return TRUE
