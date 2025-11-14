// Orbital Fleet Kosmostrelki - Elite crew of the PRA's Orbital Fleet spaceships.
/datum/ghostspawner/human/headmaster_kosmostrelki
	short_name = "headmaster_kosmostrelki"
	name = "Headmaster Ship Kosmostrelki"
	desc = "Crew an Orbital Fleet ship."
	tags = list("External")

	spawnpoints = list("headmaster_kosmostrelki")
	max_count = 4
	uses_species_whitelist = FALSE

	outfit = /obj/outfit/admin/headmaster_kosmostrelki
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Headmaster Kosmostrelki"
	special_role = "Headmaster Kosmostrelki"
	extra_languages = list(LANGUAGE_SIIK_MAAS)

/obj/outfit/admin/headmaster_kosmostrelki
	name = "Kosmostrelki"

	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/ship
	shoes = /obj/item/clothing/shoes/jackboots/tajara
	uniform = /obj/item/clothing/under/tajaran/cosmonaut
	accessory = /obj/item/clothing/accessory/badge/pra_passport
	mask = /obj/item/clothing/accessory/dogtags/adhomai
	gloves = /obj/item/clothing/gloves/black_leather/tajara
	back = /obj/item/storage/backpack/satchel/eng
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/clothing/accessory/badge/hadii_card = 1)

	r_pocket = /obj/item/storage/wallet/random
	l_hand = /obj/item/martial_manual/tajara

/obj/outfit/admin/headmaster_kosmostrelki/get_id_access()
	return list(ACCESS_PRA, ACCESS_EXTERNAL_AIRLOCKS)

// Kosmostrelki Captain - Orbital Fleet Captain in official and operational command of the Headmaster
/datum/ghostspawner/human/headmaster_kosmostrelki/captain
	short_name = "headmaster_captain"
	name = "Headmaster Ship Captain"
	desc = "Command an Orbital Fleet ship."
	tags = list("External")

	spawnpoints = list("headmaster_captain")
	max_count = 1
	uses_species_whitelist = TRUE

	outfit = /obj/outfit/admin/headmaster_kosmostrelki/captain
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kosmostrelki Captain"
	special_role = "Kosmostrelki Captain"

/obj/outfit/admin/headmaster_kosmostrelki/captain
	name = "Kosmostrelki Captain"

	head = /obj/item/clothing/head/tajaran/orbital_captain
	uniform = /obj/item/clothing/under/tajaran/cosmonaut/captain
	back = /obj/item/storage/backpack/satchel/leather

	l_pocket = /obj/item/clothing/wrists/watch/pocketwatch/adhomai

// Party Commissar - High-ranking party commissar attached to the Kosmostrelki unit and ship to ensure the loyalty of the crew.
/datum/ghostspawner/human/headmaster_kosmostrelki/commissar
	short_name = "headmaster_commissar"
	name = "Headmaster Party Commissar"
	desc = "Ensure that the Kosmostrelki follow the principles of Hadiism."

	max_count = 1
	spawnpoints = list("headmaster_commissar")

	assigned_role = "Party Commissar"
	special_role = "Party Commissar"
	uses_species_whitelist = TRUE

	outfit = /obj/outfit/admin/headmaster_kosmostrelki/commissar
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

/obj/outfit/admin/headmaster_kosmostrelki/commissar

	name = "Party Commissar"

	uniform = /obj/item/clothing/under/tajaran/cosmonaut/commissar
	accessory = /obj/item/clothing/accessory/hadii_pin
	head = /obj/item/clothing/head/tajaran/cosmonaut_commissar
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(/obj/item/storage/box/hadii_manifesto = 1,
						/obj/item/storage/box/hadii_card = 1,
						/obj/item/clothing/accessory/badge/hadii_card/member = 1,
						/obj/item/clothing/accessory/badge/pra_passport = 1,
						)
	l_pocket = /obj/item/clothing/wrists/watch/pocketwatch/adhomai
