/datum/map_template/ruin/exoplanet/ala_base
	name = "Ala Military Outpost"
	id = "ala_base"
	description = "A military outposted manned by the Adhomai Liberation Army."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/ala_base.dmm")

/area/ala_base
	name = "ALA Military Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "A Liberation Army outpost. The smell of alcohol mixed with gunpowder welcomes you."

//ghost roles

/datum/ghostspawner/human/ala_base
	short_name = "ala_base_soldier"
	name = "Adhomai Liberation Army Soldier"
	desc = "Man the Adhomai Liberation Army outpost in Adhomai."
	tags = list("External")

	spawnpoints = list("ala_base_soldier")
	max_count = 3

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/ala_base
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomai Liberation Army Soldier"
	special_role = "Adhomai Liberation Army Soldier"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/ala_base
	name = "Adhomai Liberation Army Soldier"

	uniform = /obj/item/clothing/under/tajaran/ala
	head = /obj/item/clothing/head/beret/tajaran/dpra/alt
	back = /obj/item/storage/backpack/rucksack
	shoes = /obj/item/clothing/shoes/combat
	belt = /obj/item/storage/belt/military
	l_ear = null

	id = /obj/item/card/id
	r_pocket = /obj/item/storage/wallet/random
	l_pocket = /obj/item/device/radio

/obj/outfit/admin/ala_base/get_id_access()
	return list(ACCESS_DPRA)


/datum/ghostspawner/human/ala_base/officer
	short_name = "ala_base_officer"
	name = "Adhomai Liberation Army Officer"
	desc = "Command the forces in the Liberation Army outpost"

	spawnpoints = list("ala_base_officer")
	max_count = 1

	outfit = /obj/outfit/admin/ala_base/officer
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI)
	uses_species_whitelist = TRUE

	assigned_role = "Adhomai Liberation Army Officer"
	special_role = "Adhomai Liberation Army Officer"

/obj/outfit/admin/ala_base/officer
	name = "Adhomai Liberation Army Officer"

	uniform = /obj/item/clothing/under/tajaran/ala/black/officer
	head = /obj/item/clothing/head/tajaran/ala_officer
	back = /obj/item/storage/backpack/satchel/leather
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/silenced = 1)
