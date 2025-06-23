/datum/ghostspawner/human/saniorios_outpost_crew
	short_name = "saniorios_outpost_crew"
	name = "Sani'Orios Asteroid Outpost Crewmember"
	desc = "Crew a Democratic People's Republic of Adhomai's asteroid outpost in Sani'Orios."
	tags = list("External")
	welcome_message = "As a member of the Spacer Militia crewing an outpost in Sani'Orios you are to protect Al'mariist space and aid DPRA's ships in the area."

	spawnpoints = list("saniorios_outpost_crew")
	req_perms = null
	max_count = 3
	uses_species_whitelist = FALSE

	outfit = /obj/outfit/admin/saniorios_outpost_crew
	possible_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Sani'Orios Asteroid Outpost Crewmember"
	special_role = "Sani'Orios Asteroid Outpost Crewmember"
	extra_languages = list(LANGUAGE_SIIK_MAAS)
	respawn_flag = null

/obj/outfit/admin/saniorios_outpost_crew
	name = "Sani'Orios Asteroid Outpost Crewmember"

	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/jackboots/tajara

	uniform = /obj/item/clothing/under/tajaran/pvsm
	l_ear = /obj/item/device/radio/headset/ship

	back = /obj/item/storage/backpack/rucksack
	belt = /obj/item/storage/belt/military

	r_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/saniorios_outpost_crew/get_id_access()
	return list(ACCESS_DPRA, ACCESS_EXTERNAL_AIRLOCKS)
