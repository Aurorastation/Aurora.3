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

/datum/map_template/ruin/exoplanet/sdf_outpost
	name = "System Defence Force Outpost"
	id = "sdf outpost"
	description = "A small SDF Monitoring outpost, long forgotten after many years of neglect."

	spawn_weight = 3
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)

	prefix = "grove/sdf_outpost/"
	suffix = "sdf_outpost.dmm"

	planet_types = PLANET_GROVE
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK|RUIN_HOSTILE

	unit_test_groups = list(4)

/area/grove_sdf_outpost
	name = "System Defence Force Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

/datum/map_template/ruin/exoplanet/batcave
	name = "Bat Cave"
	id = "bat cave"
	description = "A small quarry, now filled to the brim with bats and the like."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)

	prefix = "grove/batcave/"
	suffix = "batcave.dmm"

	planet_types = PLANET_GROVE
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK|RUIN_HOSTILE

	unit_test_groups = list(2)
