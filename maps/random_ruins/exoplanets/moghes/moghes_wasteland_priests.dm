/datum/map_template/ruin/exoplanet/moghes_wasteland_priests
	name = "Sk'akh Outpost"
	id = "moghes_wasteland_priests"
	description = "A Sk'akh outpost in the Wasteland, tending to the wounded as best they can."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_priests.dmm"
	unit_test_groups = list(2)

/area/moghes_wasteland_priests
	name = "Moghes - Sk'akh Wasteland Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "A repurposed ruin, built of stone and scrap. The smell of blood and filth fills the air, and the occasional hums and beeps of some machinery can be made out. This is a place of desperation, home to the dead and dying."

/datum/ghostspawner/human/moghes_wasteland_priest
	name = "Sk'akh Priestess of the Healer"
	short_name = "moghes_wasteland_priest"
	desc = "Manage an underequipped medical outpost in the Wasteland. Tend to the injured, as best you can. Only women are permitted to be priests of the Healer."
	tags = list("External")
	welcome_message = "You are a Priestess of the Healer, attempting to aid those suffering in the Wasteland. You run a small medical outpost, though you are underequipped and frequenly endangered. Do your duty as best you can, and keep your outpost intact."
	max_count = 2
	spawnpoints = list("moghes_wasteland_priest")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_wasteland_guard
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Priestess of the Healer"
	special_role = "Priestess of the Healer"
	respawn_flag = null


/datum/ghostspawner/human/moghes_wasteland_priest/guard
	name = "Sk'akh Wasteland Guard"
	short_name = "moghes_wasteland_guard"
	desc = "Protect a Sk'akh Church medical station in the Wasteland. Keep the priestesses and patients alive."
	welcome_message = "You are a warrior, guarding a Sk'akh Church medical station in the Wasteland - whether out of religious devotion or simple pragmatism. Do the best that you can to keep the priestesses alive and the outpost intact."
	uses_species_whitelist = FALSE
	max_count = 2
	spawnpoints = list("moghes_wasteland_guard")

	assigned_role = "Guard"
	special_role = "Guard"
	respawn_flag = null

/obj/outfit/admin/moghes_wasteland_priest
	name = "Sk'akh Priestess of the Healer"
	uniform = /obj/item/clothing/under/unathi/skakh/healer
	shoes = /obj/item/clothing/shoes/sandals/caligae/socks
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	gloves = /obj/item/clothing/gloves/latex/unathi
	belt = /obj/item/storage/belt/medical
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/reagent_containers/food/drinks/waterbottle
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	l_ear = null

/obj/outfit/admin/moghes_wasteland_guard
	uniform = list(
		/obj/item/clothing/under/unathi,
		/obj/item/clothing/under/unathi/himation,
		/obj/item/clothing/under/unathi/zazali
	)
	accessory = /obj/item/clothing/accessory/holster/hip
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
