
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
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(3)

/singleton/submap_archetype/crash_site
	map = /datum/map_template/ruin/away_site/crash_site::name
	descriptor = /datum/map_template/ruin/away_site/crash_site::description

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/crash_site
	name = "Juliett-Enderly, Desert Oasis Planet"
	desc = "\
		Temperate planet, mostly dry and covered in sand dunes, but with river and lake oases scattered around the equator. \
		Scans show a somewhat rich biosphere with flora and fauna, and the planet holds a standard breathable atmosphere. \
		Landing site is in a small valley with a small river running through it.\
		"
	icon_state = /obj/effect/overmap/visitable/sector/exoplanet/adhomai::icon_state
	color = /obj/effect/overmap/visitable/sector/exoplanet/adhomai::color

// --------------------------------------------------- misc
