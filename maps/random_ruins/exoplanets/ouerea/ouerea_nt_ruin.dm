/datum/map_template/ruin/exoplanet/ouerea_nt_ruin
	name = "Abandoned NanoTrasen Facility"
	id = "ouerea_nt_ruin"
	description = "A NanoTrasen base, left abandoned."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffixes = list("ouerea_nt_ruin.dmm")
	unit_test_groups = list(3)

/area/ouerea_nt_ruin
	name = "NanoTrasen Facility"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "This facility seems to be long-since abandoned - signs of rust and neglect cover everything. Banners displaying NanoTrasen logos hang limp and tattered."

/obj/item/paper/nt_ouerea
	name = "Research Director's Log"
	info = "I fucking hate this place. The other day, one of my scientists somehow managed to wind up, in the process of a standard dissection, cutting his own fucking arm off. \
	I thought NanoTrasen was supposed to hire the best and brightest of the Spur? At least I have you, Special Reserve..."
