/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon = 'icons/turf/walls.dmi'
	icon_state = "fakewindows"
	opacity = 0

/turf/unsimulated/wall/other
	icon = 'icons/turf/walls.dmi'
	icon_state = "r_wall"

// pretty much just a prettier /turf/unsimulated/wall
/turf/unsimulated/wall/riveted
	icon = 'icons/turf/smooth/riveted.dmi'
	icon_state = "riveted"
	desc = "It's a wall. It appears to be composed of a highly durable alloy."
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/turf/unsimulated/wall/riveted,
		/obj/machinery/door/airlock/centcom,
		/turf/unsimulated/wall/fakepdoor
	)
/turf/unsimulated/wall/darkshuttlewall
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall3"

/turf/unsimulated/wall/fakepdoor
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	name = "blast door"
	desc = "That looks like it doesn't open easily."
