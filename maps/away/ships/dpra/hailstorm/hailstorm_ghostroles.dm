/datum/ghostspawner/human/hailstorm_crew
	short_name = "hailstorm_crew"
	name = "Hailstorm Ship Crew"
	desc = "Crew a People's Volunteer Spacer Militia ship."
	tags = list("External")

	spawnpoints = list("hailstorm_crew")
	max_count = 4
	uses_species_whitelist = FALSE

	outfit = /obj/outfit/admin/hailstorm_crew
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	respawn_flag = null

	assigned_role = "Hailstorm Ship Crew"
	special_role = "Hailstorm Ship Crew"
	extra_languages = list(LANGUAGE_SIIK_MAAS)


/obj/outfit/admin/hailstorm_crew
	name = "People's Volunteer Spacer Militia Crew"

	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/ship
	mask = /obj/item/clothing/accessory/dogtags/adhomai
	shoes = /obj/item/clothing/shoes/jackboots/tajara

	uniform = /obj/item/clothing/under/tajaran/pvsm
	head = /obj/item/clothing/head/beret/tajaran/pvsm
	back = /obj/item/storage/backpack/rucksack
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/field_ration/dpra = 1, /obj/item/clothing/accessory/badge/dpra_passport = 1)

	r_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/hailstorm_crew/get_id_access()
	return list(ACCESS_DPRA, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/hailstorm_crew/captain
	short_name = "hailstorm_captain"
	name = "Hailstorm Ship Captain"
	desc = "Command a People's Volunteer Spacer Militia ship."
	tags = list("External")

	spawnpoints = list("hailstorm_captain")
	max_count = 1

	outfit = /obj/outfit/admin/hailstorm_crew/captain
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

	assigned_role = "Hailstorm Ship Captain"
	special_role = "Hailstorm Ship Captain"
	extra_languages = list(LANGUAGE_SIIK_MAAS)

/obj/outfit/admin/hailstorm_crew/captain
	name = "People's Volunteer Spacer Militia Captain"

	uniform = /obj/item/clothing/under/tajaran/pvsm/captain
	head = /obj/item/clothing/head/beret/tajaran/pvsm
	back = /obj/item/storage/backpack/satchel/leather

/datum/ghostspawner/human/hailstorm_crew/advisor
	short_name = "hailstorm_advisor"
	name = "Hailstorm ALA Advisor"
	desc = "Help train and guide the crew of the Hailstorm as an advisor from the Adhomai Liberation Army."
	tags = list("External")

	spawnpoints = list("hailstorm_advisor")
	max_count = 1
	uses_species_whitelist = TRUE

	outfit = /obj/outfit/admin/hailstorm_crew/advisor
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI)

	assigned_role = "Hailstorm Ship ALA Advisor"
	special_role = "Hailstorm Ship ALA Advisor"
	extra_languages = list(LANGUAGE_SIIK_MAAS)

/obj/outfit/admin/hailstorm_crew/advisor
	name = "People's Volunteer Spacer Militia ALA Advisor"

	uniform = /obj/item/clothing/under/tajaran/ala/black/officer
	accessory = /obj/item/clothing/accessory/dpra_badge
	head = /obj/item/clothing/head/tajaran/ala_officer
	back = /obj/item/storage/backpack/satchel/leather

	l_pocket = /obj/item/clothing/wrists/watch/pocketwatch/adhomai
