/datum/species/unathi
	name = SPECIES_UNATHI
	short_name = "una"
	name_plural = "Unathi"
	category_name = "Unathi"
	bodytype = BODYTYPE_UNATHI
	icobase = 'icons/mob/human_races/unathi/r_unathi.dmi'
	deform = 'icons/mob/human_races/unathi/r_def_unathi.dmi'
	preview_icon = 'icons/mob/human_races/unathi/unathi_preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	tail = "unathtail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws/unathi,
		/datum/unarmed_attack/palm/unathi,
		/datum/unarmed_attack/bite/sharp
	)
	primitive_form = SPECIES_MONKEY_UNATHI
	darksight = 3
	gluttonous = GLUT_MESSY|GLUT_ITEM_TINY
	stomach_capacity = 7
	slowdown = 0.5

	brute_mod = 0.8
	fall_mod = 1.2
	radiation_mod = 0.9 // how else did they survive nuclear armageddon?
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
	bp_base_systolic = 80 // Default 120
	bp_base_disatolic = 50 // Default 80
	low_pulse = 20 // Default 40
	norm_pulse = 40 // Default 60
	fast_pulse = 60 // Default 90
	v_fast_pulse = 80// Default 120
	max_pulse = 100// Default 160
	body_temperature = T0C + 24

	rarity_value = 3
	break_cuffs = TRUE
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

	heat_discomfort_level = 304 // 30°C
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 294  // 20°C
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold."
		)

	has_organ = list(
        BP_BRAIN =    /obj/item/organ/internal/brain/unathi,
        BP_HEART =    /obj/item/organ/internal/heart/unathi,
        BP_LIVER =    /obj/item/organ/internal/liver/unathi,
        BP_LUNGS =    /obj/item/organ/internal/lungs/unathi,
        BP_KIDNEYS =    /obj/item/organ/internal/kidneys/unathi,
        BP_STOMACH =    /obj/item/organ/internal/stomach/unathi,
        BP_EYES =    /obj/item/organ/internal/eyes/unathi
    )

	alterable_internal_organs = list(BP_HEART, BP_EYES, BP_LUNGS, BP_LIVER, BP_KIDNEYS, BP_STOMACH)

	pain_emotes_with_pain_level = list(
			list(/singleton/emote/audible/wheeze, /singleton/emote/audible/roar, /singleton/emote/audible/bellow) = 80,
			list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/wheeze, /singleton/emote/audible/hiss) = 50,
			list(/singleton/emote/audible/grunt, /singleton/emote/audible/groan, /singleton/emote/audible/hiss) = 20,
		)

	pain_messages = list("It hurts so much", "You really need some painkillers", "Ancestors, it hurts")

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	possible_cultures = list(
		/singleton/origin_item/culture/izweski,
		/singleton/origin_item/culture/traditionalists,
		/singleton/origin_item/culture/spaceborn,
		/singleton/origin_item/culture/dominian_unathi
	)

	zombie_type = SPECIES_ZOMBIE_UNATHI

	possible_external_organs_modifications = list("Normal","Amputated","Prosthesis", "Diona Nymph")

/datum/species/unathi/after_equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.shoes)
		return
	var/obj/item/clothing/shoes/sandal/S = new /obj/item/clothing/shoes/sandal(H)
	H.equip_to_slot_or_del(S,slot_shoes)
