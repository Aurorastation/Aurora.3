/turf/simulated/wall/r_wall
	icon_state = "rgeneric"

/turf/simulated/wall/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel") //3strong

/turf/simulated/wall/cult
	icon_state = "cult"

/turf/simulated/wall/cult/Initialize(mapload)
	. = ..(mapload,"cult","cult2")

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/smooth/cult_wall.dmi'
	canSmoothWith = null
	smooth = SMOOTH_TRUE
	icon_state = "cult"

/turf/simulated/wall/rusty
	icon_state = "arust"
	desc = "Rust stains this ancient wall."
/turf/simulated/wall/rusty/Initialize(mapload)
	..(mapload,"rust","rust")

/turf/simulated/wall/iron/Initialize(mapload)
	. = ..(mapload,"iron")

/turf/simulated/wall/uranium/Initialize(mapload)
	. = ..(mapload,"uranium")

/turf/simulated/wall/diamond/Initialize(mapload)
	. = ..(mapload,"diamond")

/turf/simulated/wall/gold/Initialize(mapload)
	. = ..(mapload,"gold")

/turf/simulated/wall/silver/Initialize(mapload)
	. = ..(mapload,"silver")

/turf/simulated/wall/phoron/Initialize(mapload)
	. = ..(mapload,"phoron")

/turf/simulated/wall/sandstone/Initialize(mapload)
	. = ..(mapload,"sandstone")

/turf/simulated/wall/ironphoron/Initialize(mapload)
	. = ..(mapload,"iron","phoron")

/turf/simulated/wall/golddiamond/Initialize(mapload)
	. = ..(mapload,"gold","diamond")

/turf/simulated/wall/silvergold/Initialize(mapload)
	. = ..(mapload,"silver","gold")

/turf/simulated/wall/sandstonediamond/Initialize(mapload)
	. = ..(mapload,"sandstone","diamond")

// Kind of wondering if this is going to bite me in the butt.
/turf/simulated/wall/voxshuttle/Initialize(mapload)
	. = ..(mapload,"voxalloy")

/turf/simulated/wall/voxshuttle/attackby()
	return

/turf/simulated/wall/titanium/Initialize(mapload)
	. = ..(mapload,"titanium")
