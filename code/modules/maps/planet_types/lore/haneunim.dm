//Huozhu
/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu
	name = "Huozhu"
	desc = "A scorcthing planet with a lot of volcanic activity."
	color = "#575d5e"
	planetary_area = /area/exoplanet/barren/huozhu
	rock_colors = list(COLOR_DARK_GRAY)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/lava, /datum/random_map/noise/ore)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 4
	surface_color = "#cf1020"
	water_color = null

/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu/get_surface_color()
	return "#575d5e"

/datum/random_map/noise/exoplanet/lava
	descriptor = "Huozhu"
	smoothing_iterations = 4
	land_type = /turf/unsimulated/floor/asteroid/basalt
	water_type = /turf/simulated/lava
	water_level_min = 3
	water_level_max = 5
	flora_prob = 0
	flora_diversity = 0
	fauna_prob = 0

/area/exoplanet/lava/huozhu
	name = "\improper Planetary surface"
	ambience = AMBIENCE_LAVA
	base_turf = /turf/unsimulated/floor/asteroid/basalt

//Hwanung
/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung
name = "Hwanung"
	desc = "With a barely-held atmosphere, Hwanung is without life."
	color = "#ad9c9c"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung/get_surface_color()
	return "#6C6251"

/datum/random_map/noise/exoplanet/barren
	descriptor = "Hwanung"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/barren
	flora_prob = 0.1
	flora_diversity = 0
	fauna_prob = 0

/datum/random_map/noise/exoplanet/barren/New()
	if(prob(10))
		flora_diversity = 1
	..()

/turf/simulated/floor/exoplanet/barren
	name = "ground"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/simulated/floor/exoplanet/barren/update_icon()
	overlays.Cut()
	if(prob(20))
		overlays += image('icons/turf/decals/decals.dmi', "asteroid[rand(0,9)]")

/turf/simulated/floor/exoplanet/barren/Initialize()
	. = ..()
	update_icon()

/area/exoplanet/barren/hwanung
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/barren


//Qixi
/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi
	name = "Qixi"
	desc = "The moon of Konyang. Small and Cold."
	color = "#ad9c9c"
	planetary_area = /area/exoplanet/qixi
	rock_colors = list(COLOR_BEIGE, COLOR_GRAY80, COLOR_BROWN)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 6
	surface_color = "#807d7a"
	water_color = null

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/generate_atmosphere()
	..()
	atmosphere.remove_ratio(0.9)

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/get_surface_color()
	return "#6C6251"

/datum/random_map/noise/exoplanet/barren
	descriptor = "Qixi"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/barren
	flora_prob = 0.1
	flora_diversity = 0
	fauna_prob = 0

/datum/random_map/noise/exoplanet/barren/New()
	if(prob(10))
		flora_diversity = 1
	..()

/turf/simulated/floor/exoplanet/barren
	name = "ground"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/simulated/floor/exoplanet/barren/update_icon()
	overlays.Cut()
	if(prob(20))
		overlays += image('icons/turf/decals/decals.dmi', "asteroid[rand(0,9)]")

/turf/simulated/floor/exoplanet/barren/Initialize()
	. = ..()
	update_icon()

/area/exoplanet/barren/qixi
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/barren

//Konyang
/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/konyang
	name = "Konyang"
	desc = "The jewel of Haneunim. A planet with abundant flora and fauna, and the centre of the Golden Age of Robotics."
	color = "#346934"
	planetary_area = /area/exoplanet/grass/grove/konyang
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	grass_color = null
	plant_colors = null
	map_generators = list(/datum/random_map/noise/exoplanet/grass/grove)
	possible_themes = list(/datum/exoplanet_theme/mountains/breathable)

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/konyang/get_surface_color()
	return "#5C7F34"

/area/exoplanet/grass/grove/konyang
	base_turf = /turf/simulated/floor/exoplanet/grass/grove

/datum/random_map/noise/exoplanet/grass/grove
	descriptor = "Konyang"
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

