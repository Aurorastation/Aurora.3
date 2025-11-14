//Luma coefficients suggested for HDTVs. If you change these, make sure they add up to 1.
#define LUMA_R 0.213
#define LUMA_G 0.715
#define LUMA_B 0.072

/// Datum which stores information about a matrix decomposed with decompose().
/datum/decompose_matrix
	///?
	var/scale_x = 1
	///?
	var/scale_y = 1
	///?
	var/rotation = 0
	///?
	var/shift_x = 0
	///?
	var/shift_y = 0

/// Decomposes a matrix into scale, shift and rotation.
///
/// If other operations were applied on the matrix, such as shearing, the result
/// will not be precise.
///
/// Negative scales are now supported. =)
/matrix/proc/decompose()
	var/datum/decompose_matrix/decompose_matrix = new
	. = decompose_matrix
	var/flip_sign = (a*e - b*d < 0)? -1 : 1 // Det < 0 => only 1 axis is flipped - start doing some sign flipping
	// If both axis are flipped, nothing bad happens and Det >= 0, it just treats it like a 180° rotation
	// If only 1 axis is flipped, we need to flip one direction - in this case X, so we flip a, b and the x scaling
	decompose_matrix.scale_x = sqrt(a * a + d * d) * flip_sign
	decompose_matrix.scale_y = sqrt(b * b + e * e)
	decompose_matrix.shift_x = c
	decompose_matrix.shift_y = f
	if(!decompose_matrix.scale_x || !decompose_matrix.scale_y)
		return
	// If only translated, scaled and rotated, a/xs == e/ys and -d/xs == b/xy
	var/cossine = (a/decompose_matrix.scale_x + e/decompose_matrix.scale_y) / 2
	var/sine = (b/decompose_matrix.scale_y - d/decompose_matrix.scale_x) / 2 * flip_sign
	decompose_matrix.rotation = arctan(cossine, sine) * flip_sign

/matrix/proc/TurnTo(old_angle, new_angle)
	return Turn(new_angle - old_angle) //BYOND handles cases such as -270, 360, 540 etc. DOES NOT HANDLE 180 TURNS WELL, THEY TWEEN AND LOOK LIKE SHIT

/**
 * Shear the transform on either or both axes.
 * * x - X axis shearing
 * * y - Y axis shearing
 */
/matrix/proc/Shear(x, y)
	return Multiply(matrix(1, x, 0, y, 1, 0))

//Dumps the matrix data in format a-f
/matrix/proc/tolist()
	. = list()
	. += a
	. += b
	. += c
	. += d
	. += e
	. += f

//Dumps the matrix data in a matrix-grid format
/*
a d 0
b e 0
c f 1
*/
/matrix/proc/togrid()
	. = list()
	. += a
	. += d
	. += 0
	. += b
	. += e
	. += 0
	. += c
	. += f
	. += 1

///The X pixel offset of this matrix
/matrix/proc/get_x_shift()
	. = c

///The Y pixel offset of this matrix
/matrix/proc/get_y_shift()
	. = f

/////////////////////
// COLOUR MATRICES //
/////////////////////

/* Documenting a couple of potentially useful color matrices here to inspire ideas
// Greyscale - indentical to saturation @ 0
list(LUMA_R,LUMA_R,LUMA_R,0, LUMA_G,LUMA_G,LUMA_G,0, LUMA_B,LUMA_B,LUMA_B,0, 0,0,0,1, 0,0,0,0)

// Color inversion
list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)

// Sepiatone
list(0.393,0.349,0.272,0, 0.769,0.686,0.534,0, 0.189,0.168,0.131,0, 0,0,0,1, 0,0,0,0)
*/

//Changes distance hues have from grey while maintaining the overall lightness. Greys are unaffected.
//1 is identity, 0 is greyscale, >1 oversaturates colors
/proc/color_matrix_saturation(value)
	var/inv = 1 - value
	var/R = round(LUMA_R * inv, 0.001)
	var/G = round(LUMA_G * inv, 0.001)
	var/B = round(LUMA_B * inv, 0.001)

	return list(R + value,R,R,0, G,G + value,G,0, B,B,B + value,0, 0,0,0,1, 0,0,0,0)

//Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting greys
//0 is identity, 120 moves reds to greens, 240 moves reds to blues
/proc/color_matrix_rotate_hue(angle)
	var/sin = sin(angle)
	var/cos = cos(angle)
	var/cos_inv_third = 0.333*(1-cos)
	var/sqrt3_sin = sqrt(3)*sin
	return list(
round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), 0,
round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), 0,
round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), 0,
0,0,0,1,
0,0,0,0)

