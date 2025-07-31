/mob/living/simple_animal/olive
	name = "Olive"
	desc = "A genetically modified greimorian larva. It seems unnaturally docile and wears a cute pink ribbon tied daintily around its neck."
	emote_hear = list("chitters","chatters")
	emote_see = list("skitters", "scuttles")
	speak_chance = 1
	density = FALSE
	mob_size = MOB_TINY
	faction = "Station"
	response_help = "pets"
	response_disarm = "boops"
	response_harm  = "squishes"
	icon = 'icons/mob/npc/olive.dmi'
	icon_state = "living"
	icon_dead = "dead"
	blood_type = "#51C404"

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	tameable = FALSE

/mob/living/simple_animal/olive/death()
	.=..()
	desc = "Alas, Olive has met the fate that often befalls many greimorian larvae."
