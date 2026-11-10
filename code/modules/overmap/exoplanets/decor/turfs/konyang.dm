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

/turf/simulated/floor/exoplanet/konyang
	name = "dense mossy grass"
	gender = PLURAL
	desc = "An alien moss covers the ground."
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "grass"
	footstep_sound = SFX_FOOTSTEP_GRASS
	has_edge_icon = TRUE

/turf/simulated/floor/exoplanet/konyang/no_edge
	has_edge_icon = FALSE

// manually mapped. To be surrounded by normal grass
/turf/simulated/floor/exoplanet/konyang/wilting
	name = "wilting mossy grass"
	desc = "An alien moss covers the ground. This patch doesn't look so healthy..."
	icon = 'icons/turf/flooring/exoplanet/konyang/moss_transition_1.dmi'
	icon_state = "unsmooth"
	has_edge_icon = FALSE
	smoothing_flags = SMOOTH_MORE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	canSmoothWith = list(/turf/simulated/floor/exoplanet/konyang/wilting, /turf/simulated/floor/exoplanet/konyang/pink)

// manually mapped. To be surrounded by wilting grass
/turf/simulated/floor/exoplanet/konyang/pink
	name = "blossoming mossy grass"
	desc = "The moss here is blooming in a shade of pink."
	icon = 'icons/turf/flooring/exoplanet/konyang/moss_transition_2.dmi'
	icon_state = "unsmooth"
	has_edge_icon = FALSE
	smoothing_flags = SMOOTH_TRUE

// a different path entirely so it will allow for edges to generate from grass
/turf/simulated/floor/exoplanet/dirt_konyang
	name = "compacted dirt"
	desc = "A patch of dirt."
	icon = 'icons/turf/flooring/exoplanet/konyang.dmi'
	icon_state = "dirt"
	layer = 1.99 // to let the grass edges go over it, which otherwise doesnt happen due to positioning and byond layering
	footstep_sound = SFX_FOOTSTEP_ASTEROID

// same as above
/turf/simulated/floor/exoplanet/dirt_konyang/sand
	name = "fine coastal sand"
	desc = "Some fine, white sand."
	icon = 'icons/turf/flooring/exoplanet/konyang/konyang_beach.dmi'
	icon_state = "sand"
	footstep_sound = SFX_FOOTSTEP_ASTEROID
	smoothing_flags = SMOOTH_FALSE

/turf/simulated/floor/exoplanet/dirt_konyang/cave
	name = "dense compacted dirt"

// to make these tiles dark even on daytime exoplanets
/turf/simulated/floor/exoplanet/dirt_konyang/cave/Initialize()
	. = ..()
	set_light(0, 1, null)
	footprint_color = null
	update_icon(1)

