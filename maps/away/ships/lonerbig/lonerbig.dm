
// ------------------ map/template stuff

/datum/map_template/ruin/away_site/lonerbig
	name = "Saroka Class"
	description = "A venerable hauling ship tracing its origins to the port moon of Callisto, designed by Einstein Engines to be produced on mass for transportation of cargo within a star system. This particular model is an odd one - not only has it outlived it's operational expectations, but it has been heavily modified. Energy signatures emanating from its hull indicate the presence of a simple warp drive, and visual scanners show a francisca autocannon bolted onto it's bridge."

	prefix = "ships/lonerbig/"
	suffix = "lonerbig.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 10000000000
	ship_cost = 1
	id = "lonerbig"

	unit_test_groups = list(2)

/singleton/submap_archetype/lonerbig
	map = "Saroka Class"
	descriptor = "A venerable hauling ship tracing its origins to the port moon of Callisto, designed by Einstein Engines to be produced on mass for transportation of cargo within a star system. This particular model is an odd one - not only has it outlived it's operational expectations, but it has been heavily modified. Energy signatures emanating from its hull indicate the presence of a simple warp drive, and visual scanners show a francisca autocannon bolted onto it's bridge."
