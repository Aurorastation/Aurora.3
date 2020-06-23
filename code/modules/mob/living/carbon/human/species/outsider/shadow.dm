/mob/living/carbon/human/shadow/Initialize(mapload)
	. = ..(mapload, "Shadow")

/datum/species/shadow
	name = "Shadow"
	name_plural = "shadows"

	blurb = "Have you ever been alone at night \
	thought you heard footsteps behind, \
	and turned around and no one's there? \
	And as you quicken up your pace \
	you find it hard to look again, \
	because you're sure there's someone there."

	icobase = 'icons/mob/human_races/r_shadow.dmi'
	deform = 'icons/mob/human_races/r_shadow.dmi'
	eyes = "eyes_shadow"
	has_floating_eyes = 1

	language = "Cult"

	unarmed_types = list(/datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/claws/strong)
	light_dam = 2
	darksight = 8
	has_organ = list()
	siemens_coefficient = 0
	rarity_value = 10
	virus_immune = 1

	breakcuffs = list(MALE,FEMALE,NEUTER)

	fall_mod = 0

	ethanol_resistance = -1
	taste_sensitivity = TASTE_NUMB

	speech_sounds = list('sound/species/shadow/grue_growl.ogg')
	speech_chance = 50

	warning_low_pressure = 50 //immune to pressure, so they can into space/survive breaches without worries
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	brute_mod = 0.5
	burn_mod = 1.2

	breath_type = null
	poison_type = null

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "dissolves into ash..."
	death_message_range = 7

	flags = NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN | NO_BREATHE | NO_EMBED
	spawn_flags = IS_RESTRICTED

	vision_flags = DEFAULT_SIGHT | SEE_MOBS

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/unbreakable),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.3
	exhaust_threshold = 0 //No oxyloss, so zero threshold

	inherent_verbs = list(
	/mob/living/carbon/human/proc/shatter_light,
	/mob/living/carbon/human/proc/create_darkness,
	/mob/living/carbon/human/proc/darkness_eyes,
	/mob/living/carbon/human/proc/shadow_step
	)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	max_nutrition_factor = -1

	max_hydration_factor = -1

	hud_type = /datum/hud_data/construct

/datum/species/shadow/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		new /obj/effect/decal/cleanable/ash(H.loc)
		qdel(H)

/datum/species/shadow/handle_post_spawn(var/mob/living/carbon/human/H)
	if(H.mind)
		H.mind.assigned_role = "Shadow"
		H.mind.special_role = "Shadow"
	H.real_name = "grue"
	H.name = H.real_name
	H.gender = NEUTER
	..()

/datum/species/shadow/get_random_name()
	return "grue"

/datum/species/shadow/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE