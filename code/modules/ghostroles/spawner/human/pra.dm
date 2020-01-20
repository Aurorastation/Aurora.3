/datum/ghostspawner/human/pra_cosmonaut
	short_name = "pra_cosmonaut"
	name = "Kosmostrelki"
	desc = "Protect the People's Republic of Adhomai's possessions on space."
	tags = list("External")

	enabled = FALSE
	spawnpoints = list("pra_cosmonaut")
	req_perms = null
	max_count = 3
	uses_species_whitelist = FALSE

	outfit = /datum/outfit/admin/pra_cosmonaut
	possible_species = list("Tajara", "M'sai Tajara", "Zhan-Khazan Tajara")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kosmostrelki"
	special_role = "Kosmostrelki"
	respawn_flag = null
	extra_languages = list(LANGUAGE_SIIK_MAAS)
	uses_species_whitelist = FALSE
	away_site = TRUE

/datum/ghostspawner/human/pra_cosmonaut/commissar
	short_name = "pra_commissar"
	name = "Kosmostrelki Party Commissar"
	desc = "Protect the People's Republic of Adhomai's possessions on space, and ensure that the Kosmostrelki follow the principles of Hadiism."

	max_count = 1

	assigned_role = "Party Commissar"
	special_role = "Party Commissar"

	outfit = /datum/outfit/admin/pra_cosmonaut/commissar
	possible_species = list("Tajara", "M'sai Tajara")
	req_species_whitelist = "Tajara"

/datum/outfit/admin/pra_cosmonaut
	name = "Kosmostrelki"

	uniform = /obj/item/clothing/under/tajaran/cosmonaut
	shoes = /obj/item/clothing/shoes/jackboots/toeless
	belt = /obj/item/storage/belt/military
	back = /obj/item/gun/projectile/shotgun/pump/rifle
	id = /obj/item/card/id/syndicate
	accessory = /obj/item/clothing/accessory/badge/hadii_card
	belt_contents = list(
						/obj/item/ammo_magazine/boltaction = 3,
						/obj/item/grenade/smokebomb = 2,
						/obj/item/plastique = 1,
						/obj/item/gun/projectile/pistol/adhomai = 1
						)
	r_hand = /obj/item/storage/field_ration

/datum/outfit/admin/pra_cosmonaut/commissar
	name = "Party Commissar"

	uniform = /obj/item/clothing/under/tajaran/cosmonaut/commissar
	head = /obj/item/clothing/head/tajaran/cosmonaut_commissar
	accessory = /obj/item/clothing/accessory/hadii_pin
	belt = /obj/item/gun/projectile/deagle/adhomai
	belt_contents = null
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(
						/obj/item/ammo_magazine/a50 = 2,
						/obj/item/material/knife/trench = 1,
						/obj/item/storage/box/hadii_manifesto = 1,
						/obj/item/storage/box/hadii_card = 1
						)
	l_hand = /obj/item/device/megaphone
	r_hand = null
