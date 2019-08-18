/mob/abstract/observer/shuttle
	name = "shuttle coordinates"
	var/datum/shuttle/S
	var/list/Turfs_changed

/mob/abstract/observer/shuttle/verb/view_shuttle()
	set category = "Shuttle"
	set name = "Display shuttle dimensions"
	if(!S)
		return

	var/turf/source_T = get_turf(src)
	if(!source_T)
		return

	var/icon/green = new('icons/misc/debug_group.dmi', "green")
	Turfs_changed = list()
	for(var/v in S.exterior_walls_and_engines)
		var/list/l = v
		var/turf/T = get_turf(locate(source_T.x + S.center[1] - l[1], source_T.y + S.center[2] - l[2], source_T.z))
		client.images += image(green, T,"shuttle", TURF_LAYER)
		Turfs_changed += T