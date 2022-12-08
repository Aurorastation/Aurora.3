/datum/turf_initializer/dirty/initialize(var/turf/simulated/T)
	if(T.density)
		return
	// Quick and dirty check to avoid placing things inside windows
	if(locate(/obj/structure/grille, T) || locate(/obj/structure/window_frame, T) || locate(/obj/structure/window/full, T))
		return
	//Don't place on openspace!
	if(T.is_open())
		return
	//Dont place on unsimulated!
	if(istype(T, /turf/unsimulated))
		return

	var/cardinal_turfs = T.CardinalTurfs()

	T.dirt = rand(10, 50) + rand(0, 50)
	// If a neighbor is dirty, then we get dirtier.
	var/how_dirty = dirty_neighbors(cardinal_turfs)
	for(var/i = 0; i < how_dirty; i++)
		T.dirt += rand(0,10)
	T.update_dirt()

	if(prob(25))	// Keep in mind that only "corners" get any sort of web
		attempt_web(T, cardinal_turfs)

/datum/turf_initializer/dirty/proc/dirty_neighbors(var/list/cardinal_turfs)
	var/how_dirty
	for(var/turf/simulated/T in cardinal_turfs)
		// Considered dirty if more than halfway to visible dirt
		if(T.dirt > 25)
			how_dirty++
	return how_dirty

/datum/turf_initializer/dirty/proc/attempt_web(var/turf/simulated/T)
	var/turf/north_turf = get_step(T, NORTH)
	if(!north_turf || !north_turf.density)
		return

	for(var/dir in list(WEST, EAST))	// For the sake of efficiency, west wins over east in the case of 1-tile valid spots, rather than doing pick()
		var/turf/neighbour = get_step(T, dir)
		if(neighbour && neighbour.density)
			if(dir == WEST)
				new /obj/effect/decal/cleanable/cobweb(T)
			if(dir == EAST)
				new /obj/effect/decal/cleanable/cobweb2(T)
			return