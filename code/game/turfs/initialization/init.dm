/datum/turf_initializer/proc/initialize(var/turf/T)
	return

/area
	var/datum/turf_initializer/turf_initializer = null

/area/Initialize(mapload)
	..()
	if (mapload)
		for(var/turf/T in src)
			if(turf_initializer)
				turf_initializer.initialize(T)
