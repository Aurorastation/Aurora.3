/datum/species/sectoid
	name = "Pectoid"
	name_plural =  "Pectoids"
	short_name = "ayy"
	blurb = "A completely nondescript species."
	age_min = 20
	age_max = 500
	economic_modifier = 20

	// Icon/appearance vars.
	icobase = 'icons/mob/human_races/r_sectoid.dmi'
	deform = 'icons/mob/human_races/r_sectoid.dmi'

	eyes = "eyes_grey"
	has_floating_eyes = 1
	blood_color = "#65e52c" // Green.
	flesh_color = "#D3D3D3" // Grey.
	mob_size = MOB_SMALL
	bald = 1

	language = LANGUAGE_SECTOID
	secondary_langs = list(LANGUAGE_TRADEBAND,LANGUAGE_SIGN)
	num_alternate_languages = 2
	name_language = LANGUAGE_SECTOID

	brute_mod = 1.25
	burn_mod = 0.6
	oxy_mod = 1.1
	toxins_mod = 1.1
	radiation_mod = 0.2
	willpower = 40
	awoken = 1

	heat_level_1 = 560
	heat_level_2 = 600
	heat_level_3 = 1200

	heat_discomfort_level = 515
	heat_discomfort_strings = list(
		"You feel the heat.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)

	appearance_flags = HAS_EYE_COLOR | HAS_SKIN_COLOR
	spawn_flags = CAN_JOIN// | IS_WHITELISTED

	rarity_value = 8
	ethanol_resistance = 0.6
	taste_sensitivity = TASTE_DULL

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"appendix" = /obj/item/organ/appendix,
		"eyes" =     /obj/item/organ/eyes
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"head" =   list("path" = /obj/item/organ/external/head),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right)
		)