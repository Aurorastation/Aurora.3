/datum/ghostspawner/human/headmaster_kosmostrelki
	short_name = "headmaster_kosmostrelki"
	name = "Headmaster Ship Kosmostrelki"
	desc = "Crew an Orbital Fleet ship."
	tags = list("External")

	spawnpoints = list("headmaster_kosmostrelki")
	max_count = 4
	uses_species_whitelist = FALSE

	outfit = /datum/outfit/admin/headmaster_kosmostrelki
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Headmaster Kosmostrelki"
	special_role = "Headmaster Kosmostrelki"
	extra_languages = list(LANGUAGE_SIIK_MAAS)

/datum/outfit/admin/headmaster_kosmostrelki
	name = "Kosmostrelki"

	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/tajara/jackboots

	uniform = /obj/item/clothing/under/tajaran/cosmonaut
	l_ear = /obj/item/device/radio/headset/ship

	belt = /obj/item/storage/belt/military

	accessory = /obj/item/clothing/accessory/badge/hadii_card
	r_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/headmaster_kosmostrelki/get_id_access()
	return list(access_pra, access_external_airlocks)

/datum/ghostspawner/human/headmaster_kosmostrelki/captain
	short_name = "headmaster_captain"
	name = "Headmaster Ship Captain"
	desc = "Command an Orbital Fleet ship."
	tags = list("External")

	spawnpoints = list("headmaster_captain")
	max_count = 1
	uses_species_whitelist = TRUE

	outfit = /datum/outfit/admin/headmaster_kosmostrelki/captain
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kosmostrelki Captain"
	special_role = "Kosmostrelki Captain"

/datum/outfit/admin/headmaster_kosmostrelki/captain
	name = "Kosmostrelki Captain"

	head = /obj/item/clothing/head/tajaran/orbital_captain
	uniform = /obj/item/clothing/under/tajaran/cosmonaut/captain
	belt = /obj/item/storage/belt/military
	belt_contents = list(
						/obj/item/ammo_magazine/mc9mm = 1,
						/obj/item/gun/projectile/pistol/adhomai = 1
						)


/datum/ghostspawner/human/headmaster_kosmostrelki/commissar
	short_name = "headmaster_commissar"
	name = "Headmaster Party Commissar"
	desc = "Ensure that the Kosmostrelki follow the principles of Hadiism."

	max_count = 1
	spawnpoints = list("headmaster_commissar")

	assigned_role = "Party Commissar"
	special_role = "Party Commissar"
	uses_species_whitelist = TRUE

	outfit = /datum/outfit/admin/headmaster_kosmostrelki/commissar
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

/datum/outfit/admin/headmaster_kosmostrelki/commissar

	name = "Party Commissar"

	uniform = /obj/item/clothing/under/tajaran/cosmonaut/commissar
	head = /obj/item/clothing/head/tajaran/cosmonaut_commissar
	accessory = /obj/item/clothing/accessory/hadii_pin
	belt = /obj/item/gun/projectile/deagle/adhomai
	belt_contents = null
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
						/obj/item/ammo_magazine/a50 = 2,
						/obj/item/material/knife/trench = 1,
						/obj/item/storage/box/hadii_manifesto = 1,
						/obj/item/storage/box/hadii_card = 1
						)
	l_hand = /obj/item/device/megaphone
