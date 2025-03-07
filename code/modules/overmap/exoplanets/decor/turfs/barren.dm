/turf/simulated/floor/exoplanet/barren
	name = "ground"
	gender = PLURAL
	desc = "A patch of dirt."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"

/turf/simulated/floor/exoplanet/barren/update_icon()
	overlays.Cut()
	if(prob(20))
		overlays += image('icons/turf/decals/decals.dmi', "asteroid[rand(0,9)]")

/turf/simulated/floor/exoplanet/barren/Initialize()
	. = ..()
	update_icon()

/turf/simulated/floor/exoplanet/barren/cave
	name = "dense ground"

/turf/simulated/floor/exoplanet/barren/cave/Initialize() // to make these tiles dark even on daytime exoplanets
	. = ..()
	set_light(0, 1, null)
	footprint_color = null
	update_icon(1)

/turf/simulated/floor/exoplanet/barren/raskara
	desc = "Dark, dark regolith."
	does_footprint = TRUE
	color = "#373737"

/turf/simulated/floor/exoplanet/barren/raskara/update_icon()
	overlays.Cut()
