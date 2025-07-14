
// --------------------------------------------------- template

/datum/map_template/ruin/away_site/crystal_planet_outpost
	name = "Crystal Planet Outpost"
	description = "Crystal Planet Outpost."
	id = "crystal_planet_outpost"

	prefix = "away_site/crystal_planet_outpost/"
	suffix = "crystal_planet_outpost_.dmm"

	exoplanet_theme_base = /datum/exoplanet_theme/crystal
	exoplanet_themes = list(
		/turf/unsimulated/marker/green = /datum/exoplanet_theme/crystal,
		/turf/unsimulated/marker/teal  = /datum/exoplanet_theme/crystal/mountain
	)
	exoplanet_atmospheres = list(/datum/gas_mixture/earth_cold)
	exoplanet_lightlevel = list(1, 2)
	exoplanet_lightcolor = list("#00ffff", "#33cccc") // teal-ish colors

	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(ALL_SPECIFIC_SECTORS, ALL_UNCHARTED_SECTORS) //it's a whole planet, shouldn't have it in predefined sectors
	unit_test_groups = list(1)

/singleton/submap_archetype/crystal_planet_outpost
	map = "crystal_planet_outpost"
	descriptor = "Crystal Planet Outpost."

// --------------------------------------------------- sector

/obj/effect/overmap/visitable/sector/crystal_planet_outpost
	name = "Crystal Planet Outpost"
	desc = "\
		Small crystal planetoid, rich in silicate minerals, with the surface covered in tough, compacted mineral crystals. \
		Scans show no biosphere of any kind, but the planet nonetheless holds a standard breathable atmosphere, if a bit cold. \
		Latest sector data indicate a small independent outpost to have been built and registered a year or so ago here.\
		"
	in_space = FALSE
	icon_state = "globe2"
	color = "#99eef3"
	initial_generic_waypoints = list(
		"nav_crystal_planet_outpost_landing_pad_1a",
		"nav_crystal_planet_outpost_landing_pad_1b",
		"nav_crystal_planet_outpost_landing_pad_1c",
		"nav_crystal_planet_outpost_landing_pad_1d",
		"nav_crystal_planet_outpost_landing_pad_2a",
		"nav_crystal_planet_outpost_landing_pad_2b",
		"nav_crystal_planet_outpost_landing_pad_2c",
		"nav_crystal_planet_outpost_landing_pad_2d",
		"nav_crystal_planet_outpost_landing_pad_3a",
		"nav_crystal_planet_outpost_landing_pad_3b",
		"nav_crystal_planet_outpost_landing_pad_3c",
		"nav_crystal_planet_outpost_landing_pad_3d",
		"nav_crystal_planet_outpost_landing_pad_4a",
		"nav_crystal_planet_outpost_landing_pad_4b",
		"nav_crystal_planet_outpost_landing_pad_4c",
		"nav_crystal_planet_outpost_landing_pad_4d",
	)

/obj/effect/overmap/visitable/sector/crystal_planet_outpost/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [pick("crystal planetoid", "silicate planetoid", "mineral planetoid")]"
	..()

// --------------------------------------------------- mapmanip

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/cave_01
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/cave_01

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/cave_02
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/cave_02

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/cave_03
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/cave_03

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/anomaly_cave_01
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/anomaly_cave_01

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/anomaly_cave_02
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/anomaly_cave_02

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/anomaly_cave_03
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/anomaly_cave_03

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/anomaly_cave_04
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/anomaly_cave_04

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/crew_room_n
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/crew_room_n

/obj/effect/map_effect/marker/mapmanip/submap/extract/crystal_planet_outpost/crew_room_s
/obj/effect/map_effect/marker/mapmanip/submap/insert/crystal_planet_outpost/crew_room_s

// --------------------------------------------------- fin
