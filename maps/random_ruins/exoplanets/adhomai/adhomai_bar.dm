/datum/map_template/ruin/exoplanet/adhomai_bar
	name = "Adhomian Inn"
	id = "adhomai_bar"
	description = "An Adhomian inn. Rest, drink and eat."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_bar.dmm")

/area/adhomai_bar
	name = "Adhomian Inn"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "A typical Adhomian inn. The scent of alcohol and cigarette smoke as well as the warmth welcomes you."

//ghost roles

/datum/ghostspawner/human/adhomai_bar_innkeeper
	short_name = "adhomai_bar_innkeeper"
	name = "Adhomian Innkeeper"
	desc = "Staff the Adhomian bar."
	tags = list("External")

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	spawnpoints = list("adhomai_bar_innkeeper")
	max_count = 1

	outfit = /obj/outfit/admin/adhomai_bar_innkeeper
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomian Innkeeper"
	special_role = "Adhomian Innkeeper"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/adhomai_bar_innkeeper
	name = "Adhomian Innkeeper"

	uniform = /obj/item/clothing/under/sl_suit
	head = /obj/item/clothing/head/flatcap
	shoes = /obj/item/clothing/shoes/workboots/tajara/adhomian_boots
	back = /obj/item/storage/backpack/satchel/leather
	suit = /obj/item/clothing/suit/storage/hooded/tajaran/maroon
	l_pocket = /obj/item/pocketwatch/adhomai
	l_ear = null

	id = null
	backpack_contents = list(/obj/item/storage/wallet/random = 1)

/datum/ghostspawner/human/adhomai_bar_server
	short_name = "adhomai_bar_server"
	name = "Adhomian Inn Staff"
	desc = "Serve the Adhomian bar patrons."
	tags = list("External")

	spawnpoints = list("adhomai_bar_server")
	max_count = 2

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	outfit = /obj/outfit/admin/adhomai_bar_server
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomian Inn Staff"
	special_role = "Adhomian Inn Staff"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/adhomai_bar_server
	name = "Adhomian Inn Staff"

	uniform = /obj/item/clothing/under/sl_suit
	shoes = /obj/item/clothing/shoes/workboots/tajara/adhomian_boots
	back = /obj/item/storage/backpack/satchel/leather
	accessory = /obj/item/clothing/accessory/wcoat
	l_ear = null

	id = null
	backpack_contents = list(/obj/item/storage/wallet/random = 1)

/datum/ghostspawner/human/adhomai_bar_patron
	short_name = "adhomai_bar_patron"
	name = "Adhomian Patron"
	desc = "Drink, eat, and gamble at the Adhomian inn."
	tags = list("External")

	extra_languages = list(LANGUAGE_SIIK_MAAS)
	spawnpoints = list("adhomai_bar_patron")
	max_count = 4

	outfit = /obj/outfit/admin/adhomai_bar_patron
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Adhomian Patron"
	special_role = "Adhomian Patron"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/adhomai_bar_patron
	name = "Adhomian Patron"

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
