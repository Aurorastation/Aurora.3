/datum/map_template/ruin/exoplanet/drill_site
	name = "drill site"
	id = "drill_site"
	description = "A small, abandoned mining drill operation."
	suffixes = list("lava/drill_site/drill_site.dmm")
	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, ALL_COALITION_SECTORS)

	planet_types = PLANET_ASTEROID|PLANET_BARREN|PLANET_GROVE|PLANET_LAVA|PLANET_DESERT
	ruin_tags = RUIN_LOWPOP|RUIN_WRECK|RUIN_MINING
