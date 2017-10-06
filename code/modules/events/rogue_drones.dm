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
		var/mob/living/simple_animal/hostile/retaliate/malf_drone/D = new(get_turf(pick(possible_spawns)))
		drones_list.Add(D)
		if(prob(25))
			D.disabled = rand(15, 60)

/datum/event/rogue_drone/announce()
	var/msg
	if(prob(33))
		msg = "A combat drone wing operating out of the NDV Icarus has failed to return from a sweep of this sector, if any are sighted approach with caution."
	else if(prob(50))
		msg = "Contact has been lost with a combat drone wing operating out of the NDV Icarus. If any are sighted in the area, approach with caution."
	else
		msg = "Unidentified hackers have targetted a combat drone wing deployed from the NDV Icarus. If any are sighted in the area, approach with caution."
	command_announcement.Announce(msg, "Rogue drone alert", new_sound = 'sound/AI/combatdrones.ogg')

/datum/event/rogue_drone/end()
	var/num_recovered = 0
	for(var/mob/living/simple_animal/hostile/retaliate/malf_drone/D in drones_list)
		spark(D.loc, 3)
		D.z = current_map.admin_levels[1]
		D.has_loot = 0

		qdel(D)
		num_recovered++

	if(num_recovered > drones_list.len * 0.75)
		command_announcement.Announce("Icarus drone control reports the malfunctioning wing has been recovered safely.", "Rogue drone alert")
	else
		command_announcement.Announce("Icarus drone control registers disappointment at the loss of the drones, but the survivors have been recovered.", "Rogue drone alert")
