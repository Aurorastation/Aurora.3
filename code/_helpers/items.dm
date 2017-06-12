//Prevents robots dropping their modules.
/proc/dropsafety(var/atom/movable/A)
	if (istype(A.loc, /mob/living/silicon))
		return 0

	else if (istype(A.loc, /obj/item/rig_module))
		return 0
	return 1



/obj/proc/animate_shake()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(src, transform = turn(matrix(), 8*shake_dir), pixel_x = init_px + 2*shake_dir, time = 1)
	animate(transform = null, pixel_x = init_px, time = 6, easing = ELASTIC_EASING)