/mob/living/simple_animal/aquatic/fish
	name = "aquatic creature"
	desc = "A sort of bronze-belly aquatic lifeform that takes on the appearance of a fish. It's small and rather docile."
	speak = list("Glub!")
	speak_emote = list("glubs", "glibs")
	emote_hear = list("glubs","glibs")
	emote_see = list("flops around", "inflates its gills")
	speak_chance = 1
	density = FALSE
	mob_size = MOB_SMALL
	item_state = "fish"

	holder_type = /obj/item/holder/fish

/mob/living/simple_animal/aquatic/fish/cod
	desc = "A muscular, elongated fish with a sleek appearance. Despite its size, it seems particularly passive."
	speak_chance = 0
	icon_state = "cod"
	item_state = "cod"
	icon_living = "cod"
	icon_dead = "cod_dead"
	icon_rest = "cod_rest"
	item_state = "cod"

	holder_type = /obj/item/holder/fish/cod

/mob/living/simple_animal/aquatic/fish/gupper
	icon_state = "gupper"
	item_state = "gupper"
	icon_living = "gupper"
	icon_dead = "gupper_dead"
	icon_rest = "gupper_rest"
	item_state = "gupper"
