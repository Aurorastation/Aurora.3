// someone please just turn this into a structure
/mob/living/silicon/decoy
	name = "AI"
	icon = 'icons/mob/AI.dmi'//
	icon_state = "ai"
	anchored = 1 // -- TLE
	canmove = 0

/mob/living/silicon/decoy/Initialize()
	. = ..()
	mob_list -= src
	living_mob_list -= src
	silicon_mob_list -= src
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai"
	anchored = 1
	canmove = 0
	return INITIALIZE_HINT_NORMAL