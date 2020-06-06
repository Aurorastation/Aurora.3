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
	icon_state = "rock"

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

/turf/unsimulated/wall/fakepdoor
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	name = "blast door"
	desc = "That looks like it doesn't open easily."

/turf/unsimulated/wall/steel
	icon = 'icons/turf/smooth/composite_solid.dmi'
	icon_state = "map_steel"
	desc = "It's a wall. It appears to be composed of a highly durable alloy and plated with steel."
	color = "#666666"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/turf/unsimulated/wall/steel
	)

/turf/unsimulated/wall/darkshuttlewall
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	icon_state = "map-shuttle"
	desc = "It's a wall. It appears to be composed of a highly durable alloy."
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/turf/unsimulated/wall/darkshuttlewall
	)

/turf/unsimulated/wall/fakeairlock
	icon = 'icons/obj/doors/Doorele.dmi'
	icon_state = "door_closed"
	name = "Airlock"
	desc = "It opens and closes."