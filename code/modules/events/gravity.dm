/datum/event/gravity
	announceWhen = 5
	ic_name = "a gravity failure"
	no_fake = 1

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in the gravity generation systems. Artificial gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes.", "Gravity Failure", zlevels = affecting_z)

/datum/event/gravity/start()
	..()
	for(var/obj/structure/machinery/gravity_generator/main/generator in SSmachinery.gravity_generators)
		if(generator.z in affecting_z)
			return
			// generator.eventshutofftoggle()
