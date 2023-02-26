/datum/map_template/ruin/exoplanet/adhomai_schlorrgo_cage
	name = "Adhomian Schlorrgo Testing Site "
	id = "adhomai_schlorrgo_cage"
	description = "A facility for storing and testing cybernetic schlorrgo."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list( "adhomai/adhomai_schlorrgo_cage.dmm")

/area/adhomai_schlorrgo_cage
	name = "Adhomian Schlorrgo Testing Site"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	flags = RAD_SHIELDED