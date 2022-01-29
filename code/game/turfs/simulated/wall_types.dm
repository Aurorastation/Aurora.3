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
	canSmoothWith = list(/turf/simulated/wall/cult, /turf/simulated/wall/cult_reinforced)

/turf/simulated/wall/cult_reinforced/Initialize(mapload)
	. = ..(mapload, MATERIAL_CULT, MATERIAL_CULT_REINFORCED)
	desc = "Hideous images dance beneath the surface."
	canSmoothWith = list(/turf/simulated/wall/cult, /turf/simulated/wall/cult_reinforced)

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
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_VAURCA)

/turf/simulated/wall/iron/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_IRON)

/turf/simulated/wall/uranium/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_URANIUM)

/turf/simulated/wall/diamond/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_DIAMOND)

/turf/simulated/wall/gold/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_GOLD)

/turf/simulated/wall/silver/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SILVER)

/turf/simulated/wall/phoron/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_PHORON)

/turf/simulated/wall/sandstone/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SANDSTONE)

/turf/simulated/wall/ironphoron/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_IRON, MATERIAL_PHORON)

/turf/simulated/wall/golddiamond/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_GOLD, MATERIAL_DIAMOND)

/turf/simulated/wall/silvergold/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SILVER, MATERIAL_GOLD)

/turf/simulated/wall/sandstonediamond/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_SANDSTONE, MATERIAL_DIAMOND)

/turf/simulated/wall/titanium/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_TITANIUM)

/turf/simulated/wall/titanium_reinforced/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_TITANIUM, MATERIAL_TITANIUM)

/turf/simulated/wall/wood/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_WOOD)

/turf/simulated/wall/rusty/Initialize(mapload)
	canSmoothWith = list(src.type)
	. = ..(mapload, MATERIAL_RUST)
	desc = "Rust stains this ancient wall."