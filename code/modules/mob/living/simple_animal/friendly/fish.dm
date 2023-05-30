/mob/living/simple_animal/aquatic/fish
	name = "aquatic creature"
	desc = "A sort of bronze-belly aquatic lifeform that takes on the appearance of a fish. It's small and rather docile."
	speak = list("Glub!")
	speak_emote = list("glubs", "glibs")
	emote_hear = list("glubs","glibs")
	emote_see = list("flops around", "inflates its gills")
	speak_chance = 1
	see_in_dark = 6
	density = 0

	item_state = "fish"
	mob_size = MOB_SMALL
	holder_type = /obj/item/holder/fish
