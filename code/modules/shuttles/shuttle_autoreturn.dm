/datum/shuttle/ferry/autoreturn
	var/auto_return_time = 60 //Time after which the shuttle should return in seconds
	category = /datum/shuttle/ferry/autoreturn

/datum/shuttle/ferry/autoreturn/arrived()
	if(waypoint_station == current_location)
		addtimer(CALLBACK(src, PROC_REF(announce_return)), 20)
		addtimer(CALLBACK(src, PROC_REF(do_return)), auto_return_time*10)

/datum/shuttle/ferry/autoreturn/proc/announce_return()
	if(!location)
		for(var/area/A in shuttle_area)
			for(var/turf/T as anything in A.get_turfs_from_all_zlevels())
				for(var/mob/M in T)
					if(ishuman(M))
						to_chat(M, SPAN_NOTICE("You have arrived at the [SSmapping.current_map.station_name]! The shuttle will return in [auto_return_time] seconds. Enjoy your stay!"))

/datum/shuttle/ferry/autoreturn/proc/do_return()
	launch(src)
