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

ABSTRACT_TYPE(/area/desert_comms)
	name = "Abandoned Solarian Relay Station"
	icon_state = "bluenew"
	requires_power = TRUE
	no_light_control = FALSE
	ambience = AMBIENCE_TECH_RUINS

/area/desert_comms/exterior
	name = "Abandoned Solarian Relay Station Exterior"
	sound_environment = SOUND_ENVIRONMENT_PLAIN
	is_outside = OUTSIDE_YES
	ambience = AMBIENCE_DESERT

/area/desert_comms/entrance
	name = "Abandoned Solarian Relay Station Entrance"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/desert_comms/main_room
	name = "Abandoned Solarian Relay Station Main Area"

/area/desert_comms/substation
	name = "Abandoned Solarian Relay Station Substation"
	ambience = AMBIENCE_SUBSTATION
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/desert_comms/power
	name = "Abandoned Solarian Relay Station Nuclear Generators"
	ambience = AMBIENCE_MAINTENANCE
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/desert_comms/command
	name = "Abandoned Solarian Relay Station Command Room"

/area/desert_comms/lounge
	name = "Abandoned Solarian Relay Station Crew Lounge"

/area/desert_comms/quarters
	name = "Abandoned Solarian Relay Station Crew Quarters"

/area/desert_comms/quarters/command
	name = "Abandoned Solarian Relay Station Commander's Quarters"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

/area/desert_comms/restroom
	name = "Abandoned Solarian Relay Station Crew Restroom"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/desert_comms/freezer
	name = "Abandoned Solarian Relay Station Crew Freezer"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
