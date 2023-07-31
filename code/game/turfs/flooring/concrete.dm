/turf/simulated/floor/concrete
	name = "concrete floor"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "Concrete1"

/turf/simulated/floor/concrete/update_icon()
	icon_state = "Concrete[rand(1,3)]"

/turf/simulated/floor/concrete/square
	icon_state = "Concrete4"

/turf/simulated/floor/concrete/square/update_icon()
	return