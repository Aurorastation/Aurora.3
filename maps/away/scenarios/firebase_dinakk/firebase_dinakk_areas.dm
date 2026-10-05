// ------------------------- base/parent

/area/dinakk
	icon_state = "white128a"
	requires_power = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/snow
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS | AREA_FLAG_IS_BACKGROUND
	holomap_color = "#494949"
	is_outside = OUTSIDE_YES

// ------------------------- outside

/area/dinakk/outside
	name = "Din'akk Valley"
	is_outside = OUTSIDE_YES
	requires_power = FALSE
	area_blurb = "tbd."

/area/dinakk/outside/mountains
	name = "Din'akk Mountains"
	color = "#2e2e2e"

/area/firebase_dinakk/outside/firebase_dinakk
	name = "Firebase Din'akk"
	color = "#2e2e2e"
	area_blurb = "tbd."

/area/firebase_dinakk/outside/artillery
	name = "Firebase Din'akk, Outdoors - Field Gun Emplacement"

/area/firebase_dinakk/outside/artillery/tent
	is_outside = OUTSIDE_NO

/area/firebase_dinakk/outside/parade
	name = "Firebase Din'akk, Outdoors - Parade Grounds"

/area/firebase_dinakk/outside/cages
	name = "Firebase Din'akk, Outdoors - Ha'rron Kennel"

/area/firebase_dinakk/outside/landing_pad
	name = "Firebase Din'akk, Outdoors - Landing Pad"
// --------

// ------------------------- inside

/area/firebase_dinakk/shuttle
	name = "Crashed SCC Shuttle"
	is_outside = OUTSIDE_NO
	color = "#777777"
	area_blurb = "The pungent smell of smoldering polymers and burnt metals wafts through the craft. The sporadic sparking of murdered electrical systems emphasizes the groaning of overloaded girders. Slick SCC paint and marks are scorched. Equipment is scattered, ransacked by searching hands."

/area/firebase_dinakk/shuttle/hole
	color = "#2e2e2e"
	area_blurb = "A draft of biting cold air seeps through an ugly, jagged gash in the wreckage's hull, the hole above you through which snow falls. The resulting groans and creaks of straining metal the first suggestion of the ship's eventual fate. Anything that scavengers, sapient or not, leave behind will inevitably be reclaimed by nature. Metal rusts, organic material decays, and whatever remains will be buried beneath the snow."
