/datum/map_template/ruin/exoplanet/moghes_wasteland_vihnmes
	name = "Vihnmes Wasteland Inn"

	id = "moghes_wasteland_ozeuoi"
	description = "An outpost of the Clan Ozeuoi."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffixes = list("moghes_wasteland_vihnmes.dmm")
	unit_test_groups = list(1)

/area/moghes_vihnmes
	name = "Clan Vihnmes Waystation"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	is_outside = OUTSIDE_NO
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The sound of music and the warmth of a fire fill this place - an oasis of rest in the danger of the Wasteland."

/datum/ghostspawner/human/moghes_vihnmes
	name = "Vihmes Clan Inn Staff"
	short_name = "moghes_vihnmes"
	desc = "Operate an inn in the Wasteland."
	tags = list("External")
	mob_name_suffix = " Vihnmes"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are an Unathi of the Clan Vihmes, one of the Oasis Clans of the Wasteland. Operate a safe haven in the harsh Wasteland, and defend yourself against foes."

	max_count = 3
	spawnpoints = list("moghes_vihnmes")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_vihnmes
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Vihmes Clan Inn Staff"
	special_role = "Vihmes Clan Inn Staff"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/moghes_vihmes_patron
	name = "Wasteland Inn Patron"
	short_name = "moghes_vihnmes_patron"
	desc = "Visit an inn on Moghes"
	tags = list ("External")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	max_count = 4
	spawnpoints = list("moghes_vihnmes_patron")
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/moghes_vihnmes_patron

	assigned_role = "Vihnmes Patron"
	special_role = "Vihnmes Patron"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/moghes_vihnmes
	name = "Vihnmes Clan Member"
	uniform = /obj/item/clothing/under/unathi
	shoes = /obj/item/clothing/shoes/sandals/caligae
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	suit = list(
		/obj/item/clothing/accessory/poncho/unathimantle,
		/obj/item/clothing/accessory/poncho/unathimantle/mountain
	)
	l_ear = null
	id = null

/obj/outfit/admin/vihnmes/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = pick("#473b13", "#134718", "#0a6959")
	if(H.wear_suit)
		H.wear_suit.color = "#423509"
	if(H.shoes)
		H.shoes.color = "#423509"

/obj/outfit/admin/moghes_vihnmes_patron
	name = "Moghes Bar Patron"
	uniform = list(
		/obj/item/clothing/under/unathi,
		/obj/item/clothing/under/unathi/himation,
		/obj/item/clothing/under/unathi/zazali
	)
	shoes = list(
		/obj/item/clothing/shoes/sandals,
		/obj/item/clothing/shoes/sandals/caligae,
		/obj/item/clothing/shoes/footwraps
	)
	back = /obj/item/storage/backpack/satchel/leather
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	r_pocket = /obj/item/reagent_containers/food/drinks/waterbottle
	l_pocket = /obj/item/storage/wallet/random
	suit = list(
		/obj/item/clothing/accessory/poncho/unathimantle,
		/obj/item/clothing/accessory/poncho/unathimantle/mountain
	)
	l_ear = null
	id = null

/obj/outfit/admin/moghes_vihnmes_patron/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H?.w_uniform)
		H.w_uniform.color = pick("#42330f", "#DBC684")
	if(H.wear_suit)
		H.wear_suit.color = "#423509"
	if(H.shoes)
		H.shoes.color = "#423509"
