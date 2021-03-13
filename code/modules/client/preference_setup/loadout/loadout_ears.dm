/datum/gear/ears
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	sort_category = "Earwear"
	slot = slot_r_ear

/datum/gear/ears/bandanna
	display_name = "neck bandanna selection"
	path = /obj/item/clothing/ears/bandanna

/datum/gear/ears/bandanna/New()
	..()
	var/bandanna = list()
	bandanna["red bandanna"] =  /obj/item/clothing/ears/bandanna
	bandanna["blue bandanna"] = /obj/item/clothing/ears/bandanna/blue
	bandanna["black bandanna"] = /obj/item/clothing/ears/bandanna/black
	gear_tweaks += new/datum/gear_tweak/path(bandanna)

/datum/gear/ears/bandanna_colorable
	display_name = "neck bandanna (colorable)"
	path = /obj/item/clothing/ears/bandanna/colorable
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/headphones
	display_name = "headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones

/datum/gear/ears/circuitry
	display_name = "earwear, circuitry (empty)"
	path = /obj/item/clothing/ears/circuitry

/datum/gear/ears/earrings
	display_name = "earring selection"
	description = "A selection of eye-catching earrings."
	path = /obj/item/clothing/ears/earring
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/earrings/New()
	..()
	var/earrings = list()
	earrings["stud earrings"] = /obj/item/clothing/ears/earring/stud
	earrings["dangle earrings"] = /obj/item/clothing/ears/earring/dangle
	gear_tweaks += new/datum/gear_tweak/path(earrings)

/datum/gear/ears/hearing_aid
	display_name = "hearing aid selection"
	path = /obj/item/device/hearing_aid
	cost = 1

/datum/gear/ears/hearing_aid/New()
	..()
	var/hearingaids = list()
	hearingaids["hearing aid, black"] = /obj/item/device/hearing_aid/black
	hearingaids["hearing aid, grey"] = /obj/item/device/hearing_aid
	hearingaids["hearing aid, silver"] = /obj/item/device/hearing_aid/silver
	hearingaids["hearing aid, white"] = /obj/item/device/hearing_aid/white
	hearingaids["hearing aid, skrellian"] = /obj/item/device/hearing_aid/skrell
	gear_tweaks += new/datum/gear_tweak/path(hearingaids)


/datum/gear/ear/hijab
	display_name = "hijab selection"
	path = /obj/item/clothing/ear/hijab

/datum/gear/ear/hijab/New()
	..()
	var/hijab = list()
	hijab["black hijab"] = /obj/item/clothing/ear/hijab
	hijab["grey hijab"] = /obj/item/clothing/ear/hijab/grey
	hijab["red hijab"] = /obj/item/clothing/ear/hijab/red
	hijab["brown hijab"] = /obj/item/clothing/ear/hijab/brown
	hijab["green hijab"] = /obj/item/clothing/ear/hijab/green
	hijab["blue hijab"] = /obj/item/clothing/ear/hijab/blue
	hijab["white hijab"] = /obj/item/clothing/ear/hijab/white

	gear_tweaks += new/datum/gear_tweak/path(hijab)

/datum/gear/head/hijab
	display_name = "colorable hijab"
	path = /obj/item/clothing/ear/hijab_colorable
