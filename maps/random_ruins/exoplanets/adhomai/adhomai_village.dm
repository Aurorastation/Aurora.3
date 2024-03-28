/datum/map_template/ruin/exoplanet/adhomai_village
	name = "Adhomian Village"
	id = "adhomai_village"
	description = "A tiny Tajara village somewhere in Adhomai."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_village.dmm")

/area/adhomai_village
	name = "Adhomian Village"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "A cozy Tajaran village. The heat and smell of food emanating from the houses may be a relief from the cold wilderness."

//ghost roles

/datum/ghostspawner/human/adhomai_village
	short_name = "adhomai_village"
	name = "Adhomian Villager"
	desc = "Live your life in a tiny Adhomian village."
	tags = list("External")

	spawnpoints = list("adhomai_village")
	max_count = 4

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/adhomai_village
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomian Villager"
	special_role = "Adhomian Villager"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/adhomai_village
	name = "Adhomian Villager"

	uniform = list(
				/obj/item/clothing/under/tajaran,
				/obj/item/clothing/under/tajaran/summer,
				/obj/item/clothing/under/pants/tajaran
	)

	shoes = list(
				/obj/item/clothing/shoes/tajara/footwraps,
				/obj/item/clothing/shoes/jackboots/tajara,
				/obj/item/clothing/shoes/workboots/tajara,
				/obj/item/clothing/shoes/workboots/tajara/adhomian_boots
	)

	back = /obj/item/storage/backpack/satchel/leather

	l_ear = null

	id = null
	backpack_contents = list(/obj/item/storage/wallet/random = 1)
