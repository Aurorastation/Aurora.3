/mob/living/simple_animal/spacemanta
	name = "space manta"
	desc = "A majestic space flap-flap."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "spacemanta"
	item_state = "spacemanta"
	icon_living = "spacemanta"
	icon_dead = "spacemanta_dead"
	emote_hear = list("coos", "warbles", "chirps", "hums", "whuffles")
	emote_see = list("twitches its mandibles", "swishes its tail", "spins in a circle", "looks around curiously")
	speak_chance = 1
	turns_per_move = 5
	organ_names = list("head", "body", "tail", "left wing", "right wing")
	meat_type = /obj/item/reagent_containers/food/snacks/fish/fishfillet
	response_help = "pets"
	response_disarm = "nudges"
	response_harm = "strikes"
	gender = NEUTER
	flying = TRUE
	stop_automated_movement_when_pulled = 1

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	mob_size = 6
	max_nutrition = 50
	metabolic_factor = 0.3
	bite_factor = 0.4

	stomach_size_mult = 4
	possession_candidate = TRUE
	sample_data = list("Has a noticably high brain to body weight ratio.", "Possesses a cartilaginous skeleton much like the elasmobranchs of Earth.", "Is entirely unrelated to Idris Incorporated, despite what its coloration may suggest.")

/mob/living/simple_animal/spacemanta/unique/pancake
	name = "Pancake"
	desc = "This magnificant creature is Pancake, the Operations department mascot. Her broad, flat back looks great for stacking crates onto."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "spacemanta"
	item_state = "spacemanta"
	icon_living = "spacemanta"
	icon_dead = "spacemanta_dead"
	icon_gib = null
	gender = FEMALE
	emote_hear = list("coos", "warbles", "chirps", "hums", "whuffles")
	emote_see = list("twitches her mandibles", "swishes her tail", "spins in a circle", "looks around curiously")

/mob/living/simple_animal/spacemanta/unique/pancake/death()
	.=..()
	desc = "Alas, poor Pancake. There's a malevolent manta murderer out there somewhere..."
