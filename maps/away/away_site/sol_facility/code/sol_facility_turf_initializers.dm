//
// Sol Facility Turf Initializers
//

// General
/datum/turf_initializer/sol_facility/initialize(var/turf/simulated/T)
	if(T.density)
		return
	if(locate(/obj/structure/grille, T) || locate(/obj/structure/window_frame, T) || locate(/obj/structure/window/full, T))
		return
	if(T.is_open())
		return
	if(istype(T, /turf/unsimulated))
		return

	var/cardinal_turfs = T.CardinalTurfs()

	T.dirt = rand(10, 50) + rand(0, 50)
	var/how_dirty = dirty_neighbors(cardinal_turfs)
	for(var/i = 0; i < how_dirty; i++)
		T.dirt += rand(0,10)
	T.update_dirt()

	if(prob(25))
		attempt_web(T, cardinal_turfs)

/datum/turf_initializer/sol_facility/proc/dirty_neighbors(var/list/cardinal_turfs)
	var/how_dirty
	for(var/turf/simulated/T in cardinal_turfs)
		if(T.dirt > 25)
			how_dirty++
	return how_dirty

/datum/turf_initializer/sol_facility/proc/attempt_web(var/turf/simulated/T)
	var/turf/north_turf = get_step(T, NORTH)
	if(!north_turf || !north_turf.density)
		return

	for(var/dir in list(WEST, EAST))
		var/turf/neighbour = get_step(T, dir)
		if(neighbour && neighbour.density)
			if(dir == WEST)
				new /obj/effect/decal/cleanable/cobweb(T)
			if(dir == EAST)
				new /obj/effect/decal/cleanable/cobweb2(T)
			return