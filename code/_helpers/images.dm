/proc/pixel_shift_to_turf(var/image/I, var/turf/source_turf, var/turf/target_turf)
	var/y_shift = (target_turf.y - source_turf.y) * world.icon_size
	var/x_shift = (target_turf.x - source_turf.x) * world.icon_size
	I.pixel_y += y_shift
	I.pixel_x += x_shift

/// The image's base transform scale for width.
/image/var/tf_scale_x

/// The image's base transform scale for height.
/image/var/tf_scale_y

/// The image's base transform scale for rotation.
/image/var/tf_rotation

/// The image's base transform scale for horizontal offset.
/image/var/tf_offset_x

/// The image's base transform scale for vertical offset.
/image/var/tf_offset_y


/// Clear the image's tf_* variables and the current transform state.
/image/proc/ClearTransform()
	tf_scale_x = null
	tf_scale_y = null
	tf_rotation = null
	tf_offset_x = null
	tf_offset_y = null
	transform = null


/// Sets the image's tf_* variables and the current transform state, also applying others if supplied.
/image/proc/SetTransform(
	scale,
	scale_x = tf_scale_x,
	scale_y = tf_scale_y,
	rotation = tf_rotation,
	offset_x = tf_offset_x,
	offset_y = tf_offset_y,
	list/others
)
	if (!isnull(scale))
		tf_scale_x = scale
		tf_scale_y = scale
	else
		tf_scale_x = scale_x
		tf_scale_y = scale_y
	tf_rotation = rotation
	tf_offset_x = offset_x
	tf_offset_y = offset_y
	transform = matrix().Update(
		scale_x = tf_scale_x,
		scale_y = tf_scale_y,
		rotation = tf_rotation,
		offset_x = tf_offset_x,
		offset_y = tf_offset_y,
		others = others
	)

/// Clears the matrix's a-f variables to identity.
/matrix/proc/Clear()
	a = 1
	b = 0
	c = 0
	d = 0
	e = 1
	f = 0
	return src

/// Runs Scale, Turn, and Translate if supplied parameters, then multiplies by others if set.
/matrix/proc/Update(scale_x, scale_y, rotation, offset_x, offset_y, list/others)
	var/x_null = isnull(scale_x)
	var/y_null = isnull(scale_y)
	if (!x_null || !y_null)
		Scale(x_null ? 1 : scale_x, y_null ? 1 : scale_y)
	if (!isnull(rotation))
		Turn(rotation)
	if (offset_x || offset_y)
		Translate(offset_x || 0, offset_y || 0)
	if (islist(others))
		for (var/other in others)
			Multiply(other)
	else if (others)
		Multiply(others)
	return src
