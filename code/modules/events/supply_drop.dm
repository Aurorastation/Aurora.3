//This mundane event spawns a random crate of loot

/datum/event/supply_drop
	var/location_name
	var/turf/spawn_loc

/datum/event/supply_drop/setup()
	announceWhen = rand(0,80)

/datum/event/supply_drop/start()
	var/rarity = 4
	var/quantity = rand(10,25)

	var/area/a = random_station_area()
	spawn_loc = a.random_space()
	location_name = a.name

	new /obj/structure/closet/crate/loot(spawn_loc, rarity, quantity)
	log_and_message_admins("Unusual container spawned at (<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[spawn_loc.x];Y=[spawn_loc.y];Z=[spawn_loc.z]'>JMP</a>)")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(10, 0, spawn_loc)
	s.start()
	spawn(2)
		qdel(s)


/datum/event/supply_drop/announce()
	if (prob(65))//Announce the location
		command_announcement.Announce("Transport signature of unknown origin detected in [location_name], an object appears to have been beamed aboard [station_name()].", "Unknown Object")
	else if (prob(25))//Announce the transport, but not the location
		command_announcement.Announce("External transport signature of unknown origin detected aboard [station_name()], precise destination point cannot be determined, please investigate.", "Unknown Object")
	//Otherwise, no announcement at all.
	//Someone will randomly stumble across it, and probably quietly loot it without telling anyone