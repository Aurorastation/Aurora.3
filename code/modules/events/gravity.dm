/datum/event/gravity
	announceWhen = 5
	ic_name = "a gravity failure"
	no_fake = 1

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	for (var/zlevel in affecting_z)
		if(zlevel in current_map.station_levels)
			command_announcement.Announce("Feedback surge detected in the gravity generation systems. Artificial gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes.", "Gravity Failure", zlevels = affecting_z)
			break

/datum/event/gravity/start()
	gravity_is_on = 0
	for(var/A in SSmachinery.gravity_generators)
		var/obj/machinery/gravity_generator/main/B = A
		if(B.z in affecting_z)
			B.eventshutofftoggle()


/datum/event/gravity/overmap/announce()
	if(affecting_shuttle)
		send_sensor_message("Entering dark matter influx.")
		return
	return ..()

/datum/event/gravity/overmap/announce_end(var/faked)
	if(affecting_shuttle)
		send_sensor_message("Exiting dark matter influx.")
		return
	return ..()
