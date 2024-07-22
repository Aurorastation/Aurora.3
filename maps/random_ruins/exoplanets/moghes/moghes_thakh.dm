/datum/map_template/ruin/exoplanet/moghes_thakh
	name = "Th'akh Shrine"
	id = "moghes_thakh"
	description = "A Th'akh shrine in the Untouched Lands"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_thakh.dmm"

	unit_test_groups = list(2)

/area/moghes_thakh
	name = "Moghes - Th'akh Shrine"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "A small building stands at the heart of this place, engraved with symbols in honor of countless spirits. The gentle sound of a river can be heard."

/datum/ghostspawner/human/moghes_thakh
	name = "Th'akh Shrine Keeper"
	short_name = "moghes_thakh"
	desc = "Tend to your shrine and learn from the shaman in the hopes of preserving the old ways of the Unathi people.."
	tags = list("External")
	welcome_message = "You are a shaman's student. Help them tend to the shrine, and learn from them as they mediate between this world and the world of spirits."

	max_count = 2
	spawnpoints = list("moghes_thakh")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_thakh
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Th'akh Shrine Keeper"
	special_role = "Th'akh Shrine Keeper"
	respawn_flag = null

/datum/ghostspawner/human/moghes_thakh/shaman
	name = "Th'akh Shaman"
	short_name = "moghes_thakh_shaman"
	desc = "Tend to your shrine, instruct your foolish pupils, and keep the balance between the mortal world and the spirit world."
	welcome_message = "You are a Th'akh shaman, sworn by ancient ceremony to mediate between mortal and spirit worlds. Speak with the faithful, offer guidance to them, and seek to further your own understanding of the spirits."

	max_count = 1
	spawnpoints = list("moghes_thakh_shaman")
	outfit = /obj/outfit/admin/moghes_thakh/shaman
	uses_species_whitelist = TRUE

	assigned_role = "Th'akh Shaman"
	special_role = "Th'akh Shaman"
	respawn_flag = null

/datum/ghostspawner/human/moghes_thakh_worshipper
	name = "Th'akh Pilgrim"
	short_name = "moghes_thakh_faithful"
	desc = "Go on pilgrimage to a shrine in the Untouched Lands."
	welcome_message = "You are an Unathi follower of the Th'akh faith, visiting a shrine and the wise shaman who oversees it."
	tags = list("External")

	max_count = 3
	spawnpoints = list("moghes_thakh_faithful")
	outfit = /obj/outfit/admin/unathi_village
	uses_species_whitelist = FALSE

	assigned_role = "Th'akh Pilgrim"
	special_role = "Th'akh Pilgrim"
	respawn_flag = null

/obj/outfit/admin/moghes_thakh
	uniform = list(/obj/item/clothing/under/unathi, /obj/item/clothing/under/unathi/himation)
	shoes = list(
		/obj/item/clothing/shoes/sandals,
		/obj/item/clothing/shoes/sandals/caligae,
		/obj/item/clothing/shoes/footwraps
	)
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
	suit = list(
		/obj/item/clothing/accessory/poncho/unathimantle,
		/obj/item/clothing/accessory/poncho/unathimantle/mountain
	)
	l_ear = null
	id = null

/obj/outfit/admin/moghes_thakh/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.wear_suit)
		H.wear_suit.color = "#423509"
	if(H.shoes)
		H.shoes.color = "#423509"

/obj/outfit/admin/moghes_thakh/shaman
	uniform = /obj/item/clothing/under/unathi/himation
	suit = /obj/item/clothing/accessory/poncho/maxtlatl
	head = /obj/item/clothing/head/unathi/maxtlatl
	wrist = /obj/item/clothing/wrists/unathi/maxtlatl
	belt = /obj/item/nullrod/athame
