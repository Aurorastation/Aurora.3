/*
 * Shuttle rotation callbacks.
 *
 * These are based on /tg/'s shuttleRotate callbacks, adapted to Aurora's
 * area-and-landmark shuttle movement system.
 */

/// Rotates every cardinal direction present in a direction bitmask.
/proc/rotate_cardinal_bitmask(direction, rotation)
	var/rotated_direction = direction & ~(NORTH|SOUTH|EAST|WEST)
	for(var/cardinal in GLOB.cardinals)
		if(direction & cardinal)
			rotated_direction |= angle2dir(dir2angle(cardinal) + rotation)
	return rotated_direction

/atom/proc/shuttleRotate(rotation)
	rotation = SIMPLIFY_DEGREES(rotation)
	if(!rotation)
		return

	set_dir(angle2dir(dir2angle(dir) + rotation))

	if(smoothing_flags)
		QUEUE_SMOOTH(src)

	var/list/rotated_offset = rotate_shuttle_offset(pixel_x, pixel_y, rotation)
	pixel_x = rotated_offset[1]
	pixel_y = rotated_offset[2]

/atom/movable/shuttleRotate(rotation)
	. = ..()
	rotate_shuttle_bounds(rotation)

/atom/movable/proc/rotate_shuttle_bounds(rotation)
	var/old_bound_x = bound_x
	var/old_bound_y = bound_y
	var/old_bound_width = bound_width
	var/old_bound_height = bound_height

	// BYOND does not rotate rectangular collision bounds when dir changes.
	for(var/turn_count in 1 to SIMPLIFY_DEGREES(rotation) / 90)
		var/new_bound_x = old_bound_y
		var/new_bound_y = ICON_SIZE_Y - old_bound_x - old_bound_width
		var/new_bound_width = old_bound_height
		var/new_bound_height = old_bound_width

		old_bound_x = new_bound_x
		old_bound_y = new_bound_y
		old_bound_width = new_bound_width
		old_bound_height = new_bound_height

	bound_x = old_bound_x
	bound_y = old_bound_y
	bound_width = old_bound_width
	bound_height = old_bound_height

// Floor decals are cached images baked in their mapped orientation. Copy and
// rotate them instead of mutating the shared cache entry.
/turf/simulated/floor/shuttleRotate(rotation)
	. = ..()
	if(!LAZYLEN(decals))
		return

	var/list/rotated_decals = list()
	for(var/image/decal as anything in decals)
		var/mutable_appearance/rotated_decal = new /mutable_appearance(decal)
		var/matrix/rotation_matrix = matrix(rotated_decal.transform)
		rotation_matrix.Turn(rotation)
		rotated_decal.transform = rotation_matrix

		var/list/rotated_offset = rotate_shuttle_offset(rotated_decal.pixel_x, rotated_decal.pixel_y, rotation)
		rotated_decal.pixel_x = rotated_offset[1]
		rotated_decal.pixel_y = rotated_offset[2]
		rotated_decals += rotated_decal

	decals = rotated_decals
	ClearOverlays()
	update_icon()

// Mobs keep their pixel offsets, and buckled mobs are oriented by their buckle.
/mob/shuttleRotate(rotation)
	if(!buckled_to)
		set_dir(angle2dir(dir2angle(dir) + rotation))

// Wide doors always occupy tiles north/east of their origin. Rotate that
// footprint by moving the origin to its new southwest corner, rather than
// using negative bound offsets (which are rendering offsets in BYOND 516).
/obj/structure/machinery/door/rotate_shuttle_bounds(rotation)
	if(width <= 1)
		return ..()
	var/list/rotated_corner = rotate_shuttle_offset(bound_width / world.icon_size - 1, bound_height / world.icon_size - 1, rotation)
	var/turf/new_origin = locate(x + min(0, rotated_corner[1]), y + min(0, rotated_corner[2]), z)
	SetBounds()
	if(new_origin != loc)
		forceMove(new_origin)

// Keep sprite padding fixed relative to the door's southwest corner.
/obj/structure/machinery/door/shuttleRotate(rotation)
	if(width <= 1)
		return ..()
	var/old_pixel_x = pixel_x
	var/old_pixel_y = pixel_y
	. = ..()
	pixel_x = old_pixel_x
	pixel_y = old_pixel_y
	update_nearby_tiles()

// Single airlock icons use fixed centering offsets in every direction.
/obj/structure/machinery/door/airlock/shuttleRotate(rotation)
	if(width > 1)
		return ..()
	var/old_pixel_x = pixel_x
	var/old_pixel_y = pixel_y
	. = ..()
	pixel_x = old_pixel_x
	pixel_y = old_pixel_y

// Flipped double doors have different canvas padding on each axis.
/obj/structure/machinery/door/airlock/multi_tile/flipped/shuttleRotate(rotation)
	var/was_horizontal = dir in list(EAST, WEST)
	. = ..()
	var/is_horizontal = dir in list(EAST, WEST)
	if(was_horizontal != is_horizontal)
		var/padding_shift = was_horizontal ? -world.icon_size : world.icon_size
		pixel_x += padding_shift
		pixel_y -= padding_shift

/obj/structure/cable/shuttleRotate(rotation)
	. = ..()
	d1 = rotate_cardinal_bitmask(d1, rotation)
	d2 = rotate_cardinal_bitmask(d2, rotation)
	update_icon()

/obj/structure/disposalpipe/shuttleRotate(rotation)
	. = ..()
	dpdir = rotate_cardinal_bitmask(dpdir, rotation)

/obj/structure/machinery/atmospherics/shuttleRotate(rotation)
	var/old_dir = dir
	. = ..()
	set_dir(rotate_cardinal_bitmask(old_dir, rotation))
	initialize_directions = rotate_cardinal_bitmask(initialize_directions, rotation)
	queue_icon_update()
	update_underlays()
