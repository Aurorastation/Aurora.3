/datum/map_template/ruin/exoplanet/biesel_camp_site
	name = "Biesel Camp Site"
	id = "biesel_camp_site"
	description = "A camp site set up by some locals. Seems like they're not here right now?"

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_TAU_CETI)

	prefix = "biesel/"
	suffix = "biesel_camp_site.dmm"

	unit_test_groups = list(3)

/area/biesel_camp_site
	name = "Biesel Camp Site"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE

	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg')
	base_turf = /turf/simulated/mineral
	area_flags = AREA_FLAG_HIDE_FROM_HOLOMAP | AREA_FLAG_INDESTRUCTIBLE_TURFS

