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
			if(SSatlas.is_port_call_day())
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

		var/turf/choice = validate_ruin(ruin, zlevels, remaining, allowed_area, maxx, maxy)
		if(!choice)
			available -= ruin
			continue

		log_admin("Ruin \"[ruin.name]\" placed at ([choice.x], [choice.y], [choice.z])!")
		load_ruin(choice, ruin)
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

		var/turf/choice = validate_ruin(ruin, zlevels, filter_area = allowed_area, max_x = maxx, max_y = maxy)
		if(!choice)
			log_admin("Ruin \"[ruin.name]\" failed to force-spawned at ([choice.x], [choice.y], [choice.z])!!!")
			continue

		log_admin("Ruin \"[ruin.name]\" force-spawned at ([choice.x], [choice.y], [choice.z])!")
		load_ruin(choice, ruin)
		selected += ruin

		if(!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
			GLOB.banned_ruin_ids += ruin.id

	if (remaining)
		log_admin("Ruin loader had no ruins to pick from with [budget] left to spend.")

	if (length(selected))
		log_module_ruins("Finished selecting planet ruins ([english_list(selected)]) for [budget - remaining] cost of [budget] budget.")

	return selected

/proc/validate_ruin(datum/map_template/ruin/ruin, list/zlevels, budget = 0, filter_area = /area/exoplanet, max_x = world.maxx, max_y = world.maxy)
	if(!istype(ruin) || !length(zlevels))
		return

	if(budget && (ruin.spawn_cost > budget))
		return

	var/width = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.width / 2)
	var/height = TRANSITIONEDGE + RUIN_MAP_EDGE_PAD + round(ruin.height / 2)

	if(width > max_x - width || height > max_y - height)
		return

	var/valid = TRUE

	for(var/attempts = 20, attempts > 0, --attempts)
		var/z = pick(zlevels)
		var/turf/choice = locate(rand(width, max_x - width), rand(height, max_y - height), z)

		valid = TRUE
		for(var/turf/check_turf in ruin.get_affected_turfs(choice, TRUE))
			var/area/check_area = get_area(check_turf)
			if(!istype(check_area, filter_area) || check_turf.turf_flags & TURF_NORUINS)
				valid = FALSE
				break

		if(valid)
			return choice

/proc/load_ruin(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	for(var/i in template.get_affected_turfs(central_turf, 1))
		var/turf/T = i
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
		for(var/obj/structure/S in T)
			qdel(S)
		for(var/obj/machinery/M in T)
			qdel(M)
		if(LAZYLEN(T.decals))
			T.decals.Cut()
		T.cut_overlays()
	template.load(central_turf, TRUE)
	var/datum/map_template/ruin = template
	if(istype(ruin))
		new /obj/effect/landmark/ruin(central_turf, ruin)
	return TRUE
