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
	var/message_index = rand(1, length(current_map.rogue_drone_detected_messages))
	var/message = current_map.rogue_drone_detected_messages[message_index]
	var/list/possible_sounds = list('sound/AI/rogue_drone_detected_message_1.ogg', 'sound/AI/rogue_drone_detected_message_2.ogg')
	var/our_sound
	if(length(current_map.rogue_drone_detected_messages > possible_sounds))
		our_sound = possible_sounds[message_index]
	else
		our_sound = possible_sounds[1]
	command_announcement.Announce(message, "Rogue Drone Alert", new_sound = our_sound)

/datum/event/rogue_drone/end(var/faked)
	var/num_recovered = 0
	for(var/drone in drones_list)
		var/mob/living/simple_animal/hostile/icarus_drone/malf/D = drone
		spark(D.loc, 3)
		D.beam_out()
		num_recovered++

	if(!faked)
		if(num_recovered > length(drones_list) * 0.75)
			command_announcement.Announce(current_map.rogue_drone_end_message, "Rogue Drone Alert", new_sound = 'sound/AI/rogue_drone_end_message.ogg', zlevels = affecting_z)
		else
			command_announcement.Announce(current_map.rogue_drone_destroyed_message, "Rogue Drone Alert", new_sound = 'sound/AI/rogue_drone_destroyed_message.ogg', zlevels = affecting_z)
