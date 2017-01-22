// This is an object that exists purely to make dark tiles *actually dark*,
// as apparently lighting overlays can't do that themselves.

#ifdef USE_DARKNESS_OVERLAYS

/atom/movable/darkness_overlay
	name          = ""

	anchored      = TRUE
	//ignoreinvert  = TRUE

	icon             = DARKNESS_ICON
	plane            = 0//LIGHTING_PLANE
	mouse_opacity    = 1
	layer            = LIGHTING_LAYER + 1
	invisibility     = INVISIBILITY_LIGHTING

/atom/movable/darkness_overlay/New()
	. = ..()
	verbs.Cut()
	var/turf/T = loc
	T.darkness_overlay = src

/atom/movable/darkness_overlay/forceMove(atom/destination, var/no_tp=FALSE, var/harderforce = FALSE)
	if(harderforce)
		. = ..()

/atom/movable/darkness_overlay/proc/show()
	layer = initial(layer)

/atom/movable/darkness_overlay/proc/hide()
	layer = -1

#endif