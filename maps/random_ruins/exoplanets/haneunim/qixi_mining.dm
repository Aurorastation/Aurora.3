/datum/map_template/ruin/exoplanet/qixi_mining
	name = "Qixi Mining"
	id = "qixi_mining"
	description = "A long-abandoned Hephaestus mining outpost."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_HANEUNIM)
	suffixes = list("haneunim/qixi_mining.dmm")

/area/qixi_mining
	name = "Qixi Mining Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	area_flags = AREA_FLAG_RAD_SHIELDED
