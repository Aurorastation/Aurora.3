/obj/effect/decal/cleanable
	mouse_opacity = MOUSE_OPACITY_ICON
	var/list/random_icon_states
	var/swept_away

/obj/effect/decal/cleanable/attack_hand(mob/user)
	if(!swept_away && layer == DECAL_LAYER) // have to check layer otherwise more vars need to be added to determine whether it CAN be sweeped
		if((locate(/obj/machinery/atmospherics) in get_turf(src)) || (locate(/obj/machinery/hologram/holopad) in get_turf(src)))
			to_chat(user, SPAN_NOTICE("You brush \the [src] away with your hand."))
			layer = TURF_DETAIL_LAYER
			swept_away = TRUE
			post_sweep(user)

/obj/effect/decal/cleanable/proc/post_sweep(var/mob/user)
	return

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
		SSstatistics.IncrementSimpleStat("messes_made")

	var/turf/T = get_turf(src)
	if(!T?.is_space())
		return
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
