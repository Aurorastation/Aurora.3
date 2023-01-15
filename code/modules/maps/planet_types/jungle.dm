/obj/effect/overmap/visitable/sector/exoplanet/grass/grove
	name = "grove exoplanet"
	desc = "Planet with abundant, peaceful flora and fauna."
	color = "#346934"
	planetary_area = /area/exoplanet/grass/grove
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	grass_color = null
	plant_colors = null
	map_generators = list(/datum/random_map/noise/exoplanet/grass/grove)
	possible_themes = list(/datum/exoplanet_theme/mountains/breathable)
	ruin_tags_blacklist = RUIN_VOID

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/get_surface_color()
	return "#5C7F34"

/area/exoplanet/grass/grove
	base_turf = /turf/simulated/floor/exoplanet/grass/grove

/datum/random_map/noise/exoplanet/grass/grove
	descriptor = "grove exoplanet"
	smoothing_iterations = 2
	land_type = /turf/simulated/floor/exoplanet/grass/grove
	water_type = /turf/simulated/floor/exoplanet/water/shallow

	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos)

/datum/random_map/noise/exoplanet/grass/grove/get_additional_spawns(var/value, var/turf/T)
	..()
	if(istype(T, water_type))
		return
	if(T.density)
		return
	var/val = min(10,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(2)
			if(prob(25))
				new /obj/structure/flora/bamboo(T)
		if(3)
			if(prob(25))
				new /obj/structure/flora/stalks(T)
		if(4)
			if(prob(75))
				new /obj/structure/flora/clutter(T)
		if(5)
			if(prob(35))
				new /obj/structure/flora/bush/grove(T)
		if(6)
			if(prob(25))
				new /obj/structure/flora/tree/grove(T)