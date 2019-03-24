/datum/event/mob_spawner
	ic_name = "travelling party"
	no_fake = 1

/datum/event/mob_spawner/start()
	if(severity == EVENT_LEVEL_MAJOR)
		for(var/obj/effect/landmark/C in landmarks_list)
			if(C.name == "praspawner")
				new /obj/structure/mob_spawner/pra (get_turf(C))
			if(C.name == "pracmdspawner")
				new /obj/structure/mob_spawner/pra/commander (get_turf(C))

	else if(severity == EVENT_LEVEL_MODERATE)
		for(var/obj/effect/landmark/C in landmarks_list)
			if(C.name == "traveller")
				new /obj/structure/mob_spawner/traveller (get_turf(C))


