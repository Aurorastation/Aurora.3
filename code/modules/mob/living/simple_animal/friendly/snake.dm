/mob/living/simple_animal/snake
	name = "snake"
	desc = "A slithering serpent."
	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake_dead"
	icon_rest = "snake_rest"
	speak_emote = list("hisses")
	emote_see = list("flicks out its tongue", "looks around")
	health = 15
	maxHealth = 15
	organ_names = list("head", "body")
	response_help  = "pets"
	response_disarm = "boops"
	response_harm   = "stomps on"
	mob_size = MOB_SMALL
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag
