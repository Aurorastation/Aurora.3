/turf/simulated/floor/exoplanet/barren
	name = "ground"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/simulated/floor/exoplanet/barren/update_icon()
	overlays.Cut()
	if(prob(20))
		overlays += image('icons/turf/decals/decals.dmi', "asteroid[rand(0,9)]")

/turf/simulated/floor/exoplanet/barren/Initialize()
	. = ..()
	update_icon()

/turf/simulated/floor/exoplanet/barren/raskara
	color = "#373737"

/turf/simulated/floor/exoplanet/barren/raskara/update_icon()
	overlays.Cut()
