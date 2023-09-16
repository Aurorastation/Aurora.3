/obj/effect/overmap/visitable/sector/exoplanet/grass
	name = "lush exoplanet"
	desc = "An exoplanet with abundant flora and fauna."
	color = "#407c40"
	scanimage = "jungle.png"
	geology = "High-energy geothermal signature, tectonic activity non-obstructive to surface environment"
	weather = "Global full-atmosphere hydrological weather system. Dangerous meteorological activity not present"
	surfacewater = "63% surface water, majority readings not visibly potable. Expected mineral toxicity or salt presence in water bodies"
	planetary_area = /area/exoplanet/grass
	rock_colors = list(COLOR_ASTEROID_ROCK, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = list("#3c772e","#27614b","#3f8d35","#185f18","#799628", "RANDOM")
	possible_themes = list(/datum/exoplanet_theme/grass)
	ruin_planet_type = PLANET_GRASS
	ruin_allowed_tags = RUIN_LOWPOP|RUIN_SCIENCE|RUIN_HOSTILE|RUIN_WRECK|RUIN_NATURAL

/obj/effect/overmap/visitable/sector/exoplanet/grass/generate_map()
	if(prob(40))
		lightlevel = rand(1,7)/10	//give a chance of twilight jungle
	..()

/obj/effect/overmap/visitable/sector/exoplanet/grass/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(10, 30)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/grass/get_surface_color()
	return grass_color

/obj/effect/overmap/visitable/sector/exoplanet/grass/adapt_seed(var/datum/seed/S)
	..()
	var/carnivore_prob = rand(100)
	if(carnivore_prob < 30)
		S.set_trait(TRAIT_CARNIVOROUS,2)
		if(prob(75))
			S.get_trait(TRAIT_STINGS, 1)
	else if(carnivore_prob < 60)
		S.set_trait(TRAIT_CARNIVOROUS,1)
		if(prob(50))
			S.get_trait(TRAIT_STINGS)
	if(prob(15) || (S.get_trait(TRAIT_CARNIVOROUS) && prob(40)))
		S.set_trait(TRAIT_BIOLUM,1)
		S.set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))

	if(prob(30))
		S.set_trait(TRAIT_PARASITE,1)

/obj/effect/overmap/visitable/sector/exoplanet/grass/marsh
	name = "marsh exoplanet"
	desc = "A swampy planet, home to exotic creatures and flora."
	possible_themes = list(/datum/exoplanet_theme/grass/marsh)
	ruin_planet_type = PLANET_MARSH
