/datum/event/animal_migration
	ic_name = "animal migration"

/datum/event/animal_migration/start()
	if(severity == EVENT_LEVEL_MAJOR)
		spawn_animals(landmarks_list.len)
	else if(severity == EVENT_LEVEL_MODERATE)
		spawn_animals(rand(4, 6))
	else
		spawn_animals(rand(1, 3), 1, 2)

/datum/event/animal_migration/proc/spawn_animals(var/num_groups, var/group_size_min=3, var/group_size_max=5)
	set waitfor = FALSE
	var/list/spawn_locations = list()

	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "animalspawn")
			spawn_locations.Add(C.loc)
	spawn_locations = shuffle(spawn_locations)
	num_groups = min(num_groups, spawn_locations.len)

	var/i = 1
	while (i <= num_groups)
		var/group_size = rand(group_size_min, group_size_max)
		for (var/j = 1, j <= group_size, j++)
			if(prob(50))
				new/mob/living/simple_animal/cow (spawn_locations[i])
			else
				new/mob/living/simple_animal/crab (spawn_locations[i])

			CHECK_TICK
		i++

