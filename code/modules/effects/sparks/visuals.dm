// -- Spark visual_effect --
/obj/visual_effect/sparks
	name = "sparks"
	icon = 'icons/effects/effects.dmi'
	//icon_state = "sparks"
	anchored = 1
	mouse_opacity = 0
	live_icon_state = "sparks"

/obj/visual_effect/sparks/New(var/turf/loc)
	..(loc)
	life_ticks = rand(2,10)

/obj/visual_effect/sparks/resetVariables()
	. = ..()
	life_ticks = rand(2,10)

/obj/visual_effect/sparks/tick()
	. = ..()

	var/turf/T = loc
	if(T)
		T.hotspot_expose(1000, 100)

/obj/visual_effect/sparks/start(var/direction)
	..()
	if (direction)
		spawn (5)
			step(src, direction)
