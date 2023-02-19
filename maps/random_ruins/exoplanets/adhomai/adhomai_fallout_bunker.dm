/datum/map_template/ruin/exoplanet/adhomai_fallout_bunker
	name = "Adhomian Fallout Bunker"
	id = "adhomai_fallout_bunker"
	description = "A fallout bunker built by the People's Republic of Adhomai after the armistice."
	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_fallout_bunker.dmm")

/area/adhomai_fallout_bunker
	name = "Fallout Bunker"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	flags = RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC