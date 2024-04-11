/datum/map_template/ruin/exoplanet/sol_probe
	name = "Sol Alliance Probe"
	id = "sol_probe"
	description = "A Solarian planetary survey probe, long-since abandoned."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(ALL_TAU_CETI_SECTORS, ALL_BADLAND_SECTORS, ALL_COALITION_SECTORS) //Pretty old probe, so found anywhere that Sol would have been exploring back in the day.
	suffixes = list("asteroid/probes/sol_probe.dmm")

	planet_types = ALL_PLANET_TYPES //Spawns on pretty much any planet except for specific lore ones
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE
	ban_ruins = list( //Only one probe per planet for the sake of variety
		/datum/map_template/ruin/exoplanet/pra_probe,
		/datum/map_template/ruin/exoplanet/elyra_probe,
		/datum/map_template/ruin/exoplanet/coc_probe,
		/datum/map_template/ruin/exoplanet/hegemony_probe,
		/datum/map_template/ruin/exoplanet/dominia_probe
	)

/datum/map_template/ruin/exoplanet/pra_probe
	name = "People's Republic of Adhomai Probe"
	id = "pra_probe"
	description = "A PRA planetary survey probe."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_SRANDMARR, SECTOR_BADLANDS, SECTOR_NRRAHRAHUL) //Sectors within the PRA's reach
	suffixes = list("asteroid/probes/pra_probe.dmm")

	planet_types = ALL_PLANET_TYPES //Spawns on pretty much any planet except for specific lore ones
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE
	ban_ruins = list( //Only one probe per planet for the sake of variety
		/datum/map_template/ruin/exoplanet/sol_probe,
		/datum/map_template/ruin/exoplanet/elyra_probe,
		/datum/map_template/ruin/exoplanet/coc_probe,
		/datum/map_template/ruin/exoplanet/hegemony_probe,
		/datum/map_template/ruin/exoplanet/dominia_probe
	)

/datum/map_template/ruin/exoplanet/elyra_probe
	name = "Elyran Survey Probe"
	id = "elyra_probe"
	description = "An Elyran planetary survey probe."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_AEMAQ) //Sectors within Elyra's general area of operation.
	suffixes = list("asteroid/probes/elyra_probe.dmm")

	planet_types = ALL_PLANET_TYPES //Spawns on pretty much any planet except for specific lore ones
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE
	ban_ruins = list( //Only one probe per planet for the sake of variety
		/datum/map_template/ruin/exoplanet/sol_probe,
		/datum/map_template/ruin/exoplanet/pra_probe,
		/datum/map_template/ruin/exoplanet/coc_probe,
		/datum/map_template/ruin/exoplanet/hegemony_probe,
		/datum/map_template/ruin/exoplanet/dominia_probe
	)

/datum/map_template/ruin/exoplanet/hegemony_probe
	name = "Izweski Survey Probe"
	id = "hegemony_probe"
	description = "An Izweski planetary survey probe."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_UUEOAESA, SECTOR_BADLANDS, SECTOR_GAKAL) //Sectors within the Hegemony's general area of operation.
	suffixes = list("asteroid/probes/hegemony_probe.dmm")

	planet_types = ALL_PLANET_TYPES //Spawns on pretty much any planet except for specific lore ones
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE
	ban_ruins = list( //Only one probe per planet for the sake of variety
		/datum/map_template/ruin/exoplanet/sol_probe,
		/datum/map_template/ruin/exoplanet/pra_probe,
		/datum/map_template/ruin/exoplanet/elyra_probe,
		/datum/map_template/ruin/exoplanet/coc_probe,
		/datum/map_template/ruin/exoplanet/dominia_probe
	)

/datum/map_template/ruin/exoplanet/coc_probe
	name = "Coalition Survey Probe"
	id = "coc_probe"
	description = "A Coalition planetary survey probe."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_BADLANDS, ALL_COALITION_SECTORS, ALL_VOID_SECTORS) //Sectors where the COC has or would have had surveyors.
	sectors_blacklist = list(SECTOR_HANEUNIM) //Recently Solarian, so probably no COC probes there.
	suffixes = list("asteroid/probes/coc_probe.dmm")

	planet_types = ALL_PLANET_TYPES //Spawns on pretty much any planet except for specific lore ones
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE
	ban_ruins = list( //Only one probe per planet for the sake of variety
		/datum/map_template/ruin/exoplanet/sol_probe,
		/datum/map_template/ruin/exoplanet/pra_probe,
		/datum/map_template/ruin/exoplanet/elyra_probe,
		/datum/map_template/ruin/exoplanet/hegemony_probe,
		/datum/map_template/ruin/exoplanet/dominia_probe
	)

/datum/map_template/ruin/exoplanet/dominia_probe
	name = "Dominian Survey Probe"
	id = "dominia_probe"
	description = "A Dominian planetary survey probe."

	spawn_weight = 1
	spawn_cost = 0.5
	sectors = list(SECTOR_BADLANDS) //Sectors within Dominia's general area of operation.
	suffixes = list("asteroid/probes/dominia_probe.dmm")

	planet_types = ALL_PLANET_TYPES //Spawns on pretty much any planet except for specific lore ones
	ruin_tags = RUIN_LOWPOP|RUIN_SCIENCE
	ban_ruins = list( //Only one probe per planet for the sake of variety
		/datum/map_template/ruin/exoplanet/sol_probe,
		/datum/map_template/ruin/exoplanet/pra_probe,
		/datum/map_template/ruin/exoplanet/elyra_probe,
		/datum/map_template/ruin/exoplanet/coc_probe,
		/datum/map_template/ruin/exoplanet/hegemony_probe
	)
