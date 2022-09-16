/datum/map_template/ruin/exoplanet/abandoned_mining
	name = "Abandoned Mining Site"
	id = "miningsite"
	description = "An abandoned mining site. Some tools and materials were left behind."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	suffix = list("asteroid/mining_base.dmm")

	ruin_tags = RUIN_HUMAN|RUIN_VOID

/datum/map_template/ruin/exoplanet/carp_nest
	name = "Carp Nest"
	id = "carp_nest"
	description = "A nest of deadly space carps."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	suffix = list("asteroid/carp_nest.dmm")

	ruin_tags = RUIN_ALIEN|RUIN_VOID

/datum/map_template/ruin/exoplanet/hideout
	name = "Abandoned Hideout"
	id = "hideout"
	description = "An abandoned hideout, seemingly once belonging to a marooned crew."

	spawn_weight = 0.5
	spawn_cost = 4
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	suffix = list("asteroid/hideout.dmm")

	ruin_tags = RUIN_HUMAN|RUIN_WRECK|RUIN_VOID

/datum/map_template/ruin/exoplanet/crashed_shuttle_01
	name = "Crashed Shuttle"
	id = "crashedshuttle01"
	description = "A crashed shuttle, with some gear left behind."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	suffix = list("asteroid/crashed_shuttle_01.dmm")

	ruin_tags = RUIN_WRECK|RUIN_VOID

