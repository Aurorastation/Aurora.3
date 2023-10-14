/mob/living/simple_animal/reaver/baby
	name = "baby reaver"
	desc = "The result of SCC experimentation in exploitation of space fauna. While it looks like a dangerous whirl of talons, this one has been successfully tamed."
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "babyreaver"
	item_state = "babyreaver"
	icon_living = "babyreaver"
	icon_dead = "babyreaver_dead"
	organ_names = list("head", "chest", "tail", "left flipper", "right flipper")
	meat_type = /obj/item/reagent_containers/food/snacks/fish/carpmeat
	butchering_products = list(/obj/item/reagent_containers/food/snacks/fish/roe = 1)
	meat_amount = 3
	flying = TRUE
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	density = FALSE
	mob_size = MOB_SMALL
	speed = 4
	maxHealth = 50
	health = 50

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	blood_overlay_icon = 'icons/mob/npc/blood_overlay_carp.dmi'

	//Reavers aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	holder_type = /obj/item/holder/reaver/baby

/mob/living/simple_animal/reaver/baby/jerry
	name = "Jerry"
	desc = "The winner of a poll conducted on the SCCV Horizon. While it looks like a dangerous whirl of talons, this one has been successfully tamed."

	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	holder_type = /obj/item/holder/reaver/baby/jerry
