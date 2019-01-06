/datum/species/unathi/autakh
	name = "Autakh Unathi"
	short_name = "aut"
	name_plural = "Autakh Unathi"

//	icobase = 'icons/mob/human_races/r_lizard.dmi'
//	deform = 'icons/mob/human_races/r_def_lizard.dmi'
//	tail = "sogtail"
//	tail_animation = 'icons/mob/species/unathi/tail.dmi'

	slowdown = 0.5
	brute_mod = 0.7
	burn_mod = 1.2
	toxins_mod = 0.8
	fall_mod = 1.1

	economic_modifier = 5

	secondary_langs = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA, LANGUAGE_EAL)

	sprint_speed_factor = 2.6
	sprint_cost_factor = 1.10

	rarity_value = 4

	metabolism_mod = 1

	eyes_are_impermeable = TRUE
	breakcuffs = list(MALE, FEMALE)

	meat_type = /obj/item/stack/material/steel
	remains_type = /obj/effect/decal/remains/robot

	death_message = "gives one shrill beep before falling lifeless."
	knockout_message = "encounters a hardware fault and suddenly reboots!"
	halloss_message = "encounters a hardware fault and suddenly reboots."
	halloss_message_self = "ERROR: Unrecoverable machine check exception.<BR>System halted, rebooting..."

	blurb = "A heavily reptillian species, Unathi (or 'Sinta as they call themselves) hail from the Uuosa-Eso \
	system, which roughly translates to 'burning mother'. A relatively recent addition to the galactic stage, they \
	suffered immense turmoil after the cultural and economic disruption following first contact with humanity.<br><br>\
	With their homeworld of Moghes suffering catastrophic climate change from a nuclear war in the recent past, the \
	Hegemony that rules the majority of the species struggles to find itself in a galaxy filled with dangers far \
	greater than themselves. They mostly hold ideals of honesty, virtue, martial combat and spirituality above all \
	else.They prefer warmer temperatures than most species."

	cold_level_1 = 250 //Default 260 - Lower is better
	cold_level_2 = 210 //Default 200
	cold_level_3 = 120 //Default 120

	heat_level_1 = 380 //Default 360 - Higher is better
	heat_level_2 = 420 //Default 400
	heat_level_3 = 1000 //Default 1000

	hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.

	inherent_verbs = list(
		/mob/living/proc/devour,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/disattach_limb,
		/mob/living/carbon/human/proc/attach_limb
	)

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys/autakh,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes/autakh,
		"anchor" =   /obj/item/organ/anchor,
		"haemodynamic" =   /obj/item/organ/haemodynamic,
		"adrenal" =   /obj/item/organ/adrenal
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/autakh),
		"groin" =  list("path" = /obj/item/organ/external/groin/autakh),
		"head" =   list("path" = /obj/item/organ/external/head/autakh),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/autakh),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/autakh),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/autakh),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/autakh),
		"l_hand" = list("path" = /obj/item/organ/external/hand/autakh),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/autakh),
		"l_foot" = list("path" = /obj/item/organ/external/foot/autakh),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/autakh)
		)


	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	flags = NO_CHUBBY

	flesh_color = "#575757"

	reagent_tag = IS_UNATHI

	heat_discomfort_level = 290
	heat_discomfort_strings = list(
		"Your organs feel warm.",
		"Your temperature sensors are reading high.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 285
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You read a cryogenic environment.",
		"Your servos creak in the cold."
		)

	siemens_coefficient = 1.1

	nutrition_loss_factor = 1.2

	hydration_loss_factor = 1.2

	light_range = 2
	light_power = 0.5

/datum/species/unathi/autakh/get_light_color(mob/living/carbon/human/H)
	if (!istype(H))
		return null

	var/obj/item/organ/eyes/eyes = H.get_eyes()
	if (eyes)
		var/eyegb = rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])
		return eyegb