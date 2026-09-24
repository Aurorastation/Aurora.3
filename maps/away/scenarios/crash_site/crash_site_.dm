
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/crash_site
	name = "Crash Site"
	description = "Crash Site."
	id = "crash_site"

	prefix = "scenarios/crash_site/"
	suffix = "crash_site_.dmm"

	exoplanet_theme_base = /datum/exoplanet_theme/snow/adhomai
	exoplanet_themes = list(
		/turf/unsimulated/marker/khaki = /datum/exoplanet_theme/snow/adhomai,
		/turf/unsimulated/marker/red   = /datum/exoplanet_theme/snow/adhomai/mountain,
	)
	exoplanet_atmospheres = list(/datum/gas_mixture/earth_cold)
	exoplanet_lightlevel = list(4)
	exoplanet_lightcolor = list("#d4fcff")

	spawn_weight = 0 // so it does not spawn as ordinary away site
	spawn_cost = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(LEMURIAN_SEA_SECTORS)
	// template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	unit_test_groups = list(3)

/singleton/submap_archetype/crash_site
	map = /datum/map_template/ruin/away_site/crash_site::name
	descriptor = /datum/map_template/ruin/away_site/crash_site::description

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/crash_site
	name = "Din'akk Crash Site"
	desc = "The identified site of an SCC shuttle crash. No notable signs of population or structural build-up."
	icon_state = /obj/effect/overmap/visitable/sector/exoplanet/adhomai::icon_state
	color = /obj/effect/overmap/visitable/sector/exoplanet/adhomai::color

	initial_restricted_waypoints = list(
		/obj/effect/overmap/visitable/ship/landable/intrepid::name = list(/obj/effect/shuttle_landmark/crash_site/intrepid::landmark_tag),
		/obj/effect/overmap/visitable/ship/landable/mining_shuttle::name = list(/obj/effect/shuttle_landmark/crash_site/spark::landmark_tag),
		/obj/effect/overmap/visitable/ship/landable/canary::name = list(/obj/effect/shuttle_landmark/crash_site/canary::landmark_tag),
		/obj/effect/overmap/visitable/ship/landable/quark::name = list(/obj/effect/shuttle_landmark/crash_site/quark::landmark_tag),
	)

// --------------------------------------------------- misc

/obj/abstract/weather_marker/crash_site
	weather_type = /singleton/state/weather/snow/medium
