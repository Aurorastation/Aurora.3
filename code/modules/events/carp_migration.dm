/datum/event/carp_migration
	announceWhen	= 50
	endWhen 		= 900

	var/list/spawned_carp = list()
	var/list/spawned_dweller = list()
	ic_name = "biological entities"

/datum/event/carp_migration/setup()
	announceWhen = rand(40, 60)
	endWhen = rand(600,1200)

/datum/event/carp_migration/announce()
	var/announcement = ""
	if(severity == EVENT_LEVEL_MAJOR)
		announcement = "Massive migration of unknown biological entities has been detected near [station_name()], please stand-by."
	else
		announcement = "Unknown biological [spawned_carp.len == 1 ? "entity has" : "entities have"] been detected near [station_name()], please stand-by."
	command_announcement.Announce(announcement, "Lifesign Alert")

/datum/event/carp_migration/start()
	if(severity == EVENT_LEVEL_MAJOR)
		spawn_fish(landmarks_list.len)
		spawn_caverndweller(landmarks_list.len)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_fish(rand(4, 6)) 			//12 to 30 carp, in small groups
		spawn_caverndweller(rand(1, 2)) //less of those, also don't happen in the regular event
	else
		spawn_fish(rand(1, 3), 1, 2)	//1 to 6 carp, alone or in pairs

/datum/event/carp_migration/proc/spawn_fish(var/num_groups, var/group_size_min=3, var/group_size_max=5)
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		for (var/j = 1, j <= group_size, j++)
			if(prob(99))
				var/mob/living/simple_animal/hostile/carp/carp = new(spawn_locations[i])
				spawned_carp += "\ref[carp]"
			else
				var/mob/living/simple_animal/hostile/carp/shark/carp = new(spawn_locations[i])
				spawned_carp += "\ref[carp]"
		i++

/datum/event/carp_migration/proc/spawn_caverndweller(var/num_groups, var/group_size_min=2, var/group_size_max=3)
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "cavernspawn")
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		for (var/j = 1, j <= group_size, j++)
			var/mob/living/simple_animal/hostile/retaliate/cavern_dweller/dweller = new(spawn_locations[i])
			spawned_dweller += "\ref[dweller]"
		i++

/datum/event/carp_migration/end()
	for (var/carp_ref in spawned_carp)
		var/mob/living/simple_animal/hostile/carp/fish = locate(carp_ref)
		if (fish && istype(fish.loc, /turf/space) && prob(50))
			qdel(fish)
