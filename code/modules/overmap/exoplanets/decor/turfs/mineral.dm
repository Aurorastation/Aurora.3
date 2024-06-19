/turf/simulated/floor/exoplanet/mineral
	name = "sand"
	desc = "It's coarse and gets everywhere."
	dirt_color = "#544c31"
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/simulated/floor/exoplanet/mineral/adhomai
	name = "icy rock"
	icon = 'icons/turf/flooring/ice_cavern.dmi'
	icon_state = "icy_rock"
	temperature = T0C - 5
	has_edge_icon = FALSE
	does_footprint = FALSE

/turf/simulated/floor/exoplanet/mineral/adhomai/Initialize(mapload)
	. = ..()
	icon_state = "icy_rock[rand(1,19)]"
