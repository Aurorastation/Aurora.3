/datum/shuttle/autodock/ferry/arrival
	category = /datum/shuttle/autodock/ferry/arrival

/datum/shuttle/autodock/ferry/arrival/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)
	SSarrivals.shuttle = src

/datum/shuttle/autodock/ferry/arrival/proc/try_jump()
	spawn(warmup_time * 10)
		if(moving_status != SHUTTLE_IDLE) //The shuttle's already been launched.
			return FALSE

		if(at_station() && forbidden_atoms_check())
			//cancel the launch because of forbidden atoms
			global_announcer.autosay("Unacceptable items or lifeforms detected aboard the arrivals shuttle. Launch attempt aborted. Reattempting launch in one minute.", "Arrivals Shuttle Oversight")
			SSarrivals.set_launch_countdown(60)
			SSarrivals.failreturnnumber++
			if(SSarrivals.failreturnnumber >= 2) // get off my shuttle fool
				var/list/mobstoyellat = list()
				for(var/area/subarea in shuttle_area)
					mobs_in_area(subarea)
				if (!mobstoyellat || !mobstoyellat.len)
					return FALSE
				for(var/mob/living/A in mobstoyellat)
					to_chat(A, "<span class='danger'>You feel as if you shouldn't be on the shuttle.</span>") // give them an angry text
					if(!A.client && ishuman(A) && SSarrivals.failreturnnumber >= 3) // well they are SSD and holding up the shuttle so might as well.
						SSjobs.DespawnMob(A)
						global_announcer.autosay("[A.real_name], [A.mind.role_alt_title], has entered long-term storage.", "Cryogenic Oversight")
						mobstoyellat -= A // so they don't get told on
					else if(A.client && ishuman(A) && SSarrivals.failreturnnumber >= 3) // they aren't SSD and are holding up the shuttle so we are booting them.
						A.forceMove(pick(kickoffsloc))
						mobstoyellat -= A
					else if(!ishuman(A) && SSarrivals.failreturnnumber >= 4 && !A.client) // remove non-player mobs to keep things rolling
						qdel(A)
					else if(issilicon(A.loc) && isMMI(A))
						mobstoyellat -= A
				if (mobstoyellat)
					global_announcer.autosay("Current life-forms on shuttle: [english_list(mobstoyellat)].", "Arrivals Shuttle Oversight") // tell on them
			return FALSE

		if (!forbidden_atoms_check() && !at_station())
			//cancel the launch because of there's no one on the shuttle.
			return FALSE

		if(!at_station())
			global_announcer.autosay("Central Command Arrivals shuttle inbound to [station_name()]. ETA: one minute.", "Arrivals Shuttle Oversight")
		SSarrivals.failreturnnumber = 0
		launch(SSarrivals)

/datum/shuttle/autodock/ferry/arrival/arrived()
	SSarrivals.shuttle_arrived()

/datum/shuttle/autodock/ferry/arrival/proc/forbidden_atoms_check()
	for(var/area/subarea in shuttle_area)
		if(SSarrivals.forbidden_atoms_check(subarea))
			return TRUE

/datum/shuttle/autodock/ferry/arrival/proc/at_station()
	return (!location)
