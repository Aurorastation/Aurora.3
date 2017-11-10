/datum/species/psy_worm

	name = "Urlamia"
	name_plural = "Urlamian"
	short_name = "url"
	blurb = "The Urlamian brood is a species of large serpentine sentients native and found almost exclusively within the Dagon system. They are extremely long-lived \
	thanks to both their natural physiology and their tendency to enter into hibernative sleep for sustained periods of time - lasting from decades to centuries. Their minds \
	develop extraordinarily throughout their lifespan - unlike other species the Urlamian brain never stops growing and expanding, and as a result they are often rumoured \
	to have legendary psionic powers by the end of their life. Their society is a solitary one, and their species is low in numbers despite their \
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

	default_language = "Ceti Basic"
	language = "Cambion"
	secondary_langs = list(LANGUAGE_UNATHI,"Sol Common",LANGUAGE_SIIK_MAAS,LANGUAGE_SKRELLIAN,LANGUAGE_VOX)
	num_alternate_languages = 1
	name_language = "Cambion"

	brute_mod = 0.85
	burn_mod = 1.1
	oxy_mod = 1
	toxins_mod = 0.85
	radiation_mod = 0.2
	darksight = 8
	breakcuffs = list(MALE,FEMALE,NEUTER)

	heat_level_1 = 560 //Default 360 - Higher is better
	heat_level_2 = 600 //Default 400
	heat_level_3 = 1200 //Default 1000
	passive_temp_gain = 0		                  // Species will gain this much temperature every second
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
		/mob/living/carbon/human/proc/change_colour,
		/mob/living/carbon/human/proc/active_camo
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
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"appendix" = /obj/item/organ/appendix,
		"eyes" =     /obj/item/organ/eyes
		)
	vision_organ =
	breathing_organ =

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

/datum/species/psy_worm/handle_movement_delay_special(var/mob/living/carbon/human/H)
	var/tally = 0

	H.active_camo(1)

	var/obj/item/organ/internal/B = H.internal_organs_by_name["illuminated cortex"]
	if(istype(B,/obj/item/organ/internal/brain/psy_worm))
		var/obj/item/organ/internal/brain/psy_worm/PW = B

		tally += PW.lowblood_tally
		tally += PW.psi_feedback

	return tally