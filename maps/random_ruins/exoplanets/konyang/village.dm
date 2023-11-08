/datum/map_template/ruin/exoplanet/konyang_village
	name = "Konyang Village"
	id = "konyang_village"
	description = "A rural village on Konyang."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/village.dmm")

/area/konyang_village
	name = "Konyang Village"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	flags = HIDE_FROM_HOLOMAP

/datum/ghostspawner/human/konyang_villager
	short_name = "konyang_villager"
	name = "Konyang Villager"
	desc = "Live your life in a rural Konyang village."
	tags = list("External")
	welcome_message = "You are a villager in rural Konyang"

	spawnpoints = list("konyang_villager")
	max_count = 5

	extra_languages = list(LANGUAGE_SOL_COMMON)
	outfit = /datum/outfit/admin/konyang_villager
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Konyang Villager"
	special_role = "Konyang Villager"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/konyang_villager
	name = "Konyang Villager"

	uniform = list(
		/obj/item/clothing/under/konyang,
		/obj/item/clothing/under/konyang/blue,
		/obj/item/clothing/under/konyang/male,
		/obj/item/clothing/under/konyang/pink,
		/obj/item/clothing/under/konyang/male/sleeveless,
		/obj/item/clothing/under/konyang/male/shortsleeve
	)
	shoes = /obj/item/clothing/shoes/konyang
	back = /obj/item/storage/backpack/satchel/leather
	l_ear = null
	id = null
	l_pocket = /obj/item/storage/wallet/random
