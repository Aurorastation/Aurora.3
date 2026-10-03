/datum/ai_holder/simple_animal/passive/cosmozoan

/mob/living/simple_animal/cosmozoan
	ai_holder_type = /datum/ai_holder/simple_animal/passive/cosmozoan
	name = "cosmozoan"
	desc = "These jellyfish-like entities drift through asteroid fields, emitting a soft glow."
	desc_extended = "Schools of Cosmozoans often congregate in asteroid fields, though they have rarely been witnessed in greater number and size in the Frontier. Their origin remains a mystery but it is believed they predate early man. This belief landed them the name Cosmozoa."
	icon_state = "cosmozoan"
	icon_living = "cosmozoan"
	icon_dead = "cosmozoan_dead"
	maxhealth = 15
	health = 15
	meat_type = /obj/item/reagent_containers/food/snacks/fish/cosmozoan
	meat_amount = 2
	organ_names = list("hood", "tentacles")
	response_help   = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "whacks"
	harm_intent_damage = 5
	blood_type = COLOR_CRYSTAL
	blood_overlay_icon = null
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag
	wanders_diagonally = TRUE

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	flying = TRUE
	lighting_alpha = LIGHTING_PLANE_ALPHA_SOMEWHAT_INVISIBLE
	sample_data = list("Cellular biochemistry include bioluminescent reactions", "Tissue sample contains micro-gas release structures")

/mob/living/simple_animal/cosmozoan/Initialize()
	. = ..()
	set_light(1.4, 3, COLOR_CRYSTAL)
