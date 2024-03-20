/datum/map_template/ruin/exoplanet/konyang_homestead
	name = "Konyang Homestead"
	id = "konyang_homestead"
	description = "A rural homestead on Konyang."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("konyang/homestead.dmm")

/area/konyang_homestead
	name = "Konyang Homestead"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE

	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/ambience/eeriejungle2.ogg','sound/ambience/eeriejungle1.ogg')
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

/datum/ghostspawner/human/konyang_homesteader
	short_name = "konyang_homesteader"
	name = "Konyang Homesteader"
	desc = "Live your life in a rural Konyang homestead."
	tags = list("External")
	welcome_message = "You are a farmer living in rural homestead"

	spawnpoints = list("konyang_homesteader")
	max_count = 2

	extra_languages = list(LANGUAGE_SOL_COMMON)
	outfit = /obj/outfit/admin/konyang/homesteader
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Konyang Homesteader"
	special_role = "Konyang Homesteader"
	respawn_flag = null

	uses_species_whitelist = FALSE

	culture_restriction = list(/singleton/origin_item/culture/solarian)
	origin_restriction = list(/singleton/origin_item/origin/konyang)

/obj/outfit/admin/konyang/homesteader
	name = "Konyang Homesteader"

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
