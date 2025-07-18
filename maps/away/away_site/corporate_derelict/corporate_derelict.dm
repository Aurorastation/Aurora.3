/datum/map_template/ruin/away_site/corporate_derelict
	name = "Corporate Derelict"
	description = "Corporate Derelict."
	id = "corp_derelict"
	prefix = "away_site/corporate_derelict/"
	suffix = "corporate_derelict.dmm"
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	// shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/cult_base_shuttle)
	unit_test_groups = list(3)

/singleton/submap_archetype/corporate_derelict
	map = "Corporate Derelict"
	descriptor = "Corporate Derelict."
