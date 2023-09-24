/turf/unsimulated/wall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE

/turf/unsimulated/wall/fakeglass
	name = "window"
	icon = 'icons/turf/walls.dmi'
	icon_state = "fakewindows"
	opacity = FALSE

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
		/turf/unsimulated/wall/fakepdoor,
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty
	)

/turf/unsimulated/wall/fakepdoor
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = "pdoor1"
	name = "blast door"
	desc = "That looks like it doesn't open easily."

/turf/unsimulated/wall/steel
	icon = 'icons/turf/smooth/composite_solid_color.dmi'
	icon_state = "map_readable"//the best approximation of the ingame gunmetal blended wall sprite for example
	desc = "It's a wall. It appears to be composed of a highly durable alloy and plated with steel."
	color = COLOR_WALL_GUNMETAL
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/turf/unsimulated/wall/steel,
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty
	)

/turf/unsimulated/wall/darkshuttlewall
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	icon_state = "map-shuttle"
	desc = "It's a wall. It appears to be composed of a highly durable alloy."
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/turf/unsimulated/wall/darkshuttlewall,
		/turf/unsimulated/wall/riveted,
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty
	)

/turf/unsimulated/wall/fakeairlock
	icon = 'icons/obj/doors/Doorele.dmi'
	icon_state = "door_closed"
	name = "airlock"
	desc = "It opens and closes."

/turf/unsimulated/wall/konyang
	name = "wall"
	icon = 'icons/turf/smooth/building-konyang.dmi'
	canSmoothWith = list(
		/turf/simulated/wall,
		/turf/simulated/wall/r_wall,
		/turf/simulated/wall/shuttle/scc_space_ship,
		/turf/unsimulated/wall,
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty,
		/obj/machinery/door,
		/obj/machinery/door/airlock
	)
	smooth = SMOOTH_MORE
	icon_state = "map_white"

