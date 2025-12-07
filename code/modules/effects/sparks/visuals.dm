// -- Spark visual effect --
/obj/effect/visual/sparks
	name = "sparks"
	icon_state = "sparks"
	anchored = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	/// Holds a reference to the timer for `do_step`, used in stopping the timer incase of deletion.
	var/step_timer_id

/obj/effect/visual/sparks/Initialize(mapload)
	. = ..(mapload)
	life_ticks = rand(5,10)

/obj/effect/visual/sparks/Destroy()
	deltimer(step_timer_id)
	animate(src, flags = ANIMATION_END_NOW) // if we're being deleted end the animation early
	//find_references()
	return ..()

/obj/effect/visual/sparks/tick()
	. = ..()

	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(1000, 100)

	if (life_ticks < 2)
		animate(src, alpha = 0, time = 2, easing = SINE_EASING | EASE_IN)

/obj/effect/visual/sparks/start(var/direction)
	if (direction)
		step_timer_id = addtimer(CALLBACK(src, PROC_REF(do_step), direction), 0.5 SECONDS, TIMER_STOPPABLE)

/obj/effect/visual/sparks/proc/do_step(direction)
	step(src, direction)
