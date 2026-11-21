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
	/// Whether a tissue sample has already been clipped from this wild plant.
	var/sampled = FALSE

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

/obj/structure/flora/harvestable/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_WIRECUTTER || istype(attacking_item, /obj/item/surgery/scalpel))
		if(!seed)
			to_chat(user, SPAN_WARNING("There is nothing to take a sample from."))
			return
		if(sampled)
			to_chat(user, SPAN_WARNING("You have already taken a sample from \the [src]."))
			return
		user.visible_message(SPAN_NOTICE("\The [user] begins taking a cutting from \the [src]."), SPAN_NOTICE("You begin taking a cutting from \the [src]."))
		if(do_after(user, 1 SECOND, src))
			playsound(src, 'sound/items/Wirecutter.ogg', 25, 1)
			seed.harvest(user, 0, 1)
			var/exhaust_chance = 100
			var/bonus_seed_chance = 0
			var/wild_destroy_chance = 50
			SEND_SIGNAL(user, COMSIG_PLANT_SAMPLER, seed, null, &exhaust_chance, &bonus_seed_chance, &wild_destroy_chance)
			if(exhaust_chance > 0 && prob(exhaust_chance))
				sampled = TRUE
			if(bonus_seed_chance > 0 && prob(bonus_seed_chance))
				var/obj/item/seeds/bonus_seeds = new(get_turf(user))
				bonus_seeds.seed_type = seed.name
				bonus_seeds.update_seed()
				to_chat(user, SPAN_NOTICE("Your surgical precision lets you divide the wild cutting into a second viable seed packet!"))
			if(wild_destroy_chance > 0 && prob(wild_destroy_chance))
				to_chat(user, SPAN_WARNING("Your rough cutting damages \the [src] beyond recovery, and it withers away!"))
				qdel(src)
		return
	return ..()

/obj/structure/flora/harvestable/attack_hand(mob/user)
	if(!seed)
		to_chat(user, SPAN_NOTICE("There is nothing to harvest."))
		return
	if(!Adjacent(user))
		return
	if(seed.harvest(user))
		var/salvage_seed_chance = 0
		if(!sampled && user)
			SEND_SIGNAL(user, COMSIG_BOTANY_FLORA_HANDLING, seed, null, &salvage_seed_chance)
		if(salvage_seed_chance > 0 && prob(salvage_seed_chance))
			var/obj/item/seeds/salvaged = new(get_turf(user))
			salvaged.seed_type = seed.name
			salvaged.update_seed()
			to_chat(user, SPAN_NOTICE("Your xenobotanical training lets you salvage a viable packet of [seed.seed_name] [seed.seed_noun] while harvesting \the [src]!"))
		qdel(src)

/obj/structure/flora/harvestable/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(seed)
		. += SPAN_NOTICE("You could harvest this plant.")
		var/botany_skill = GET_SKILL_LEVEL(user, XENOBOTANY_SKILL_COMPONENT)
		if(botany_skill >= SKILL_LEVEL_FAMILIAR)
			. += SPAN_NOTICE("Your xenobotanical eye estimates: Potency <b>[GET_SEED_TRAIT(seed, TRAIT_POTENCY)]</b> | Ideal Heat <b>[GET_SEED_TRAIT(seed, TRAIT_IDEAL_HEAT)]K</b> | Ideal Light <b>[GET_SEED_TRAIT(seed, TRAIT_IDEAL_LIGHT)] lm</b>.")
			var/list/hazards = list()
			if(GET_SEED_TRAIT(seed, TRAIT_STINGS))
				hazards += "stinging spines"
			if(GET_SEED_TRAIT(seed, TRAIT_CARNIVOROUS))
				hazards += "carnivorous thorns"
			if(GET_SEED_TRAIT(seed, TRAIT_SPOROUS))
				hazards += "volatile spore sacs"
			if(GET_SEED_TRAIT(seed, TRAIT_EXPLOSIVE))
				hazards += "explosive fruit"
			if(GET_SEED_TRAIT(seed, TRAIT_TELEPORTING))
				hazards += "bluespace instability"
			if(length(hazards))
				. += SPAN_WARNING("Detected flora hazards: <b>[english_list(hazards)]</b>.")
			if(botany_skill >= SKILL_LEVEL_PROFESSIONAL && islist(seed.chems) && length(seed.chems))
				var/list/chem_names = list()
				for(var/rid in seed.chems)
					var/singleton/reagent/R = GET_SINGLETON(rid)
					if(R)
						chem_names += R.name
				if(length(chem_names))
					. += SPAN_NOTICE("Your expert xenobotanical knowledge identifies its chemical synthesis profile: <b>[english_list(chem_names)]</b>.")

/obj/structure/flora/harvestable/Destroy()
	// Check if we're masking a decal that needs to be visible again.
	for(var/obj/effect/plant/plant in get_turf(src))
		if(plant.invisibility == INVISIBILITY_MAXIMUM)
			plant.set_invisibility(initial(plant.invisibility))
	seed = null
	return ..()
