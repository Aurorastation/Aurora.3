/turf/simulated/floor/exoplanet/ice
	name = "ice"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "ice"
	footprint_color = FALSE

/turf/simulated/floor/exoplanet/ice/update_icon()
	return

/turf/simulated/floor/exoplanet/ice/cold //temperature is -5 celsius
	temperature = 268.15

/turf/simulated/floor/exoplanet/ice/dark
	icon_state = "icedark"

/turf/simulated/floor/exoplanet/ice/dark/cold //temperature is -5 celsius
	temperature = 268.15
