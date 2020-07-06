/obj/effect/decal/cleanable
	layer = ABOVE_CABLE_LAYER
	var/list/random_icon_states
	var/swept_away

/obj/effect/decal/cleanable/attack_hand(mob/user)
	if(!swept_away)
		if(locate(/obj/machinery/atmospherics) in get_turf(src))
			to_chat(user, SPAN_NOTICE("You brush \the [src] away from the piping with your hand."))
			layer = UNDER_PIPE_LAYER
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
		SSfeedback.IncrementSimpleStat("messes_made")