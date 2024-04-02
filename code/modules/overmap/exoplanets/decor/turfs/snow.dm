/turf/simulated/floor/exoplanet/snow
	name = "snow"
	icon = 'icons/turf/smooth/snow40.dmi'
	icon_state = "snow"
	dirt_color = "#e3e7e8"
	footstep_sound = /singleton/sound_category/snow_footstep
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	canSmoothWith = list(
		/turf/simulated/floor/exoplanet/snow,
		/turf/simulated/wall,
		/turf/unsimulated/wall
	) //Smooths with walls but not the inverse. This way to avoid layering over walls.

/turf/simulated/floor/exoplanet/snow/Initialize()
	. = ..()
	pixel_x = -4
	pixel_y = -4
	icon_state = pick("snow[rand(1,2)]","snow0","snow0")
	SSicon_smooth.add_to_queue_neighbors(src)
	SSicon_smooth.add_to_queue(src)

/turf/simulated/floor/exoplanet/snow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	melt()

/turf/simulated/floor/exoplanet/snow/melt()
	ChangeTurf(/turf/simulated/floor/exoplanet/permafrost)

/turf/simulated/floor/exoplanet/snow/cold //temperature is -5 celsius
	temperature = 268.15

/turf/simulated/floor/exoplanet/permafrost
	name = "permafrost"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "permafrost"
	footstep_sound = /singleton/sound_category/asteroid_footstep

/turf/simulated/floor/exoplanet/permafrost/cold //temperature is -5 celsius
	temperature = 268.15
