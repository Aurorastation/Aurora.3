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

/atom
	/// Rotates this atom's rendered icon as a flat image when its shuttle turns.
	/// Intended for icon-state mosaics that do not provide directional frames.
	var/rotate_icon_with_shuttle = FALSE

/atom/proc/shuttleRotate(rotation)
	rotation = SIMPLIFY_DEGREES(rotation)
	if(!rotation)
		return

	set_dir(angle2dir(dir2angle(dir) + rotation))

	if(smoothing_flags)
		QUEUE_SMOOTH(src)

	// A map-level icon override on an opted-in family may itself be directional,
	// such as the Canary's nozzle sprites. In that case set_dir() is sufficient.
	if(rotate_icon_with_shuttle && icon == initial(icon))
		var/list/icon_dimensions = get_icon_dimensions(icon)
		var/icon_width = icon_dimensions["width"]
		var/icon_height = icon_dimensions["height"]

		// Rotate the rendered icon's center around the center of its turf. Raw
		// pixel-offset rotation only works for 32x32 icons. A transform rotates
		// around the original icon canvas center, so its unrotated dimensions
		// remain the pixel-offset anchor even after a 90-degree turn.
		var/center_x = pixel_x + icon_width * 0.5 - world.icon_size * 0.5
		var/center_y = pixel_y + icon_height * 0.5 - world.icon_size * 0.5
		var/list/rotated_center = rotate_shuttle_offset(center_x, center_y, rotation)
		pixel_x = rotated_center[1] + world.icon_size * 0.5 - icon_width * 0.5
		pixel_y = rotated_center[2] + world.icon_size * 0.5 - icon_height * 0.5

		var/matrix/rotation_matrix = matrix(transform)
		rotation_matrix.Turn(rotation)
		transform = rotation_matrix
	else
		// Pixel offsets on ordinary 32x32 directional sprites rotate directly.
		var/list/rotated_offset = rotate_shuttle_offset(pixel_x, pixel_y, rotation)
		pixel_x = rotated_offset[1]
		pixel_y = rotated_offset[2]

/atom/movable/shuttleRotate(rotation)
	var/old_bound_x = bound_x
	var/old_bound_y = bound_y
	var/old_bound_width = bound_width
	var/old_bound_height = bound_height

	. = ..()

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

// Aurora airlock icons are 64x64 and use a fixed -16,-16 centering offset in
// every direction. Rotating that offset shifts the rendered door off its turf.
/obj/structure/machinery/door/airlock/shuttleRotate(rotation)
	var/old_pixel_x = pixel_x
	var/old_pixel_y = pixel_y
	. = ..()
	pixel_x = old_pixel_x
	pixel_y = old_pixel_y

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

// SCC shuttle hulls are assembled from single-direction 32x32 icon-state
// mosaics. Opt in at the family level so existing and future variants inherit
// rotation without needing their own shuttleRotate() override.
/turf/simulated/wall/shuttle/unique/scc
	rotate_icon_with_shuttle = TRUE

/obj/structure/shuttle_part/scc
	rotate_icon_with_shuttle = TRUE

/obj/structure/window/shuttle/unique/scc
	rotate_icon_with_shuttle = TRUE

// Cockpit consoles are 32x64 single-direction sprites. Their left/right state
// selects the layout variant, not a directional frame, so set_dir() alone
// cannot turn them with the shuttle.
/obj/structure/machinery/computer/ship/engines/cockpit
	rotate_icon_with_shuttle = TRUE

/obj/structure/machinery/computer/ship/helm/cockpit
	rotate_icon_with_shuttle = TRUE

/obj/structure/machinery/computer/ship/navigation/cockpit
	rotate_icon_with_shuttle = TRUE

/obj/structure/machinery/computer/ship/sensors/cockpit
	rotate_icon_with_shuttle = TRUE

/obj/structure/machinery/computer/ship/targeting/cockpit
	rotate_icon_with_shuttle = TRUE

/obj/structure/machinery/computer/shuttle_control/explore/canary
	rotate_icon_with_shuttle = TRUE

/obj/structure/machinery/computer/shuttle_control/explore/mining_shuttle
	rotate_icon_with_shuttle = TRUE
