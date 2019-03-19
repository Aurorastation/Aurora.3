/datum/random_map/automata/cave_system/adhomai
	descriptor = "adhomai caverns"
	wall_type =  /turf/simulated/mineral/adhomai/surface
	floor_type = /turf/simulated/floor/asteroid/ash/rocky/adhomai
	mineral_sparse = /turf/simulated/mineral/random/adhomai/surface
	mineral_rich = /turf/simulated/mineral/random/adhomai/high_chance/surface

/datum/random_map/automata/cave_system/adhomai/under
	descriptor = "adhomai deep caverns"
	wall_type =  /turf/simulated/mineral/adhomai
	floor_type = /turf/simulated/floor/asteroid/basalt/adhomai
	mineral_sparse = /turf/simulated/mineral/random/adhomai/high_chance
	mineral_rich = /turf/simulated/mineral/random/adhomai/higher_chance

/datum/random_map/automata/meteor_chunk
	descriptor = "meteor chunk"
	wall_type =  /turf/simulated/mineral/random/adhomai/higher_chance
	floor_type = /turf/simulated/floor/snow

/datum/random_map/noise/tundra/adhomai
	descriptor = "adhomai wildnerss"
	target_turf_type = /turf/unsimulated/mask/adhomai

/datum/random_map/noise/tundra/adhomai/get_appropriate_path(var/value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(0 to 2)
			return /turf/simulated/floor/ice
		else
			return /turf/simulated/floor/snow

/datum/random_map/noise/tundra/adhomai/get_additional_spawns(var/value, var/turf/T)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(2)
			if(prob(5))
				new /mob/living/simple_animal/hostile/retaliate/rafama(T)
		if(6)
			var/grass_path = pick(typesof(/obj/structure/flora/grass)-/obj/structure/flora/grass)
			new grass_path(T)
		if(7)
			if(prob(60))
				new /obj/structure/flora/bush(T)
			else if(prob(30))
				new /obj/structure/flora/tree/pine(T)
			else if(prob(20))
				new /obj/structure/flora/tree/dead(T)
		if(8)
			if(prob(70))
				new /obj/structure/flora/tree/pine(T)
			else if(prob(30))
				new /obj/structure/flora/tree/dead(T)
			else
				new /obj/structure/flora/bush(T)
		if(9)
			new /obj/structure/flora/tree/pine(T)