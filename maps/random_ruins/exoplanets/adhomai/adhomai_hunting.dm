/datum/map_template/ruin/exoplanet/adhomai_hunting
	name = "Adhomai Hunting Lodge"
	id = "adhomai_hunting"
	description = "A lodge housing some Tajaran hunters."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_hunting.dmm")

/area/adhomai_hunting
	name = "Adhomai Hunting Lodge"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "Multiple huntings trophies decorate this place. The lodge smells of fresh meat and blood."

//ghost roles

/datum/ghostspawner/human/adhomai_hunter
	short_name = "adhomai_hunter"
	name = "Adhomian Hunter"
	desc = "Hunt the wild creatures of Adhomai."
	tags = list("External")

	spawnpoints = list("adhomai_hunter")
	max_count = 2

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/adhomai_hunter
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomian Hunter"
	special_role = "Adhomian Hunter"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/adhomai_hunter
	name = "Adhomian Hunter"

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

	back = list(
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/rucksack/tan
	)

	l_ear = null

	suit = /obj/item/clothing/suit/storage/tajaran/hunting
	id = null
	suit_store = /obj/item/gun/projectile/shotgun/pump/rifle/scope
	backpack_contents = list(/obj/item/storage/wallet/random = 1)

/datum/ghostspawner/human/matake_hunter
	short_name = "matake_hunter"
	name = "Mata'ke Priest-Hunter"
	desc = "Hunt the wild creatures of Adhomai in the name of Mata'ke."
	tags = list("External")

	spawnpoints = list("matake_hunter")
	max_count = 1

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/matake_hunter
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Mata'ke Priest-Hunter"
	special_role = "Mata'ke Priest-Hunter"
	respawn_flag = null

	uses_species_whitelist = TRUE

/obj/outfit/admin/matake_hunter
	name = "Mata'ke Priest-Hunter"

	uniform = /obj/item/clothing/under/tajaran/matake

	shoes = /obj/item/clothing/shoes/tajara/footwraps
	suit = /obj/item/clothing/suit/storage/tajaran/matake
	head = /obj/item/clothing/head/tajaran/matake

	l_ear = null

	l_hand = list(/obj/item/material/twohanded/spear/silver,
				/obj/item/material/twohanded/pike/silver,
				/obj/item/material/knife/bayonet/silver,
				/obj/item/material/knife/trench/silver,
				/obj/item/material/sword/sabre/silver
				)
	id = null
	back = /obj/item/gun/projectile/shotgun/pump/rifle/scope
	l_pocket = list(/obj/item/storage/wallet/random = 1)
