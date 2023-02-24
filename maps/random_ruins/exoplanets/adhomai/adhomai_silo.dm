/datum/map_template/ruin/exoplanet/adhomai_silo
	name = "Adhomian Missile Silo"
	id = "adhomai_silo"
	description = "A heavily guarded Hadiist missile silo."
	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_silo.dmm")

/area/adhomai_silo
	name = "Adhomian Missile Silo"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	flags = RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC