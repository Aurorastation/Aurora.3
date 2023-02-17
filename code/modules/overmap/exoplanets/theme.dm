/datum/exoplanet_theme
	var/name = "Nothing Special"
	var/list/surface_turfs = list()
	var/surface_color

/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	if(E.rock_colors)
		surface_color = pick(E.rock_colors)

/datum/exoplanet_theme/proc/on_turf_generation(turf/T, var/area/use_area)
	if(surface_color && is_type_in_list(T, surface_turfs))
		T.color = surface_color

/datum/exoplanet_theme/proc/get_planet_image_extra()

/datum/exoplanet_theme/mountains
	name = "Mountains"
	surface_turfs = list(
		/turf/simulated/mineral,
		/turf/unsimulated/floor/asteroid/ash
		)
	var/cave_path = /datum/random_map/automata/cave_system/mountains

/datum/exoplanet_theme/mountains/get_planet_image_extra()
	var/image/res = image('icons/skybox/planet.dmi', "mountains")
	res.color = surface_color
	return res

/datum/exoplanet_theme/mountains/before_map_generation(obj/effect/overmap/visitable/sector/exoplanet/E)
	..()
	for(var/zlevel in E.map_z)
		new cave_path(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, src)

/datum/exoplanet_theme/mountains/on_turf_generation(turf/simulated/mineral/T, var/area/use_area)
	..()
	if(use_area && istype(T))
		T.mined_turf = use_area.base_turf

/datum/exoplanet_theme/mountains/phoron
	cave_path = /datum/random_map/automata/cave_system/mountains/phoron

/datum/exoplanet_theme/mountains/breathable
	cave_path = /datum/random_map/automata/cave_system/mountains/breathable

/datum/exoplanet_theme/mountains/adhomai
	cave_path = /datum/random_map/automata/cave_system/mountains/adhomai

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

/datum/random_map/automata/cave_system/mountains/New(var/seed, var/tx, var/ty, var/tz, var/tlx, var/tly, var/do_not_apply, var/do_not_announce, var/never_be_priority = 0, var/used_area, var/datum/exoplanet_theme/_theme)
	if(_theme)
		planet_theme = _theme
	target_turf_type = world.turf
	floor_type = world.turf
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value, turf/T)
	planet_theme.on_turf_generation(T, use_area)

