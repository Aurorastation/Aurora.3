/turf/simulated/floor/exoplanet/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"
	footstep_sound = SFX_FOOTSTEP_PLATING
	has_resources = FALSE

/turf/simulated/floor/exoplanet/plating/is_plating()
	return TRUE // none of this shit has an `initial_flooring` and i refuse to go over billions of types

/turf/simulated/floor/exoplanet/plating/asteroid
	icon_state = "asteroidplating"

/turf/simulated/floor/exoplanet/plating/asteroid/crystal
	color = "#95c2d9"
