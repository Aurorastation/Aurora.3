/datum/ghostspawner/human/tajara_mining_jack
	short_name = "mining_jack."
	name = "Tajaran Miner"
	desc = "Crew the Tajaran Mining Jack."
	tags = list("External")

	spawnpoints = list("tajara_mining_jack")
	max_count = 3

	outfit = /datum/outfit/admin/tajara_mining_jack
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tajaran Miner"
	special_role = "Tajaran Miner"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/tajara_mining_jack
	name = "Tajaran Miner"

	uniform = list(
				/obj/item/clothing/under/serviceoveralls,
				/obj/item/clothing/under/tajaran/mechanic,
				/obj/item/clothing/under/tajaran,
				/obj/item/clothing/under/overalls
	)

	shoes = list(
				/obj/item/clothing/shoes/tajara/footwraps,
				/obj/item/clothing/shoes/tajara/jackboots,
				/obj/item/clothing/shoes/tajara/workboots,
				/obj/item/clothing/shoes/tajara/workboots/adhomian_boots
	)

	back = list(
		/obj/item/storage/backpack/industrial,
		/obj/item/storage/backpack/rucksack/tan,
		/obj/item/storage/backpack/satchel/eng,
		/obj/item/storage/backpack/duffel/eng,
		/obj/item/storage/backpack/messenger/engi
	)

	l_ear = /obj/item/device/radio/headset/ship

	id = /obj/item/card/id

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

/datum/outfit/admin/tajara_mining_jack/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)