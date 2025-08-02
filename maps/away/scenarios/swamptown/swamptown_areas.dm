// Base Area
/area/swamptown
	name = "Base/Parent Area"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
	holomap_color = "#494949"
	color = "#747474"

//---------------------------------
// Exterior
/area/swamptown/outside
	is_outside = OUTSIDE_YES
	holomap_color = "#494949"

/area/swamptown/outside/landing
	name = "Landing Pad"
	holomap_color = "#575757"
//---------------------------------
// Interior
/area/swamptown/inside
	is_outside = OUTSIDE_NO
	holomap_color = "#7e7e7e"
	color = "#7e7e7e"
//---------------------------------
