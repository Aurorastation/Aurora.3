/datum/gear/belt
	display_name = "belt (colorable)"
	description = "A generic colorable belt."
	path = /obj/item/storage/belt/generic
	slot = slot_belt
	sort_category = "Belts"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/belt/resize
	display_name = "alternative belt sizes (colorable)"
	description = "A generic colorable belt selection of varying appearances."
	path = /obj/item/storage/belt/generic/thin

/datum/gear/belt/resize/New()
	..()
	var/list/belt = list()
	belt["thin belt"] = /obj/item/storage/belt/generic/thin
	belt["thick belt"] = /obj/item/storage/belt/generic/thick
	belt["buckle belt"] = /obj/item/storage/belt/generic/buckle
	gear_tweaks += new /datum/gear_tweak/path(belt)

/datum/gear/belt/fannypack
	display_name = "fannypack"
	description = "A colorable fannypack."
	cost = 2
	path = /obj/item/storage/belt/fannypack/recolorable

/datum/gear/belt/toolbelt_alt
	display_name = "tool-belt, alt"
	description = "An alternative look to a standard toolbelt."
	cost = 1
	path = /obj/item/storage/belt/utility/alt
	allowed_roles = list("Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice", "Machinist", "Research Director", "Engineering Personnel", "Operations Personnel")
	flags = null

/datum/gear/belt/securitybelt_alt
	display_name = "security-belt, alt"
	description = "An alternative look to a standard security belt, this one looks like it got a chestrig."
	cost = 1
	path = /obj/item/storage/belt/security/vestbelt
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator", "Security Personnel")
	flags = null

/datum/gear/belt/waistpack
	display_name = "waist pack"
	description = "A small, waist-mounted pack for... well, storing stuff!"
	cost = 2
	path = /obj/item/storage/belt/fannypack/waistpack

/datum/gear/belt/pouchbelt
	display_name = "belt with pouches"
	description = "A belt coated from front to back in pouches."
	cost = 2
	path = /obj/item/storage/belt/fannypack/pouchbelt
