/datum/map_template/ruin/exoplanet/ouerea_bar
	name = "Ouerea Inn"
	id = "ouerea_bar"
	description = "An inn for the weary traveler, located on the planet Ouerea"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_bar.dmm"
	unit_test_groups = list(1)

/area/ouerea_bar
	name = "Ouerea Bar"
	icon_state = "bar"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The sound of music and the warmth of a fire fill this place."

/datum/ghostspawner/human/ouerea_bar_innkeeper
	name = "Ouerean Innkeeper"
	short_name = "ouerea_bar_innkeeper"
	desc = "Operate an inn on Ouerea"
	tags = list("External")
	welcome_message = "You are the proprietor of an inn on Ouerea. Serve drinks and food, rent your rooms, and make a profit."

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	max_count = 1
	spawnpoints = list("ouerea_bar_innkeeper")
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/moghes_bar_innkeeper

	assigned_role = "Ouerean Innkeeper"
	special_role = "Ouerean Innkeeper"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/ouerea_bar_server
	name = "Ouerean Inn Server"
	short_name = "ouerea_bar_server"
	desc = "Work at an inn on Ouerea"
	tags = list ("External")
	welcome_message = "You are an employee of an inn on Ouerea. Ensure that your patrons enjoy themselves, and that the inn makes a profit."

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	spawnpoints = list("ouerea_bar_server")
	max_count = 2
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/moghes_bar_server

	assigned_role = "Ouerean Inn Staff"
	special_role = "Ouerean Inn Staff"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/ouerea_bar_patron
	name = "Ouerean Inn Patron"
	short_name = "ouerea_bar_patron"
	desc = "Visit an inn on Ouerea"
	tags = list ("External")
	welcome_message = "You are a visitor to the local inn, whether for food, drink, or board. Relax and enjoy yourself!"

	extra_languages = list(LANGUAGE_UNATHI)
	max_count = 5
	spawnpoints = list("ouerea_bar_patron")
	possible_species = list(SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/moghes_bar_patron
	species_outfits = list(
		SPECIES_UNATHI = /obj/outfit/admin/moghes_bar_patron,
		SPECIES_SKRELL = /obj/outfit/admin/ouerea_skrell,
		SPECIES_SKRELL_AXIORI = /obj/outfit/admin/ouerea_skrell,
		SPECIES_HUMAN = /obj/outfit/admin/ouerea_human
	)

	assigned_role = "Ouerean Inn Patron"
	special_role = "Ouerean Inn Patron"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/ouerea_human
	name = "Ouerean Human"
	uniform = list(/obj/item/clothing/under/dressshirt/silversun/random, /obj/item/clothing/under/dressshirt, /obj/item/clothing/under/dressshirt/tshirt, /obj/item/clothing/under/dressshirt/longsleeve)
	pants = list(/obj/item/clothing/pants/tan, /obj/item/clothing/pants/jeans, /obj/item/clothing/pants/shorts/black, /obj/item/clothing/pants/shorts/jeans)
	suit = list(/obj/item/clothing/suit/storage/toggle/track, /obj/item/clothing/suit/storage/toggle/asymmetriccoat/izharshan, /obj/item/clothing/accessory/poncho/unathimantle, /obj/item/clothing/suit/storage/toggle/corp/heph)
	shoes = list(/obj/item/clothing/shoes/sandals/caligae, /obj/item/clothing/shoes/sandals, /obj/item/clothing/shoes/workboots, /obj/item/clothing/shoes/jackboots)
	head = list(/obj/item/clothing/head/unathi, /obj/item/clothing/head/cowboy, /obj/item/clothing/head/cowboy/wide, /obj/item/clothing/head/bandana/colorable/random)
	back = /obj/item/storage/backpack/satchel/leather
	l_pocket = /obj/item/storage/wallet/random
	l_ear = null
	id = null

/obj/outfit/admin/ouerea_skrell
	name = "Ouerean Skrell"
	uniform = list(/obj/item/clothing/under/dressshirt/tshirt/skrell/maelstrom, /obj/item/clothing/under/dressshirt/tshirt/skrell/nebula, /obj/item/clothing/under/dressshirt/tshirt/skrell/reef)
	pants = list(/obj/item/clothing/pants/tan, /obj/item/clothing/pants/jeans, /obj/item/clothing/pants/shorts/black, /obj/item/clothing/pants/shorts/jeans)
	shoes = list(/obj/item/clothing/shoes/sandals/caligae, /obj/item/clothing/shoes/sandals, /obj/item/clothing/shoes/workboots, /obj/item/clothing/shoes/jackboots)
	back = /obj/item/storage/backpack/satchel/leather
	l_pocket = /obj/item/storage/wallet/random
	l_ear = null
	id = null
