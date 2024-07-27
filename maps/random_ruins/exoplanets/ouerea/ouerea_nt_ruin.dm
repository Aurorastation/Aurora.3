/datum/map_template/ruin/exoplanet/ouerea_nt_ruin
	name = "Abandoned NanoTrasen Facility"
	id = "ouerea_nt_ruin"
	description = "A NanoTrasen base, left abandoned."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_nt_ruin.dmm"
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

/obj/item/research_slip/nt_ouerea
	desc = "A small slip of plastic with an embedded chip. It is commonly used to store small amounts of research data. This one appears worn down from age. Why did they leave this behind?"
	origin_tech = list(TECH_BLUESPACE = 6, TECH_MAGNET = 3, TECH_ARCANE = 1)
