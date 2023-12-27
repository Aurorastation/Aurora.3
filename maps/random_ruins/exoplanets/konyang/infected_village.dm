/datum/map_template/ruin/exoplanet/infected_village
	name = "Infected Village"
	id = "infected_village"
	description = "An infected rural village on Konyang. - WIP"

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/infected_village.dmm")

/area/konyang_infected_village
	name = "Infected Village"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP

/datum/ghostspawner/human/konyang_infected_villager
	short_name = "konyang_infected_villager"
	name = "Infected Villager"
	desc = "Live your life in an infected rural Konyang village. - WIP"
	tags = list("External")
	welcome_message = "You are an infected villager in rural Konyang. - WIP"

	spawnpoints = list("konyang_infected_villager")
	max_count = 5

	extra_languages = list(LANGUAGE_SOL_COMMON)
	outfit = /datum/outfit/admin/konyang_infected_villager
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Infected Villager"
	special_role = "Infected Villager"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/konyang_infected_villager
	name = "Infected Villager"

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
