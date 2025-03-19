/proc/get_cargo_package_delivery_point(var/atom/atom, var/horizon_only = FALSE)
	var/obj/effect/overmap/visitable/ship/horizon
	if(SSatlas.current_map.overmap_visitable_type)
		horizon = SSshuttle.ship_by_type(SSatlas.current_map.overmap_visitable_type)

	var/turf/current_turf = get_turf(atom)

	var/list/eligible_delivery_points = list()
	for(var/obj/structure/cargo_receptacle/delivery_point in GLOB.all_cargo_receptacles)
		var/obj/effect/overmap/visitable/my_sector = GLOB.map_sectors["[current_turf.z]"]
		var/obj/effect/overmap/visitable/delivery_point_sector = GLOB.map_sectors["[delivery_point.z]"]
		// no delivering to ourselves
		if(my_sector == delivery_point_sector)
			continue
		// guaranteed horizon, has to go to horizon
		if(horizon_only && horizon && delivery_point_sector != horizon)
			continue
		eligible_delivery_points += delivery_point

	if(!length(eligible_delivery_points))
		return

	return pick(eligible_delivery_points)
