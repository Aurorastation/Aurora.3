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

	for(var/z in affecting_z)
		for(var/obj/machinery/gravity_generator/main/gen as anything in GLOB.gravity_generators["[z]"])
			INVOKE_ASYNC(gen, TYPE_PROC_REF(/obj/machinery/gravity_generator/main, eventshutofftoggle))
