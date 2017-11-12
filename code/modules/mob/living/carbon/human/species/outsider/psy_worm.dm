/datum/species/psy_worm

	name = "Urlamia"
	name_plural = "Urlamians"
	short_name = "url"
	blurb = "The Urlamian brood is a species of large serpentine sentients native and found almost exclusively within the Dagon system. They are extremely long-lived \
	thanks to both their natural physiology and their tendency to enter into hibernative sleep for sustained periods of time - lasting from decades to centuries. Their minds \
	develop extraordinarily throughout their lifespan - unlike other species the Urlamian brain never stops growing and expanding, and as a result they are often rumoured \
	to have legendary mental powers by the end of their life. Their society is a solitary one, and their species is low in numbers despite their \
	long life due to their tendency against breeding except once or twice in their lifetime. Almost by a rule they are haughty, imperious, covetous, and more than a \
	little suspicious of their fellow broodmates. They are loathe to travel and tend to keep to their own little worlds within Dagon, feuding between themselves and \
	ignoring the rest of the galaxy at large. The number one cause of death amongst Urlamians is not old age or accidental death, but instead political assassination \
	or 'unforeseeable incidents' as the history books label them."
	age_min = 200
	age_max = 3000
	economic_modifier = 0

	icobase = 'icons/mob/human_races/r_psy_worm.dmi'
	deform = 'icons/mob/human_races/r_psy_worm.dmi'

	eyes = "eyes_worm"
	has_floating_eyes = 1
	blood_color = "#525252"
	flesh_color = "#525252"
	mob_size	= MOB_LARGE
	reagent_tag = IS_UNATHI //effectively IS_CARNIVORE

	default_language = "Ceti Basic"
	language = "Cambion"
	secondary_langs = list(LANGUAGE_UNATHI,"Sol Common",LANGUAGE_SIIK_MAAS,LANGUAGE_SKRELLIAN,LANGUAGE_VOX)
	num_alternate_languages = 1
	name_language = "Cambion"

	brute_mod = 0.85
	toxins_mod = 0.85
	radiation_mod = 0.2
	darksight = 8
	breakcuffs = list(MALE,FEMALE,NEUTER)
	willpower = 100
	awoken = 1

	heat_level_1 = 560 //Default 360 - Higher is better
	heat_level_2 = 600 //Default 400
	heat_level_3 = 1200 //Default 1000
	warning_low_pressure = 50
	hazard_low_pressure = 0

	heat_discomfort_level = 515                  // Aesthetic messages about feeling warm.
	cold_discomfort_level = 285                   // Aesthetic messages about feeling chilly.
	heat_discomfort_strings = list(
		"Your scales ventilate.",
		"You feel uncomfortably warm.",
		"You feel heat press against your exoskeleton."
		)
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your scales are cold to the touch."
		)

	hud_type

	inherent_verbs = list(
		/mob/living/proc/devour,
		/mob/living/carbon/human/proc/regurgitate,
	)

	flags = NO_SLIP
	appearance_flags = HAS_SKIN_COLOR | HAS_EYE_COLOR
	spawn_flags = CAN_JOIN | IS_WHITELISTED
	slowdown = -0.5
	rarity_value = 10
	taste_sensitivity = TASTE_SENSITIVE

	gluttonous = TRUE

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"kidneys" =  /obj/item/organ/kidneys,
		"appendix" = /obj/item/organ/appendix,
		"eyes" =     /obj/item/organ/eyes,
		"tracheae" = /obj/item/organ/lungs/psy_worm,
		"phoron sac" = /obj/item/organ/psy_chem,
		"chemical reactor" = /obj/item/organ/liver/psy_worm,
		"photoreceptor cluster" = /obj/item/organ/psy_camo,
		"illuminated cortex" = /obj/item/organ/brain/psy_worm
		)
	breathing_organ = "tracheae"

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/psy_worm),
		"groin" =  list("path" = /obj/item/organ/external/groin/psy_worm),
		"head" =   list("path" = /obj/item/organ/external/head/psy_worm),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/psy_worm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/psy_worm),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/psy_worm),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/psy_worm),
		"l_hand" = list("path" = /obj/item/organ/external/hand/psy_worm),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/psy_worm),
		"l_foot" = list("path" = /obj/item/organ/external/foot/psy_worm),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/psy_worm)
		)

	bump_flag = HEAVY
	push_flags = ALLMOBS
	swap_flags = ALLMOBS

/datum/species/psy_worm/handle_movement_delay_special(var/mob/living/carbon/human/H)
	var/tally = 0

	var/obj/item/organ/C = H.internal_organs_by_name["photoreceptor cluster"]
	if(istype(C,/obj/item/organ/psy_camo))
		var/obj/item/organ/psy_camo/PW = C
		PW.active_camo(1)

	var/obj/item/organ/B = H.internal_organs_by_name["brain"]
	if(istype(B,/obj/item/organ/brain/psy_worm))
		var/obj/item/organ/brain/psy_worm/PW = B

		tally += PW.lowblood_tally
		//tally += PW.psi_feedback

	return tally