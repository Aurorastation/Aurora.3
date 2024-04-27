/datum/ghostspawner/human/tajaran_scrapper
	short_name = "tajaran_scrapper"
	name = "Tajaran Scrapper"
	desc = "Crew the Tajaran Scrapper ship."
	tags = list("External")

	spawnpoints = list("tajaran_scrapper")
	max_count = 3

	outfit = /obj/outfit/admin/tajaran_scrapper
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tajaran Scrapper"
	special_role = "Tajaran Scrapper"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/tajaran_scrapper
	name = "Scrapper"

	uniform = list(
				/obj/item/clothing/under/service_overalls,
				/obj/item/clothing/under/tajaran/mechanic,
				/obj/item/clothing/under/tajaran,
				/obj/item/clothing/under/overalls
	)

	shoes = list(
				/obj/item/clothing/shoes/tajara/footwraps,
				/obj/item/clothing/shoes/jackboots/tajara,
				/obj/item/clothing/shoes/workboots/tajara,
				/obj/item/clothing/shoes/workboots/tajara/adhomian_boots
	)

	back = list(
		/obj/item/storage/backpack,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/duffel
	)

	l_ear = /obj/item/device/radio/headset/ship

	id = /obj/item/card/id

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

/obj/outfit/admin/tajaran_scrapper/get_id_access()
	return list(ACCESS_GENERIC_AWAY_SITE, ACCESS_EXTERNAL_AIRLOCKS)
