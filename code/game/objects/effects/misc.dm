//The effect when you wrap a dead body in gift wrap
/obj/effect/spresent
	name = "strange present"
	desc = "It's a ... present?"
	icon = 'icons/holidays/christmas/presents.dmi'
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
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
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

/obj/effect/constructing_effect
	icon = 'icons/effects/effects_rfd.dmi'
	icon_state = ""
	layer = BASE_ABOVE_OBJ_LAYER
	anchored = TRUE
	var/delay = 0
	var/status = 0

/obj/effect/constructing_effect/Initialize(mapload, build_delay, mode)
	. = ..()
	delay = build_delay // so the variables transfer over between procs.
	status = mode
	if(status == 3)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 11)
		delay -= 11
		icon_state = "rfd_end_reverse"
	else
		update_icon()

/obj/effect/constructing_effect/update_icon()
	icon_state = "rfd"
	if(delay < 10)
		icon_state += "_shortest"
	else if(delay < 20)
		icon_state += "_shorter"
	else if(delay < 37)
		icon_state += "_short"
	if(status == 3)
		icon_state += "_reverse"

/obj/effect/constructing_effect/proc/end_animation()
	if(status == 3)
		end()
	else
		icon_state = "rfd_end"
		addtimer(CALLBACK(src, PROC_REF(end)), 15)

/obj/effect/constructing_effect/proc/end()
	qdel(src)
