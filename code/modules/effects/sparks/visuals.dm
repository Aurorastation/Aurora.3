// -- Spark visual effect --
/obj/effect/visual/sparks
	name = "sparks"
	icon_state = "sparks"
	anchored = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/spread_direction
	var/ticks_until_step

/obj/effect/visual/sparks/Initialize(mapload)
	. = ..(mapload)
	life_ticks = rand(5,10)

/obj/effect/visual/sparks/tick()
	. = ..()
	ticks_until_step = ticks_until_step ? ticks_until_step - 1 : 0
	if (!ticks_until_step && spread_direction)
		step(src, spread_direction)
		spread_direction = null

	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(1000, 100)

	if (life_ticks < 2)
		animate(src, alpha = 0, time = 2, easing = SINE_EASING | EASE_IN)

/obj/effect/visual/sparks/start(var/direction)
	if (direction)
		spread_direction = direction
		ticks_until_step = 5
