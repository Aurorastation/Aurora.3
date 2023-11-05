var/list/banned_ruin_ids = list()

/proc/seedRuins(list/zlevels, budget, list/potentialRuins, allowed_area = /area/space, var/maxx = world.maxx, var/maxy = world.maxy, ignore_sector = FALSE)
	if (!length(zlevels))
		UNLINT(log_module_ruins_warning("No Z levels provided - Not generating ruins"))
		return

	for (var/z in zlevels)
		var/turf/check = locate(1, 1, z)
		if (!check)
			UNLINT(log_module_ruins_warning("Z level [z] does not exist - Not generating ruins"))
			return

	var/list/available = list()
	var/list/selected = list()
	var/list/force_spawn = list()
	var/remaining = budget

	for(var/datum/map_template/ruin/ruin in potentialRuins)
		if((ruin.spawns_in_current_sector()) && (ruin.template_flags & TEMPLATE_FLAG_SPAWN_GUARANTEED))
			force_spawn |= ruin
			continue
		if(ruin.id in banned_ruin_ids)
			continue
		if(!(ruin.spawns_in_current_sector()) && !ignore_sector)
			continue
		available[ruin] = ruin.spawn_weight

	if(!length(available) && !length(force_spawn))
		UNLINT(log_module_ruins_warning("No ruins available - Not generating ruins"))

	for(var/datum/map_template/ruin/ruin in force_spawn)
		var/turf/choice = validate_ruin(ruin, zlevels, filter_area = allowed_area, max_x = maxx, max_y = maxy)
		if(!choice)
			continue

		log_admin("Ruin \"[ruin.name]\" force-spawned at ([choice.x], [choice.y], [choice.z])!")
		load_ruin(choice, ruin)
		selected += ruin

		banned_ruin_ids += ruin.id
		remaining -= ruin.spawn_cost

	while (remaining > 0 && length(available))
		var/datum/map_template/ruin/ruin = pickweight(available)
		var/turf/choice = validate_ruin(ruin, zlevels, remaining, allowed_area, maxx, maxy)
		if(!choice)
			available -= ruin
			continue

		log_admin("Ruin \"[ruin.name]\" placed at ([choice.x], [choice.y], [choice.z])!")
		load_ruin(choice, ruin)
		selected += ruin

		if(ruin.spawn_cost > 0)
			remaining -= ruin.spawn_cost
		if(!(ruin.template_flags & TEMPLATE_FLAG_ALLOW_DUPLICATES))
			banned_ruin_ids += ruin.id
			available -= ruin

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
			if(!istype(check_area, filter_area) || check_turf.flags & TURF_NORUINS)
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
