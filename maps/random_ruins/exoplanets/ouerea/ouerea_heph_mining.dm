/datum/map_template/ruin/exoplanet/ouerea_heph_mining
	name = "Hephaestus Mining Camp"
	id = "ouerea_heph_mining"
	description = "A Hephaestus Industries mining facility on Ouerea"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_heph_mining.dmm"
	ban_ruins = list(/datum/map_template/ruin/exoplanet/ouerea_guild_mining)
	unit_test_groups = list(2)

/area/ouerea_heph_mining
	name = "Hephaestus Mining Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The faint sounds of heavy machinery can be heard - the whirring of drills, the quiet noise of conveyor belts, and the electrical hum of power cables."

/datum/ghostspawner/human/ouerea_heph_miner
	name = "Hephaestus Miner"
	short_name = "ouerea_heph_miner"
	desc = "Work as a miner for Hephaestus Industries on Ouerea."
	tags = list("External")
	welcome_message = "You are a miner working for Hephaestus Industries, on the planet Ouerea. Break rocks, earn your paycheck."

	spawnpoints = list("ouerea_heph_miner")
	max_count = 5

	extra_languages = list(LANGUAGE_UNATHI)
	outfit = /obj/outfit/admin/moghes_heph_miner
	possible_species = list(SPECIES_UNATHI, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE
	species_outfits = list(
		SPECIES_HUMAN = /obj/outfit/admin/cyclops_crew,
		SPECIES_SKRELL = /obj/outfit/admin/cyclops_crew,
		SPECIES_SKRELL_AXIORI = /obj/outfit/admin/cyclops_crew,
		SPECIES_UNATHI = /obj/outfit/admin/moghes_heph_miner
	)

/datum/ghostspawner/human/ouerea_heph_miner/klax
	name = "Hephaestus K'laxan Miner"
	short_name = "ouerea_klax_miner"
	max_count = 1

	extra_languages = list(LANGUAGE_VAURCA)
	possible_species = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BULWARK)
	outfit = /obj/outfit/admin/moghes_heph_miner/klax
	uses_species_whitelist = TRUE
