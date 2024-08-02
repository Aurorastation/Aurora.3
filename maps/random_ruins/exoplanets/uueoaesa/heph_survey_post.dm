/datum/map_template/ruin/exoplanet/heph_survey_post
	name = "Hephaestus Survey Post"
	id = "heph_survey_post"
	description = "A long-abandoned Hephaestus survey outpost."
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffix = "heph_survey_post.dmm"
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED

	unit_test_groups = list(1)

/area/heph_survey_post
	name = "Hephaestus Survey Post"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/plating
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	ambience = AMBIENCE_EXPOUTPOST
