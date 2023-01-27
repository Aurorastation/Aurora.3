var/datum/overmap_sectors =  list()
var/datum/overmaps_by_name = list()
var/datum/overmaps_by_z =    list()

/proc/get_empty_zlevel(var/base_turf_type)
	if(base_turf_type && base_turf_type != world.turf)
		for(var/turf/T as anything in block(locate(1, 1, .),locate(world.maxx, world.maxy, .)))
			T.ChangeTurf(base_turf_type)
	return world.maxz
