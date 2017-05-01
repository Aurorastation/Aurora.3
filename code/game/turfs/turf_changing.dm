/turf
	var/tmp/changing_turf

/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(get_base_turf_by_area(src))
	spawn()
		new /obj/structure/lattice( locate(src.x, src.y, src.z) )

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)

//Creates a new turf
/turf/proc/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0)
	if (!N)
		return

	// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		if(istype(below) && (SSair.has_valid_zone(below) || SSair.has_valid_zone(src)))
			N = /turf/simulated/open

	var/obj/fire/old_fire = fire
	var/old_baseturf = baseturf
	changing_turf = TRUE
	
	//world << "Replacing [src.type] with [N]"

	if(connections) 
		connections.erase_all()

	// So we call destroy.
	qdel(src)

	if(ispath(N, /turf/simulated/floor))
		var/turf/simulated/W = new N( locate(src.x, src.y, src.z) )
		if(old_fire)
			fire = old_fire

		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()

		if(tell_universe)
			universe.OnTurfChange(W)

		if(SSair)
			SSair.mark_for_update(src) //handle the addition of the new turf.

		W.baseturf = old_baseturf

		W.levelupdate()
		. = W

	else

		var/turf/W = new N( locate(src.x, src.y, src.z) )

		if(old_fire)
			old_fire.RemoveFire()

		if(tell_universe)
			universe.OnTurfChange(W)

		if(SSair)
			SSair.mark_for_update(src)

		W.baseturf = old_baseturf

		W.levelupdate()
		. =  W

	queue_smooth_neighbors(src)
	queue_smooth(src)
