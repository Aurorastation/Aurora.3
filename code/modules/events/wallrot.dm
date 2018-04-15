datum/event/wallrot/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1

datum/event/wallrot/announce()
	command_announcement.Announce("Harmful fungi detected on station. Station structures may be contaminated.", "Biohazard Alert", new_sound = pick('sound/AI/fungi.ogg', 'sound/AI/funguy.ogg', 'sound/AI/fun_guy.ogg', 'sound/AI/fun_gi.ogg'))

datum/event/wallrot/start()
	set waitfor = FALSE

	var/turf/simulated/wall/center = null

	// 100 attempts
	for(var/i=0, i<100, i++)
		var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), pick(current_map.station_levels))
		if(istype(candidate, /turf/simulated/wall))
			center = candidate

	if(center)
		// Make sure at least one piece of wall rots!
		center.rot()

		// Have a chance to rot lots of other walls.
		var/rotcount = 0
		var/actual_severity = severity * rand(10, 20)
		for(var/turf/simulated/wall/W in range(12, center)) if(prob(30))
			W.rot()
			rotcount++

			// Only rot up to severity walls
			if(rotcount >= actual_severity)
				break
