#define SHORT_REAL_LIMIT 16777216

//"fancy" math for calculating time in ms from tick_usage percentage and the length of ticks
//percent_of_tick_used * (ticklag * 100(to convert to ms)) / 100(percent ratio)
//collapsed to percent_of_tick_used * tick_lag
#define TICK_DELTA_TO_MS(percent_of_tick_used) ((percent_of_tick_used) * world.tick_lag)
#define TICK_USAGE_TO_MS(starting_tickusage) (TICK_DELTA_TO_MS(TICK_USAGE_REAL - starting_tickusage))

#if DM_VERSION < 516
/// Gets the sign of x, returns -1 if negative, 0 if 0, 1 if positive
#define SIGN(x) ( ((x) > 0) - ((x) < 0) )
#else
/// Gets the sign of x, returns -1 if negative, 0 if 0, 1 if positive
#define SIGN(x) (sign(x))
#endif

#define CEILING(x, y) ( -round(-(x) / (y)) * (y) )

#define ROUND_UP(x) ( -round(-(x)))

// round() acts like floor(x, 1) by default but can't handle other values
#define FLOOR(x, y) ( round((x) / (y)) * (y) )

// Real modulus that handles decimals
#define MODULUS(x, y) ( (x) - FLOOR(x, y))

/**
 * Actually real modulus that handles floating points and returns a floating point.
 * This one will only return positive numbers, use PLUSMINUSFMOD if you need a negative number to modulus into a negative number.
 */
#define FMOD(value, modulus) (value - (trunc(value / modulus) * modulus))

/**
 * Actually real modulus that handles floating points and returns a floating point.
 * This one will return a modulus whose sign matches the given value.
 */
#define PLUSMINUSFMOD(value, modulus) (sign(value) * value - (trunc(value / modulus) * modulus))

// Similar to clamp but the bottom rolls around to the top and vice versa. min is inclusive, max is exclusive
#define WRAP(val, min, max) clamp(( min == max ? min : (val) - (round(((val) - (min))/((max) - (min))) * ((max) - (min))) ),min,max)


#define ATAN2(x, y) ( !(x) && !(y) ? 0 : (y) >= 0 ? arccos((x) / sqrt((x)*(x) + (y)*(y))) : -arccos((x) / sqrt((x)*(x) + (y)*(y))) )

// Will filter out extra rotations and negative rotations
// E.g: 540 becomes 180. -180 becomes 180.
#define SIMPLIFY_DEGREES(degrees) (MODULUS((degrees), 360))

#define GET_ANGLE_OF_INCIDENCE(face, input) (MODULUS((face) - (input), 360))

//Finds the shortest angle that angle A has to change to get to angle B. Aka, whether to move clock or counterclockwise.
/proc/closer_angle_difference(a, b)
	if(!isnum(a) || !isnum(b))
		return
	a = SIMPLIFY_DEGREES(a)
	b = SIMPLIFY_DEGREES(b)
	var/inc = b - a
	if(inc < 0)
		inc += 360
	var/dec = a - b
	if(dec < 0)
		dec += 360
	. = inc > dec? -dec : inc

/// Converts a probability/second chance to probability/seconds_per_tick chance
/// For example, if you want an event to happen with a 10% per second chance, but your proc only runs every 5 seconds, do `if(prob(100*SPT_PROB_RATE(0.1, 5)))`
#define SPT_PROB_RATE(prob_per_second, seconds_per_tick) (1 - (1 - (prob_per_second)) ** (seconds_per_tick))

/// Like SPT_PROB_RATE but easier to use, simply put `if(SPT_PROB(10, 5))`
#define SPT_PROB(prob_per_second_percent, seconds_per_tick) (prob(100*SPT_PROB_RATE((prob_per_second_percent)/100, (seconds_per_tick))))

// RADIAN TRIGONOMETRY
// Because its literally impossible to have any semblance of precision if you're limited to integer degrees.
// Remember that 1 degree = pi / 180 radians.

/// The common angle that corresponds with "EastNorthEast"
#define PIOVERSIX = 0.523598775598

/// The common angle that corresponds with "NorthEast"
#define PIOVERFOUR = 0.785398163397

/// The common angle that corresponds with "NorthNorthEast"
#define PIOVERTHREE = 1.0471975512

/// The common angle that corresponds with "North", IE sin(pi/2) = 1 and cos(pi/2) = 0
#define PIOVERTWO = 1.57079632679

/// The common angle that corresponds with "West", and defined here because a lot of things break if I define this with PI.
#define PIOVERONE = 3.14159265359

/// The common angle that corresponds with "East", technically equal to 0pi, but this exact value is needed for domain definitions.
#define TWOPI = 6.28318530718

/**
 * The floating point equivalent of Sine(x), that accepts and returns floating point values.
 * This function is written using the first 3 terms of the Maclaurin Series definition for Sin(x).
 * It only falls within the floating point precision limit out to a distance of +- pi/2, so it is self clamping to this range.
 */
#define FSIN(x) { \
	x = PLUSMINUSFMOD(x, PIOVERTWO); \
	return x - ((x ** 3)/6) + ((x ** 5)/120)}

/// The floating point equivalent of Cosecant(x)
#define FCSC(x) (1 / FSIN(x))

/**
 * The floating point equivalent of SinC(x)-- aka Sin(x)/x, that accepts and returns floating point values.
 * This is a surprisingly common function in engineering math, and is provided for your expedience.
 * This function is written using the first 3 terms of the Maclaurin Series definition for SinC(x).
 * It only falls within the floating point precision limit out to a distance of +- pi/2, so it is self clamping to this range.
 */
#define FSINC(x) { \
	x = PLUSMINUSFMOD(x, PIOVERTWO); \
	return 1 - ((x ** 2)/6) + ((x ** 4)/120)}

/**
 * The floating point equivalent of Cosine(x), that accepts and returns floating point values.
 * This function is written using the first 3 terms of the Taylor Series definition for Sin(x-pi/2).
 * It only falls within the floating point precision limit out to a distance of +- pi/2, so it is self clamping to this range.
 */
#define FCOS(x) { \
	x = FMOD(x, PIOVERONE) - PIOVERTWO; \
	return x - ((x ** 3)/6) + ((x ** 5)/120)}

/// The floating point equivalent of Secant(x)
#define FSEC(x) (1 / FCOS(x))

/// The floating point equivalent of Tan(x)
#define FTAN(x) (FSIN(x)/FCOS(x))

/// The floating point equivalent of Cotangent(x)
#define FCOT(x) (FCOS(x)/FSIN(x))

// TODO: TCJ needs to write N step precision variants of these that use a while loop
// TODO: TCJ also needs to write Arcsin, Arccos, Arctan, as well as hyperbolic forms of all of these.
