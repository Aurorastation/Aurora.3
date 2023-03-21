/datum/map_template/ruin/exoplanet/hut
	name = "hut"
	id = "hut"
	description = "A small and simple little research hut."
	suffixes = list("grove/hut/hut.dmm")
	spawn_weight = 1
	spawn_cost = 0.5
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS|TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT


/datum/map_template/ruin/exoplanet/crashsurvivors
	name = "Crashed Shuttle"
	id = "crashed shuttle"
	description = "A crash shuttle with gear thrown about."

	spawn_weight = 3
	spawn_cost = 0.5
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	suffixes = list("grove/crashsurvivors/crashsurvivors.dmm")

	ruin_tags = RUIN_WRECK|RUIN_HUMAN