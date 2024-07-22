/datum/map_template/ruin/exoplanet/hut
	name = "hut"
	id = "hut"
	description = "A small and simple little research hut."

	prefix = "grove/hut/"
	suffix = "hut.dmm"

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)

	planet_types = PLANET_DESERT|PLANET_GRASS|PLANET_GROVE|PLANET_SNOW
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE

	unit_test_groups = list(2)

/datum/map_template/ruin/exoplanet/crashsurvivors
	name = "Crashed Shuttle"
	id = "crashed shuttle"
	description = "A crash shuttle with gear thrown about."

	spawn_weight = 3
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)

	prefix = "grove/crashsurvivors/"
	suffix = "crashsurvivors.dmm"

	planet_types = PLANET_GROVE
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK|RUIN_HOSTILE

	unit_test_groups = list(3)
