
// ---- map template/archetype

/datum/map_template/ruin/away_site/environmental_testing_facility
	name = "IPC RnD Facility"
	description = "IPC RnD Facility."
	id = "environmental_testing_facility"
	prefix = "missions/environmental_testing_facility/"
	suffix = "environmental_testing_facility.dmm"
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(3)

/singleton/submap_archetype/environmental_testing_facility
	map = "IPC RnD Facility"
	descriptor = "IPC RnD Facility."
