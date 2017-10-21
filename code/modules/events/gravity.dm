/datum/event/gravity
	announceWhen = 5
	ic_name = "a gravity failure"

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in the gravity generation systems. Artificial gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes.", "Gravity Failure")

/datum/event/gravity/start()
	gravity_is_on = 0
	for(var/A in SSmachinery.gravity_generators)
		var/obj/machinery/gravity_generator/main/B = A
		B.eventshutofftoggle()
