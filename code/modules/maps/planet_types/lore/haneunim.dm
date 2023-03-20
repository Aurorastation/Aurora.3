//Huozhu
/obj/effect/overmap/visitable/sector/exoplanet/lava/huozhu
	name = "Huozhu"
	desc = "A scorching planet with a lot of volcanic activity."
	color = "#575d5e"
	planetary_area = /area/exoplanet/barren
	rock_colors = list(COLOR_DARK_GRAY)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/lava, /datum/random_map/noise/ore)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	features_budget = 4
	surface_color = "#cf1020"
	generated_name = FALSE
	ring_chance = 0
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
	desc = "A desolate planet barely capable of holding its corrosive atmosphere."
	color = "#bf7c39"
	icon_state = "globe1"
	rock_colors = list(COLOR_GRAY80)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 1
	surface_color = "#B1A69B"
	generated_name = FALSE
	ring_chance = 0

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.adjust_gas(GAS_NITROGEN, MOLES_O2STANDARD)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung/get_surface_color()
	return "#B1A69B"

/obj/effect/overmap/visitable/sector/exoplanet/barren/hwanung/update_icon()
	return

//Qixi

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi
	name = "Qixi"
	desc = "The moon of Konyang."
	color = "#bf7c39"
	icon_state = "globe1"
	rock_colors = list(COLOR_GRAY80)
	possible_themes = list(/datum/exoplanet_theme/mountains)
	map_generators = list(/datum/random_map/noise/exoplanet/barren, /datum/random_map/noise/ore)
	features_budget = 1
	surface_color = "#B1A69B"
	generated_name = FALSE
	ring_chance = 0
	place_near_main = list(3, 3)

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/generate_habitability()
	return HABITABILITY_BAD

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/get_surface_color()
	return "#B1A69B"

/obj/effect/overmap/visitable/sector/exoplanet/barren/qixi/update_icon()
	return

//Konyang

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/konyang
	name = "Konyang"
	desc = "The jewel of Haneunim, lush with life."
	color = "#346934"
	planetary_area = /area/exoplanet/grass/grove
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	grass_color = null
	plant_colors = null
	map_generators = list(/datum/random_map/noise/exoplanet/grass/grove)
	possible_themes = list(/datum/exoplanet_theme/mountains/breathable)
	generated_name = FALSE
	ring_chance = 0
	place_near_main = list(2, 2)

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/konyang/generate_habitability()
	return HABITABILITY_IDEAL

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/konyang/generate_map()
	if(prob(75))
		lightlevel = rand(5, 10)/10	//Lancer requested Konyang be reasonably light aka: Daytime
	..()

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/konyang/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(1, 15)
		atmosphere.update_values()

/obj/effect/overmap/visitable/sector/exoplanet/grass/grove/konyang/get_surface_color()
	return "#5C7F34"

/area/exoplanet/grass/grove
	base_turf = /turf/simulated/floor/exoplanet/grass/grove

/datum/random_map/noise/exoplanet/grass/grove
	descriptor = "Konyang"
	smoothing_iterations = 2
	land_type = /turf/simulated/floor/exoplanet/grass/grove
	water_type = /turf/simulated/floor/exoplanet/water/shallow

	fauna_prob = 1
	fauna_types = list(/mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos)

/datum/random_map/noise/exoplanet/grass/grove/konyang/get_additional_spawns(var/value, var/turf/T)
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

