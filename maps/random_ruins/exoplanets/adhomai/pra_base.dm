/datum/map_template/ruin/exoplanet/pra_base
	name = "PRA Military Outpost"
	id = "pra_base"
	description = "A military outposted manned by the Grand People's Army."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/pra_base.dmm")

/area/pra_base
	name = "PRA Military Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "A Hadiist Army outpost. The People's Republic of Adhomai's anthem is blared from the speakers."

//ghost roles

/datum/ghostspawner/human/pra_base
	short_name = "pra_base_soldier"
	name = "Grand People's Army Soldier"
	desc = "Man the People's Republic outpost in Adhomai."
	tags = list("External")

	spawnpoints = list("pra_base_soldier")
	max_count = 3

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/pra_base
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Grand People's Army Soldier"
	special_role = "Grand People's Army Soldier"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/pra_base
	name = "People's Republic of Adhomai Soldier"

	uniform = /obj/item/clothing/under/tajaran/pra_uniform
	head = /obj/item/clothing/head/beret/tajaran/pra
	suit = /obj/item/clothing/suit/storage/tajaran/pra_jacket/armored
	back = /obj/item/storage/backpack/rucksack/green
	shoes = /obj/item/clothing/shoes/combat
	belt = /obj/item/storage/belt/military
	accessory = /obj/item/clothing/accessory/badge/hadii_card
	l_ear = null

	id = /obj/item/card/id
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/device/radio

/obj/outfit/admin/pra_base/get_id_access()
	return list(ACCESS_PRA)

/datum/ghostspawner/human/pra_base/commissar
	short_name = "pra_base_commissar"
	name = "Grand People's Army Commissar"
	desc = "Ensure that the forces in the People's Republic outpost follows the principles of Hadiism."

	spawnpoints = list("pra_base_commissar")
	max_count = 1

	outfit = /obj/outfit/admin/pra_base/commissar
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI)
	uses_species_whitelist = TRUE

	assigned_role = "Grand People's Army Commissar"
	special_role = "Grand People's Army Commissar"

/obj/outfit/admin/pra_base/commissar
	name = "Grand People's Army Commissar"

	uniform = /obj/item/clothing/under/tajaran/army_commissar
	head = /obj/item/clothing/head/tajaran/army_commissar
	suit = null
	belt = /obj/item/gun/projectile/deagle/adhomai
	belt_contents = null
	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list(
						/obj/item/ammo_magazine/a50 = 2,
						/obj/item/material/knife/trench = 1,
						/obj/item/clothing/accessory/badge/hadii_card/member = 1,
						/obj/item/storage/box/hadii_manifesto = 1,
						/obj/item/storage/box/hadii_card = 1
						)
	l_hand = /obj/item/device/megaphone

	accessory = /obj/item/clothing/accessory/hadii_pin
