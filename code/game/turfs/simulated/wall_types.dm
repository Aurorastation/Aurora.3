/turf/simulated/wall/r_wall
	icon_state = "rgeneric"

/turf/simulated/wall/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel") //3strong

/turf/simulated/wall/cult
	icon_state = "cult"
	desc = "Hideous images dance beneath the surface."
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/wall/cult/Initialize(mapload)
	. = ..(mapload,"cult")
	desc = "Hideous images dance beneath the surface."

/turf/simulated/wall/cult_reinforced/Initialize(mapload)
	. = ..(mapload,"cult","cult2")
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

/turf/simulated/wall/rusty
	icon_state = "arust"

/turf/simulated/wall/rusty/Initialize(mapload)
	. = ..(mapload,"rust")
	desc = "Rust stains this ancient wall."

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

/turf/simulated/wall/wood/Initialize(mapload)
	. = ..(mapload,"wood")

//Destructible shuttle walls

/turf/simulated/wall/voxshuttle/Initialize(mapload)
	. = ..(mapload,"voxalloy")

/turf/simulated/wall/voxshuttle/attackby()
	return

/turf/simulated/wall/shuttle_destructible
	name = "placeholder"
	icon = 'icons/turf/smooth/shuttle_wall.dmi'
	icon_state = "shuttle"
	smooth = SMOOTH_MORE | SMOOTH_DIAGONAL
	permit_ao = FALSE
	canSmoothWith = list(
		/turf/simulated/wall/shuttle_destructible,
		/turf/simulated/shuttle
		/obj/structure/window/shuttle,
		/obj/machinery/door/airlock,
		/obj/machinery/door/unpowered/shuttle,
		/obj/structure/shuttle/engine/propulsion
	)

/turf/simulated/wall/shuttle_destructible/standard
	name = "white wall"
	roof_type = /turf/simulated/shuttle/roof

/turf/simulated/wall/shuttle_destructible/standard/Initialize(mapload)
	.=..(mapload, "shuttle alloy")

/turf/simulated/wall/shuttle_destructible/blue
	name = "blue wall"
	icon = 'icons/turf/smooth/shuttle_wall_blue.dmi'
	roof_type = /turf/simulated/shuttle/roof

/turf/simulated/wall/shuttle_destructible/blue/Initialize(mapload)
	.=..(mapload, "blue shuttle alloy")

/turf/simulated/wall/shuttle_destructible/black
	name = "black wall"
	smooth = null
	icon = 'icons/turf/smooth/shuttle_wall_black.dmi'

/turf/simulated/wall/shuttle/black/Initialize(mapload)
	.=..(mapload, "black shuttle alloy")