/datum/event/drop_pod
	ic_name = "drop pod"
	no_fake = 1
	var/turf/spawn_loc
	var/list/possible_bad_drops = list(/mob/living/simple_animal/hostile/hivebot/tele, /mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/carp, /mob/living/simple_animal/hostile/carp/shark,
								/mob/living/simple_animal/hostile/giant_spider, /mob/living/simple_animal/hostile/giant_spider/nurse, /mob/living/simple_animal/hostile/viscerator, /mob/living/simple_animal/hostile/creature,
								/mob/living/simple_animal/hostile/retaliate/malf_drone)
	var/list/possible_good_drops = list(/mob/living/simple_animal/cat, /mob/living/simple_animal/corgi, /mob/living/simple_animal/corgi/puppy, /mob/living/simple_animal/crab, /mob/living/simple_animal/hostile/retaliate/goat,
								/mob/living/simple_animal/cow, /mob/living/simple_animal/chick, /mob/living/simple_animal/corgi/fox)

/datum/event/drop_pod/start()
	var/area/a = random_station_area()
	spawn_loc = a.random_space()
	var/drop_x = spawn_loc.x-2
	var/drop_y = spawn_loc.y-2
	var/drop_z = spawn_loc.z

	var/dropped_selection
	if(severity == EVENT_LEVEL_MAJOR)
		dropped_selection = pick(possible_bad_drops)
	else
		dropped_selection = pick(possible_good_drops)

	new /datum/random_map/droppod (null, drop_x, drop_y, drop_z, supplied_drop = dropped_selection)
	log_and_message_admins("A drop pod has landed at (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[spawn_loc.x];Y=[spawn_loc.y];Z=[spawn_loc.z]'>JMP</a>)")