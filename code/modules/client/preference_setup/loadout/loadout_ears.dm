// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/ears
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	sort_category = "Earwear"

/datum/gear/ears/bandana
	display_name = "neck bandana selection"
	path = /obj/item/clothing/ears/bandana

/datum/gear/ears/bandana/New()
	..()
	var/bandana = list()
	bandana["red bandana"] =  /obj/item/clothing/ears/bandana
	bandana["blue bandana"] = /obj/item/clothing/ears/bandana/blue
	bandana["black bandana"] = /obj/item/clothing/ears/bandana/black
	gear_tweaks += new/datum/gear_tweak/path(bandana)

/datum/gear/ears/headphones
	display_name = "headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones

/datum/gear/ears/circuitry
	display_name = "earwear, circuitry (empty)"
	path = /obj/item/clothing/ears/circuitry
	cost = 3/2