//Utilities for mapping mixed areas. Perhaps a ruin has areas that should imply lack of roof for example

/obj/effect/map_effect/exterior_marker
	var/set_outside

/obj/effect/map_effect/exterior_marker/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/exterior_marker/LateInitialize()
	var/turf/T = loc
	if(istype(T))
		if(T.flags_1 & INITIALIZED_1)
			T.set_outside(set_outside)
		else
			T.is_outside = set_outside
			T.last_outside_check = OUTSIDE_UNCERTAIN
	qdel(src)

/obj/effect/map_effect/exterior_marker/outside
	name = "Outside"
	set_outside = OUTSIDE_YES

/obj/effect/map_effect/exterior_marker/inside
	name = "Inside"
	set_outside = OUTSIDE_NO

/obj/effect/map_effect/exterior_marker/use_area
	name = "Use Area Outside"
	set_outside = OUTSIDE_AREA
