/datum/map_template/ruin/exoplanet/moghes_wasteland_dorviza
	name = "Dorviza Clan Outpost"
	id = "moghes_wasteland_dorviza"
	description = "An outpost of the Clan Dorviza"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffixes = list("moghes_wasteland_dorviza.dmm")
	unit_test_groups = list(2)

/area/moghes_dorviza
	name = "Clan Dorviza Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "An alien chirping can be heard here. Between the tents, tendrils of biomass wind and grow."

/area/moghes_dorviza/tent
	name = "Clan Dorviza Camp"
	icon_state = "red"
	is_outside = OUTSIDE_NO
	area_blurb = "The carpets laid on the ground are choked with sand. Outside, the wind can be heard whipping through the wastes, ruffling the tent's cloth."

/datum/ghostspawner/human/moghes_dorviza
	name = "Dorviza Clan Traveler"
	short_name = "moghes_dorviza"
	desc = "Survive the Wasteland as a member of the Clan Dorviza, known as the Dryads due to their affiliation for herbalsm and medicine."
	tags = list("External")
	mob_name_suffix = " Dorviza"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are a member of the Clan Dorviza, one of the Oasis Clans of the Wasteland. Survive beside your clanmates both Unathi and Diona, in the hopes of seeing the Wasteland bloom again."

	max_count = 3
	spawnpoints = list("moghes_dorviza")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_dorviza
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Dorviza Clan Traveler"
	special_role = "Dorviza Clan Traveler"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/moghes_dorviza/diona
	name = "Dorviza Clan Diona"
	short_name = "moghes_dorviza_diona"
	mob_name_suffix = null
	mob_name_pick_message = null
	welcome_message = "You are a diona gestalt associated with a wandering group of the Clan Dorviza, one of the Oasis Clans of the Wasteland. Survive alongside your Unathi clanmates, in the hopes of seeing the Wasteland bloom again."

	max_count = 1
	spawnpoints = list("moghes_dorviza_diona")

	extra_languages = list(LANGUAGE_ROOTSONG)
	outfit = /obj/outfit/admin/moghes_dorviza/diona
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = TRUE

/obj/outfit/admin/moghes_dorviza
	uniform = list(/obj/item/clothing/under/unathi, /obj/item/clothing/under/unathi/himation)
	suit = list(/obj/item/clothing/suit/unathi/robe, /obj/item/clothing/suit/unathi/robe/kilt)
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	shoes = /obj/item/clothing/shoes/sandals/caligae
	l_ear = null
	id = null
	back = /obj/item/storage/backpack/satchel/leather

/obj/outfit/admin/moghes_dorviza/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42330f", "#DBC684")
	if(H?.wear_suit)
		H.wear_suit.color = pick("#42330f", "#DBC684")

/obj/outfit/admin/moghes_dorviza/diona
	uniform = /obj/item/clothing/under/gearharness
	suit = /obj/item/clothing/accessory/poncho/green
	shoes = null
	glasses = null
