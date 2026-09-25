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
	is_outside = OUTSIDE_YES
	area_blurb = "Cold winter wind whips by with snowflakes on its trail. In the distance, a smoke plume carries off into the sky above the piney Adhomian trees. Mountains loom at a distance seeming near but yet so far, piercing the sky with snowy summits beyond."

/area/crash_site/outside/near_crash_site
	name = "Din'akk Crash Site, Near"
	color = "#2e2e2e"
	area_blurb = "The cold air brings an offering of burnt metal and smoldering plastics. The smoke plume has not eased up. It's not tall, reaching only some meters above the trees before being stolen by rushing winds. The silence is disrupted with creaking girders and sparking wires."

/area/crash_site/outside/mountains
	name = "Din'akk Mountains"
	color = "#2e2e2e"

// ------------------------- inside

/area/crash_site/shuttle
	name = "Crashed SCC Shuttle"
	is_outside = OUTSIDE_NO
	color = "#777777"
	area_blurb = "The pungent smell of smoldering polymers and burnt metals wafts through the craft. The sporadic sparking of murdered electrical systems emphasizes the groaning of overloaded girders. Slick SCC paint and marks are scorched. Equipment is scattered, ransacked by searching hands."

/area/crash_site/shuttle/hole
	color = "#2e2e2e"
	area_blurb = "A draft of biting cold air seeps through an ugly, jagged gash in the wreckage's hull, the hole above you through which snow falls. The resulting groans and creaks of straining metal the first suggestion of the ship's eventual fate. Anything that scavengers, sapient or not, leave behind will inevitably be reclaimed by nature. Metal rusts, organic material decays, and whatever remains will be buried beneath the snow."
