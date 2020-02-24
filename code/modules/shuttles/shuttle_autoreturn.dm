/datum/shuttle/ferry/autoreturn
	var/auto_return_time = 60 //Time after which the shuttle should return in seconds

/datum/shuttle/ferry/autoreturn/arrived()
	addtimer(CALLBACK(src, .proc/announce_return), 20)
	addtimer(CALLBACK(src, .proc/do_return), auto_return_time*10)

/datum/shuttle/ferry/autoreturn/proc/announce_return()
	if(!location)
		for(var/turf/T in get_area_turfs(area_station))
			var/mob/M = locate(/mob) in T
			to_chat(M, span("notice","You have arrived at [current_map.station_name]. The shuttle will return in [auto_return_time] seconds."))

/datum/shuttle/ferry/autoreturn/proc/do_return()
	if(!location)
		launch(null)
		force_launch(null)
