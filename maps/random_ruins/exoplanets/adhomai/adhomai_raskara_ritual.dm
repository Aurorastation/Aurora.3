/datum/map_template/ruin/exoplanet/adhomai_raskara_ritual
	name = "Adhomian Raskariim Ritual Site"
	id = "adhomai_raskara_ritual"
	description = "The site of a Raskariim Ritual."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)

	prefix = "adhomai/"
	suffix = "adhomai_raskara_ritual.dmm"

	unit_test_groups = list(1)

/area/adhomai_raskara_ritual
	name = "Adhomian Wilderness"
	icon_state = "bluenew"
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	ambience = AMBIENCE_OTHERWORLDLY
	area_blurb = "The ambience here feels eerie. It's too quiet."
