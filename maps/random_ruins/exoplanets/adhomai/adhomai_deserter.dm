/datum/map_template/ruin/exoplanet/adhomai_deserter
	name = "Liberation Army Deserter"
	id = "adhomai_deserter"
	description = "A deserter from the Adhomai Liberation Army."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_deserter.dmm")

//ghost roles

/datum/ghostspawner/human/adhomai_deserter
	short_name = "adhomai_deserter"
	name = "Liberation Army Deserter"
	desc = "Survive as a deserter from the Adhomai Liberation Army."
	tags = list("External")

	spawnpoints = list("adhomai_deserter")
	max_count = 1

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /datum/outfit/admin/adhomai_amohdan
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Liberation Army Deserter"
	special_role = "Liberation Army Deserter"
	respawn_flag = null

/datum/outfit/admin/adhomai_deserter
	name = "Liberation Army Deserter"

	uniform = /obj/item/clothing/under/tajaran/ala/wraps
	head = /obj/item/clothing/head/tajaran/ala_wraps

	shoes = /obj/item/clothing/shoes/tajara/combat
	belt = /obj/item/storage/belt/military
	belt_contents = list(
						/obj/item/gun/projectile/pistol/adhomai = 1,
						/obj/item/ammo_magazine/mc9mm = 2,
						/obj/item/grenade/frag = 1,
						/obj/item/ammo_magazine/d762 = 2
						)

	l_ear = null
	back = /obj/item/gun/projectile/dragunov
	id = null
	l_pocket = /obj/item/material/caltrops
	r_pocket = /obj/item/material/caltrops