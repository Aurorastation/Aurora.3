/turf/simulated/floor/exoplanet/roofing_tiles
	name = "roofing tiles"
	desc = "You're on top of the world!"
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "rooftop"

/turf/simulated/floor/exoplanet/roofing_tiles/Initialize()
	. = ..()
	icon_state = "rooftop[rand(1, 3)]"
