/datum/map_template/ruin/exoplanet/moghes_queendom
	name = "Queendom Patrol"
	description = "A group of Unathi from the Queendom of Szek'Hakh."
	id = "moghes_queendom"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_queendom.dmm"
	unit_test_groups = list(3)

/area/moghes_queendom
	name = "Queendom Patrol Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	is_outside = OUTSIDE_NO
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS

/datum/ghostspawner/human/moghes_queendom
	name = "Szek'Hakh Queendom Warrior"
	short_name = "moghes_queendom"
	desc = "Patrol the Wasteland for threats and supplies, in the name of the Queen Szek'Hakh."
	tags = list("External")
	welcome_message = "You are a warrior of the Queendom of Szek'Hakh, sworn to defend it against the harsh Wasteland. Warriors of the Queendom are always women, as there are too few men left after the Contact War to risk."

	max_count = 3
	spawnpoints = list("moghes_queendom")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_queendom
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Szek'Hakh Warrior"
	special_role = "Szek'Hakh Warrior"
	respawn_flag = null

/datum/ghostspawner/human/moghes_queendom/lead
	name = "Szek'Hakh Queendom Patrol Leader"
	short_name = "moghes_queendom_lead"
	desc = "Lead your warriors through the Wasteland to recover supplies and eliminate threats, in the name of the Queen Szek'Hakh"
	max_count = 1
	outfit = /obj/outfit/admin/moghes_queendom/lead
	uses_species_whitelist = TRUE

/obj/outfit/admin/moghes_queendom
	name = "Szek'Hakh Queendom Warrior"

	uniform = list(
		/obj/item/clothing/under/unathi,
		/obj/item/clothing/under/unathi/himation,
		/obj/item/clothing/under/unathi/zazali
	)
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/pistol/spitter = 1)
	shoes = /obj/item/clothing/shoes/sandals/caligae
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/reagent_containers/food/drinks/waterbottle
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	suit = list(
		/obj/item/clothing/accessory/poncho/unathimantle,
		/obj/item/clothing/accessory/poncho/unathimantle/mountain,
		/obj/item/clothing/suit/unathi/robe/beige,
		/obj/item/clothing/suit/unathi/robe/kilt
	)
	l_ear = null
	id = null

/obj/outfit/admin/moghes_queendom/lead
	name = "Szek'Hakh Queendom Leader"
	belt = /obj/item/melee/energy/sword/hegemony
