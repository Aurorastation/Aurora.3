/datum/map_template/ruin/exoplanet/desert_oasis
	name = "Desert Oasis"
	id = "desert_oasis"
	description = "An oasis within the desert."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)

	prefix = "desert/desert_oasis/"
	suffix = "desert_oasis.dmm"

	planet_types = PLANET_DESERT
	ruin_tags = RUIN_NATURAL

	unit_test_groups = list(1)

/datum/map_template/ruin/exoplanet/desert_camp
	name = "Desert Camp"
	id = "desert_camp"
	description = "A small research camp, left in a hurry."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)

	prefix = "desert/desert_camp/"
	suffix = "desert_camp.dmm"

	planet_types = PLANET_DESERT
	ruin_tags = RUIN_NATURAL

	unit_test_groups = list(1)
