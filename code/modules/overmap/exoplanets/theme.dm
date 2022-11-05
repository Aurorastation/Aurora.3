/datum/exoplanet_theme
	var/name = "Nothing Special"

/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)

/datum/exoplanet_theme/proc/get_planet_image_extra()

/datum/exoplanet_theme/mountains
	name = "Mountains"
	var/rock_color

/datum/exoplanet_theme/mountains/get_planet_image_extra()
	var/image/res = image('icons/skybox/planet.dmi', "mountains")
	res.color = rock_color
	return res

/datum/exoplanet_theme/mountains/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, rock_color)

/datum/exoplanet_theme/mountains/phoron/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains/phoron(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, rock_color)

/datum/exoplanet_theme/mountains/breathable/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains/breathable(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, rock_color)

/datum/exoplanet_theme/mountains/breathable/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains/breathable(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, rock_color)

/datum/exoplanet_theme/mountains/adhomai/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains/adhomai(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, rock_color)


/datum/random_map/automata/cave_system/mountains
	iterations = 2
	descriptor = "space mountains"
	wall_type =  /turf/simulated/mineral
	cell_threshold = 6
	var/rock_color

/datum/random_map/automata/cave_system/mountains/phoron
	mineral_sparse =  /turf/simulated/mineral/random/phoron
	mineral_rich = /turf/simulated/mineral/random/high_chance/phoron

/datum/random_map/automata/cave_system/mountains/breathable
	wall_type = /turf/simulated/mineral/planet
	mineral_sparse =  /turf/simulated/mineral/random/exoplanet
	mineral_rich = /turf/simulated/mineral/random/high_chance/exoplanet
	floor_type = /turf/simulated/floor/exoplanet/mineral
	use_area = FALSE

/datum/random_map/automata/cave_system/mountains/adhomai
	wall_type = /turf/simulated/mineral/adhomai
	mineral_sparse =  /turf/simulated/mineral/random/adhomai
	mineral_rich = /turf/simulated/mineral/random/high_chance/adhomai
	floor_type = /turf/simulated/floor/exoplanet/mineral/adhomai
	use_area = FALSE

/datum/random_map/automata/cave_system/mountains/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0, var/used_area, var/_rock_color)
	if(_rock_color)
		rock_color = _rock_color
	target_turf_type = world.turf
	floor_type = world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, var/turf/simulated/mineral/T)
	if(rock_color)
		T.color = rock_color
	if(use_area)
		if(istype(T))
			T.mined_turf = use_area.base_turf
