/datum/map_template/ruin/exoplanet/haneunim_mystery
	name = "Haneunim Mystery"
	id = "haneunim_mystery"
	description = "A mysterious ancient vessel."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)

	prefix = "haneunim/"
	suffix = "haneunim_mystery.dmm"

	unit_test_groups = list(1)

/area/haneunim_mystery
	name = "Ancient Vessel"
	icon_state = "bluenew"
	ambience = AMBIENCE_TECH_RUINS
