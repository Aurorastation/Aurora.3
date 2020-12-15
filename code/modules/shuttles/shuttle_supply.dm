/datum/shuttle/autodock/ferry/supply
	category = /datum/shuttle/autodock/ferry/supply
	var/away_location = 1	//the location to hide at while pretending to be in-transit
	var/late_chance = 80
	var/max_late_time = 300

/datum/shuttle/autodock/ferry/supply/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)
	SScargo.shuttle = src

/datum/shuttle/autodock/ferry/supply/short_jump(var/area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	if(isnull(location))
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if (at_station() && forbidden_atoms_check())
			//cancel the launch because of forbidden atoms. announce over supply channel?
			moving_status = SHUTTLE_IDLE
			return

		if (!at_station())	//at centcom
			if(!SScargo.buy()) //Check if the shuttle can be sent
				moving_status = SHUTTLE_IDLE //Dont move the shuttle

		//We pretend it's a long_jump by making the shuttle stay at centcom for the "in-transit" period.
		var/obj/effect/shuttle_landmark/away_waypoint = get_location_waypoint(away_location)
		moving_status = SHUTTLE_INTRANSIT

		//If we are at the away_landmark then we are just pretending to move, otherwise actually do the move
		if (next_location == away_waypoint)
			attempt_move(away_waypoint)

		//wait ETA here.
		arrive_time = world.time + SScargo.movetime
		while (world.time <= arrive_time)
			sleep(5)

		if (next_location != away_waypoint)
			//late
			if (prob(late_chance))
				sleep(rand(0,max_late_time))

			attempt_move(destination)

		moving_status = SHUTTLE_IDLE

		if (!at_station())	//at centcom
			SScargo.sell()

// returns 1 if the supply shuttle should be prevented from moving because it contains forbidden atoms
/datum/shuttle/autodock/ferry/supply/proc/forbidden_atoms_check()
	if (!at_station())
		return 0	//if badmins want to send mobs or a nuke on the supply shuttle from centcom we don't care

	for(var/area/A in shuttle_area)
		if(SScargo.forbidden_atoms_check(A))
			return 1

/datum/shuttle/autodock/ferry/supply/proc/at_station()
	return (!location)

//returns 1 if the shuttle is idle and we can still mess with the cargo shopping list
/datum/shuttle/autodock/ferry/supply/proc/idle()
	return (moving_status == SHUTTLE_IDLE)

//returns the ETA in minutes
/datum/shuttle/autodock/ferry/supply/proc/eta_minutes()
	var/ticksleft = arrive_time - world.time
	return round(ticksleft/600,1)
