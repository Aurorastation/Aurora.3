/datum/map_template/ruin/exoplanet/adhomai_amohdan
	name = "Amohdan Swordsman"
	id = "adhomai_amohdan"
	description = "An Amohdan swordsman waiting for a challenge."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_amohdan.dmm")

//ghost roles

/datum/ghostspawner/human/adhomai_amohdan
	short_name = "adhomai_amohdan"
	name = "Amohdan Swordsman"
	desc = "Wander the land in search of a proper challenge as an Amohdan Swordsman. Live and die by the sword."
	tags = list("External")

	spawnpoints = list("adhomai_amohdan")
	max_count = 1

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /datum/outfit/admin/adhomai_amohdan
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Amohdan Swordsman"
	special_role = "Amohdan Swordsman"
	respawn_flag = null

/datum/outfit/admin/adhomai_amohdan
	name = "Amohdan Swordsman"

	uniform = /obj/item/clothing/under/pants/tajaran
	head = /obj/item/clothing/head/helmet/amohda
	suit = /obj/item/clothing/suit/armor/amohda
	shoes = /obj/item/clothing/shoes/tajara/combat
	belt = /obj/item/material/sword/amohdan_sword
	accessory = /obj/item/clothing/accessory/storage/bayonet

	l_ear = null

	id = null
	l_pocket = /obj/item/material/knife/butterfly/switchblade
	r_pocket = /obj/item/material/caltrops