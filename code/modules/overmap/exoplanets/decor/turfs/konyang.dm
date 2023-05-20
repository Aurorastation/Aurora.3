/turf/simulated/floor/exoplanet/konyang
	name = "dense mossy grass"
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "grass"
	footstep_sound = /singleton/sound_category/grass_footstep
	does_footprint = FALSE

/obj/effect/konyang_foam
	name = "coastal sea foam"
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "foam"
	layer = ON_TURF_LAYER
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/turf/simulated/floor/exoplanet/dirt_konyang//a different path entirely so it will allow for edges to generate from grass
	name = "compacted dirt"
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "dirt"
	layer = 1.99//to let the grass edges go over it, which otherwise doesnt happen due to positioning and byond layering
	footstep_sound = /singleton/sound_category/asteroid_footstep
	does_footprint = FALSE
	has_edge_icon = FALSE
