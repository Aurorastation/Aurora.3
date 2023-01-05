/datum/ghostspawner/human/nka_merchant_crew
	short_name = "nka_merchant_crew"
	name = "New Kingdom Merchant Navy Crew"
	desc = "Crew a Her Majesty's Mercantile Flotilla ship."
	tags = list("External")

	spawnpoints = list("nka_merchant_crew")
	max_count = 3
	uses_species_whitelist = FALSE

	outfit = /datum/outfit/admin/nka_merchant_crew
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "NKA Merchant Navy Crew"
	special_role = "NKA Merchant Navy Crew"
	extra_languages = list(LANGUAGE_SIIK_MAAS)

/datum/outfit/admin/nka_merchant_crew
	name = "New Kingdom Merchant Navy Crew"

	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/tajara/workboots

	uniform = /obj/item/clothing/under/dress/tajaran/nka_merchant_navy
	head = /obj/item/clothing/head/tajaran/nka_merchant_navy
	l_ear = /obj/item/device/radio/headset/ship

	r_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/nka_merchant_crew/get_id_access()
	return list(access_nka, access_external_airlocks)

/datum/ghostspawner/human/nka_merchant_crew/captain
	short_name = "nka_merchant_captain"
	name = "New Kingdom Merchant Navy Captain"
	desc = "Command a Her Majesty's Mercantile Flotilla ship."

	spawnpoints = list("nka_merchant_captain")
	max_count = 1
	uses_species_whitelist = TRUE

	outfit = /datum/outfit/admin/nka_merchant_crew/captain
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)


	assigned_role = "NKA Merchant Navy Captain"
	special_role = "NKA Merchant Navy Captain"


/datum/outfit/admin/nka_merchant_crew/captain
	name = "New Kingdom Merchant Navy Captain"

	shoes = /obj/item/clothing/shoes/tajara/jackboots

	uniform = /obj/item/clothing/under/tajaran/nka_merchant_navy/captain
	head = /obj/item/clothing/head/tajaran/nka_merchant_navy/captain

	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/revolver/adhomian = 1)

/datum/ghostspawner/human/nka_merchant_crew/guard
	short_name = "nka_merchant_guard"
	name = "New Kingdom Merchant Navy PMCG Guard"
	desc = "Protect a Her Majesty's Mercantile Flotilla ship."

	spawnpoints = list("nka_merchant_guard")
	max_count = 1

	outfit = /datum/outfit/admin/nka_merchant_crew/captain

	assigned_role = "NKA Merchant Navy PMCG Guard"
	special_role = "NKA Merchant Navy PMCG Guard"


/datum/outfit/admin/nka_merchant_crew/guard
	name = "New Kingdom Merchant Navy PMCG Guard"

	shoes = /obj/item/clothing/shoes/tajara/jackboots

	uniform = /obj/item/clothing/under/pmc_modsuit
	head = /obj/item/clothing/head/beret/corporate/pmc
	belt = /obj/item/storage/belt/security/full

	back = /obj/item/storage/backpack/duffel/pmcg
	backpack_contents = list(/obj/item/clothing/suit/armor/carrier/officer = 1,
							/obj/item/clothing/accessory/arm_guard = 1,
							/obj/item/clothing/accessory/leg_guard = 1,
							/obj/item/clothing/head/helmet/security = 1,
							/obj/item/gun/energy/gun = 1)

	accessory = /obj/item/clothing/accessory/holster/hip

	accessory_contents = list(/obj/item/gun/energy/pistol = 1)