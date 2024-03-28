/datum/map_template/ruin/exoplanet/adhomai_silo
	name = "Adhomian Missile Silo"
	id = "adhomai_silo"
	description = "A heavily guarded Hadiist missile silo."
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_silo.dmm")

/area/adhomai_silo
	name = "Adhomian Missile Silo"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC
	area_blurb = "The closed doors on the ground ominously point to the sky."

//ghost roles

/datum/ghostspawner/human/silo_guard
	short_name = "silo_guard"
	name = "Hadiist Missile Silo Guard"
	desc = "Guard the Hadiist missile silo."
	tags = list("External")

	spawnpoints = list("silo_guard")
	max_count = 1

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/silo_guard
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hadiist Missile Silo Guard"
	special_role = "Hadiist Missile Silo Guard"
	respawn_flag = null

	uses_species_whitelist = FALSE


/obj/outfit/admin/silo_guard
	name = "People's Republic of Adhomai Silo Guard"

	uniform = /obj/item/clothing/under/tajaran/pra_uniform
	head = /obj/item/clothing/head/beret/tajaran/pra
	suit = /obj/item/clothing/suit/storage/tajaran/pra_jacket/armored
	back = /obj/item/gun/projectile/automatic/rifle/adhomian
	shoes = /obj/item/clothing/shoes/combat
	belt = /obj/item/storage/belt/military
	accessory = /obj/item/clothing/accessory/badge/hadii_card
	l_ear = null

	belt_contents = list(
						/obj/item/gun/projectile/pistol/adhomai = 1,
						/obj/item/ammo_magazine/mc9mm = 2,
						/obj/item/ammo_magazine/boltaction = 3,
						/obj/item/melee/baton/stunrod = 1,
						/obj/item/handcuffs = 1
						)

	id = /obj/item/card/id
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/device/radio

/obj/outfit/admin/silo_guard/get_id_access()
	return list(ACCESS_PRA)
