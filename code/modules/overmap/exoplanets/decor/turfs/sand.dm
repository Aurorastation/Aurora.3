/turf/simulated/floor/exoplanet/desert
	name = "sand"
	desc = "It's coarse and gets everywhere."
	dirt_color = "#ae9e66"
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/simulated/floor/exoplanet/desert/Initialize()
	. = ..()
	icon_state = "desert[rand(0,4)]"

/turf/simulated/floor/exoplanet/desert/sand
	icon = 'icons/turf/desert_color_tweak.dmi'
	icon_state = "desert_sand"

/turf/simulated/floor/exoplanet/desert/sand/Initialize()
	. = ..()
	icon_state = "desert_sand[rand(4,7)]"

/turf/simulated/floor/exoplanet/desert/sand/dune/Initialize()
	. = ..()
	icon_state = "desert_sand[rand(1,3)]"
