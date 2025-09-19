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

/datum/map_template/ruin/exoplanet/smuggler_hideout
	name = "Smuggler Hideout"
	id = "smuggler_hideout"
	description = "A miniture, undetectable hut that seems to be hiding something..."

	spawn_weight = 2
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)

	prefix = "desert/smuggler_hideout/"
	suffix = "smuggler_hideout.dmm"

	planet_types = PLANET_DESERT
	ruin_tags = RUIN_NATURAL

	unit_test_groups = list(1)

/datum/map_template/ruin/exoplanet/desert_comms
	name = "Abandoned Solarian Relay Station"
	id = "desert_comms"
	description = "An abandoned pre-war Solarian Relay Station, used to collect data from nearby orbital sensors across the Spur."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_COALITION, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_GENERIC)

	prefix = "desert/desert_comms/"
	suffix = "desert_comms.dmm"

	planet_types = PLANET_DESERT
	ruin_tags = RUIN_HOSTILE

	unit_test_groups = list(1)

/area/desert_comms
	name = "Abandoned Solarian Relay Station"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
