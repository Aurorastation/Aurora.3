/datum/map_template/ruin/exoplanet/abandoned_mining
	name = "Abandoned Mining Site"
	id = "miningsite"
	description = "An abandoned mining site. Some tools and materials were left behind."

	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/mining_base/mining_base.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN
	ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_MINING

/datum/map_template/ruin/exoplanet/carp_nest
	name = "Carp Nest"
	id = "carp_nest"
	description = "A nest of deadly space carps."

	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/carp_nest/carp_nest.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN
	ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_HOSTILE|RUIN_NATURAL

/datum/map_template/ruin/exoplanet/hideout
	name = "Abandoned Hideout"
	id = "hideout"
	description = "An abandoned hideout, seemingly once belonging to a marooned crew."

	spawn_weight = 0.5
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/hideout/hideout.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_HOSTILE|RUIN_WRECK

/datum/map_template/ruin/exoplanet/crashed_shuttle_01
	name = "Crashed Shuttle"
	id = "crashedshuttle01"
	description = "A crashed shuttle, with some gear left behind."

	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/crashed_shuttle/crashed_shuttle_01.dmm")

	spawn_weight = 0.5
	spawn_cost = 2

	planet_types = PLANET_ASTEROID|PLANET_BARREN
	ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_HOSTILE|RUIN_WRECK

/datum/map_template/ruin/exoplanet/crashed_sol_shuttle_01
	name = "Crashed Solarian Shuttle"
	id = "crashed_sol_shuttle_1"
	description = "A crashed sol shuttle, with some gear left behind."

	spawn_weight = 0.5
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_WEEPING_STARS)
	suffixes = list("asteroid/sol_ship/sol_ship_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK

/datum/map_template/ruin/exoplanet/crashed_skrell_shuttle_01
	name = "Crashed Skrellian Shuttle"
	id = "crashed_skrell_shuttle_1"
	description = "A crashed skrell shuttle, with some gear left behind."

	spawn_weight = 0.5
	spawn_cost = 3
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("asteroid/skrell_ship/skrell_crash_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK

/datum/map_template/ruin/exoplanet/mystery_ship_1
	name = "Mystery Ship"
	id = "mystery_ship_1"
	description = "An unmarked shuttle in almost pristine condition. The occupants are nowhere to be found."

	spawn_weight = 0.5
	spawn_cost = 3
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/mystery_ship/mystery_ship_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE|RUIN_WRECK

/datum/map_template/ruin/exoplanet/crashed_satellite
	name = "Crashed Satellite"
	id = "crashed_satelite"
	description = "A crashed satelite."

	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/satelite_crash/satelite_crash_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN
	ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_WRECK|RUIN_HOSTILE

/datum/map_template/ruin/exoplanet/abandoned_listening_post
	name = "Abandoned Listening Post"
	id = "abandoned_listening_post"
	description = "An abandoned listening post."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/listening_post/listening_post_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_HOSTILE

/datum/map_template/ruin/exoplanet/crashed_escape_pod_1
	name = "Crashed Escape Pod"
	id = "crashed_escape_pod_1"
	description = "A crashed escape pod."

	spawn_weight = 0.5
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/escape_pod/escape_pod_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN
	ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_WRECK|RUIN_HOSTILE

/datum/map_template/ruin/exoplanet/digsite
	name = "Digsite"
	id = "digsite"
	description = "A research digsite."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/digsite/digsite_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE

/datum/map_template/ruin/exoplanet/crashed_pod_1
	name = "Crashed Pod"
	id = "crashed_pod_1"
	description = "A crashed pod."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/crashed_pod/crashed_pod_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN
	ruin_tags = RUIN_AIRLESS|RUIN_LOWPOP|RUIN_WRECK|RUIN_HOSTILE

/datum/map_template/ruin/exoplanet/crashed_coc_skipjack
	name = "Crashed Coalition Skipjack"
	id = "crashed_coc_skipjack"
	description = "A crashed Coalition skipjack, with some gear left behind."

	spawn_weight = 0.5
	spawn_cost = 3
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/coc_ship/coc_ship_unique.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK|RUIN_HOSTILE

/datum/map_template/ruin/exoplanet/abandoned_outpost
	name = "Abandoned Mining Outpost"
	id = "miningoutpost"
	description = "A long-abandoned mining outpost."

	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)
	suffixes = list("asteroid/old_outpost/old_outpost.dmm")

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_MINING
