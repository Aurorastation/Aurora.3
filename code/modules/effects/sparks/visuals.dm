// -- Spark visual_effect --
/obj/visual_effect/sparks
	name = "sparks"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	anchored = 1
	mouse_opacity = 0

/obj/visual_effect/sparks/New(var/turf/loc)
	..(loc)
	life_ticks = rand(2,10)

/obj/visual_effect/sparks/tick()
	. = ..()

	var/turf/T = loc
	if(T)
		T.hotspot_expose(1000, 100)

/obj/visual_effect/sparks/start(var/direction)
	..()
	if (direction)
		addtimer(CALLBACK(src, .proc/do_step, direction), 5, TIMER_UNIQUE)

/obj/visual_effect/sparks/proc/do_step(direction)
	step(src, direction)
