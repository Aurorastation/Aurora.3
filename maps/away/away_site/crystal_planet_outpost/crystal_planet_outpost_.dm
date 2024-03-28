/datum/map_template/ruin/away_site/crystal_planet_outpost
	name = "Crystal Planet Outpost"
	description = "Crystal Planet Outpost."
	id = "crystal_planet_outpost"
	spawn_cost = 1
	spawn_weight = 1
	suffixes = list("away_site/crystal_planet_outpost/crystal_planet_outpost.dmm")
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(SECTOR_BURZSIA, SECTOR_HANEUNIM, SECTOR_SRANDMARR, SECTOR_TAU_CETI) //it's a whole planet, shouldn't have it in predefined sectors
	unit_test_groups = list(1)

/singleton/submap_archetype/crystal_planet_outpost
	map = "crystal_planet_outpost"
	descriptor = "Crystal Planet Outpost."

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
		"nav_crystal_planet_outpost_landing_pad_2a",
		"nav_crystal_planet_outpost_landing_pad_2b",
		"nav_crystal_planet_outpost_landing_pad_3a",
		"nav_crystal_planet_outpost_landing_pad_3b",
		"nav_crystal_planet_outpost_landing_pad_4a",
		"nav_crystal_planet_outpost_landing_pad_4b",
	)

/obj/effect/overmap/visitable/sector/crystal_planet_outpost/New(nloc, max_x, max_y)
	name = "[generate_planet_name()], \a [pick("crystal planetoid", "silicate planetoid", "mineral planetoid")]"
	..()
