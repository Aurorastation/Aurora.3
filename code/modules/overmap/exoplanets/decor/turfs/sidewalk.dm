/turf/simulated/floor/exoplanet/sidewalk
	name = "weathered tiling"
	gender = PLURAL
	desc = "Great for speeding on."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "sidewalk-tile"
	has_resources = FALSE

/turf/simulated/floor/exoplanet/sidewalk/blocks
	name = "blocked sidewalk tiles"
	icon_state = "blocks"

/turf/simulated/floor/exoplanet/sidewalk/dark
	icon_state = "sidewalk_alt"

/turf/simulated/floor/exoplanet/sidewalk/flat
	name = "flat paved tiles"
	icon_state = "flat"

/turf/simulated/floor/exoplanet/sidewalk/flat/Initialize(mapload)
	. = ..()
	icon_state = "flat[rand(1,3)]"

/turf/simulated/floor/exoplanet/sidewalk/paved
	name = "paved tiles"
	icon_state = "brick-paver"
