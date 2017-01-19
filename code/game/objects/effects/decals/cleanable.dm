/obj/effect/decal/cleanable
	var/list/random_icon_states = list()
	plane = PLANE_ABOVE_FLOOR
	layer = LAYER_FLOOR_BLOOD

/obj/effect/decal/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/New()
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	..()
