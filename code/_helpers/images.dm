/proc/pixel_shift_to_turf(var/image/I, var/turf/source_turf, var/turf/target_turf)
	var/y_shift = (target_turf.y - source_turf.y) * world.icon_size
	var/x_shift = (target_turf.x - source_turf.x) * world.icon_size
	I.pixel_y += y_shift
	I.pixel_x += x_shift