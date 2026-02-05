/obj/effect/overmap/visitable/sector/exoplanet/proc/generate_flora()
	if(flora_diversity == 0)
		return

	/// Generate custom seeds for lore planets.
	if(islist(small_flora_types) && length(small_flora_types))
		for(var/seed_type in small_flora_types)
			var/datum/seed/S = new seed_type()
			small_flora_types += S

	if(islist(big_flora_types) && length(big_flora_types))
		for(var/seed_type in big_flora_types)
			var/datum/seed/S = new seed_type()
			big_flora_types += S

	/// Now, generate random seeds for normal planets.
	for(var/i = 1 to flora_diversity)
		var/datum/seed/S = new()
		if(exterior_atmosphere?.gas)
			S.randomize(exterior_atmosphere.gas.Copy())
		else
			S.randomize()
		var/plant_icon = "alien[rand(1,7)]"
		SET_SEED_TRAIT(S, TRAIT_PRODUCT_ICON, plant_icon)
		SET_SEED_TRAIT(S, TRAIT_PLANT_ICON, plant_icon)
		var/color = pick(plant_colors)
		if(color == "RANDOM")
			color = get_random_colour(0,75,190)
		SET_SEED_TRAIT(S, TRAIT_PLANT_COLOUR, color)
		adapt_seed(S)
		S.update_growth_stages()
		small_flora_seeds += S

	if(has_trees)
		var/tree_diversity = max(1, flora_diversity/2)
		for(var/i = 1 to tree_diversity)
			var/datum/seed/S = new()
			S.randomize()
			SET_SEED_TRAIT(S, TRAIT_PRODUCT_ICON, "alien[rand(1,5)]")
			SET_SEED_TRAIT(S, TRAIT_PLANT_ICON, "tree")
			SET_SEED_TRAIT(S, TRAIT_SPREAD, 0)
			SET_SEED_TRAIT(S, TRAIT_HARVEST_REPEAT, 1)
			SET_SEED_TRAIT(S, TRAIT_LARGE, 1)
			var/color = pick(plant_colors)
			if (color == "RANDOM")
				color = get_random_colour(0,75,190)
			SET_SEED_TRAIT(S, TRAIT_LEAVES_COLOUR, color)
			S.chems[/singleton/reagent/woodpulp] = list(1)
			adapt_seed(S)
			S.update_growth_stages()
			big_flora_seeds += S

/obj/effect/overmap/visitable/sector/exoplanet/proc/adapt_seed(var/datum/seed/S)
	SET_SEED_TRAIT_BOUNDED(S, TRAIT_IDEAL_HEAT, exterior_atmosphere.temperature + rand(-5,5), 800, 70, null)
	SET_SEED_TRAIT_BOUNDED(S, TRAIT_HEAT_TOLERANCE, GET_SEED_TRAIT(S, TRAIT_HEAT_TOLERANCE) + rand(-5,5), 800, 70, null)
	SET_SEED_TRAIT_BOUNDED(S, TRAIT_LOWKPA_TOLERANCE, exterior_atmosphere.return_pressure() + rand(-5,-50), 80, 0, null)
	SET_SEED_TRAIT_BOUNDED(S, TRAIT_HIGHKPA_TOLERANCE, exterior_atmosphere.return_pressure() + rand(5,50), 500, 110, null)
	SET_SEED_TRAIT(S, TRAIT_SPREAD, 0)
	if(S.exude_gasses)
		S.exude_gasses -= badgas
	if(exterior_atmosphere)
		if(S.consume_gasses)
			S.consume_gasses = list(pick(exterior_atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for(var/g in exterior_atmosphere.gas)
			if(gas_data.flags[g] & XGM_GAS_CONTAMINANT)
				SET_SEED_TRAIT(S, TRAIT_TOXINS_TOLERANCE, rand(10,15))

/obj/effect/landmark/exoplanet_spawn/plant
	name = "spawn exoplanet plant"

/obj/effect/landmark/exoplanet_spawn/plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	if(length(planet.small_flora_seeds))
		var/seed_path = pick(planet.small_flora_seeds)
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(src), seed_path, TRUE)

/obj/effect/landmark/exoplanet_spawn/large_plant
	name = "spawn exoplanet large plant"

/obj/effect/landmark/exoplanet_spawn/large_plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	if(length(planet.big_flora_seeds))
		var/seed_path = pick(planet.big_flora_seeds)
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(src), seed_path, TRUE)

