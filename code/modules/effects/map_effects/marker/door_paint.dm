
// ----------------------------------- main defs

///
/obj/effect/map_effect/marker/door_paint
	var/fill_color = null
	var/stripe_color = null
	var/frame_color = null

/obj/effect/map_effect/marker/door_paint/Initialize(mapload, ...)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/door_paint/LateInitialize()
	for(var/thing in loc)
		var/obj/structure/machinery/door/airlock/door = thing
		if(!istype(door))
			continue
		door.paintable = AIRLOCK_PAINTABLE_MAIN | AIRLOCK_PAINTABLE_STRIPE
		if(fill_color)
			door.door_color = fill_color
		if(stripe_color)
			door.stripe_color = stripe_color
		if(frame_color)
			door.door_frame_color = frame_color
		door.update_icon()

// ----------------------------------- main defs

/obj/effect/map_effect/marker/door_paint/fill
	icon_state = "marker_door_paint_fill"

/obj/effect/map_effect/marker/door_paint/fill/LateInitialize()
	fill_color = color
	. = ..()

/obj/effect/map_effect/marker/door_paint/stripe
	icon_state = "marker_door_paint_stripe"

/obj/effect/map_effect/marker/door_paint/stripe/LateInitialize()
	stripe_color = color
	. = ..()

/obj/effect/map_effect/marker/door_paint/frame
	icon_state = "marker_door_paint_frame"

/obj/effect/map_effect/marker/door_paint/frame/LateInitialize()
	frame_color = color
	. = ..()

// ----------------------------------- department subtypes

// to be filled with department color defines, if they were ever to be decided

// ----------------------------------- color fill subtypes

/obj/effect/map_effect/marker/door_paint/fill/black
	color = COLOR_GRAY20

/obj/effect/map_effect/marker/door_paint/fill/blue
	color = COLOR_BLUE_GRAY

/obj/effect/map_effect/marker/door_paint/fill/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/map_effect/marker/door_paint/fill/dark_blue
	color = COLOR_DARK_BLUE_GRAY

/obj/effect/map_effect/marker/door_paint/fill/dark_green
	color = COLOR_DARK_GREEN_GRAY

/obj/effect/map_effect/marker/door_paint/fill/green
	color = COLOR_GREEN_GRAY

/obj/effect/map_effect/marker/door_paint/fill/lime
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/map_effect/marker/door_paint/fill/yellow
	color = COLOR_BROWN

/obj/effect/map_effect/marker/door_paint/fill/beige
	color = COLOR_BEIGE

/obj/effect/map_effect/marker/door_paint/fill/red
	color = COLOR_RED_GRAY

/obj/effect/map_effect/marker/door_paint/fill/pink
	color = COLOR_PALE_RED_GRAY

/obj/effect/map_effect/marker/door_paint/fill/purple
	color = COLOR_PURPLE_GRAY

/obj/effect/map_effect/marker/door_paint/fill/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/map_effect/marker/door_paint/fill/orange
	color = COLOR_DARK_ORANGE

/obj/effect/map_effect/marker/door_paint/fill/brown
	color = COLOR_DARK_BROWN

/obj/effect/map_effect/marker/door_paint/fill/white
	color = COLOR_GRAY70

/obj/effect/map_effect/marker/door_paint/fill/grey
	color = COLOR_GRAY

// ----------------------------------- color stripe subtypes

/obj/effect/map_effect/marker/door_paint/stripe/gold
	color = COLOR_GOLD

/obj/effect/map_effect/marker/door_paint/stripe/black
	color = COLOR_GRAY20

/obj/effect/map_effect/marker/door_paint/stripe/blue
	color = COLOR_BLUE_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/paleblue
	color = COLOR_PALE_BLUE_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/dark_blue
	color = COLOR_DARK_BLUE_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/dark_green
	color = COLOR_DARK_GREEN_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/green
	color = COLOR_GREEN_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/lime
	color = COLOR_PALE_GREEN_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/yellow
	color = COLOR_BROWN

/obj/effect/map_effect/marker/door_paint/stripe/beige
	color = COLOR_BEIGE

/obj/effect/map_effect/marker/door_paint/stripe/red
	color = COLOR_RED_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/pink
	color = COLOR_PALE_RED_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/purple
	color = COLOR_PURPLE_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/mauve
	color = COLOR_PALE_PURPLE_GRAY

/obj/effect/map_effect/marker/door_paint/stripe/orange
	color = COLOR_DARK_ORANGE

/obj/effect/map_effect/marker/door_paint/stripe/brown
	color = COLOR_DARK_BROWN

/obj/effect/map_effect/marker/door_paint/stripe/white
	color = COLOR_GRAY70

/obj/effect/map_effect/marker/door_paint/stripe/grey
	color = COLOR_GRAY

// ----------------------------------- color frame subtypes

/obj/effect/map_effect/marker/door_paint/frame/scc
	color = /turf/simulated/wall/shuttle/scc::color

/obj/effect/map_effect/marker/door_paint/frame/brown
	color = /turf/simulated/wall/shuttle/brown::color

// ----------------------------------- fin
