/datum/map_template/ruin/exoplanet/adhomai_raskariim_hideout
	name = "Adhomian Raskariim Hideout"
	id = "adhomai_raskariim_hideout"
	description = "An abandoned house used by Raskariim cultists."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_raskariim_hideout.dmm")

/area/adhomai_raskariim_hideout
	name = "Abandoned House"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	turf_initializer = new /datum/turf_initializer/maintenance/raskariim()
	ambience = AMBIENCE_GHOSTLY
	area_blurb = "You feel watched as you enter this old house."

/datum/turf_initializer/maintenance/raskariim/initialize(var/turf/simulated/T)
	..()
	if(prob(2) && istype(T, /turf/simulated/floor))
		var/turf/simulated/floor/F = T
		F.break_tile()

//ghost roles

/datum/ghostspawner/human/raskariim_hideout
	short_name = "raskariim_hideout"
	name = "Raskariim"
	desc = "Worship Raskara and live the cultist life in an abandoned house as your hideout."
	tags = list("External")

	spawnpoints = list("raskariim_hideout")
	max_count = 3

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/raskariim_hideout
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Raskariim"
	special_role = "Raskariim"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/raskariim_hideout
	name = "Raskariim"

	uniform = list(
				/obj/item/clothing/under/tajaran,
				/obj/item/clothing/under/tajaran/summer,
				/obj/item/clothing/under/pants/tajaran,
				/obj/item/clothing/under/pants,
				/obj/item/clothing/under/pants/track
	)

	suit = list(
				/obj/item/clothing/suit/storage/toggle/bomber,
				/obj/item/clothing/suit/storage/toggle/leather_jacket/flight,
				/obj/item/clothing/suit/storage/leathercoat,
				/obj/item/clothing/suit/storage/toggle/trench,
				/obj/item/clothing/suit/storage/toggle/trench/grey,
				/obj/item/clothing/suit/storage/toggle/track)

	shoes = list(
				/obj/item/clothing/shoes/tajara/footwraps,
				/obj/item/clothing/shoes/jackboots/tajara,
				/obj/item/clothing/shoes/workboots/tajara,
				/obj/item/clothing/shoes/workboots/tajara/adhomian_boots
	)

	back = /obj/item/storage/backpack/satchel/leather
	accessory = /obj/item/clothing/accessory/tajaran/charm/raskariim
	l_ear = null

	id = null
	backpack_contents = list(
						/obj/item/storage/wallet/random = 1,
						/obj/item/material/knife/raskariim = 1,
						/obj/item/clothing/suit/storage/tajaran/raskara = 1,
						/obj/item/clothing/head/tajaran/raskara = 1
						)
