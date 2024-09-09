/datum/map_template/ruin/exoplanet/raskara_okon
	name = "Okon 001"
	id = "raskara_okon"
	description = "A People's Republic observation outpost on the Moon."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)

	prefix = "raskara/"
	suffix = "raskara_okon.dmm"

	unit_test_groups = list(1)

/area/raskara_okon
	name = "Okon 001"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren/raskara
	area_flags = AREA_FLAG_RAD_SHIELDED
	ambience = AMBIENCE_EXPOUTPOST

/area/raskara_okon/observatory
	name = "Okon 001 Observatory"
	icon_state = "bridge"

/area/raskara_okon/mess_hall
	name = "Okon 001 Mess Hall"
	icon_state = "lounge"

/area/raskara_okon/barracks
	name = "Okon 001 Barracks"
	icon_state = "crew_quarters"

/area/raskara_okon/mining
	name = "Okon 001 Mining"
	icon_state = "mining"

/area/raskara_okon/entry
	name = "Okon 001 Entry"
	icon_state = "exit"

/area/raskara_okon/eva
	name = "Okon 001 EVA Storage"
	icon_state = "eva"

/area/raskara_okon/engineer
	name = "Okon 001 Engineer"
	icon_state = "outpost_engine"

/area/raskara_okon/laboratory
	name = "Okon 001 Laboratory"
	icon_state = "anolab"

/area/raskara_okon/medbay
	name = "Okon 001 Medbay"
	icon_state = "medbay"

//ghost roles

/datum/ghostspawner/human/okon_crew
	short_name = "okon_crew"
	name = "Okon Crewmember"
	desc = "Man the Okon 001 observation outpost on Raskara."
	tags = list("External")

	spawnpoints = list("okon_crew")
	max_count = 5

	outfit = /obj/outfit/admin/okon_crew
	possible_species = list(SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Okon Crewmember"
	special_role = "Okon Crewmember"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/okon_crew
	name = "Okon Crewmember"

	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/jackboots/tajara

	uniform = /obj/item/clothing/under/tajaran/database_freighter
	l_ear = null
	back = /obj/item/storage/backpack/duffel/eng

	accessory = /obj/item/clothing/accessory/badge/hadii_card
	r_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/okon_crew/get_id_access()
	return list(ACCESS_PRA, ACCESS_EXTERNAL_AIRLOCKS)
