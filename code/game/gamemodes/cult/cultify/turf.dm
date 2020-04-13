/turf/proc/cultify()
	ChangeTurf(/turf/space)
	return

/turf/simulated/floor/cultify()
	//todo: flooring datum cultify check
	cultify_floor()

/turf/simulated/wall/cultify()
	cultify_wall()

/turf/simulated/wall/r_wall/cultify()
	ChangeTurf(/turf/simulated/wall/cult_reinforced)

/turf/simulated/wall/cult/cultify()
	return

/turf/unsimulated/wall/cult/cultify()
	return

/turf/unsimulated/beach/cultify()
	return

/turf/simulated/open/cultify()
	return

/turf/unsimulated/floor/cultify()
	cultify_floor()

/turf/unsimulated/wall/cultify()
	cultify_wall()

/turf/unsimulated/floor/asteroid/cultify()
	return

/turf/simulated/mineral/cultify()
	return

/turf/proc/cultify_floor()
	if((icon_state != "cult")&&(icon_state != "cult-narsie"))
		icon = 'icons/turf/flooring/cult.dmi'
		icon_state = "cult"
		pixel_x = 0
		pixel_y = 0
		if(istype(src,/turf/simulated/floor))
			var/turf/simulated/floor/F = src
			F.set_flooring(get_flooring_data(/decl/flooring/reinforced/cult))

/turf/proc/cultify_wall()
	ChangeTurf(/turf/unsimulated/wall/cult)
