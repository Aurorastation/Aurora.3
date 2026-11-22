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

/obj/effect/landmark/exoplanet_spawn/plant
	name = "spawn exoplanet plant"

/obj/effect/landmark/exoplanet_spawn/plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	if(length(planet.small_flora_seeds))
		var/datum/seed/seed_pick = pick(planet.small_flora_seeds)
		new /obj/structure/flora/harvestable(get_turf(src), seed_pick)

/obj/effect/landmark/exoplanet_spawn/large_plant
	name = "spawn exoplanet large plant"

/obj/effect/landmark/exoplanet_spawn/large_plant/do_spawn(var/obj/effect/overmap/visitable/sector/exoplanet/planet)
	if(length(planet.big_flora_seeds))
		var/datum/seed/seed_pick = pick(planet.big_flora_seeds)
		new /obj/structure/flora/harvestable(get_turf(src), seed_pick)

/**
 * Lightweight harvestable plant for exoplanets
 * We can assert that since these grew on a planet that the seed is pre-adapted to during exoplanet generation
 * That the plant has no reason at all that it shouldn't be able to survive in the generated climate.
 * Therefore to save on processing costs, we just make a static object that can be harvested just like a botany plant
 * Except its completely missing the entire atmos-code-intensive processing costs that are normally associated with botany code.
 */
/obj/structure/flora/harvestable
	name = "plant"
	desc = "A wild plant."
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"
	density = FALSE
	/// The seed datum this plant grows from.
	var/datum/seed/seed

/obj/structure/flora/harvestable/Initialize(var/newloc, var/datum/seed/newseed)
	. = ..()
	if(!newseed)
		return INITIALIZE_HINT_QDEL
	seed = newseed
	name = seed.display_name
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

	// Large plants (trees) are dense and opaque.
	if(GET_SEED_TRAIT(seed, TRAIT_LARGE))
		density = TRUE
		opacity = TRUE

	update_icon()

	// Apply bioluminescence.
	if(GET_SEED_TRAIT(seed, TRAIT_BIOLUM))
		var/pwr
		if(GET_SEED_TRAIT(seed, TRAIT_BIOLUM_PWR) == 0)
			pwr = GET_SEED_TRAIT(seed, TRAIT_BIOLUM)
		else
			pwr = GET_SEED_TRAIT(seed, TRAIT_BIOLUM_PWR)
		var/clr = GET_SEED_TRAIT(seed, TRAIT_BIOLUM_COLOUR)
		set_light(GET_SEED_TRAIT(seed, TRAIT_POTENCY) / 10, pwr, clr)

/obj/structure/flora/harvestable/update_icon()
	ClearOverlays()
	if(!seed)
		return
	// Ensure growth stages are calculated.
	if(!seed.growth_stages)
		seed.update_growth_stages()
	// Render the fully-grown plant icon.
	var/image/plant_overlay = seed.get_icon(seed.growth_stages)
	AddOverlays(plant_overlay)
	// Render the harvestable product overlay.
	var/ikey = "[GET_SEED_TRAIT(seed, TRAIT_PRODUCT_ICON)]"
	var/cache_key = "product-[ikey]-[GET_SEED_TRAIT(seed, TRAIT_PLANT_COLOUR)]"
	var/image/harvest_overlay = SSplants.plant_icon_cache[cache_key]
	if(!harvest_overlay)
		harvest_overlay = image('icons/obj/hydroponics_products.dmi', "[ikey]")
		harvest_overlay.color = GET_SEED_TRAIT(seed, TRAIT_PRODUCT_COLOUR)
		SSplants.plant_icon_cache[cache_key] = harvest_overlay
	AddOverlays(harvest_overlay)

/obj/structure/flora/harvestable/attack_hand(mob/user)
	if(!seed)
		to_chat(user, SPAN_NOTICE("There is nothing to harvest."))
		return
	if(!Adjacent(user))
		return
	if(seed.harvest(user))
		qdel(src)

/obj/structure/flora/harvestable/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(seed)
		. += SPAN_NOTICE("You could harvest this plant.")

/obj/structure/flora/harvestable/Destroy()
	// Check if we're masking a decal that needs to be visible again.
	for(var/obj/effect/plant/plant in get_turf(src))
		if(plant.invisibility == INVISIBILITY_MAXIMUM)
			plant.set_invisibility(initial(plant.invisibility))
	seed = null
	return ..()
