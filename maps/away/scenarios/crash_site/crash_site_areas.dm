// ------------------------- base/parent

/area/crash_site
	icon_state = "white128a"
	requires_power = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/snow
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_IS_BACKGROUND
	holomap_color = "#494949"
	is_outside = OUTSIDE_YES

// ------------------------- outside

/area/crash_site/outside
	name = "Din'akk Crash Site"
	area_blurb = "?"
	is_outside = OUTSIDE_YES

/area/crash_site/outside/near_crash_site
	area_blurb = "?"
	color = "#2e2e2e"

/area/crash_site/outside/mountains
	name = "Din'akk Mountains"
	color = "#2e2e2e"

// ------------------------- inside

/area/crash_site/shuttle
	area_blurb = "Crashed SCC Shuttle"
	is_outside = OUTSIDE_NO
	color = "#777777"
