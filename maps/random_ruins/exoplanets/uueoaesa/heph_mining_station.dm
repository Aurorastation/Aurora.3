/datum/map_template/ruin/exoplanet/heph_mining_station
	name = "Hephaestus Mining Station"
	id = "heph_mining_station"
	description = "A Hephaestus Industries mining station on one of Uueoa-Esa's minor celestial bodies."
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffix = "heph_mining_station.dmm"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	spawn_cost = 2
	ban_ruins = list(/datum/map_template/ruin/exoplanet/miners_guild_outpost)

	unit_test_groups = list(3)

/area/heph_mining_station
	name = "Hephaestus Mining Station"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	ambience = AMBIENCE_EXPOUTPOST

/area/heph_mining_station/mining
	name = "Hephaestus Mining Station - Processing"
	icon_state = "mining"

/area/heph_mining_station/mess
	name = "Hephaestus Mining Station - Mess Hall"
	icon_state = "cafeteria"

/area/heph_mining_station/medbay
	name = "Hephaestus Mining Station - Medical"
	icon_state = "medbay"

/area/heph_mining_station/entry
	name = "Hephaestus Mining Station - Entry"
	icon_state = "exit"

/area/heph_mining_station/engineer
	name = "Hephaestus Mining Station - Engineering"
	icon_state = "outpost_engine"

/area/heph_mining_station/quarters
	name = "Hephaestus Mining Station - Crew Quarters"
	icon_state = "crew_quarters"

/area/heph_mining_station/equipmentstorage
	name = "Hephaestus Mining Station - Equipment Storage"
	icon_state = "security"

/area/heph_mining_station/eva
	name = "Hephaestus Mining Station - EVA Storage"
	icon_state = "eva"

/area/heph_mining_station/storage
	name = "Hephaestus Mining Station - General Storage"
	icon_state = "machinist_workshop"

/datum/ghostspawner/human/heph_space_miner
	name = "Hephaestus Miner"
	short_name = "heph_space_miner"
	desc = "Work as a miner for Hephaestus Industries on a planetary station."
	tags = list("External")
	welcome_message = "You are a Hephaestus Industries miner, working on an outpost on one of Uueoa-Esa's smaller celestial bodies. Mine the planet or asteroid you find yourself on."

	spawnpoints = list("heph_space_miner")
	max_count = 3

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_heph_miner
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/heph_space_miner/klax
	name = "Hephaestus K'laxan Miner"
	short_name = "heph_klax_space_miner"
	max_count = 1

	extra_languages = list(LANGUAGE_VAURCA)
	possible_species = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BULWARK)
	outfit = /obj/outfit/admin/moghes_heph_miner/klax
	uses_species_whitelist = TRUE
