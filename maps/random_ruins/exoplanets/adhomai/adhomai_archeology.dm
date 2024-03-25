/datum/map_template/ruin/exoplanet/adhomai_archeology
	name = "Adhomian Archeology Camp"
	id = "adhomai_archeology"
	description = "A camp setup by Tajaran archeologists searching for clues of their planet's past."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list( "adhomai/adhomai_archeology.dmm")

/area/adhomai_archeology
	name = "Adhomian Archeology Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "Digging equipment is scattered around the camp. Royalist flags hang from the tents."

//ghost roles

/datum/ghostspawner/human/adhomai_archeology
	short_name = "adhomai_archeology"
	name = "Adhomian Archeologist"
	desc = "Do some archeological work in Adhomai as part of a New Kingdom of Adhomai expedition."
	tags = list("External")

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	spawnpoints = list("adhomai_archeology")
	max_count = 4

	outfit = /obj/outfit/admin/adhomai_archeology
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomian Archeologist"
	special_role = "Adhomian Archeologist"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/adhomai_archeology
	name = "Adhomian Archeologist"

	uniform = /obj/item/clothing/under/tajaran/archeologist
	suit = /obj/item/clothing/suit/storage/tajaran/archeologist
	head = /obj/item/clothing/head/tajaran/archeologist
	shoes = /obj/item/clothing/shoes/workboots/tajara/adhomian_boots
	back = /obj/item/storage/backpack/satchel/leather
	belt = /obj/item/melee/whip
	accessory = /obj/item/clothing/accessory/holster/waist/brown
	accessory_contents = list(/obj/item/gun/projectile/revolver/adhomian)
	l_ear = null

	id = null
	backpack_contents = list(/obj/item/storage/wallet/random = 1)
