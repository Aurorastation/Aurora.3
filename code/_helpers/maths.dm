#define FLOOR(x) round(x)

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR_FLOAT(x, y) ( round((x) / (y)) * (y) )

// min is inclusive, max is exclusive
/proc/Wrap(val, min, max)
	var/d = max - min
	var/t = FLOOR((val - min) / d)
	return val - (t * d)

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

// Real modulus that handles decimals
#define MODULUS(x, y) ( (x) - FLOOR_FLOAT(x, y))

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
	return FLOOR(x) == x

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

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS((degrees), 360))

/// Value or the next multiple of divisor in a positive direction. Ceilm(-1.5, 0.3) = -1.5 , Ceilm(-1.5, 0.4) = -1.2
#define Ceilm(value, divisor) ( -round(-(value) / (divisor)) * (divisor) )

/// Value or the nearest multiple of divisor in either direction
#define Roundm(value, divisor) round((value), (divisor))

/// A random real number between low and high inclusive
#define Frand(low, high) ( rand() * ((high) - (low)) + (low) )


/**
 * Get a list of turfs in a line from `starting_atom` to `ending_atom`.
 *
 * Uses the ultra-fast [Bresenham Line-Drawing Algorithm](https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm).
 */
/proc/get_line(atom/starting_atom, atom/ending_atom)
	var/current_x_step = starting_atom.x // start at X and Y, then add 1 or -1 to these to get every turf from start to end
	var/current_y_step = starting_atom.y
	var/starting_z = starting_atom.z

	var/list/line = list(get_turf(starting_atom))

	var/x_distance = ending_atom.x - current_x_step
	var/y_distance = ending_atom.y - current_y_step

	var/abs_x_distance = abs(x_distance)
	var/abs_y_distance = abs(y_distance)

	var/x_distance_sign = SIGN(x_distance)
	var/y_distance_sign = SIGN(y_distance)

	var/x = abs_x_distance >> 1
	var/y = abs_y_distance >> 1

	if (abs_x_distance >= abs_y_distance)
		for (var/distance_counter in 0 to (abs_x_distance - 1))
			y += abs_y_distance

			if(y >= abs_x_distance) // Every abs_y_distance steps, step once in y direction
				y -= abs_x_distance
				current_y_step += y_distance_sign

			current_x_step += x_distance_sign // Step in x direction
			line += locate(current_x_step, current_y_step, starting_z)
	else
		for (var/distance_counter in 0 to (abs_y_distance - 1))
			x += abs_x_distance

			if(x >= abs_y_distance)
				x -= abs_y_distance
				current_x_step += x_distance_sign

			current_y_step += y_distance_sign
			line += locate(current_x_step, current_y_step, starting_z)

	return line


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
