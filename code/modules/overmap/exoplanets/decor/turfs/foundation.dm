/turf/simulated/floor/exoplanet/foundation
	name = "foundation"
	desc = "The unclean but highly compacted solid foundation for a building or structure."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "rust"

/turf/simulated/floor/exoplanet/foundation/Initialize(mapload)
	. = ..()
	icon_state = "rust[rand(1,12)]"
