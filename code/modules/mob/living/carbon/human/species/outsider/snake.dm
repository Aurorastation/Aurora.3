/mob/living/carbon/human/snake/New(var/new_loc)
	..(new_loc, "Snake People")

/datum/species/snake
	name = "Snake People"
	short_name = "snek"
	name_plural = "Snake Folk"
	bodytype = "Snake"
	icobase = 'icons/mob/human_races/r_snake.dmi'
	deform = 'icons/mob/human_races/r_snake.dmi'
	blurb = "A race of snakelike sapients from somewhere beyond the frontier. They are a new threat, arriving in the galaxy as invaders."
	eyes = "eyes_snake"
	breakcuffs = list(MALE,FEMALE,NEUTER)

	tail_stance = 1
	tail_length = 5

	mob_size = 15
	gluttonous = 3
	vision_flags = SEE_SELF | SEE_MOBS
	rarity_value = 10
	slowdown = -1 // Compensating for a total inability to wear shoes.
	
	darksight = 8
	brute_mod = 0.8
	ethanol_resistance = 0.7
	
	virus_immune = 1
	siemens_coefficient = 0.5

	cold_level_1 = 280
	cold_level_2 = 220
	cold_level_3 = 130
	heat_level_1 = 420
	heat_level_2 = 480
	heat_level_3 = 1100
	heat_discomfort_level = 295
	
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)
	cold_discomfort_level = 292
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)

	hud_type = /datum/hud_data/snake
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)

	default_language = "Snake Language"
	language = "Ceti Basic"
	num_alternate_languages = 1

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	flags = NO_SLIP

	inherent_verbs = list(
		/mob/living/proc/devour,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/venomspit,
		/mob/living/carbon/human/proc/coil_up
		)

	flesh_color = "#006600"
	blood_color = "#1D2CBF"
	base_color = "#006666"
	
	reagent_tag = IS_UNATHI

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/snake),
		"groin" =  list("path" = /obj/item/organ/external/groin/snake),
		"head" =   list("path" = /obj/item/organ/external/head/snake),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right)
		)

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes,
		"venom gland" =  /obj/item/organ/venomgland
		)

	stamina	=	120	
	sprint_speed_factor = 3
	stamina_recovery = 1
	sprint_cost_factor = 1
	
/datum/species/snake
	autohiss_basic_map = list(
			"s" = list("ssss", "sssss", "ssssss"),
			"c" = list("cksss", "ckssss", "cksssss"),
			"k" = list("ksss", "kssss", "ksssss"),
			"x" = list("ksss", "kssss", "ksssss")
		)
