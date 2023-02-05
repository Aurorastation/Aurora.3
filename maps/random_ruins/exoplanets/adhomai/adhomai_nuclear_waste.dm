/datum/map_template/ruin/exoplanet/adhomai_nuclear_waste
	name = "Radioactive Waste Disposal Site"
	id = "adhomai_nuclear_waste"
	description = "A site used by the PRA to store radioactive waste."

	spawn_weight = 1
	spawn_cost = 1
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_nuclear_waste.dmm")

/area/adhomai_nuclear_waste
	name = "Radioactive Waste Disposal Site"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	flags = RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC