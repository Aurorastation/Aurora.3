///Calculate the angle between two movables and the west|east coordinate
/proc/get_angle(atom/movable/start, atom/movable/end)//For beams.
	if(!start || !end)
		return 0
	var/dy =(ICON_SIZE_Y * end.y + end.pixel_y) - (ICON_SIZE_Y * start.y + start.pixel_y)
	var/dx =(ICON_SIZE_X * end.x + end.pixel_x) - (ICON_SIZE_X * start.x + start.pixel_x)
	return delta_to_angle(dx, dy)

/// Calculate the angle produced by a pair of x and y deltas
/proc/delta_to_angle(x, y)
	if(!y)
		return (x >= 0) ? 90 : 270
	. = arctan(x/y)
	if(y < 0)
		. += 180
	else if(x < 0)
		. += 360

/// Angle between two arbitrary points and horizontal line same as [/proc/get_angle]
/proc/get_angle_raw(start_x, start_y, start_pixel_x, start_pixel_y, end_x, end_y, end_pixel_x, end_pixel_y)
	var/dy = (ICON_SIZE_Y * end_y + end_pixel_y) - (ICON_SIZE_Y * start_y + start_pixel_y)
	var/dx = (ICON_SIZE_X * end_x + end_pixel_x) - (ICON_SIZE_X * start_x + start_pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx/dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

///for getting the angle when animating something's pixel_x and pixel_y
/proc/get_pixel_angle(y, x)
	if(!y)
		return (x >= 0) ? 90 : 270
	. = arctan(x/y)
	if(y < 0)
		. += 180
	else if(x < 0)
		. += 360


/**
 * Get a list of turfs in a line from `starting_atom` to `ending_atom`.
 *
 * Uses the ultra-fast [Bresenham Line-Drawing Algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).
 */
/proc/get_line(atom/starting_atom, atom/ending_atom)
	var/current_x_step = starting_atom.x//start at x and y, then add 1 or -1 to these to get every turf from starting_atom to ending_atom
	var/current_y_step = starting_atom.y
	var/starting_z = starting_atom.z

	var/list/line = list(get_turf(starting_atom))//get_turf(atom) is faster than locate(x, y, z)

	var/x_distance = ending_atom.x - current_x_step //x distance
	var/y_distance = ending_atom.y - current_y_step

	var/abs_x_distance = abs(x_distance)//Absolute value of x distance
	var/abs_y_distance = abs(y_distance)

	var/x_distance_sign = SIGN(x_distance) //Sign of x distance (+ or -)
	var/y_distance_sign = SIGN(y_distance)

	var/x = abs_x_distance >> 1 //Counters for steps taken, setting to distance/2
	var/y = abs_y_distance >> 1 //Bit-shifting makes me l33t.  It also makes get_line() unnecessarily fast.

	if(abs_x_distance >= abs_y_distance) //x distance is greater than y
		for(var/distance_counter in 0 to (abs_x_distance - 1))//It'll take abs_x_distance steps to get there
			y += abs_y_distance

			if(y >= abs_x_distance) //Every abs_y_distance steps, step once in y direction
				y -= abs_x_distance
				current_y_step += y_distance_sign

			current_x_step += x_distance_sign //Step on in x direction
			line += locate(current_x_step, current_y_step, starting_z)//Add the turf to the list
	else
		for(var/distance_counter in 0 to (abs_y_distance - 1))
			x += abs_x_distance

			if(x >= abs_y_distance)
				x -= abs_y_distance
				current_x_step += x_distance_sign

			current_y_step += y_distance_sign
			line += locate(current_x_step, current_y_step, starting_z)
	return line

/**
 * Get a list of turfs in a perimeter given the `center_atom` and `radius`.
 * Automatically rounds down decimals and does not accept values less than positive 1 as they don't play well with it.
 * Is efficient on large circles but ugly on small ones
 * Uses [Jesko`s method to the midpoint circle Algorithm](https://en.wikipedia.org/wiki/Midpoint_circle_algorithm).
 */
/proc/get_perimeter(atom/center, radius)
	if(radius < 1)
		return
	var/rounded_radius = round(radius)
	var/x = center.x
	var/y = center.y
	var/z = center.z
	var/t1 = rounded_radius/16
	var/dx = rounded_radius
	var/dy = 0
	var/t2
	var/list/perimeter = list()
	while(dx >= dy)
		perimeter += locate(x + dx, y + dy, z)
		perimeter += locate(x - dx, y + dy, z)
		perimeter += locate(x + dx, y - dy, z)
		perimeter += locate(x - dx, y - dy, z)
		perimeter += locate(x + dy, y + dx, z)
		perimeter += locate(x - dy, y + dx, z)
		perimeter += locate(x + dy, y - dx, z)
		perimeter += locate(x - dy, y - dx, z)
		dy += 1
		t1 += dy
		t2 = t1 - dx
		if(t2 > 0)
			t1 = t2
			dx -= 1
	return perimeter

/*#####################
	AURORA SNOWFLAKE
#####################*/

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR_FLOAT(x, y) ( round((x) / (y)) * (y) )

/proc/Default(a, b)
	return a ? a : b

// Trigonometric functions.
/proc/Tan(x)
	return sin(x) / cos(x)

/proc/Csc(x)
	return 1 / sin(x)

/proc/Sec(x)
	return 1 / cos(x)

/proc/Cot(x)
	return 1 / Tan(x)

/proc/Atan2(x, y)
	if(!x && !y) return 0
	var/a = arccos(x / sqrt(x*x + y*y))
	return y >= 0 ? a : -a

/// Value or the next integer in a positive direction: Ceil(-1.5) = -1 , Ceil(1.5) = 2
#define Ceil(value) ( -round(-(value)) )

/proc/Ceiling(x, y=1)
	return -round(-x / y) * y

/proc/Percent(current_value, max_value, rounding = 1)
	return round((current_value / max_value) * 100, rounding)

// Greatest Common Divisor: Euclid's algorithm.
/proc/Gcd(a, b)
	while (1)
		if (!b) return a
		a %= b
		if (!a) return b
		b %= a

// Least Common Multiple. The formula is a consequence of: a*b = LCM*GCD.
/proc/Lcm(a, b)
	return abs(a) * abs(b) / Gcd(a, b)

// Useful in the cases when x is a large expression, e.g. x = 3a/2 + b^2 + Function(c)
/proc/Square(x)
	return x*x

/proc/Inverse(x)
	return 1 / x

// Condition checks.
/proc/IsAboutEqual(a, b, delta = 0.1)
	return abs(a - b) <= delta

// Returns true if val is from min to max, inclusive.
/proc/IsInRange(val, min, max)
	return (min <= val && val <= max)

// Same as above, exclusive.
/proc/IsInRange_Ex(val, min, max)
	return (min < val && val < max)

/proc/IsInteger(x)
	return FLOOR(x, 1) == x

/proc/IsMultiple(x, y)
	return x % y == 0

#define ISEVEN(x) (x % 2 == 0)
#define ISODD(x) (x % 2 != 0)

// Performs a linear interpolation between a and b.
// Note: weight=0 returns a, weight=1 returns b, and weight=0.5 returns the mean of a and b.
/proc/Interpolate(a, b, weight = 0.5)
	return a + (b - a) * weight // Equivalent to: a*(1 - weight) + b*weight

/proc/Mean(...)
	var/sum = 0
	for(var/val in args)
		sum += val
	return sum / args.len

// Returns the nth root of x.
/proc/Root(n, x)
	return x ** (1 / n)

// The quadratic formula. Returns a list with the solutions, or an empty list
// if they are imaginary.
/proc/SolveQuadratic(a, b, c)
	ASSERT(a)

	. = list()
	var/discriminant = b*b - 4*a*c
	var/bottom       = 2*a

	// Return if the roots are imaginary.
	if(discriminant < 0)
		return

	var/root = sqrt(discriminant)
	. += (-b + root) / bottom

	// If discriminant == 0, there would be two roots at the same position.
	if(discriminant != 0)
		. += (-b - root) / bottom

/// 180 / Pi ~ 57.2957795
#define TO_DEGREES(radians) ((radians) * 57.2957795)
/// Pi / 180 ~ 0.0174532925
#define TO_RADIANS(degrees) ((degrees) * 0.0174532925)

// Vector algebra.
/proc/squaredNorm(x, y)
	return x*x + y*y

/proc/norm(x, y)
	return sqrt(squaredNorm(x, y))

/proc/IsPowerOfTwo(var/val)
	return (val & (val-1)) == 0

/proc/RoundUpToPowerOfTwo(var/val)
	return 2 ** -round(-log(2,val))

//Returns the cube root of the input number
/proc/cubert(var/num, var/iterations = 10)
	. = num
	for (var/i = 0, i < iterations, i++)
		. = (1/3) * (num/(.**2)+2*.)


// Old scripting functions used by all over place.
// Round down
/proc/n_floor(var/num)
	if(isnum(num))
		return round(num)

// Round up
/proc/n_ceil(var/num)
	if(isnum(num))
		return round(num)+1

// Round to nearest integer
/proc/n_round(var/num)
	if(isnum(num))
		if(num-round(num)<0.5)
			return round(num)
		return n_ceil(num)

// Returns 1 if N is inbetween Min and Max
/proc/n_inrange(var/num, var/min=-1, var/max=1)
	if(isnum(num)&&isnum(min)&&isnum(max))
		return ((min <= num) && (num <= max))

/// Value or the next multiple of divisor in a positive direction. Ceilm(-1.5, 0.3) = -1.5 , Ceilm(-1.5, 0.4) = -1.2
#define Ceilm(value, divisor) ( -round(-(value) / (divisor)) * (divisor) )

/// Value or the nearest multiple of divisor in either direction
#define Roundm(value, divisor) round((value), (divisor))

/// A random real number between low and high inclusive
#define Frand(low, high) ( rand() * ((high) - (low)) + (low) )


/// Returns the distance between two points
#define DIST_BETWEEN_TWO_POINTS(ax, ay, bx, by) (sqrt((bx-ax)*(bx-ax))+((by-ay)*(by-ay)))

/**
 * Returns bearing of object relative to observer (0-360)
 * a is the observer, b is the other object
 *
 * observer_x - Observer's X coordinate
 * observer_y - Observer's Y coordinate
 * target_x - Target's X coordinate
 * target_y - Target's Y coordinate
 */
#define BEARING_RELATIVE(observer_x, observer_y, target_x, target_y) (90 - Atan2(target_x - observer_x, target_y - observer_y))

#define ISINTEGER(x) (round(x) == x)
