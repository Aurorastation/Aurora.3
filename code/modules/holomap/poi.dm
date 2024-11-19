
/obj/effect/landmark/minimap_poi
	name = "minimap poi"
	desc = null
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "minimap_poi"

/obj/effect/landmark/minimap_poi/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/minimap_poi/LateInitialize()
	. = ..()
	SSholomap.pois += src

/obj/effect/landmark/minimap_poi/Destroy()
	SSholomap.pois -= src
	. = ..()
