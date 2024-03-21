/turf/simulated/floor/exoplanet/asphalt
	name = "asphalt"
	desc = "Once-hot asphalt."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "asphalt0"

/turf/simulated/floor/exoplanet/asphalt/Initialize(mapload)
	. = ..()
	icon_state = "asphalt[rand(0,3)]"
