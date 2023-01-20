/datum/map_template/ruin/exoplanet/ala_base
	name = "Ala Military Outpost"
	id = "ala_base"
	description = "A military outposted manned by the Adhomai Liberation Army."

	spawn_weight = 1
	spawn_cost = 2
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/ala_base.dmm")

/area/ala_base
	name = "ALA Military Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	flags = RAD_SHIELDED