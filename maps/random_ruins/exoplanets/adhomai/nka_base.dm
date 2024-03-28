/datum/map_template/ruin/exoplanet/nka_base
	name = "NKA Military Outpost"
	id = "nka_base"
	description = "A military outposted manned by the New Kingdom Royal Army."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/nka_base.dmm")

/area/nka_base
	name = "NKA Military Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "A Royal Army outpost. The installations appear to be precarious."

//ghostroles

//ghost roles

/datum/ghostspawner/human/nka_base
	short_name = "nka_base_soldier"
	name = "Imperial Adhomian Army Soldier"
	desc = "Man the New Kingdom outpost in Adhomai."
	tags = list("External")

	spawnpoints = list("nka_base_soldier")
	max_count = 3

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/nka_base
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Imperial Adhomian Army Soldier"
	special_role = "Imperial Adhomian Army Soldier"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/nka_base
	name = "Imperial Adhomian Army Soldier"

	uniform = /obj/item/clothing/under/tajaran/nka_uniform
	head = /obj/item/clothing/head/tajaran/nka_cap
	back = /obj/item/storage/backpack/rucksack/tan
	shoes = /obj/item/clothing/shoes/combat
	belt = /obj/item/storage/belt/military
	l_ear = null

	id = /obj/item/card/id
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/device/radio

/obj/outfit/admin/nka_base/get_id_access()
	return list(ACCESS_NKA)

/datum/ghostspawner/human/nka_base/commander
	short_name = "nka_base_commander"
	name = "Imperial Adhomian Army Officer"
	desc = "Command the forces in the New Kingdom outpost."

	spawnpoints = list("nka_base_commander")
	max_count = 1

	outfit = /obj/outfit/admin/nka_base/commander
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI)
	uses_species_whitelist = TRUE

	assigned_role = "Imperial Adhomian Army Officer"
	special_role = "Imperial Adhomian Army Officer"

/obj/outfit/admin/nka_base/commander
	name = "Imperial Adhomian Army Officer"

	uniform = /obj/item/clothing/under/tajaran/nka_uniform/commander
	head = /obj/item/clothing/head/tajaran/nka_cap/commander
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/material/sword/sabre
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/revolver/adhomian = 1)