//These next three rotate values about one axis only
//x is the red axis, y is the green axis, z is the blue axis.
/proc/color_matrix_rotate_x(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(1,0,0,0, 0,cosval,sinval,0, 0,-sinval,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_y(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,0,-sinval,0, 0,1,0,0, sinval,0,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_z(angle)
	var/sinval = round(sin(angle), 0.001); var/cosval = round(cos(angle), 0.001)
	return list(cosval,sinval,0,0, -sinval,cosval,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)


//Returns a matrix addition of A with B
/proc/color_matrix_add(list/A, list/B)
	if(!istype(A) || !istype(B))
		return COLOR_MATRIX_IDENTITY
	if(A.len != 20 || B.len != 20)
		return COLOR_MATRIX_IDENTITY
	var/list/output = list()
	output.len = 20
	for(var/value in 1 to 20)
		output[value] = A[value] + B[value]
	return output

//Returns a matrix multiplication of A with B
/proc/color_matrix_multiply(list/A, list/B)
	if(!istype(A) || !istype(B))
		return COLOR_MATRIX_IDENTITY
	if(A.len != 20 || B.len != 20)
		return COLOR_MATRIX_IDENTITY
	var/list/output = list()
	output.len = 20
	var/x = 1
	var/y = 1
	var/offset = 0
	for(y in 1 to 5)
		offset = (y-1)*4
		for(x in 1 to 4)
			output[offset+x] = round(A[offset+1]*B[x] + A[offset+2]*B[x+4] + A[offset+3]*B[x+8] + A[offset+4]*B[x+12]+(y == 5?B[x+16]:0), 0.001)
	return output

/**
 * Converts RGB shorthands into RGBA matrices complete of constants rows (ergo a 20 keys list in byond).
 * if return_identity_on_fail is true, stack_trace is called instead of CRASH, and an identity is returned.
 */
/proc/color_to_full_rgba_matrix(color, return_identity_on_fail = TRUE)
	if(!color)
		return COLOR_MATRIX_IDENTITY
	if(istext(color))
		var/list/L = rgb2num(color)
		if(!L)
			var/message = "Invalid/unsupported color ([color]) argument in color_to_full_rgba_matrix()"
			if(return_identity_on_fail)
				stack_trace(message)
				return COLOR_MATRIX_IDENTITY
			CRASH(message)
		return list(L[1]/255,0,0,0, 0,L[2]/255,0,0, 0,0,L[3]/255,0, 0,0,0,L.len>3?L[4]/255:1, 0,0,0,0)
	if(!islist(color)) //invalid format
		CRASH("Invalid/unsupported color ([color]) argument in color_to_full_rgba_matrix()")
	var/list/L = color
	switch(L.len)
		if(3 to 5) // row-by-row hexadecimals
			. = list()
			for(var/a in 1 to L.len)
				var/list/rgb = rgb2num(L[a])
				for(var/b in rgb)
					. += b/255
				if(length(rgb) % 4) // RGB has no alpha instruction
					. += a != 4 ? 0 : 1
			if(L.len < 4) //missing both alphas and constants rows
				. += list(0,0,0,1, 0,0,0,0)
			else if(L.len < 5) //missing constants row
				. += list(0,0,0,0)
		if(9 to 12) //RGB
			. = list(L[1],L[2],L[3],0, L[4],L[5],L[6],0, L[7],L[8],L[9],0, 0,0,0,1)
			for(var/b in 1 to 3)  //missing constants row
				. += L.len < 9+b ? 0 : L[9+b]
			. += 0
		if(16 to 20) // RGBA
			. = L.Copy()
			if(L.len < 20) //missing constants row
				for(var/b in 1 to 20-L.len)
					. += 0
		else
			var/message = "Invalid/unsupported color (list of length [L.len]) argument in color_to_full_rgba_matrix()"
			if(return_identity_on_fail)
				stack_trace(message)
				return COLOR_MATRIX_IDENTITY
			CRASH(message)

///Animates source spinning around itself. For docmentation on the args, check atom/proc/SpinAnimation()
/atom/proc/do_spin_animation(speed = 1 SECONDS, loops = -1, segments = 3, angle = 120, parallel = TRUE)
	var/list/matrices = list()
	for(var/i in 1 to segments-1)
		var/matrix/segment_matrix = matrix(transform)
		segment_matrix.Turn(angle*i)
		matrices += segment_matrix
	var/matrix/last = matrix(transform)
	matrices += last

	speed /= segments

	if(parallel)
		animate(src, transform = matrices[1], time = speed, loop = loops, flags = ANIMATION_PARALLEL)
	else
		animate(src, transform = matrices[1], time = speed, loop = loops)
	for(var/i in 2 to segments) //2 because 1 is covered above
		animate(transform = matrices[i], time = speed)
		//doesn't have an object argument because this is "Stacking" with the animate call above
		//3 billion% intentional

/**
 * Proc called when you want the atom to spin around the center of its icon (or where it would be if its transform var is translated)
 * By default, it makes the atom spin forever and ever at a speed of 60 rpm.
 *
 * Arguments:
 * * speed: how much it takes for the atom to complete one 360° rotation
 * * loops: how many times do we want the atom to rotate
 * * clockwise: whether the atom ought to spin clockwise or counter-clockwise
 * * segments: in how many animate calls the rotation is split. Probably unnecessary, but you shouldn't set it lower than 3 anyway.
 * * parallel: whether the animation calls have the ANIMATION_PARALLEL flag, necessary for it to run alongside concurrent animations.
 */
/atom/proc/SpinAnimation(speed = 1 SECONDS, loops = -1, clockwise = TRUE, segments = 3, parallel = TRUE)
	if(!segments)
		return
	var/segment = 360/segments
	if(!clockwise)
		segment = -segment
	SEND_SIGNAL(src, COMSIG_ATOM_SPIN_ANIMATION, speed, loops, segments, segment)
	do_spin_animation(speed, loops, segments, segment, parallel)


/*############################
	AURORA SNOWFLAKE SECTION
	(Most are from Bay)
############################*/

/**
 * Performs a shaking animation on the atom's sprite.
 *
 * **Parameters**:
 * - `intensity` integer - The intensity of the shaking.
 */
/atom/proc/shake_animation(intensity = 8)
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	animate(
		src,
		transform = matrix().Update(rotation = intensity * shake_dir),
		pixel_x = init_px + 2 * shake_dir,
		time = 1
	)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)


///Returns an identity color matrix which does nothing
/proc/color_identity()
	RETURN_TYPE(/list)
	return list(1,0,0, 0,1,0, 0,0,1)

//TODO: Need a version that only affects one color (ie shift red to blue but leave greens and blues alone)
///Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting whites
/proc/color_rotation(angle)
	RETURN_TYPE(/list)
	if(angle == 0)
		return color_identity()
	angle = clamp(angle, -180, 180)
	var/cos = cos(angle)
	var/sin = sin(angle)

	var/constA = 0.143
	var/constB = 0.140
	var/constC = -0.283
	return list(
	LUMA_R + cos * (1-LUMA_R) + sin * -LUMA_R, LUMA_R + cos * -LUMA_R + sin * constA, LUMA_R + cos * -LUMA_R + sin * -(1-LUMA_R),
	LUMA_G + cos * -LUMA_G + sin * -LUMA_G, LUMA_G + cos * (1-LUMA_G) + sin * constB, LUMA_G + cos * -LUMA_G + sin * LUMA_G,
	LUMA_B + cos * -LUMA_B + sin * (1-LUMA_B), LUMA_B + cos * -LUMA_B + sin * constC, LUMA_B + cos * (1-LUMA_B) + sin * LUMA_B
	)

GLOBAL_LIST_INIT(delta_index, list(
	0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
	0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
	0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
	0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68,
	0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
	1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
	1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25,
	2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
	4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
	7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8,
	10.0))

///Exxagerates or removes brightness
/proc/color_contrast(value)
	RETURN_TYPE(/list)
	value = round(clamp(value, -100, 100))
	if(value == 0)
		return color_identity()

	var/x = 0
	if (value < 0)
		x = 127 + value / 100 * 127;
	else
		x = value % 1
		if(x == 0)
			x = GLOB.delta_index[value]
		else
			x = GLOB.delta_index[value] * (1-x) + GLOB.delta_index[value+1] * x//use linear interpolation for more granularity.
		x = x * 127 + 127

	var/mult = x / 127
	var/add = 0.5 * (127-x) / 255
	return list(mult,0,0, 0,mult,0, 0,0,mult, add,add,add)

///Exxagerates or removes colors
/proc/color_saturation(value as num)
	RETURN_TYPE(/list)
	if(value == 0)
		return color_identity()
	value = clamp(value, -100, 100)
	if(value > 0)
		value *= 3
	var/x = 1 + value / 100
	var/inv = 1 - x
	var/R = LUMA_R * inv
	var/G = LUMA_G * inv
	var/B = LUMA_B * inv

	return list(R + x,R,R, G,G + x,G, B,B,B + x)


/**
 *
 * # Matrix math
 * Given 2 matrices mxn and nxp (row major) it multiplies their members and return an mxp matrix
 *
 * Do make sure your lists actually have this many elements
 */
/proc/multiply_matrices(list/A, list/B, m, n, p)
	RETURN_TYPE(/list)
	var/list/result = new (m * p)

	if(length(A) == m*n && length(B) == n*p)
		for(var/row = 1; row <= m; row += 1) //For each row on left matrix
			for(var/col = 1; col <= p; col += 1) //go over each column of the second matrix
				var/sum = 0
				for(var/i = 1; i <= n; i += 1) //multiply each pair
					sum += A[(row-1)*n + i] * B[(i-1)*p + col]

				result[(row-1)*p + col] = sum

	return result


#undef LUMA_R
#undef LUMA_G
#undef LUMA_B
