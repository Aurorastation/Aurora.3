/datum/map_template/ruin/exoplanet/ouerea_village
	name = "Ouerea Village"
	id = "ouerea_village"
	description = "A rural Unathi village, somewhere on the planet Ouerea."
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_village.dmm"
	unit_test_groups = list(3)

/area/ouerea_village
	name = "Ouerea Village"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "A cozy Ouerean village. Lights can be seen through the windows of the buildings here, and the smell of cooking fish drifts on the wind."

/datum/ghostspawner/human/ouerea_villager
	name = "Ouerean Villager"
	short_name = "ouerea_villager"
	desc = "Live your life in a rural village on Ouerea."
	tags = list("External")
	welcome_message = "You are are a rural villager on the planet Ouerea. Live your life and tend to your fish and fields."


	spawnpoints = list("ouerea_villager")
	max_count = 5

	extra_languages = list(LANGUAGE_UNATHI)
	outfit = /obj/outfit/admin/unathi_village
	possible_species = list(SPECIES_UNATHI, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	species_outfits = list(
		SPECIES_UNATHI = /obj/outfit/admin/unathi_village,
		SPECIES_HUMAN = /obj/outfit/admin/ouerea_human,
		SPECIES_SKRELL = /obj/outfit/admin/ouerea_skrell,
		SPECIES_SKRELL_AXIORI = /obj/outfit/admin/ouerea_skrell
	)

	assigned_role = "Ouerean Villager"
	special_role = "Ouerean Villager"
	respawn_flag = null

	uses_species_whitelist = FALSE
