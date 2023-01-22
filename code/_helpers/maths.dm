#define Default(a, b) (a ? a : b)

// /proc/Default(a, b)
// 	return a ? a : b

// Trigonometric functions.

/// The cosecant of degrees
#define Csc(degrees) (1 / sin(degrees))

/// The secant of degrees
#define Sec(degrees) (1 / cos(degrees))

/// The cotangent of degrees
#define Cot(degrees) (1 / tan(degrees))

/// The 2-argument arctangent of x and y
#define Atan2(x,y) ((!x && !y) ? 0 : (y >= 0 ? arccos(x / sqrt(x*x + y*y)) : -(arccos(x / sqrt(x*x + y*y)))))

/// Value or the next integer in a negative direction: Floor(-1.5) = -2 , Floor(1.5) = 1
#define Floor(value) round(value)

/// Same as Floor but rounds A to the nearest multiple of B.
#define Floorm(value, divisor) round(value)

/// Value or the next integer in a positive direction: Ceil(-1.5) = -1 , Ceil(1.5) = 2
#define Ceil(value) ( -round(-(value)) )

/// Value or the next multiple of divisor in a positive direction. Ceilm(-1.5, 0.3) = -1.5 , Ceilm(-1.5, 0.4) = -1.2
#define Ceilm(value, divisor) ( -round(-(value) / (divisor)) * (divisor) )

#define WrapNumber(value, minimum, maximum) (value - ((Floor((value - minimum) / (maximum - minimum))) * (maximum - minimum)))

#define Modulus(x, y) ( (x) - (y) * round((x) / (y)) )

#define Percent(value, maximum) (round((value / maximum) * 100))

#define PercentRounding(value, maximum, rounding) (round((value / maximum) * 100, rounding))

// /proc/Percent(current_value, max_value, rounding = 1)
// 	return round((current_value / max_value) * 100, rounding)

// Greatest Common Divisor: Euclid's algorithm.
/proc/Gcd(a, b)
	while (1)
		if (!b) return a
		a %= b
		if (!a) return b
		b %= a

// Least Common Multiple. The formula is a consequence of: a*b = LCM*GCD.
#define Lcm(a, b) (abs(a) * abs(b) / Gcd(a, b))

// Useful in the cases when x is a large expression, e.g. x = 3a/2 + b^2 + Function(c)
#define Square(x) (x*x)

#define Inverse(x) (1 / x)

// Condition checks.
#define IsAboutEqual(a, b) (abs(a - b) <= 0.1)

#define IsAboutEqualDelta(a, b, delta) (abs(a - b) <= delta)

// Returns true if val is from min to max, inclusive.
#define IsInRange(val, min, max) (min <= val && val <= max)

// Same as above, exclusive.
#define IsInRange_Ex(val, min, max) (min < val && val < max)

/// True if value is an integer number.
#define IsInteger(value) (round(value) == (value))

/// True if value is a multiple of divisor
#define IsMultiple(value, divisor) ((value) % (divisor) == 0)

#define ISEVEN(x) (x % 2 == 0)
#define ISODD(x) (x % 2 != 0)

// Performs a linear interpolation between a and b.
// Note: weight=0 returns a, weight=1 returns b, and weight=0.5 returns the mean of a and b.
#define Interpolate(a, b, weight) (a + (b - a) * weight) // Equivalent to: a*(1 - weight) + b*weight

/proc/Mean(...)
	var/sum = 0
	for(var/val in args)
		sum += val
	return sum / args.len

// Returns the nth root of x.
#define Root(n, x) (x ** (1 / n))

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

#define ToDegrees(radians) (radians * 57.2957795) // 180 / Pi ~ 57.2957795

#define ToRadians(degrees) (degrees * 0.0174532925) // Pi / 180 ~ 0.0174532925

// Vector algebra.
#define squaredNorm(x, y) (x*x + y*y)

#define norm(x, y) (sqrt(squaredNorm(x, y)))

#define IsPowerOfTwo(val) ((val & (val-1)) == 0)

#define RoundUpToPowerOfTwo(val) (2 ** -round(-log(2,val)))

//Returns the cube root of the input number
/proc/cubert(var/num, var/iterations = 10)
	. = num
	for (var/i = 0, i < iterations, i++)
		. = (1/3) * (num/(.**2)+2*.)


// Round up
#define n_ceil(number) ( (isnum(number)) ? (round(number)+1) : (null))


// Round up
// /proc/n_ceil(var/num)
// 	if(isnum(num))
// 		return round(num)+1

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

#define MODULUS_FLOAT(X, Y) ( (X) - (Y) * round((X) / (Y)) )

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS_FLOAT((degrees), 360))

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
