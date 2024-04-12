/datum/map_template/ruin/exoplanet/haneunim_mining
	name = "Haneunim Mining"
	id = "haneunim_mining"
	description = "A long-abandoned Hephaestus mining outpost."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("haneunim/haneunim_mining.dmm")

/area/haneunim_mining
	name = "Haneunim Mining Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_INDESTRUCTIBLE_TURFS
