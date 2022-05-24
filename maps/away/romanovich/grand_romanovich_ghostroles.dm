/datum/ghostspawner/human/grand_romanovich_host
	short_name = "casino_host"
	name = "Grand Romanovich Host"
	desc = "Be the head for the Adhomian casino, the Grand Romanovich."
	tags = list("External")

	spawnpoints = list("casino_host")
	max_count = 1

	outfit = /datum/outfit/admin/grand_romanovich_host
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Grand Romanovich Host"
	special_role = "Grand Romanovich Host"
	respawn_flag = null

	extra_languages = list(LANGUAGE_SIIK_MAAS)

/datum/outfit/admin/grand_romanovich_host
	name = "Grand Romanovich Host"

	uniform = /obj/item/clothing/under/tajaran/fancy
	shoes = /obj/item/clothing/shoes/tajara/jackboots

	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site
	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1, /obj/item/storage/bag/money/casino = 1)

/datum/outfit/admin/grand_romanovich_host/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/grand_romanovich_staff
	short_name = "casino_staff"
	name = "Grand Romanovich Staff"
	desc = "Staff the Adhomian casino, the Grand Romanovich."
	tags = list("External")

	spawnpoints = list("casino_staff")
	max_count = 4

	outfit = /datum/outfit/admin/grand_romanovich_staff
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Grand Romanovich Staff"
	special_role = "Grand Romanovich Staff"
	respawn_flag = null

/datum/outfit/admin/grand_romanovich_staff
	name = "Grand Romanovich Staff"

	uniform = /obj/item/clothing/under/tajaran

	shoes = /obj/item/clothing/shoes/tajara/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1, /obj/item/storage/bag/money/casino = 1)

/datum/outfit/admin/grand_romanovich_staff/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/grand_romanovich_guard
	short_name = "casino_guard"
	name = "Grand Romanovich Guard"
	desc = "Guard the Adhomian casino, the Grand Romanovich."
	tags = list("External")

	spawnpoints = list("casino_guard")
	max_count = 4

	outfit = /datum/outfit/admin/grand_romanovich_guard
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Grand Romanovich Guard"
	special_role = "Grand Romanovich Guard"
	respawn_flag = null

/datum/outfit/admin/grand_romanovich_guard
	name = "Grand Romanovich Guard"

	uniform = /obj/item/clothing/under/suit_jacket/checkered

	head = /obj/item/clothing/head/fedora/grey

	shoes = /obj/item/clothing/shoes/tajara/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/away_site

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1, /obj/item/storage/box/handcuffs = 1)

	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/pistol/adhomai = 1)

	belt = /obj/item/storage/belt/security
	belt_contents = list(
		/obj/item/reagent_containers/spray/pepper = 1,
		/obj/item/melee/baton/loaded = 1,
		/obj/item/grenade/chem_grenade/gas = 1,
		/obj/item/device/flash = 1,
		/obj/item/ammo_magazine/mc9mm = 2
	)

/datum/outfit/admin/grand_romanovich_guard/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/casino_patron
	short_name = "casino_patron"
	name = "Grand Romanovich Patron"
	desc = "Gamble in the Grand Romanovich."
	tags = list("External")

	spawnpoints = list("casino_patron")
	max_count = 4

	outfit = /datum/outfit/admin/random/casino_patron
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Grand Romanovich"
	special_role = "Grand Romanovich"
	respawn_flag = null

/datum/outfit/admin/random/casino_patron
	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1, /obj/item/storage/bag/money/casino = 1)
