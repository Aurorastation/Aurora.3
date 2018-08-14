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

/datum/gear/ears/headphones
	display_name = "headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones
