/datum/map_template/ruin/exoplanet/moghes_hegemony_base
	name = "Hegemony Base"
	id = "moghes_hegemony_base"
	description = "An Izweski military base in the Untouched Lands"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_hegemony_base.dmm"

	unit_test_groups = list(2)

/area/moghes/hegemony_base
	name = "Hegemony Base"
	icon_state = "red"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	is_outside = OUTSIDE_NO
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS

/area/moghes/hegemony_base/outdoors
	name = "Hegemony Base"
	icon_state = "bluenew"
	is_outside = OUTSIDE_YES
	area_blurb = "A tall fence encircles squat concrete buildings. The red-and-gold banners of the Izweski Hegemony snap in the wind."

/datum/ghostspawner/human/moghes_hegemony_base
	name = "Izweski Hegemony Soldier"
	short_name = "hegemony_base_soldier"
	desc = "Man an Izweski Hegemony outpost in the Untouched Lands."
	welcome_message = "As an Unathi warrior, abide by the Warrior's Code - act with righteousness, mercy, integrity, courage and loyalty. Defend the life and honor of Hegemony citizens, and ensure that enemies of the Izweski cannot threaten your base."

	spawnpoints = list("hegemony_base_soldier")
	max_count = 4
	possible_species = list(SPECIES_UNATHI)
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	uses_species_whitelist = FALSE
	outfit = /obj/outfit/admin/izweski
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Izweski Hegemony Soldier"
	special_role = "Izweski Hegemony Soldier"
	respawn_flag = null

/datum/ghostspawner/human/moghes_hegemony_base/commander
	name = "Izweski Hegemony Base Commander"
	short_name = "hegemony_base_commander"
	desc = "Command an Izweski Hegemony outpost in the Untouched Lands"
	max_count = 1
	spawnpoints = list("hegemony_base_commander")
	assigned_role = "Izweski Hegemony Commander"
	special_role = "Izweski Hegemony Commander"
	uses_species_whitelist = TRUE
	outfit = /obj/outfit/admin/izweski/captain
