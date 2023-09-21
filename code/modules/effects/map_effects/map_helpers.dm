/obj/effect/map_effect/map_helper
	name = "some non-descript map helper (abstract type def)"
	desc = ""
	icon = 'icons/effects/map_effects.dmi'
	layer = ABOVE_ALL_MOB_LAYER

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
