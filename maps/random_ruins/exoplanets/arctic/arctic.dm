/datum/map_template/ruin/exoplanet/arctic/bunker
	name = "Pre-War Auxiliary Bunker"
	id = "prewar bunker"
	description = "A relitively small bunker used Pre-Interstellar War for local operations and sector management."

	spawn_weight = 3
	spawn_cost = 1
	sectors = list(SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS, SECTOR_GENERIC)

	prefix = "arctic/arctic_bunker/"
	suffix = "arctic_bunker.dmm"

	planet_types = PLANET_SNOW
	ruin_tags = RUIN_LOWPOP|RUIN_HOSTILE

	unit_test_groups = list(4)

/area/arctic_bunker
	name = "Pre-War Auxiliary Bunker"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

/datum/map_template/ruin/exoplanet/arctic/crashed_fighter
	name = "Crashed CR-80 VOLT"
	id = "crashed fighter"
	description = "An old Pre-War design interceptor, crashed into the arctic terrain."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)

	prefix = "arctic/arctic_sol_crash/"
	suffix = "arctic_sol_crash.dmm"

	planet_types = PLANET_SNOW
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK

	unit_test_groups = list(2)

/datum/map_template/ruin/exoplanet/arctic/mining_camp
	name = "Abandoned Mining Camp"
	id = "mining camp"
	description = "An abandoned mining camp on the snowy terrain, with some things left behind still."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)

	prefix = "arctic/arctic_campsite/"
	suffix = "arctic_campsite.dmm"

	planet_types = PLANET_SNOW
	ruin_tags = RUIN_LOWPOP

	unit_test_groups = list(2)
