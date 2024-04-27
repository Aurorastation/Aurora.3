/datum/map_template/ruin/exoplanet/ala_cell
	name = "Inactive Liberation Army Cell"
	id = "ala_cell"
	description = "A hideout used by a Liberation Army cell. It is currently inactive."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)

	prefix = "adhomai/"
	suffixes = list("ala_cell.dmm")

	unit_test_groups = list(2)
