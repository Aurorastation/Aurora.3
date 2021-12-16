/datum/gear/wrists
	display_name = "bracelet"
	path = /obj/item/clothing/wrists/bracelet
	cost = 1
	slot = slot_wrists
	sort_category = "Wristwear"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/wrists/beaded
	display_name = "beaded bracelet"
	path = /obj/item/clothing/wrists/beaded

/datum/gear/wrists/slap
	display_name = "slap bracelet"
	path = /obj/item/clothing/wrists/slap

/datum/gear/wrists/watch
	display_name = "watch selection"
	description = "A selection of watches."
	path = /obj/item/clothing/wrists/watch
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/wrists/watch/New()
	..()
	var/list/watchtype = list()
	watchtype["watch"] = /obj/item/clothing/wrists/watch
	watchtype["silver watch"] = /obj/item/clothing/wrists/watch/silver
	watchtype["gold watch"] = /obj/item/clothing/wrists/watch/gold
	watchtype["holo watch"] = /obj/item/clothing/wrists/watch/holo
	watchtype["leather watch"] = /obj/item/clothing/wrists/watch/leather
	watchtype["spy watch"] = /obj/item/clothing/wrists/watch/spy
	watchtype["pocketwatch"] = /obj/item/pocketwatch
	gear_tweaks += new /datum/gear_tweak/path(watchtype)
