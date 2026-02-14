/atom/proc/shuttle_rotate(rotation, params=ROTATE_DIR|ROTATE_SMOOTH|ROTATE_OFFSET)
	if(params & ROTATE_DIR)
		set_dir(angle2dir(rotation+dir2angle(dir)))

	if(params & ROTATE_SMOOTH && smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH(src)

	if((pixel_x || pixel_y) && (params & ROTATE_OFFSET))
		if(rotation < 0)
			rotation += 360
		for(var/turntimes=rotation/90; turntimes > 0; turntimes--)
			var/oldPX = pixel_x
			var/oldPY = pixel_y
			pixel_x = oldPY
			pixel_y = (oldPX*(-1))

/atom/movable/shuttle_rotate(rotation, params)
	. = ..()
	if(((bound_height != ICON_SIZE_Y) || (bound_width != ICON_SIZE_X)) && (bound_x == 0) && (bound_y == 0))
		pixel_x = dir & (NORTH|EAST) ? -bound_width + ICON_SIZE_X : 0
		pixel_y = dir & (NORTH|WEST) ? -bound_width + ICON_SIZE_X : 0
		bound_x = pixel_x
		bound_y = pixel_y

/mob/shuttle_rotate(rotation, params)
	params = buckled_to ? ROTATE_DIR : NONE
	return ..()

//Fixes dpdir on shuttle rotation
/obj/structure/disposalpipe/shuttle_rotate(rotation, params)
	. = ..()
	var/new_dpdir = 0
	for(var/D in GLOB.cardinals)
		if(dpdir & D)
			new_dpdir = new_dpdir | angle2dir(rotation+dir2angle(D))
	dpdir = new_dpdir

/obj/machinery/atmospherics/shuttle_rotate(rotation, params)
	// TODOWILD this shit is gonna break I just know it
	// :doakes:
	. = ..()
