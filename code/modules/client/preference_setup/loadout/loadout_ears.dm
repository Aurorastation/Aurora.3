/datum/gear/ears
	display_name = "earwear, circuitry (empty)"
	path = /obj/item/clothing/ears/circuitry
	sort_category = "Earwear"
	slot = slot_r_ear

/datum/gear/ears/double
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	slot = null

/datum/gear/ears/bandanna
	display_name = "neck bandanna selection"
	path = /obj/item/clothing/ears/bandanna

/datum/gear/ears/bandanna/New()
	..()
	var/list/bandanna = list()
	bandanna["red bandanna"] =  /obj/item/clothing/ears/bandanna
	bandanna["blue bandanna"] = /obj/item/clothing/ears/bandanna/blue
	bandanna["black bandanna"] = /obj/item/clothing/ears/bandanna/black
	gear_tweaks += new /datum/gear_tweak/path(bandanna)

/datum/gear/ears/bandanna_colorable
	display_name = "neck bandanna (colorable)"
	path = /obj/item/clothing/ears/bandanna_colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/double/headphones
	display_name = "headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones

/datum/gear/ears/earrings
	display_name = "earring selection"
	description = "A selection of eye-catching earrings."
	path = /obj/item/clothing/ears/earring
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/earrings/New()
	..()
	var/list/earrings = list()
	earrings["stud earrings"] = /obj/item/clothing/ears/earring/stud
	earrings["dangle earrings"] = /obj/item/clothing/ears/earring/dangle
	gear_tweaks += new /datum/gear_tweak/path(earrings)

/datum/gear/ears/hearing_aid
	display_name = "hearing aid selection"
	path = /obj/item/device/hearing_aid
	cost = 1

/datum/gear/ears/hearing_aid/New()
	..()
	var/list/hearingaids = list()
	hearingaids["hearing aid, black"] = /obj/item/device/hearing_aid/black
	hearingaids["hearing aid, grey"] = /obj/item/device/hearing_aid
	hearingaids["hearing aid, silver"] = /obj/item/device/hearing_aid/silver
	hearingaids["hearing aid, white"] = /obj/item/device/hearing_aid/white
	hearingaids["hearing aid, skrellian"] = /obj/item/device/hearing_aid/skrell
	gear_tweaks += new /datum/gear_tweak/path(hearingaids)

