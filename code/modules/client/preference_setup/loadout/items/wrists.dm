/datum/gear/wrists
	display_name = "bracelet"
	path = /obj/item/clothing/wrists/bracelet
	cost = 1
	slot = slot_wrists
	sort_category = "Wristwear"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/wrists/New()
	..()
	gear_tweaks += list(GLOB.gear_tweak_wrist_layer)

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
	watchtype["pocketwatch"] = /obj/item/clothing/wrists/watch/pocketwatch
	gear_tweaks += new /datum/gear_tweak/path(watchtype)

/*
	Wristwear Layer Adjustment
*/

#define WRISTS_UNDER "Under Uniform"
#define WRISTS_OVER_UNIFORM "Over Uniform"
#define WRISTS_OVER_SUIT "Over Suit"

GLOBAL_DATUM_INIT(gear_tweak_wrist_layer, /datum/gear_tweak/wrist_layer, new())

/datum/gear_tweak/wrist_layer
	var/list/options = list(WRISTS_UNDER = UNDER_UNIFORM_LAYER_WR, WRISTS_OVER_UNIFORM = ABOVE_UNIFORM_LAYER_WR, WRISTS_OVER_SUIT = ABOVE_SUIT_LAYER_WR)

/datum/gear_tweak/wrist_layer/get_contents(var/metadata)
	return "Wrist Layer: [metadata]"

/datum/gear_tweak/wrist_layer/get_default()
	return WRISTS_OVER_SUIT

/datum/gear_tweak/wrist_layer/get_metadata(var/user, var/metadata, var/gear_path)
	var/input = tgui_input_list(user, "Choose in which layer you want your wristwear to spawn in.", "Wristwear Layer", options, metadata)
	if(!input)
		input = metadata
	return input

/datum/gear_tweak/wrist_layer/tweak_item(var/obj/item/clothing/wrists/wrists, var/metadata, var/title, var/gear_path)
	if(!istype(wrists))
		return
	wrists.mob_wear_layer = options[metadata]

#undef WRISTS_UNDER
#undef WRISTS_OVER_UNIFORM
#undef WRISTS_OVER_SUIT
