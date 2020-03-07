/turf/simulated/wall/r_wall
	icon_state = "rgeneric"

/turf/simulated/wall/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel") //3strong

/turf/simulated/wall/cult
	icon_state = "cult"
	desc = "Hideous images dance beneath the surface."
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/wall/cult/Initialize(mapload)
	. = ..(mapload, "cult")
	desc = "Hideous images dance beneath the surface."

/turf/simulated/wall/cult_reinforced/Initialize(mapload)
	. = ..(mapload, "cult", "cult_reinforced")
	desc = "Hideous images dance beneath the surface."

/turf/unsimulated/wall/cult
	name = "cult wall"
	desc = "Hideous images dance beneath the surface."
	icon = 'icons/turf/smooth/cult_wall.dmi'
	canSmoothWith = null
	smooth = SMOOTH_TRUE
	smoothing_hints = SMOOTHHINT_TARGETS_NOT_UNIQUE | SMOOTHHINT_ONLY_MATCH_TURF
	icon_state = "cult"
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/wall/vaurca/Initialize(mapload)
	. = ..(mapload,"alien biomass")

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

/turf/simulated/wall/titanium/Initialize(mapload)
	. = ..(mapload,"titanium")

/turf/simulated/wall/titanium_reinforced/Initialize(mapload)
	. = ..(mapload,"titanium", "titanium")

/turf/simulated/wall/wood/Initialize(mapload)
	. = ..(mapload,"wood")
