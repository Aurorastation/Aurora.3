/datum/map_template/ruin/exoplanet/moghes_wasteland_izweski
	name = "Hegemony Wasteland Outpost"
	id = "moghes_wasteland_izweski"
	description = "An Izweski military outpost in the Wasteland"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_izweski.dmm"
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_kataphract_wasteland)
	unit_test_groups = list(3)

/area/moghes/hegemony_wasteland
	name = "Hegemony Wasteland Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	is_outside = OUTSIDE_NO
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS

/area/moghes/hegemony_wasteland/outdoors
	name = "Hegemony Wasteland Outpost"
	icon_state = "bluenew"
	is_outside = OUTSIDE_YES
	area_blurb = "An outpost of the Izweski Hegemony, standing in the Wasteland. Red-and-gold banners snap in the wind."

/datum/ghostspawner/human/moghes_hegemony_wasteland
	name = "Izweski Hegemony Soldier"
	short_name = "hegemony_wasteland_soldier"
	desc = "Man an Izweski Hegemony outpost in the Wasteland"
	welcome_message = "As an Unathi warrior, abide by the Warrior's Code - act with righteousness, mercy, integrity, courage and loyalty. Defend the life and honor of Hegemony citizens, and ensure that enemies of the Izweski cannot threaten your base."

	spawnpoints = list("hegemony_wasteland_soldier")
	max_count = 4
	possible_species = list(SPECIES_UNATHI)
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	uses_species_whitelist = FALSE
	outfit = /obj/outfit/admin/izweski
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Izweski Hegemony Soldier"
	special_role = "Izweski Hegemony Soldier"
	respawn_flag = null

/datum/ghostspawner/human/moghes_hegemony_wasteland/commander
	name = "Izweski Hegemony Outpost Commander"
	short_name = "hegemony_wasteland_commander"
	desc = "Command an Izweski Hegemony outpost in the Wasteland."
	max_count = 1
	spawnpoints = list("hegemony_wasteland_commander")
	assigned_role = "Izweski Hegemony Commander"
	special_role = "Izweski Hegemony Commander"
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/izweski/captain
