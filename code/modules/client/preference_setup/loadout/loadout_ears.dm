// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/ears
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	sort_category = "Earwear"

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

/datum/gear/ears/bandana_colour
	display_name = "neck bandana (colourable)"
	path = /obj/item/clothing/ears/bandanna/colour
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

/datum/gear/ears/earrings/New()
	..()
	var/earrings = list()
	earrings["stud, pearl"] = /obj/item/clothing/ears/earring/stud
	earrings["stud, glass"] = /obj/item/clothing/ears/earring/stud/glass
	earrings["stud, wood"] = /obj/item/clothing/ears/earring/stud/wood
	earrings["stud, iron"] = /obj/item/clothing/ears/earring/stud/iron
	earrings["stud, steel"] = /obj/item/clothing/ears/earring/stud/steel
	earrings["stud, silver"] = /obj/item/clothing/ears/earring/stud/silver
	earrings["stud, gold"] = /obj/item/clothing/ears/earring/stud/gold
	earrings["stud, platinum"] = /obj/item/clothing/ears/earring/stud/platinum
	earrings["stud, diamond"] = /obj/item/clothing/ears/earring/stud/diamond
	earrings["dangle, glass"] = /obj/item/clothing/ears/earring/dangle/glass
	earrings["dangle, wood"] = /obj/item/clothing/ears/earring/dangle/wood
	earrings["dangle, iron"] = /obj/item/clothing/ears/earring/dangle/iron
	earrings["dangle, steel"] = /obj/item/clothing/ears/earring/dangle/steel
	earrings["dangle, silver"] = /obj/item/clothing/ears/earring/dangle/silver
	earrings["dangle, gold"] = /obj/item/clothing/ears/earring/dangle/gold
	earrings["dangle, platinum"] = /obj/item/clothing/ears/earring/dangle/platinum
	earrings["dangle, diamond"] = /obj/item/clothing/ears/earring/dangle/diamond
	gear_tweaks += new/datum/gear_tweak/path(earrings)
