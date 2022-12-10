/datum/event/carp_migration
	announceWhen	= 50
	endWhen 		= 900

	var/list/spawned_carp = list()

	var/list/despawn_turfs = list(
		/turf/space,
		/turf/unsimulated/floor/asteroid,
		/turf/simulated/open,
		/turf/simulated/floor/reinforced/airless	// Station roof.
	)

	ic_name = "biological entities"
	var/deploy_drones = FALSE

/datum/event/carp_migration/setup()
	announceWhen = rand(40, 60)
	endWhen = rand(600, 1200)
	despawn_turfs = typecacheof(despawn_turfs)

/datum/event/carp_migration/announce()
	for (var/zlevel in affecting_z)
		if(zlevel in current_map.station_levels)
			var/announcement = ""
			var/soundfile = 'sound/AI/carp_migration.ogg'
			if(severity == EVENT_LEVEL_MAJOR && deploy_drones)
				announcement = "A massive migration of unknown biological entities has been detected near [location_name()], please stand-by."
				soundfile = 'sound/AI/massivespacecarp.ogg'
			else
				announcement = "Unknown biological [length(spawned_carp) == 1 ? "entity has" : "entities have"] been detected near [location_name()], please stand-by."
			command_announcement.Announce(announcement, "Lifesign Alert", new_sound = soundfile)
			break

/datum/event/carp_migration/start()
	if(severity == EVENT_LEVEL_MAJOR)
		spawn_fish(length(landmarks_list), spawn_drones = deploy_drones)
		spawn_caverndweller(length(landmarks_list), spawn_drones = deploy_drones)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_fish(rand(4, 6), spawn_drones = deploy_drones)			//12 to 30 carp, in small groups
		spawn_caverndweller(rand(1, 2), spawn_drones = deploy_drones) //less of those, also don't happen in the regular event
	else
		spawn_fish(rand(1, 3), 1, 2)	//1 to 6 carp, alone or in pairs

/datum/event/carp_migration/proc/spawn_fish(var/num_groups, var/group_size_min = 3, var/group_size_max = 5, var/spawn_drones = FALSE)
	set waitfor = FALSE
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		if(spawn_drones && prob(25))
			var/drone_num = rand(1, 2)
			for(var/d = 1, d <= drone_num, d++)
				new /mob/living/simple_animal/hostile/icarus_drone(get_random_turf_in_range(spawn_locations[i], 10, 6, TRUE, TRUE))
		for(var/j = 1, j <= group_size, j++)
			if(prob(95))
				var/mob/living/simple_animal/hostile/carp/carp = new(spawn_locations[i])
				spawned_carp += WEAKREF(carp)
			else if(prob(80))
				var/mob/living/simple_animal/carp/baby/carp = new(spawn_locations[i])
				spawned_carp += WEAKREF(carp)
			else
				var/mob/living/simple_animal/hostile/carp/shark/carp = new(spawn_locations[i])
				spawned_carp += WEAKREF(carp)
			CHECK_TICK
		i++

/datum/event/carp_migration/proc/spawn_caverndweller(var/num_groups, var/group_size_min=2, var/group_size_max=3, var/spawn_drones = FALSE)
	set waitfor = FALSE
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "cavernspawn")
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		if(spawn_drones && prob(25))
			var/drone_num = rand(1, 2)
			for(var/d = 1, d <= drone_num, d++)
				new /mob/living/simple_animal/hostile/icarus_drone(get_random_turf_in_range(spawn_locations[i], 10, 6, TRUE))
		for (var/j in 1 to group_size)
			new /mob/living/simple_animal/hostile/retaliate/cavern_dweller(spawn_locations[i])
			CHECK_TICK
		i++

/datum/event/carp_migration/end(var/faked)
	for (var/carp_ref in spawned_carp)
		var/datum/weakref/carp_weakref = carp_ref
		var/mob/living/simple_animal/hostile/carp/fish = carp_weakref.resolve()
		if (fish && prob(50) && is_type_in_typecache(fish.loc, despawn_turfs))
			qdel(fish)

/datum/event/carp_migration/cozmo/start()
	spawn_fish(7, 3, 5)

/datum/event/carp_migration/cozmo/announce()
	for (var/zlevel in affecting_z)
		if(zlevel in current_map.station_levels)
			command_announcement.Announce("A migration of non-hostile entities has been detected near the ship.", "Lifesign Alert", 'sound/AI/cozmo_migration.ogg')
			break

/datum/event/carp_migration/cozmo/spawn_fish(var/num_groups, var/group_size_min = 3, var/group_size_max = 5, var/spawn_drones = FALSE)
	set waitfor = FALSE
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		for(var/j = 1, j <= group_size, j++)
			var/mob/living/simple_animal/cosmozoan/cozmo = new(spawn_locations[i])
			spawned_carp += WEAKREF(cozmo)
		i++

/datum/event/carp_migration/overmap
	despawn_turfs = list(/turf/space)
	deploy_drones = FALSE

/datum/event/carp_migration/overmap/setup()
	announceWhen = 1
	despawn_turfs = typecacheof(despawn_turfs)