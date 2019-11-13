//Foxxy
/mob/living/simple_animal/corgi/fox
	name = "fox"
	real_name = "fox"
	desc = "It's a fox. I wonder what it says?"
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
	max_nutrition = 90
	holder_type = /obj/item/holder/fox
	emote_sounds = list()
	butchering_products = list(/obj/item/stack/material/animalhide = 3)

//Captain fox
/mob/living/simple_animal/corgi/fox/Chauncey
	name = "Chauncey"
	real_name = "Chauncey"
	desc = "Chauncey, the Captain's trustworthy fox. I wonder what it says?"
