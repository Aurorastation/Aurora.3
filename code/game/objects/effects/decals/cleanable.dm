/obj/effect/decal/cleanable
	layer = ON_TURF_LAYER
	var/list/random_icon_states

/obj/effect/decal/cleanable/clean_blood(var/ignore = 0)
	if(!ignore)
		qdel(src)
		return
	..()

/obj/effect/decal/cleanable/Initialize(mapload)
	if (LAZYLEN(random_icon_states))
		icon_state = pick(src.random_icon_states)
	. = ..()
	if (!mapload && ROUND_IS_STARTED)
		SSfeedback.IncrementSimpleStat("messes_made")
