/datum/gear/belt
	display_name = "belt"
	path = /obj/item/storage/belt/generic
	slot = slot_belt
	sort_category = "Belts"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/belt/fannypack
	display_name = "fannypack"
	cost = 2
	path = /obj/item/storage/belt/fannypack/recolorable

/datum/gear/belt/toolbelt_alt
	display_name = "tool-belt, alt"
	cost = 0
	path = /obj/item/storage/belt/utility/alt
	allowed_roles = list("Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Machinist", "Research Director")
	flags = null
