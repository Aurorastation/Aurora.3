/mob/living/carbon/human/skeleton/Initialize(mapload)
	. = ..(mapload, "Skeleton")

/datum/species/skeleton //SPOOKY
	name = "Skeleton"
	name_plural = "skeletons"
	bodytype = "Skeleton"
	icobase = 'icons/mob/human_races/r_skeleton.dmi'
	deform = 'icons/mob/human_races/r_skeleton.dmi'
	eyes = "blank_eyes"

	default_language = "Ceti Basic"
	language = "Cult"
	name_language = "Cult"
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	has_organ = list() //skeletons are empty shells for now, maybe we can add something in the future
	siemens_coefficient = 0
	ethanol_resistance = -1 //no drunk skeletons
	taste_sensitivity = TASTE_NUMB
	breakcuffs = list(MALE,FEMALE,NEUTER)

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/undead

	reagent_tag = IS_UNDEAD

	virus_immune = 1

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

	remains_type = /obj/effect/decal/cleanable/ash

	death_message = "collapses, their bones clattering in a symphony of demise..."
	death_sound = 'sound/effects/falling_bones.ogg'

	breath_type = null
	poison_type = null

	flags = NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN | NO_BREATHE | NO_EMBED | NO_CHUBBY
	spawn_flags = IS_RESTRICTED

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

/mob/living/carbon/human/apparition/Initialize(mapload)
	. = ..(mapload, "Apparition")

/datum/species/apparition
	name = "Apparition"
	name_plural = "apparitions"
	bodytype = "Apparition"
	icobase = 'icons/mob/human_races/r_manifested.dmi'
	deform = 'icons/mob/human_races/r_manifested.dmi'

	default_language = "Ceti Basic"
	language = "Cult"
	name_language = "Cult"
	has_organ = list()

	virus_immune = 1

	reagent_tag = IS_UNDEAD

	rarity_value = 10
	blurb = "Apparitions are vengeful spirits, they are given temporary bodies to fulfill the wicked \
	desires of their masters. A common sight among the ranks of the geometer of blood."

	remains_type = /obj/effect/decal/cleanable/ash

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/undead

	flesh_color = "#551A8B"

	flags = NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN | NO_BREATHE | NO_EMBED
	spawn_flags = IS_RESTRICTED

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.3
	exhaust_threshold = 0 //No oxyloss, so zero threshold

/datum/species/apparition/handle_death(var/mob/living/carbon/human/H)
	set waitfor = 0
	sleep(1)
	new /obj/effect/decal/cleanable/ash(H.loc)
	qdel(H)
