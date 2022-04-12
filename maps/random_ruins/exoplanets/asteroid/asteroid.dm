/datum/map_template/ruin/exoplanet/abandoned_mining
	name = "Abandoned Mining Site"
	id = "miningsite"
	description = "An abandoned mining site. Some tools and materials were left behind."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	suffix = "asteroid/mining_base.dmm"

	template_flags = RUIN_HUMAN

/datum/map_template/ruin/exoplanet/carp_nest
	name = "Carp Nest"
	id = "carp_nest"
	description = "A nest of deadly space carps."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	suffix = "asteroid/carp_nest.dmm"

	template_flags = RUIN_ALIEN