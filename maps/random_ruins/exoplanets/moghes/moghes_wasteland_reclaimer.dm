/datum/map_template/ruin/exoplanet/moghes_wasteland_reclaimer
	name = "Reclaimer Camp"
	description = "A group of Unathi salvagers from one of the Reclaimer clans."
	id = "moghes_reclaimer"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_reclaimers.dmm"
	unit_test_groups = list(1)

/area/moghes_reclaimer
	name = "Reclaimer Salvage Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS

/datum/ghostspawner/human/moghes_wasteland_reclaimer
	name = "Reclaimer Salvager"
	short_name = "moghes_wasteland_reclaimer"
	desc = "Salvage the ruins of the Wasteland to keep yourself alive and your crawler running."
	tags = list("External")
	welcome_message = "You are an Unathi from one of the Reclaimer Clans, sent out into the Wastes in search of supplies. Trade and salvage for what you need, and keep yourself alive."

	max_count = 3
	spawnpoints = list("moghes_reclaimer")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_reclaimer
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Reclaimer Salvager"
	special_role = "Reclaimer Salvager"
	respawn_flag = null

/obj/outfit/admin/moghes_reclaimer
	name = "Reclaimer Salvager"

	uniform = /obj/item/clothing/under/unathi
	accessory = /obj/item/clothing/accessory/storage/overalls/engineer
	belt = /obj/item/storage/belt/utility
	suit = list(
		/obj/item/clothing/accessory/poncho,
		/obj/item/clothing/suit/unathi/robe/beige,
		/obj/item/clothing/suit/unathi/robe/kilt
	)
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	gloves = /obj/item/clothing/gloves/yellow/specialu
	shoes = list(/obj/item/clothing/shoes/sandals/caligae, /obj/item/clothing/shoes/workboots/toeless)
	back = /obj/item/storage/backpack/satchel/leather
