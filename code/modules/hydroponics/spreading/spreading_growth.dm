#define NEIGHBOR_REFRESH_TIME 100

/obj/effect/plant/proc/get_cardinal_neighbors()
	var/list/cardinal_neighbors = list()
	for(var/check_dir in GLOB.cardinals)
		var/turf/simulated/T = get_step(get_turf(src), check_dir)
		if(istype(T))
			cardinal_neighbors |= T
	return cardinal_neighbors

/obj/effect/plant/proc/update_neighbors()
	// Update our list of valid neighboring turfs.
	neighbors = list()
	for(var/turf/simulated/floor in get_cardinal_neighbors())
		if(get_dist(parent, floor) > spread_distance)
			continue
		if((locate(/obj/effect/plant) in floor.contents) || (locate(/obj/effect/dead_plant) in floor.contents) )
			continue
		if(floor.density)
			if(seed && seed.chems[/singleton/reagent/acid/polyacid])
				addtimer(CALLBACK(floor, TYPE_PROC_REF(/atom, ex_act), 3), rand(5, 25))
			continue
		if(!Adjacent(floor) || !floor.Enter(src))
			continue
		neighbors |= floor

	if (neighbors.len)
		SSplants.add_plant(src)

	// Update all of our friends.
	var/turf/T = get_turf(src)
	for(var/obj/effect/plant/neighbor in range(1,src))
		neighbor.neighbors -= T

/obj/effect/plant/process()
	// Something is very wrong, kill ourselves.
	if(!seed)
		die_off()
		return 0

	for(var/obj/effect/smoke/chem/smoke in view(1, src))
		if(smoke.reagents.has_reagent(/singleton/reagent/toxin/plantbgone))
			die_off()
			return

	// Handle life.
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		health -= seed.handle_environment(T,T.return_air(),null,1)
	if(health < max_health)
		health += rand(3,5)
		refresh_icon()
		if(health > max_health)
			health = max_health
	else if(health == max_health && !plant)
		plant = new(T,seed)
		plant.dir = src.dir
		plant.transform = src.transform
		plant.age = seed.get_trait(TRAIT_MATURATION)-1
		plant.update_icon()
		if(growth_type==0) //Vines do not become invisible.
			set_invisibility(INVISIBILITY_MAXIMUM)
		else
			plant.layer = layer + 0.1

	if(buckled)
		seed.do_sting(buckled,src)
		if(seed.get_trait(TRAIT_CARNIVOROUS))
			seed.do_thorns(buckled,src)

	if(world.time >= last_tick+NEIGHBOR_REFRESH_TIME)
		last_tick = world.time
		update_neighbors()

	if(sampled)
		//Should be between 2-7 for given the default range of values for TRAIT_PRODUCTION
		var/chance
		if(!seed.get_trait(TRAIT_PRODUCTION))
			chance = 1
		else
			chance = max(1, round(30/seed.get_trait(TRAIT_PRODUCTION)))
		if(prob(chance))
			sampled = 0

	if(is_mature() && neighbors.len && prob(spread_chance))
		//spread to 1-3 adjacent turfs depending on yield trait.
		var/max_spread = between(1, round(seed.get_trait(TRAIT_YIELD)*3/14), 3)

		do_spread(spread_chance, max_spread)

	// We shouldn't have spawned if the controller doesn't exist.
	check_health()
	if(neighbors.len || health != max_health || buckled || !is_mature())
		SSplants.add_plant(src)

/obj/effect/plant/proc/do_spread(spread_chance, max_spread)
	set waitfor = FALSE
	for(var/i in 1 to max_spread)
		if(prob(spread_chance))
			sleep(rand(3,5))
			if(!neighbors.len)
				return

			var/turf/target_turf = pick(neighbors)
			var/obj/effect/plant/child = new(get_turf(src),seed,parent)
			// This should do a little bit of animation.
			addtimer(CALLBACK(src, PROC_REF(do_move), target_turf, child), 1)
			// Update neighboring squares.
			for(var/obj/effect/plant/neighbor in range(1,target_turf))
				neighbor.neighbors -= target_turf

/obj/effect/plant/proc/do_move(turf/target, obj/effect/plant/child)
	child.forceMove(target)
	child.queue_icon_update()

/obj/effect/plant/proc/die_off()
	// Kill off our plant.
	if(plant) plant.die()
	// This turf is clear now, let our buddies know.
	for(var/turf/simulated/check_turf in get_cardinal_neighbors())
		if(!istype(check_turf))
			continue
		for(var/obj/effect/plant/neighbor in check_turf.contents)
			neighbor.neighbors |= check_turf
			SSplants.add_plant(neighbor)

	qdel(src)

#undef NEIGHBOR_REFRESH_TIME
