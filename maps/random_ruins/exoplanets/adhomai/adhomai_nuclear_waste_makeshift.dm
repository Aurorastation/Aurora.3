/datum/map_template/ruin/exoplanet/adhomai_nuclear_waste_makeshift
	name = "Makeshift Radioactive Waste Disposal Site"
	id = "adhomai_nuclear_waste_makeshift"
	description = "A site used by the DPRA to store radioactive waste."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_nuclear_waste_makeshift.dmm")

/area/adhomai_nuclear_waste_makeshift
	name = "Makeshift Radioactive Waste Disposal Site"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	area_blurb = "This area is devoid of any life. Only your steps can be heard here."
