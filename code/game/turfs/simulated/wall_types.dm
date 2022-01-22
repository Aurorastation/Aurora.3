/turf/simulated/wall/r_wall
	icon_state = "rgeneric"

/turf/simulated/wall/r_wall/Initialize(mapload)
	. = ..(mapload, "plasteel","plasteel") //3strong

/turf/simulated/wall/cult
	icon_state = "cult"
	desc = "Hideous images dance beneath the surface."
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/wall/cult/Initialize(mapload)
	. = ..(mapload, MATERIAL_CULT)
	desc = "Hideous images dance beneath the surface."
	canSmoothWith = (/turf/simulated/wall/cult, /turf/simulated/wall/cult_reinforced)

/turf/simulated/wall/cult_reinforced/Initialize(mapload)
	. = ..(mapload, MATERIAL_CULT, MATERIAL_CULT_REINFORCED)
	desc = "Hideous images dance beneath the surface."
	canSmoothWith = (/turf/simulated/wall/cult, /turf/simulated/wall/cult_reinforced)

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
	. = ..(mapload, MATERIAL_VAURCA)
	canSmoothWith = (src.type)

/turf/simulated/wall/iron/Initialize(mapload)
	. = ..(mapload, MATERIAL_IRON)
	canSmoothWith = (src.type)

/turf/simulated/wall/uranium/Initialize(mapload)
	. = ..(mapload, MATERIAL_URANIUM)
	canSmoothWith = (src.type)

/turf/simulated/wall/diamond/Initialize(mapload)
	. = ..(mapload, MATERIAL_DIAMOND)
	canSmoothWith = (src.type)

/turf/simulated/wall/gold/Initialize(mapload)
	. = ..(mapload, MATERIAL_GOLD)
	canSmoothWith = (src.type)

/turf/simulated/wall/silver/Initialize(mapload)
	. = ..(mapload, MATERIAL_SILVER)
	canSmoothWith = (src.type)

/turf/simulated/wall/phoron/Initialize(mapload)
	. = ..(mapload, MATERIAL_PHORON)
	canSmoothWith = (src.type)

/turf/simulated/wall/sandstone/Initialize(mapload)
	. = ..(mapload, MATERIAL_SANDSTONE)
	canSmoothWith = (src.type)

/turf/simulated/wall/ironphoron/Initialize(mapload)
	. = ..(mapload, MATERIAL_IRON, MATERIAL_PHORON)
	canSmoothWith = (src.type)

/turf/simulated/wall/golddiamond/Initialize(mapload)
	. = ..(mapload, MATERIAL_GOLD, MATERIAL_DIAMOND)
	canSmoothWith = (src.type)

/turf/simulated/wall/silvergold/Initialize(mapload)
	. = ..(mapload, MATERIAL_SILVER, MATERIAL_GOLD)
	canSmoothWith = (src.type)

/turf/simulated/wall/sandstonediamond/Initialize(mapload)
	. = ..(mapload, MATERIAL_SANDSTONE, MATERIAL_DIAMOND)
	canSmoothWith = (src.type)

/turf/simulated/wall/titanium/Initialize(mapload)
	. = ..(mapload, MATERIAL_TITANIUM)
	canSmoothWith = (src.type)

/turf/simulated/wall/titanium_reinforced/Initialize(mapload)
	. = ..(mapload, MATERIAL_TITANIUM, MATERIAL_TITANIUM)
	canSmoothWith = (src.type)

/turf/simulated/wall/wood/Initialize(mapload)
	. = ..(mapload, MATERIAL_WOOD)
	canSmoothWith = (src.type)

/turf/simulated/wall/rusty/Initialize(mapload)
	. = ..(mapload, MATERIAL_RUST)
	desc = "Rust stains this ancient wall."
	canSmoothWith = (src.type)