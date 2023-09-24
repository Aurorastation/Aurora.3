/datum/ghostspawner/human/kazhkz_privateer
	short_name = "kazhkz_privateer"
	name = "House Kazhkz Privateer"
	desc = "You are a privateer of the Dominian Great House Kazhkz - sent into the Badlands to pillage and harass the enemies of the Empire and the Kazhkz-Han'san. Vessels of the Serene Republic of Elyra, the Coalition of Colonies, and the Izweski Hegemony are particularly prized targets by the Kazhkz. NOT AN ANTAGONIST! Do not act as such."
	tags = list("External")
	mob_name_suffix = " Kazhkz"
	mob_name_pick_message = "Pick an Unathi first name."
	spawnpoints = list("kazhkz_privateer")
	max_count = 4

	outfit = /datum/outfit/admin/kazhkz_privateer
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kazhkz Privateer"
	special_role = "Kazhkz Privateer"
	respawn_flag = null
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	uses_species_whitelist = FALSE
	welcome_message = "You are a privateer of the Kazhkz Fleet - a plausibly deniable weapon of the Empire of Dominia, sent to scourge the Emperor's enemies in the Sparring Sea and Badlands. Though the two empires are not enemies, the Kazhkz bear a particular enemy for the Izweski Hegemony, and will often attack their vessels. The Unathi in Dominia wiki page may have some useful information for roleplaying a Kazhkz privateer."

/datum/outfit/admin/kazhkz_privateer
	name = "Kazhkz Privateer"
	uniform = /obj/item/clothing/under/unathi
	suit = /obj/item/clothing/accessory/poncho/dominia_cape/kazhkz
	belt = /obj/item/melee/energy/sword/pirate
	shoes = /obj/item/clothing/shoes/sandals/caligae
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/box/donkpockets = 1,
		/obj/item/device/versebook/tribunal = 1,
		/obj/item/shield/energy/dominia = 1
	)

/datum/outfit/admin/kazhkz_privateer/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/uniform_colour = pick("#540e06", "#ab7318", "#302d26")
	if(H?.w_uniform)
		H.w_uniform.color = uniform_colour

/datum/outfit/admin/kazhkz_privateer/get_id_access()
	return list(access_imperial_fleet_voidsman_ship, access_external_airlocks)

/datum/ghostspawner/human/kazhkz_privateer/captain
	short_name = "kazhkz_privateer_captain"
	name = "House Kazhkz Privateer Captain"
	desc = "You are a captain of the Dominian Great House Kazhkz - placed in command of a vessel and sent into the Badlands to pillage and harass the enemies of the Empire and the Kazhkz-Han'san. Vessels of the Serene Republic of Elyra, the Coalition of Colonies, and the Izweski Hegemony are particularly prized targets by the Kazhkz. NOT AN ANTAGONIST! Do not act as such."
	tags = list("External")
	mob_name_suffix = " Kazhkz"
	mob_name_pick_message = "Pick an Unathi first name."
	spawnpoints = list("kazhkz_privateer_captain")
	max_count = 1
	assigned_role = "Kazhkz Privateer Captain"
	special_role = "Kazhkz Privateer Captain"
	uses_species_whitelist = TRUE
	outfit = /datum/outfit/admin/kazhkz_privateer/captain

/datum/outfit/admin/kazhkz_privateer/captain
	name = "Kazhkz Privateer Captain"
	uniform = /obj/item/clothing/under/dominia/imperial_suit/kazhkz

/datum/outfit/admin/kazhkz_privateer/captain/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
