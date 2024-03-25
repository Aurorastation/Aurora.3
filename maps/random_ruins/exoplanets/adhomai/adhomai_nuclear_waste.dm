/datum/map_template/ruin/exoplanet/adhomai_nuclear_waste
	name = "Radioactive Waste Disposal Site"
	id = "adhomai_nuclear_waste"
	description = "A site used by the PRA to store radioactive waste."

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_SRANDMARR)
	suffixes = list("adhomai/adhomai_nuclear_waste.dmm")

/area/adhomai_nuclear_waste
	name = "Radioactive Waste Disposal Site"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/mineral/adhomai
	area_flags = AREA_FLAG_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC
	area_blurb = "Countless warnings are stamped on the walls in multiple language, amounting to \"This place is not a place of honor. No highly esteemed deed is commemorated here. Nothing valued is here.\""
