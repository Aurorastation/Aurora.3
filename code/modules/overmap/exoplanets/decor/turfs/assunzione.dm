/turf/simulated/floor/exoplanet/assunzione
	name = "artificial substratum"
	desc = "The unclean but highly compacted solid foundation for a building or structure."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "rust"
	has_resources = FALSE

/turf/simulated/floor/exoplanet/assunzione/Initialize(mapload)
	. = ..()
	icon_state = "rust[rand(1,12)]"

/turf/simulated/floor/exoplanet/assunzione/no_edge
	has_edge_icon = FALSE
