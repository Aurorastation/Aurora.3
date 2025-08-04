/turf/simulated/floor/exoplanet/konyang
	name = "dense mossy grass"
	gender = PLURAL
	desc = "An alien moss covers the ground."
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "grass"
	footstep_sound = /singleton/sound_category/grass_footstep

/turf/simulated/floor/exoplanet/konyang/no_edge
	has_edge_icon = FALSE

/obj/effect/konyang_foam
	name = "coastal sea foam"
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "foam"
	layer = 3
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/obj/effect/konyang_waterfall
	name = "waterfall"
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "waterfall_top"
	layer = 5
	opacity = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/obj/effect/konyang_waterfall/mist
	icon_state = "mist_center"
	layer = 5.1

/turf/simulated/floor/exoplanet/konyang/wilting//manually mapped. To be surrounded by normal grass
	name = "wilting mossy grass"
	desc = "An alien moss covers the ground. This patch doesn't look so healthy..."
	icon = 'icons/turf/flooring/exoplanet/konyang/moss_transition_1.dmi'
	icon_state = "unsmooth"
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	canSmoothWith = list(/turf/simulated/floor/exoplanet/konyang/wilting, /turf/simulated/floor/exoplanet/konyang/pink)

/turf/simulated/floor/exoplanet/konyang/pink//manually mapped. To be surrounded by wilting grass
	name = "blossoming mossy grass"
	desc = "The moss here is blooming in a shade of pink."
	icon = 'icons/turf/flooring/exoplanet/konyang/moss_transition_2.dmi'
	icon_state = "unsmooth"
	smoothing_flags = SMOOTH_TRUE

/turf/simulated/floor/exoplanet/dirt_konyang//a different path entirely so it will allow for edges to generate from grass
	name = "compacted dirt"
	desc = "A patch of dirt."
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "dirt"
	layer = 1.99//to let the grass edges go over it, which otherwise doesnt happen due to positioning and byond layering
	footstep_sound = /singleton/sound_category/asteroid_footstep
	has_edge_icon = FALSE

/turf/simulated/floor/exoplanet/dirt_konyang/cave
	name = "dense compacted dirt"

/turf/simulated/floor/exoplanet/dirt_konyang/cave/Initialize() // to make these tiles dark even on daytime exoplanets
	. = ..()
	set_light(0, 1, null)
	footprint_color = null
	update_icon(1)

/turf/simulated/floor/exoplanet/dirt_konyang/sand//same as above
	name = "fine coastal sand"
	desc = "Some fine, white sand."
	icon = 'icons/turf/flooring/exoplanet/konyang/konyang_beach.dmi'
	icon_state = "sand"
	footstep_sound = /singleton/sound_category/asteroid_footstep
	smoothing_flags = SMOOTH_FALSE
	has_edge_icon = FALSE
