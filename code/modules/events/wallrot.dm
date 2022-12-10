/datum/event/wallrot
	var/turf/simulated/wall/origin_turf

/datum/event/wallrot/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1

/datum/event/wallrot/announce()
	command_announcement.Announce("Harmful fungi detected at coordinates ([origin_turf.x], [origin_turf.y], [origin_turf.z]). The structure may be contaminated.", "Biohazard Alert", new_sound = 'sound/AI/fungi.ogg', zlevels = affecting_z)

/datum/event/wallrot/start()
	set waitfor = FALSE

	// 100 attempts
	for(var/i = 0, i < 100, i++)
		var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), pick(current_map.station_levels))
		if(istype(candidate, /turf/simulated/wall))
			origin_turf = candidate
			break

	if(origin_turf)
		// Make sure at least one piece of wall rots!
		origin_turf.rot()

		// Have a chance to rot lots of other walls.
		var/rotcount = 0
		var/actual_severity = severity * rand(10, 20)
		for(var/turf/simulated/wall/W in range(12, origin_turf))
			if(prob(30))
				W.rot()
				rotcount++

				// Only rot up to severity walls
				if(rotcount >= actual_severity)
					break
