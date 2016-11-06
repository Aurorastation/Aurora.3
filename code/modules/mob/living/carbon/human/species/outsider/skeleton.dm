/mob/living/carbon/human/skeleton/New(var/new_loc)
	..(new_loc, "Skeleton")

/datum/species/skeleton //SPOOKY
	name = "Skeleton"
	name_plural = "skeletons"

	icobase = 'icons/mob/human_races/r_skeleton.dmi'
	deform = 'icons/mob/human_races/r_skeleton.dmi'

	default_language = "Ceti Basic"
	language = "Cult"
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	has_organ = list() //skeletons are empty shells for now, maybe we can add something in the future
	siemens_coefficient = 0
	ethanol_resistance = -1 //no drunk skeletons

	rarity_value = 10
	blurb = "Skeletons are undead brought back to life through dark wizardry, \
	they are empty shells fueled by sheer obscure power and blood-magic. \
	However, some men are cursed to carry such burden due to vile curses."

	warning_low_pressure = 50 //immune to pressure, so they can into space/survive breaches without worries
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	body_temperature = T0C //skeletons are cold

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	death_message = "collapses, their bones clattering in a symphony of demise."
	death_sound = 'sound/effects/falling_bones.ogg'

	breath_type = null
	poison_type = null

	flags = IS_RESTRICTED | NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN | NO_BREATHE

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/skeleton),
		"groin" =  list("path" = /obj/item/organ/external/groin/skeleton),
		"head" =   list("path" = /obj/item/organ/external/head/skeleton),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/skeleton),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/skeleton),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/skeleton),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/skeleton),
		"l_hand" = list("path" = /obj/item/organ/external/hand/skeleton),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/skeleton),
		"l_foot" = list("path" = /obj/item/organ/external/foot/skeleton),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/skeleton)
		)

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.3
	exhaust_threshold = 0 //No oxyloss, so zero threshold
