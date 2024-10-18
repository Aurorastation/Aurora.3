
// ---- map template/archetype

/datum/map_template/ruin/away_site/ipc_rnd_facility
	name = "IPC RnD Facility"
	description = "IPC RnD Facility."
	id = "ipc_rnd_facility"
	prefix = "missions/ipc_rnd_facility/"
	suffixes = list("ipc_rnd_facility.dmm")
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(3)

/singleton/submap_archetype/ipc_rnd_facility
	map = "IPC RnD Facility"
	descriptor = "IPC RnD Facility."
