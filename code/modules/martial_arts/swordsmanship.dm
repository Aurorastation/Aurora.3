/datum/martial_art/swordsmanship
	name = "Swordsmanship"
	weapon_affinity	= /obj/item/material/sword
	parry_multiplier = 2
	possible_weapons = list(/obj/item/material/sword, /obj/item/material/sword/katana, /obj/item/material/sword/rapier)

/obj/item/martial_manual/swordsmanship
	name = "swordsmanship manual"
	desc = "A manual containing basic swordsmanship instruction and techniques."
	icon_state ="rulebook"
	martial_art = /datum/martial_art/swordsmanship
