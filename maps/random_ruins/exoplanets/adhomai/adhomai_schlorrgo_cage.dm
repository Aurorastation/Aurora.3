/datum/map_template/ruin/exoplanet/adhomai_schlorrgo_cage
	name = "Adhomian Schlorrgo Testing Site"
	id = "adhomai_schlorrgo_cage"
	description = "A facility for storing and testing cybernetic schlorrgo."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_schlorrgo_cage.dmm")

/area/adhomai_schlorrgo_cage
	name = "Adhomian Schlorrgo Testing Site"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "The sounds of animals and machines can be heard in this installation."
