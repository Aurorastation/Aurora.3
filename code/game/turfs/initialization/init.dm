/datum/turf_initializer/proc/initialize(var/turf/T)
	return

/area
	var/datum/turf_initializer/turf_initializer = null

/area/Initialize(mapload)
	. = ..()
	if (mapload && turf_initializer)
		for(var/turf/T in src)
			turf_initializer.initialize(T)
