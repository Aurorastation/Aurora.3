/// Wandering Psirens, an event similar enough to Carp Migration that I can reuse much of the code.
/datum/event/wandering_psirens
	announceWhen	= 50
	endWhen 		= 900

	var/list/spawned_psirens = list()

	var/list/despawn_turfs = list(
		/turf/space,
		/turf/simulated/floor/exoplanet/asteroid,
		/turf/simulated/open,
		/turf/simulated/floor/reinforced/airless	// Station roof.
	)

/datum/event/wandering_psirens/setup()
	announceWhen = rand(40, 60)
	endWhen = rand(600, 1200)
	despawn_turfs = typecacheof(despawn_turfs)

/datum/event/wandering_psirens/announce()
	// Pings every "Psi-sensitive", will trigger feedback on people's mindshields.
	for (var/mob/victim in GLOB.player_list)
		if (SShallucinations.is_adpi_excluded(victim) || SShallucinations.is_adpi_blocked(victim))
			continue

		SShallucinations.send_adpi_message(victim, null, FALSE)

/datum/event/wandering_psirens/start()
	..()

	if(severity == EVENT_LEVEL_MAJOR)
		spawn_psirens(length(GLOB.landmarks_list))
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_psirens(rand(4, 6))			//12 to 30 psirens
	else
		spawn_psirens(rand(1, 3), 1, 2)	//1 to 6 psirens, alone or in pairs

/datum/event/wandering_psirens/proc/spawn_psirens(num_groups, group_size_min = 3, group_size_max = 5)
	set waitfor = FALSE
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in GLOB.landmarks_list)
		if(C.name == "carpspawn") // Reusing the carp landmarks. :)
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		for(var/j = 1, j <= group_size, j++)
			if(prob(95))
				var/basic_psiren
				if (prob(50))
					basic_psiren = new /mob/living/simple_animal/hostile/psiren(spawn_locations[i])
				else basic_psiren = new /mob/living/simple_animal/hostile/psiren/ranged(spawn_locations[i])
				spawned_psirens += WEAKREF(basic_psiren)
			else
				var/mob/living/simple_animal/hostile/psiren/omen/new_omen = new(spawn_locations[i])
				spawned_psirens += WEAKREF(new_omen)
			CHECK_TICK
		i++

/datum/event/wandering_psirens/end(faked)
	..()

	for (var/datum/weakref/psiren_weakref in spawned_psirens)
		var/mob/living/simple_animal/hostile/psiren/psiren = psiren_weakref.resolve()
		if (psiren && prob(50) && is_type_in_typecache(psiren.loc, despawn_turfs))
			spawned_psirens -= psiren_weakref
			qdel(psiren_weakref)
	spawned_psirens?.Cut()

/datum/event/wandering_psirens/overmap
	despawn_turfs = list(/turf/space)
