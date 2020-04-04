/datum/shuttle/autodock/ferry/autoreturn
	var/auto_return_time = 60 //Time after which the shuttle should return in seconds
	category = /datum/shuttle/autodock/ferry/autoreturn

/datum/shuttle/autodock/ferry/autoreturn/arrived()
	if(waypoint_station == current_location)
		addtimer(CALLBACK(src, .proc/announce_return), 20)
		addtimer(CALLBACK(src, .proc/do_return), auto_return_time*10)

/datum/shuttle/autodock/ferry/autoreturn/proc/announce_return()
	if(!location)
		for(var/area/A in shuttle_area)
			for(var/mob/M in A)
				if(ishuman(M))
					to_chat(M, SPAN_NOTICE("You have arrived at the [current_map.station_name]! The shuttle will return in [auto_return_time] seconds. Enjoy your stay!"))

/datum/shuttle/autodock/ferry/autoreturn/proc/do_return()
	launch(src)
