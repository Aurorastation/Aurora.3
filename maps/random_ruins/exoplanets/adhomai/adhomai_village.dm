/datum/map_template/ruin/exoplanet/adhomai_village
	name = "Adhomai Hunting Lodge"
	id = "adhomai_hunting"
	description = "A tiny Tajara village somewhere in Adhomai."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_SRANDMARR)
	suffix = "adhomai/adhomai_village.dmm"

/area/adhomai_village
	name = "Adhomian Village"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	flags = RAD_SHIELDED

//ghost roles

/datum/ghostspawner/human/adhomai_village
	short_name = "adhomai_village."
	name = "Adhomian Hunter"
	desc = "Hunt the wild creatures of Adhomai."
	tags = list("External")

	spawnpoints = list("adhomai_village")
	max_count = 4

	outfit = /datum/outfit/admin/adhomai_village
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomian Villager"
	special_role = "Adhomian Villager"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/outfit/admin/adhomai_village
	name = "Adhomian Villager"

	uniform = list(
				/obj/item/clothing/under/tajaran,
				/obj/item/clothing/under/tajaran/summer,
				/obj/item/clothing/under/pants/tajaran
	)

	shoes = list(
				/obj/item/clothing/shoes/tajara/footwraps,
				/obj/item/clothing/shoes/tajara/jackboots,
				/obj/item/clothing/shoes/tajara/workboots,
				/obj/item/clothing/shoes/tajara/workboots/adhomian_boots
	)

	back = list(
		/obj/item/storage/backpack/satchel/leather
	)

	l_ear = null

	id = null
	backpack_contents = list(/obj/item/storage/wallet/random = 1)