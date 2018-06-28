#define ANIMATION_STYLE_GROWMOVE 1
#define ANIMATION_STYLE_SHRINKMOVE 2
#define ANIMATION_STYLE_GROWFADE 3
#define ANIMATION_STYLE_HALFMOVE 4

/obj/effect/animated_inventory
	mouse_opacity = 0
	var/turf/start_location
	var/turf/end_location
	var/atom/object_to_animate
	var/animation_time = 0
	var/animation_style = 0
	var/stored_alpha = 0
	anchored = TRUE
	layer = ABOVE_MOB_LAYER

/obj/effect/animated_inventory/proc/do_animate()

	if(TICK_CHECK)
		return


	icon = object_to_animate.icon
	icon_state = object_to_animate.icon_state
	pixel_x = object_to_animate.pixel_x
	pixel_y = object_to_animate.pixel_y
	alpha = object_to_animate.alpha
	stored_alpha = alpha
	appearance_flags = object_to_animate.appearance_flags
	appearance_flags |= PIXEL_SCALE

	switch(animation_style)
		if(ANIMATION_STYLE_HALFMOVE) //Small into small
			var/x_offset =  end_location.x*32 - (start_location.x*32 + pixel_x)
			var/y_offset =  end_location.y*32 - (start_location.y*32 + pixel_y)
			var/matrix/M = new
			M.Scale(0.5)
			transform = M
			layer = object_to_animate.layer
			animate(src, pixel_x = x_offset, pixel_y = y_offset, time = animation_time, easing = LINEAR_EASING)

		if(ANIMATION_STYLE_GROWMOVE) //Small into big
			var/x_offset =  end_location.x*32 - (start_location.x*32 + pixel_x)
			var/y_offset =  end_location.y*32 - (start_location.y*32 + pixel_y)
			var/matrix/M = new
			M.Scale(0.1)
			transform = M
			layer = object_to_animate.layer
			animate(src, pixel_x = x_offset, pixel_y = y_offset, transform = matrix(), time = animation_time, easing = LINEAR_EASING)
			object_to_animate.alpha = 0 //The object needs to be invisible until it is moved into the world
		if(ANIMATION_STYLE_SHRINKMOVE) // Big into small
			var/x_offset =  end_location.x*32 - (start_location.x*32 + pixel_x)
			var/y_offset =  end_location.y*32 - (start_location.y*32 + pixel_y)
			animate(src, pixel_x = x_offset, pixel_y = y_offset, transform = matrix()*0.1, time = animation_time, easing = LINEAR_EASING)
		if(ANIMATION_STYLE_GROWFADE)
			animate(src,transform = matrix()*2, alpha = 0, time = animation_time, easing = LINEAR_EASING)

	addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, src), animation_time, TIMER_CLIENT_TIME) //thanks lohikar for this

/obj/effect/animated_inventory/Destroy()
	object_to_animate.alpha = stored_alpha
	return ..()

/proc/animate_item(var/atom/object_to_animate, var/turf/start_location, var/turf/end_location, var/animation_time = 1 SECONDS, var/animation_style = ANIMATION_STYLE_GROWMOVE)
	if(!start_location || !end_location || !object_to_animate)
		return

	var/obj/effect/animated_inventory/O = new(start_location)
	O.object_to_animate = object_to_animate
	O.start_location = start_location
	O.end_location = end_location
	O.animation_time = animation_time
	O.animation_style = animation_style
	O.do_animate()
	//The item will delete itself in the above callback

