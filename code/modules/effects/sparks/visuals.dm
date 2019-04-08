// -- Spark visual effect --
/obj/effect/visual/sparks
	name = "sparks"
	icon_state = "sparks"
	anchored = 1
	mouse_opacity = 0

/obj/effect/visual/sparks/Initialize(mapload)
	. = ..(mapload)
	life_ticks = rand(5,10)

/obj/effect/visual/sparks/tick()
	. = ..()

	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(1000, 100)

	if (life_ticks < 2)
		animate(src, alpha = 0, time = 2, easing = SINE_EASING | EASE_IN)

/obj/effect/visual/sparks/start(var/direction)
	if (direction)
		addtimer(CALLBACK(src, .proc/do_step, direction), 5)

/obj/effect/visual/sparks/proc/do_step(direction)
	step(src, direction)
