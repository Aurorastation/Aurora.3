/datum/shuttle/ferry/arrival

/datum/shuttle/ferry/arrival/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	if(isnull(location))
		return

	if(!destination)
		destination = get_location_area(!location)
	if(!departing)
		departing = get_location_area(location)

	direction = !location

	if(moving_status != SHUTTLE_IDLE) return

	//it would be cool to play a sound here

	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if (at_station() && forbidden_atoms_check())
			//cancel the launch because of forbidden atoms
			moving_status = SHUTTLE_IDLE
			global_announcer.autosay("Unacceptable items detected aboard the arrivals shuttle. Launch attempt failed. Restarting launch in one minute.", "Arrivals Shuttle Oversight")
			SSarrivals.set_launch_countdown(60)
			SSarrivals.failreturnnumber++
			if(SSarrivals.failreturnnumber >= 2) // get off my shuttle fool
				var/list/mobstoyellat = mobs_in_area(get_location_area(location))
				if (!mobstoyellat || !mobstoyellat.len)
					return
				for(var/mob/living/A in mobstoyellat)
					to_chat(A, "<span class='danger'>You feel as if you shouldn't be on the shuttle.</span>") // give them an angry text
					if(!A.client && ishuman(A) && SSarrivals.failreturnnumber >= 3) // well they are SSD and holding up the shuttle so might as well.
						SSjobs.DespawnMob(A)
						global_announcer.autosay("[A.real_name], [A.mind.role_alt_title], has entered long-term storage.", "Cryogenic Oversight")
						mobstoyellat -= A // so they don't get told on
					else if(A.client && ishuman(A) && SSarrivals.failreturnnumber >= 3) // they aren't SSD and are holding up the shuttle so we are booting them.
						A.forceMove(pick(kickoffsloc))
						mobstoyellat -= A
					else if(!ishuman(A) && SSarrivals.failreturnnumber >=4 && !A.client) // remove non-player mobs to keep things rolling
						qdel(A)
				if (mobstoyellat)
					global_announcer.autosay("Current life-forms on shuttle: [english_list(mobstoyellat)].", "Arrivals Shuttle Oversight") // tell on them
			return

		if (!forbidden_atoms_check() && !at_station())
			//cancel the launch because of there's no one on the shuttle.
			moving_status = SHUTTLE_IDLE
			return

		if(!at_station())
			global_announcer.autosay("Central Command Arrivals shuttle inbound to [station_name()]. ETA: one minute.", "Arrivals Shuttle Oversight")
		SSarrivals.failreturnnumber = 0
		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		move(departing, interim, direction)


		while (world.time < arrive_time)
			sleep(5)

		move(interim, destination, direction)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/ferry/arrival/arrived()
	SSarrivals.shuttle_arrived()

/datum/shuttle/ferry/arrival/proc/forbidden_atoms_check()
	return SSarrivals.forbidden_atoms_check(get_location_area())

/datum/shuttle/ferry/arrival/proc/at_station()
	return (!location)
