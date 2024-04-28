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
		if(atmosphere?.gas)
			S.randomize(atmosphere.gas.Copy())
		else
			S.randomize()
		var/plant_icon = "alien[rand(1,7)]"
		S.set_trait(TRAIT_PRODUCT_ICON,plant_icon)
		S.set_trait(TRAIT_PLANT_ICON, plant_icon)
		var/color = pick(plant_colors)
		if(color == "RANDOM")
			color = get_random_colour(0,75,190)
		S.set_trait(TRAIT_PLANT_COLOUR,color)
		adapt_seed(S)
		S.update_growth_stages()
		small_flora_seeds += S

	if(has_trees)
		var/tree_diversity = max(1, flora_diversity/2)
		for(var/i = 1 to tree_diversity)
			var/datum/seed/S = new()
			S.randomize()
			S.set_trait(TRAIT_PRODUCT_ICON,"alien[rand(1,5)]")
			S.set_trait(TRAIT_PLANT_ICON,"tree")
			S.set_trait(TRAIT_SPREAD,0)
			S.set_trait(TRAIT_HARVEST_REPEAT,1)
			S.set_trait(TRAIT_LARGE,1)
			var/color = pick(plant_colors)
			if (color == "RANDOM")
				color = get_random_colour(0,75,190)
			S.set_trait(TRAIT_LEAVES_COLOUR,color)
			S.chems[/singleton/reagent/woodpulp] = list(1)
			adapt_seed(S)
			S.update_growth_stages()
			big_flora_seeds += S

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

