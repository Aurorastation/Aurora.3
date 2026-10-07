
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/firebase_dinakk
	name = "Firebase Din'akk"
	description = "Firebase Din'akk."
	id = "firebase_dinakk"

	prefix = "scenarios/firebase_dinakk/"
	suffix = "firebase_dinakk_.dmm"

	exoplanet_theme_base = /datum/exoplanet_theme/snow/adhomai
	exoplanet_themes = list(
		/turf/unsimulated/marker/khaki = /datum/exoplanet_theme/snow/adhomai/no_mountain,
		/turf/unsimulated/marker/red   = /datum/exoplanet_theme/snow/adhomai/mountain,
	)
	exoplanet_atmospheres = list(/datum/gas_mixture/earth_cold)
	exoplanet_lightlevel = list(4)
	exoplanet_lightcolor = list("#d4fcff")

	spawn_weight = 0 // so it does not spawn as ordinary away site
	spawn_cost = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(LEMURIAN_SEA_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	// template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	unit_test_groups = list(3)

/singleton/submap_archetype/firebase_dinakk
	map = /datum/map_template/ruin/away_site/firebase_dinakk::name
	descriptor = /datum/map_template/ruin/away_site/firebase_dinakk::description

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/firebase_dinakk
	name = "Din'akk Crash Site"
	desc = "The identified site of an SCC shuttle crash. No notable signs of population or structural build-up."
	icon_state = /obj/effect/overmap/visitable/sector/exoplanet/adhomai::icon_state
	color = /obj/effect/overmap/visitable/sector/exoplanet/adhomai::color

	initial_restricted_waypoints = list(
		/obj/effect/overmap/visitable/ship/landable/intrepid::name = list(/obj/effect/shuttle_landmark/firebase_dinakk/intrepid::landmark_tag),
		/obj/effect/overmap/visitable/ship/landable/mining_shuttle::name = list(/obj/effect/shuttle_landmark/firebase_dinakk/spark::landmark_tag),
		/obj/effect/overmap/visitable/ship/landable/canary::name = list(/obj/effect/shuttle_landmark/firebase_dinakk/canary::landmark_tag),
		/obj/effect/overmap/visitable/ship/landable/quark::name = list(/obj/effect/shuttle_landmark/firebase_dinakk/quark::landmark_tag),
	)

// --------------------------------------------------- misc

/obj/abstract/weather_marker/firebase_dinakk
	weather_type = /singleton/state/weather/snow/medium

/obj/item/key/door_key/firebase_dinakk_armoury
	name = "Armoury Master Key"
	desc = "A key with a label attached reading \"ARMOURY MASTER KEY\"."
	access_list = list(/datum/access/firebase_dinakk_armoury)

/obj/item/research_slip/firebase_dinakk
	name = "Flight Data Recorder transcript slip"
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store recent flight data for recovery following a crash."
	icon_state = "slip_generic"
