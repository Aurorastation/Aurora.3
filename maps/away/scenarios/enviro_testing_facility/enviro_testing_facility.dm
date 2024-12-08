
// ---- map template/archetype

/datum/map_template/ruin/away_site/enviro_testing_facility
	name = "IPC RnD Facility"
	description = "IPC RnD Facility."
	id = "enviro_testing_facility"
	prefix = "missions/enviro_testing_facility/"
	suffix = "enviro_testing_facility.dmm"
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(3)

/singleton/submap_archetype/enviro_testing_facility
	map = "IPC RnD Facility"
	descriptor = "IPC RnD Facility."
