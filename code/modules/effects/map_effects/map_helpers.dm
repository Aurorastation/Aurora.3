/obj/effect/map_effect/map_helper
	name = "some non-descript map helper (abstract type def)"
	desc = ""
	icon = 'icons/effects/map_effects.dmi'
	layer = ABOVE_HUMAN_LAYER

/obj/effect/map_effect/map_helper/Initialize(mapload)
	..()
	return INITIALIZE_HINT_QDEL

/obj/effect/map_effect/map_helper/mark_good
	name = "GOOD"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "mark_good"

/obj/effect/map_effect/map_helper/mark_acceptable
	name = "ACCEPTABLE"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "mark_ehh"

/obj/effect/map_effect/map_helper/mark_bad
	name = "BAD"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "mark_bad"

/obj/effect/map_effect/map_helper/ruler_tiles_3
	name = "ruler, three tiles long"
	icon = 'icons/effects/map_effects_96x96.dmi'
	icon_state = "ruler_tiles_3"
	pixel_x = -32
	pixel_y = -32
