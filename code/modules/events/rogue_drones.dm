/datum/event/rogue_drone
	endWhen = 1300
	var/list/drones_list = list()
	ic_name = "combat drones"

/datum/event/rogue_drone/start()
	//spawn them at the same place as carp
	var/list/possible_spawns = list()
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn")
			possible_spawns.Add(C)

	var/num = rand(2,10)
	for(var/i=0, i<num, i++)
		var/mob/living/simple_animal/hostile/icarus_drone/malf/D = new(get_turf(pick(possible_spawns)))
		drones_list.Add(D)
		if(prob(25))
			D.disabled = rand(15, 60)

/datum/event/rogue_drone/announce()
	command_announcement.Announce(pick(current_map.rogue_drone_detected_messages), "Rogue drone alert", new_sound = 'sound/AI/combatdrones.ogg')

/datum/event/rogue_drone/end(var/faked)
	var/num_recovered = 0
	for(var/drone in drones_list)
		var/mob/living/simple_animal/hostile/icarus_drone/malf/D = drone
		spark(D.loc, 3)
		D.beam_out()
		num_recovered++

	if(!faked)
		if(num_recovered > length(drones_list) * 0.75)
			command_announcement.Announce(current_map.rogue_drone_end_message, "Rogue drone alert")
		else
			command_announcement.Announce(current_map.rogue_drone_destroyed_message, "Rogue drone alert")
