/datum/map_template/ruin/exoplanet/moghes_bar
	name = "Moghes Inn"
	id = "moghes_bar"
	description = "An inn for the weary traveler, located in the Untouched Lands of Moghes"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_bar.dmm"
	ban_ruins = list("ouerea_bar")

	unit_test_groups = list(3)

/area/moghes_bar
	name = "Moghes Bar"
	icon_state = "bar"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	is_outside = OUTSIDE_NO
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The sound of music and the warmth of a fire fill this place."

/datum/ghostspawner/human/moghes_bar_innkeeper
	name = "Moghresian Innkeeper"
	short_name = "moghes_bar_innkeeper"
	desc = "Operate an inn on Moghes"
	tags = list("External")
	welcome_message = "You are the proprietor of an inn on Moghes. Serve drinks and food, rent your rooms, and make a profit."

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	max_count = 1
	spawnpoints = list("moghes_bar_innkeeper")
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/moghes_bar_innkeeper

	assigned_role = "Moghresian Innkeeper"
	special_role = "Moghresian Innkeeper"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/moghes_bar_innkeeper
	name = "Moghes Innkeeper"
	uniform = /obj/item/clothing/under/unathi
	suit = /obj/item/clothing/suit/unathi/robe/robe_coat/blue
	shoes = /obj/item/clothing/shoes/sandals
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	l_ear = null
	id = /obj/item/card/id

/obj/outfit/admin/moghes_bar_inkeeper/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = pick("#473b13", "#134718", "#0a6959")
	if(H.shoes)
		H.shoes.color = "#423509"

/datum/ghostspawner/human/moghes_bar_server
	name = "Moghresian Inn Server"
	short_name = "moghes_bar_server"
	desc = "Work at an inn on Moghes"
	tags = list ("External")
	welcome_message = "You are an employee of an inn on Moghes. Ensure that your patrons enjoy themselves, and that the inn makes a profit."

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	spawnpoints = list("moghes_bar_server")
	max_count = 2
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/moghes_bar_server

	assigned_role = "Moghresian Inn Staff"
	special_role = "Moghresian Inn Staff"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/moghes_bar_server
	name = "Moghes Server"
	uniform = /obj/item/clothing/under/unathi
	shoes = /obj/item/clothing/shoes/sandals
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	suit = list(
		/obj/item/clothing/accessory/poncho/unathimantle,
		/obj/item/clothing/accessory/poncho/unathimantle/mountain
	)
	l_ear = null
	id = /obj/item/card/id

/obj/outfit/admin/moghes_bar_server/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = pick("#473b13", "#134718", "#0a6959")
	if(H.wear_suit)
		H.wear_suit.color = "#423509"
	if(H.shoes)
		H.shoes.color = "#423509"

/datum/ghostspawner/human/moghes_bar_patron
	name = "Moghresian Inn Patron"
	short_name = "moghes_bar_patron"
	desc = "Visit an inn on Moghes"
	tags = list ("External")
	welcome_message = "You are a visitor to the local inn, whether for food, drink, or board. Relax and enjoy yourself!"

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	max_count = 4
	spawnpoints = list("moghes_bar_patron")
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/moghes_bar_patron

	assigned_role = "Moghresian Patron"
	special_role = "Moghresian Patron"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/moghes_bar_patron
	name = "Moghes Bar Patron"
	uniform = list(
		/obj/item/clothing/under/unathi,
		/obj/item/clothing/under/unathi/himation,
		/obj/item/clothing/under/unathi/huytai,
		/obj/item/clothing/under/unathi/mogazali,
		/obj/item/clothing/under/unathi/zazali,
		/obj/item/clothing/under/unathi/zozo
	)
	shoes = list(
		/obj/item/clothing/shoes/sandals,
		/obj/item/clothing/shoes/sandals/caligae,
		/obj/item/clothing/shoes/footwraps
	)
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	suit = list(
		/obj/item/clothing/accessory/poncho/unathimantle,
		/obj/item/clothing/accessory/poncho/unathimantle/mountain,
		/obj/item/clothing/accessory/poncho/unathimantle/hephaestus,
		/obj/item/clothing/accessory/poncho/unathimantle/fisher
	)
	l_ear = null
	id = null

/obj/outfit/admin/moghes_bar_patron/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = pick("#473b13", "#134718", "#0a6959", "#d2d9d8", "#262928")
	if(H.wear_suit)
		H.wear_suit.color = "#423509"
	if(H.shoes)
		H.shoes.color = "#423509"
