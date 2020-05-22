//Foxxy
/mob/living/simple_animal/corgi/fox
	name = "fox"
	real_name = "fox"
	desc = "It's a fox. I wonder what it says?"
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	speak = list("Ack-Ack.", "Ack-Ack-Ack-Ackawoooo!", "Awoo!", "Tchoff.")
	speak_emote = list("geckers", "barks")
	emote_hear = list("howls","barks")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 3
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "kicks"
	mob_size = 4
	max_nutrition = 80
	holder_type = /obj/item/holder/fox
	emote_sounds = list()
	butchering_products = list(/obj/item/stack/material/animalhide = 3)

/mob/living/simple_animal/corgi/fox/Initialize()
	. = ..()
	verbs -= /mob/living/simple_animal/corgi/verb/rename_corgi

/mob/living/simple_animal/corgi/verb/rename_fox()
	set name = "Name Fox"
	set category = "IC"
	set desc = "Name this fox."
	set src in view(1)

	if(!can_change_name())
		return
	rename_self_helper(usr, defaultgex, "What do you want to name this fox? No numbers or symbols other than -", "No numbers or symbols, please.")


//Captain fox
/mob/living/simple_animal/corgi/fox/Chauncey
	name = "Chauncey"
	real_name = "Chauncey"
	desc = "Chauncey, the Captain's trustworthy fox. I wonder what it says?"
	unique = TRUE

/mob/living/simple_animal/corgi/fox/Chauncey/Initialize()
	. = ..()
	verbs -= /mob/living/simple_animal/corgi/verb/rename_fox