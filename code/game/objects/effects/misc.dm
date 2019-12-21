//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/obj/items.dmi'
	icon_state = "strangepresent"
	density = 1
	anchored = 0

/atom/movable/afterimage
	name = "after-image"
	desc = "There used to be something here."
	simulated = FALSE
	mouse_opacity = FALSE
	anchored = TRUE

/atom/movable/afterimage/New(turf/loc, atom/target)
	..(loc)
	appearance = target
	// Reset some vars.
	mouse_opacity = 0
	alpha /= 4
	dir = target.dir
	if (!color)
		color = list(
			0.5, 0.5, 0.5,
			0.5, 0.5, 0.5,
			0.5, 0.5, 0.5
		)

	animate(src, alpha = 0, time = 2 SECONDS - 10, easing = EASE_IN|QUAD_EASING)
	QDEL_IN(src, 2 SECONDS)

/atom/movable/afterimage/Destroy()
	appearance = null
	return ..()

/proc/shadow(atom/movable/target)
	new /atom/movable/afterimage(get_turf(target), target)
