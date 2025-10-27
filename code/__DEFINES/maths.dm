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

/**
 * Unironically just the factorial proc from the dmdocs, it came up when I searched for it, and it wasn't already in this codebase.
 * I made it a define rather than a proc for performance reasons.
 */
#define FACTORIAL(n) {\
	if (n <= 0) return 1;\
	return .(n-1)*n}

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

// Standard Trig Functions
// !DEAR MAINTAINER: NONE OF THESE ARE MAGIC NUMBERS. -TCJ!

/// Converts an Angle (in degrees) to an Angle (in Radians)
#define RADIANFROMDEGREE(x) (x * 0.0174532925199)

// ALL OF THESE ACCEPT ANGLES IN RADIANS, NOT DEGREES.
/**
 * The floating point equivalent of Sine(x), that accepts and returns floating point values.
 * Outputs the Y directional value for a given Angle(in Radians)
 * This function is written using the first 3 terms of the Maclaurin Series definition for Sin(x).
 * It only falls within the floating point precision limit out to a distance of +- pi/2, so it is self clamping to this range.
 */
#define FSIN(x) { \
	x = PLUSMINUSFMOD(x, PIOVERTWO); \
	return x - ((x ** 3)/6) + ((x ** 5)/120)}

/**
 * Floating Point Sin(x) to any n desired precision, as defined by the Taylor-series expansion of Sin(x)
 * Where x is any angle given in Radians, and n is the desired number of steps to perform.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNSIN(x, n) { \
	for (var/i in 0 to n)\
		. += ((-1 ** i)*(x**(2i+1))/FACTORIAL(2i+1))}

/**
 * Floating Point Csc(x) to any n desired precision, as defined by the Taylor-series expansion of Csc(x)
 * Where x is any angle given in Radians, and n is the desired number of steps to perform.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNCSC(x, n) (1 / FNSIN(x, n))

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
 * Outputs the X directional value for a given Angle(in Radians)
 * This function is written using the first 3 terms of the Taylor Series definition for Sin(x-pi/2).
 * It only falls within the floating point precision limit out to a distance of +- pi/2, so it is self clamping to this range.
 */
#define FCOS(x) { \
	x = FMOD(x, PIOVERONE) - PIOVERTWO; \
	return x - ((x ** 3)/6) + ((x ** 5)/120)}

/**
 * Floating Point Cos(x) to any n desired precision, as defined by the Taylor-series expansion of Cos(x)
 * Where x is any angle given in Radians, and n is the desired number of steps to perform.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNCOS(x, n) { \
	for (var/i in 0 to n)\
		. += ((-1 ** i)*(x**(2i))/FACTORIAL(2i))}

/**
 * Floating Point Sec(x) to any n desired precision, as defined by the Taylor-series expansion of Sec(x)
 * Where x is any angle given in Radians, and n is the desired number of steps to perform.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNSEC(x, n) (1 / FNCOS(x, n))

/// The floating point equivalent of Secant(x)
#define FSEC(x) (1 / FCOS(x))

/// The floating point equivalent of Tan(x)
#define FTAN(x) (FSIN(x)/FCOS(x))

/**
 * Floating Point Tan(x) to any n desired precision, as defined by Sin(x) over Cos(x), both to N precision.
 * Where x is any angle given in Radians, and n is the desired number of steps to perform.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNTAN(x, n) (FNSIN(x,n)/FNCOS(x,n))

/// The floating point equivalent of Cotangent(x)
#define FCOT(x) (FCOS(x)/FSIN(x))

/**
 * Floating Point Cot(x) to any n desired precision, as defined by Cos(x) over Sin(x), both to N precision.
 * Where x is any angle given in Radians, and n is the desired number of steps to perform.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNCOT(x, n) (FNCOS(x,n)/FNSIN(x,n))

// RADIAN ARC FUNCTIONS

/**
 * The floating point equivalent of Arcsine(x), that accepts and returns floating point values.
 * Returns the Angle(in Radians) from the Y value of a NORMALIZED vector.
 * This function is written using the first 4 terms for the Maclaurin series definition for Arcsin(x)
 */
#define FARCSIN(x) { \
	x = PLUSMINUSFMOD(x, 1); \
	return x + ((x ** 3)/3) + (3 * (x ** 5) / 10) + (5 * (x ** 7) / 42)}

/**
 * Floating Point Arcsin(x) to any n desired precision, as defined by the Taylor-series expansion of Arcsin(x)
 * Where y is the y coordinate of a NORMALIZED VECTOR, and the output is the angle that vector forms with the x axis.
 * !NORMALIZED VECTOR, THIS DOESN'T WORK WITH A NON-NORMALIZED VECTOR.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNARCSIN(x, n) { \
	x = PLUSMINUSFMOD(x, 1); \
	for (var/i in 0 to n)\
		. += (FACTORIAL(2i)*(x**(2i+1))/((4**i)*(FACTORIAL(i)**2)*(2i+1)))}

/**
 * The floating point equivalent of Arccos(x), that accepts and returns floating point values.
 * Returns the Angle(in Radians) from the X value of a NORMALIZED vector.
 * This function is written using the first 4 terms for the Maclaurin series definition for Arccos(x)
 */
#define FARCCOS(x) (PIOVERTWO - FARCSIN(x))

/**
 * Floating Point Arccos(x) to any n desired precision, as defined by the Taylor-series expansion of Arccos(x)
 * Where x is the x coordinate of a NORMALIZED VECTOR, and the output is the angle that vector forms with the X axis.
 * !NORMALIZED VECTOR, THIS DOESN'T WORK WITH A NON-NORMALIZED VECTOR.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 */
