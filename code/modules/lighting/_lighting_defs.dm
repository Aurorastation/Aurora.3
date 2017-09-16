// This is the define used to calculate falloff.
#define LUM_FALLOFF_XYH(Cx,Cy,Tx,Ty,HEIGHT) (1 - CLAMP01(sqrt(((Cx) - (Tx)) ** 2 + ((Cy) - (Ty)) ** 2 + HEIGHT) / max(1, actual_range)))

// Macro that applies light to a new corner.
// It is a macro in the interest of speed, yet not having to copy paste it.
// If you're wondering what's with the backslashes, the backslashes cause BYOND to not automatically end the line.
// As such this all gets counted as a single line.
// The braces and semicolons are there to be able to do this on a single line.

#define APPLY_CORNER_XYH(C,now,Tx,Ty,Tz)         \
	. = LUM_FALLOFF_XYH(C.x, C.y, Tx, Ty, Tz) * light_power;    \
	var/OLD = effect_str[C];                 \
	effect_str[C] = .;                       \
	C.update_lumcount                        \
	(                                        \
		(. * lum_r) - (OLD * applied_lum_r), \
		(. * lum_g) - (OLD * applied_lum_g), \
		(. * lum_b) - (OLD * applied_lum_b), \
		(. * lum_u) - (OLD * applied_lum_u), \
		now                                  \
	);

#define APPLY_CORNER_XY(C,now,Tx,Ty) APPLY_CORNER_XYH(C, now, Tx, Ty, LIGHTING_HEIGHT)

#define APPLY_CORNER(C,now) APPLY_CORNER_XY(C,now,source_turf.x,source_turf.y)

// I don't need to explain what this does, do I?
#define REMOVE_CORNER(C,now)         \
	. = -effect_str[C];              \
	C.update_lumcount                \
	(                                \
		. * applied_lum_r,           \
		. * applied_lum_g,           \
		. * applied_lum_b,           \
		. * applied_lum_u,           \
		now                          \
	);

#define CALCULATE_CORNER_HEIGHT(ZA,ZB) ((max(ZA,ZB) - min(ZA,ZB) + 1) * LIGHTING_HEIGHT)

#define APPLY_CORNER_BY_HEIGHT(now)                       \
	if (C.z != Sz) {                                      \
		corner_height = CALCULATE_CORNER_HEIGHT(C.z, Sz); \
	}                                                     \
	else {                                                \
		corner_height = LIGHTING_HEIGHT;                  \
	}                                                     \
	APPLY_CORNER_XYH(C, now, Sx, Sy, corner_height);
