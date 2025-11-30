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