#define FNARCCOS(x, n) (PIOVERTWO - FNARCSIN(x, n))

/**
 * The floating point equivalent of Arctan(x), that accepts and returns floating point values.
 * This function is written using the first 5 terms for the Maclaurin series definition for Arctan(x)
 * You should not be using this unless you know what you're doing, if you're calculating angles you should be using FARCTAN2(x,y) instead.
 */
#define FARCTAN(x) { \
	x = PLUSMINUSFMOD(x, 1); \
	return x - ((x ** 3)/3) + ((x ** 5)/5) - ((x ** 7)/7) + ((x ** 9)/9)}

/**
 * Floating Point Arccos(x) to any n desired precision, as defined by the Taylor-series expansion of Arccos(x)
 * Where x is the (y over x) value of any vector EXCEPT ones that fall upon one of the axies, and the output is the angle that vector forms with the X axis.
 * This function is not sanitized in any way, so if you give it an input beyond your desired precision limit, that's your own skill issue.
 * !Just use FNARCTAN2(x, y, n)!
 */
#define FNARCTAN(x, n) {\
	for (var/i in 0 to n)\
		. += (-1 ** i)*(x**(2i+1))/(2i+1)}

/**
 * Arctan's big older brother. Unlike arctan, you supply it a whole vector, and it will always output the angle no matter where that vector is.
 * Unlike standard Arctan, it has significantly less downsides, and will only fail if given the directionless vector <0,0>.
 */
#define FARCTAN2(x, y) { \
	if(x > 0) return FARCTAN(y/x); \
	if (x < 0 & y >= 0) return FARCTAN(y/x) + PIOVERONE; \
	if (x < 0 & y < 0) return FARCTAN(y/x) - PIOVERONE; \
	if (y > 0) return PIOVER2; \
	if (y < 0) return -PIOVER2; \
	return null}

/**
 * Arctan's big older brother, to any n desired precision. Unlike arctan, you supply it a whole vector, and it will always output the angle no matter where that vector is.
 * Unlike standard Arctan, it has significantly less downsides, and will only fail if given the directionless vector <0,0>.
 */
#define FNARCTAN2(x, y, n) { \
	if(x > 0) return FNARCTAN(y/x, n); \
	if (x < 0 & y >= 0) return FNARCTAN(y/x, n) + PIOVERONE; \
	if (x < 0 & y < 0) return FNARCTAN(y/x, n) - PIOVERONE; \
	if (y > 0) return PIOVER2; \
	if (y < 0) return -PIOVER2; \
	return null}

// RADIAN HYPERBOLICS

/**
 * The floating point equivalent of HyperbolicSine(x), that accepts and returns floating point values.
 * This function is written using the first 3 terms of the Maclaurin Series definition for SinH(x).
 * It only falls within the floating point precision limit out to a distance of +- pi/2, so it is self clamping to this range.
 */
#define FSINH(x) { \
	x = PLUSMINUSFMOD(x, PIOVERTWO);\
	return x + ((x ** 3)/6) + ((x ** 5)/120)}

/// Hyperbolic Sine to any n desired precision.
#define FNSINH(x, n) {\
	for (var/i in 0 to n)\
		. += (x ** (2i+1))/FACTORIAL(2i+1)}

/// The floating point equivalent of HyperbolicCosecant(x)
#define FCSCH(x) (1 / FSINH(x))

/// Hyperbolic Cosecant to any n desired precision.
#define FNCSCH(x, n) (1 / FNSINH(x, n))

/**
 * The floating point equivalent of HyperbolicCosine(x), that accepts and returns floating point values.
 * This function is written using the first 3 terms of the Maclaurin Series definition for Cosh(x).
 * It only falls within the floating point precision limit out to a distance of +- pi/2, so it is self clamping to this range.
 */
#define FCOSH(x) { \
	x = FMOD(x, PIOVERONE); \
	return 1 + ((x ** 2)/2) + ((x ** 4)/24)}

/// Hyperbolic Cosine to any n desired precision.
#define FNCOSH(x, n) {\
	for (var/i in 0 to n)\
		. += (x ** (2i))/FACTORIAL(2i)}

/// The floating point equivalent of HyperbolicSecant(x)
#define FSECH(x) (1 / FCOSH(x))

/// Hyperbolic Secant to any n desired precision.
#define FNSECH(x, n) (1 / FNCOSH(x, n))

/**
 * The floating point equivalent of HyperbolicTangent(x)
 * This function is particularly useful as its a viable linear approximation of the Logistic Equation.
 */
#define FTANH(x) (FSINH(x)/FCOSH(x))

/// Hyperbolic Tangent to any n desired precision
#define FNTANH(x, n) (FNSINH(x, n)/FNCOSH(x,n))

/// The floating point equivalent of HyperbolicCotangent(x)
#define FCOTH(x) (FCOSH(x)/FSINH(x))

/// Hyperbolic Cotangent to any n desired precision
#define FNCOTH(x, n) (FNCOSH(x, n)/FNSINH(x,n))

/// The fundamental definition of Euler's number e raised to the power of X is THIS function. This represents the Fundamental Hyperbolic Identity.
#define FEXP(x) (FSINH(x) + FCOSH(x))

/// Euler's Number e raised to the power of x, to any n desired precision.
#define FNEXP(x, n) (FNSINH(x, n) + FNCOSH(x, n))

// TODO: TCJ Add Desmos links to code comments to actually prove what I'm doing here is correct.
