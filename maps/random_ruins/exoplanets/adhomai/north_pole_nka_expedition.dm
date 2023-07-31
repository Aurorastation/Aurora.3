/datum/map_template/ruin/exoplanet/north_pole_nka_expedition
	name = "New Kingdom Arctic Expedition"
	id = "north_pole_nka_expedition"
	description = "A New Kingdom expedition sent to explore the North Pole."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/north_pole_nka_expedition.dmm")

//ghost roles

/datum/ghostspawner/human/nka_polar_explorer
	short_name = "nka_polar_explorer"
	name = "New Kingdom Arctic Explorer"
	desc = "Explore the north pole as part of the New Kingdom expedition."
	tags = list("External")

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	spawnpoints = list("nka_polar_explorer")
	max_count = 3

	outfit = /datum/outfit/admin/nka_polar_explorer
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "New Kingdom Arctic Explorer"
	special_role = "New Kingdom Arctic Explorer"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/nka_polar_explorer
	name = "New Kingdom Arctic Explorer"

	uniform = /obj/item/clothing/under/tajaran/archeologist
	suit = /obj/item/clothing/suit/storage/tajaran/archeologist
	head = /obj/item/clothing/head/tajaran/archeologist
	shoes = /obj/item/clothing/shoes/tajara/workboots/adhomian_boots
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/melee/whip
	accessory = /obj/item/clothing/accessory/holster/waist/brown
	accessory_contents = list(/obj/item/gun/projectile/revolver/adhomian)
	l_ear = null

	id = /obj/item/card/id
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/device/radio

/datum/outfit/admin/nka_polar_explorer/get_id_access()
	return list(access_nka)

/datum/ghostspawner/human/nka_polar_sailor
	short_name = "nka_polar_sailor"
	name = "New Kingdom Arctic Sailor"
	desc = "Defend the New Kingdom's Explorers as part of the expedition."
	tags = list("External")

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	spawnpoints = list("nka_polar_sailor")
	max_count = 3

	outfit = /datum/outfit/admin/nka_polar_sailor
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "New Kingdom Arctic Sailor"
	special_role = "New Kingdom Arctic Sailor"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/nka_polar_sailor
	name = "New Kingdom Arctic Sailor"

	uniform = /obj/item/clothing/under/tajaran/nka_uniform/sailor
	head = /obj/item/clothing/head/tajaran/nka_cap/sailor
	back = /obj/item/storage/backpack/rucksack/tan
	shoes = /obj/item/clothing/shoes/tajara/combat
	belt = /obj/item/storage/belt/military
	l_ear = null

	id = /obj/item/card/id
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/device/radio

/datum/outfit/admin/nka_polar_sailor/get_id_access()
	return list(access_nka)
