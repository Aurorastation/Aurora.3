/datum/map_template/ruin/exoplanet/psis_outpost
	name = "PSIS Outpost"
	id = "psis_outpost"
	description = "An advanced outpost of the People's Republic of Adhomai's intelligence service."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/psis_outpost.dmm")

/area/psis_outpost
	name = "PSIS Military Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	flags = RAD_SHIELDED

//ghost roles

/datum/ghostspawner/human/psis_outpost
	short_name = "psis_outpost"
	name = "People's Strategic Intelligence Service Agent"
	desc = "Man the People's Strategic Intelligence Service's outpost."
	tags = list("External")

	spawnpoints = list("psis_outpost")
	max_count = 3

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /datum/outfit/admin/psis_outpost
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "People's Strategic Intelligence Service Agent"
	special_role = "People's Strategic Intelligence Service Agent"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/outfit/admin/psis_outpost
	name = "People's Strategic Intelligence Service Agent"

	uniform = /obj/item/clothing/under/tajaran/psis
	head = /obj/item/clothing/head/tajaran/psis
	back = /obj/item/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/tajara/combat
	belt = /obj/item/storage/belt/military
	accessory = /obj/item/clothing/accessory/hadii_pin
	belt_contents = list(
						/obj/item/ammo_magazine/mc9mm = 4,
						/obj/item/gun/projectile/pistol/adhomai = 1,
						/obj/item/material/knife/trench = 1,
						/obj/item/melee/telebaton = 1,
						/obj/item/handcuffs = 2
						)

	l_ear = null

	id = /obj/item/card/id
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/device/radio

/datum/outfit/admin/psis_outpost/get_id_access()
	return list(access_pra)