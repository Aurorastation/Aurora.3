/turf/simulated/floor/exoplanet/sidewalk
	name = "weathered tiling"
	gender = PLURAL
	desc = "Great for speeding on."
	icon = 'icons/turf/flooring/urban_turfs.dmi'
	icon_state = "colorable-sidewalk"
	color = "#7f7574"
	has_resources = FALSE

/turf/simulated/floor/exoplanet/sidewalk/detail
	icon_state = "preview-colorable-sidewalk-detail"
	var/detail_color = COLOR_ASTEROID_ROCK

/turf/simulated/floor/exoplanet/sidewalk/detail/Initialize()
	. = ..()
	icon_state = "colorable-sidewalk"
	var/image/detail = new(icon, "colorable-sidewalk-detail-center")
	detail.color = detail_color
	AddOverlays(detail.appearance)

/turf/simulated/floor/exoplanet/sidewalk/paved
	name = "paved tiles"
	icon_state = "colorable-brick-paver"

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
