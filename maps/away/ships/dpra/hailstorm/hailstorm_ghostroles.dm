/datum/ghostspawner/human/hailstorm_crew
	short_name = "hailstorm_crew"
	name = "Hailstorm Ship Crew"
	desc = "Crew a People's Volunteer Spacer Militia ship."
	tags = list("External")

	spawnpoints = list("hailstorm_crew")
	max_count = 3
	uses_species_whitelist = FALSE

	outfit = /datum/outfit/admin/hailstorm_crew
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Hailstorm Ship Crew"
	special_role = "Hailstorm Ship Crew"
	extra_languages = list(LANGUAGE_SIIK_MAAS)


/datum/outfit/admin/hailstorm_crew
	name = "People's Volunteer Spacer Militia Crew"

	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/tajara/jackboots

	uniform = /obj/item/clothing/under/tajaran/pvsm
	l_ear = /obj/item/device/radio/headset/ship

	back = /obj/item/storage/backpack/rucksack
	belt = /obj/item/storage/belt/military

	r_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/hailstorm_crew/get_id_access()
	return list(access_dpra, access_external_airlocks)

/datum/ghostspawner/human/hailstorm_crew/captain
	short_name = "hailstorm_captain"
	name = "Hailstorm Ship Captain"
	desc = "Command a People's Volunteer Spacer Militia ship."
	tags = list("External")

	spawnpoints = list("hailstorm_captain")
	max_count = 1

	outfit = /datum/outfit/admin/hailstorm_crew/captain
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

	assigned_role = "Hailstorm Ship Captain"
	special_role = "Hailstorm Ship Captain"
	extra_languages = list(LANGUAGE_SIIK_MAAS)

/datum/outfit/admin/hailstorm_crew/captain
	name = "People's Volunteer Spacer Militia Captain"

	head = /obj/item/clothing/head/beret/tajaran/pvsm

	uniform = /obj/item/clothing/under/tajaran/pvsm/captain
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/silenced = 1)

/datum/ghostspawner/human/hailstorm_crew/advisor
	short_name = "hailstorm_advisor"
	name = "Hailstorm ALA Advisor"
	desc = "Help train and guide the crew of the Hailstorm as an advisor from the Adhomai Liberation Army."
	tags = list("External")

	spawnpoints = list("hailstorm_advisor")
	max_count = 1
	uses_species_whitelist = TRUE

	outfit = /datum/outfit/admin/hailstorm_crew/advisor
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

	assigned_role = "Hailstorm Ship ALA Advisor"
	special_role = "Hailstorm Ship ALA Advisor"
	extra_languages = list(LANGUAGE_SIIK_MAAS)

/datum/outfit/admin/hailstorm_crew/advisor
	name = "People's Volunteer Spacer Militia ALA Advisor"

	head = /obj/item/clothing/head/tajaran/ala_officer

	uniform = /obj/item/clothing/under/tajaran/ala/black/officer
	accessory = /obj/item/clothing/accessory/storage/bandolier
	accessory_contents = list(/obj/item/ammo_casing/shotgun = 5,
							/obj/item/ammo_casing/shotgun/pellet = 5)

	belt = /obj/item/gun/projectile/shotgun/foldable
	backpack_contents = list(/obj/item/gun/projectile/silenced = 1)