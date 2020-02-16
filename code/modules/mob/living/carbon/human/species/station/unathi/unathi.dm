/datum/species/unathi
	name = "Unathi"
	short_name = "una"
	name_plural = "Unathi"
	bodytype = "Unathi"
	icobase = 'icons/mob/human_races/unathi/r_lizard.dmi'
	deform = 'icons/mob/human_races/unathi/r_def_lizard.dmi'
	preview_icon = 'icons/mob/human_races/unathi/unathi_preview.dmi'
	tail = "sogtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/sharp
	)
	primitive_form = "Stok"
	darksight = 3
	gluttonous = GLUT_MESSY
	stomach_capacity = 7
	slowdown = 0.5

	brute_mod = 0.8
	fall_mod = 1.2
	grab_mod = 1.25 // Huge, usually have horns
	resist_mod = 2.5 // Arguably our strongest organic species

	ethanol_resistance = 0.4
	taste_sensitivity = TASTE_SENSITIVE
	economic_modifier = 7

	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	name_language = LANGUAGE_UNATHI

	stamina	=	120			  // Unathi have the shortest but fastest sprint of all
	stamina_recovery = 5

	sprint_cost_factor = 1.45
	sprint_speed_factor = 3.2
	exhaust_threshold = 65

	rarity_value = 3
	breakcuffs = list(MALE)
	mob_size = 10
	climb_coeff = 1.35

	blurb = "A heavily reptillian species, Unathi (or 'Sinta as they call themselves) hail from the Uuosa-Eso \
	system, which roughly translates to 'burning mother'. A relatively recent addition to the galactic stage, they \
	suffered immense turmoil after the cultural and economic disruption following first contact with humanity.<br><br>\
	With their homeworld of Moghes suffering catastrophic climate change from a nuclear war in the recent past, the \
	Hegemony that rules the majority of the species struggles to find itself in a galaxy filled with dangers far \
	greater than themselves. They mostly hold ideals of honesty, virtue, martial combat and spirituality above all \
	else.They prefer warmer temperatures than most species."

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tongue_flick
	)


	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34AF10"

	reagent_tag = IS_UNATHI
	base_color = "#066000"

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

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	allowed_citizenships = list(CITIZENSHIP_IZWESKI, CITIZENSHIP_DOMINIA, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION, CITIZENSHIP_ELYRA, CITIZENSHIP_ERIDANI)
	allowed_religions = list(RELIGION_THAKH, RELIGION_SKAKH, RELIGION_SIAKH, RELIGION_AUTAKH, RELIGION_MOROZ, RELIGION_NONE, RELIGION_OTHER, RELIGION_CHRISTIANITY, RELIGION_ISLAM)
	default_citizenship = CITIZENSHIP_IZWESKI

	zombie_type = "Unathi Zombie"

/datum/species/unathi/after_equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.shoes)
		return
	var/obj/item/clothing/shoes/sandal/S = new /obj/item/clothing/shoes/sandal(H)
	if(H.equip_to_slot_or_del(S,slot_shoes))
		S.autodrobe_no_remove = 1