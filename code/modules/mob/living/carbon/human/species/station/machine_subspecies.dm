/datum/species/machine/shell
	name = "Shell Frame"
	hide_name = TRUE
	short_name = "jak"
	name_plural = "Shells"
	bodytype = "Human"

	burn_mod = 1.2

	blurb = "IPCs with humanlike properties. Their focus is on service, civilian, and medical, but there are no \
	job restrictions. Created in the late days of 2457, the Shell is a controversial IPC model equipped with a synthskin weave applied over its metal chassis \
	to create an uncannily close approximation of the organic form. Early models of Shell had the advantage of being able to compose themselves of a wide \
	 variety of organic parts, but contemporary models have been restricted to a single species for the sake of prosthetic integrity. The additional weight of \
	 the synthskin on the original Hephaestus frame reduces the efficacy of the unit's already strained coolant systems, and increases charge consumption."

	num_alternate_languages = 3

	icobase = 'icons/mob/human_races/r_human.dmi'
	deform = 'icons/mob/human_races/robotic.dmi'

	light_range = 0
	light_power = 0

	eyes = "eyes_s"
	show_ssd = "completely quiescent"

	max_nutrition_factor = 0.8

	heat_level_1 = 400
	heat_level_2 = 800
	heat_level_3 = 1600

	heat_discomfort_level = 400
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!",
		"Your synthetic flesh crawls in the heat, swelling into a disgusting morass of plastic."
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_EYE_COLOR | HAS_FBP | HAS_UNDERWEAR | HAS_SOCKS

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/shell),
		"groin" =  list("path" = /obj/item/organ/external/groin/shell),
		"head" =   list("path" = /obj/item/organ/external/head/shell),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/shell),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/shell),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/shell),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/shell),
		"l_hand" = list("path" = /obj/item/organ/external/hand/shell),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/shell),
		"l_foot" = list("path" = /obj/item/organ/external/foot/shell),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/shell)
		)

	sprint_temperature_factor = 1.3
	sprint_charge_factor = 0.85

/datum/species/machine/shell/get_light_color(hair_style)
	return

/datum/species/machine/shell/handle_post_spawn(var/mob/living/carbon/human/H)
	. = ..()
	check_tag(H, H.client)

/datum/species/machine/shell/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/machine/shell/equip_survival_gear(var/mob/living/carbon/human/H)
	check_tag(H, H.client)

/datum/species/machine/industrial
	name = "Industrial Frame"
	short_name = "ind"
	name_plural = "Industrials"
	bald = 1

	brute_mod = 0.8
	burn_mod = 1.1
	slowdown = 4

	blurb = "Tough units made for engineering and security with simple exteriors, roughly resembling humans. No job restrictions. Heavy emphasis on \
	engineering/security/EMT. Developed also by Hephaestus Industries, the Industrial Frame trades the common availability of the Baseline Frame for \
	advanced durability and increased longevity. Constructed of durable plasteel, the frame can withstand a great deal more abuse, and its coolant systems \
	and internal cell have been improved to allow for much more strenuous work. However, due to an unfortunate fault in the capacitor, actual battery charge \
	tends to be short."

	icobase = 'icons/mob/human_races/r_industrial.dmi'
	deform = 'icons/mob/human_races/r_industrial.dmi'

	eyes = "eyes_industry"
	show_ssd = "completely quiescent"

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/industrial),
		"groin" =  list("path" = /obj/item/organ/external/groin/industrial),
		"head" =   list("path" = /obj/item/organ/external/head/industrial),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/industrial),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/industrial),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/industrial),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/industrial),
		"l_hand" = list("path" = /obj/item/organ/external/hand/industrial),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/industrial),
		"l_foot" = list("path" = /obj/item/organ/external/foot/industrial),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/industrial)
		)

	appearance_flags = HAS_EYE_COLOR

	heat_level_1 = 600
	heat_level_2 = 1200
	heat_level_3 = 2400

	heat_discomfort_level = 800

	max_nutrition_factor = 1.25
	nutrition_loss_factor = 2

	sprint_speed_factor = 1.4
	sprint_temperature_factor = 0.9
	sprint_charge_factor = 1.1

/datum/species/machine/industrial/get_light_color(hair_style)
	return LIGHT_COLOR_TUNGSTEN

/datum/species/machine/industrial/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/machine/terminator
	name = "Hunter-Killer"
	short_name = "hks"
	name_plural = "HKs"
	bald = 1

	blurb = "\[REDACTED\]"

	icobase = 'icons/mob/human_races/r_terminator.dmi'
	deform = 'icons/mob/human_races/r_terminator.dmi'

	light_range = 0
	light_power = 0

	unarmed_types = list(/datum/unarmed_attack/terminator)
	rarity_value = 20

	language = "Hephaestus Darkcomms"
	name_language = "Hephaestus Darkcomms"

	eyes = "eyes_terminator"
	has_floating_eyes = 1

	brute_mod = 0.3
	burn_mod = 0.5
	flash_mod = 0
	siemens_coefficient = 0
	breakcuffs = list(MALE,FEMALE,NEUTER)
	mob_size = 20

	show_ssd = "laying inert, its activation glyph dark"
	death_sound = 'sound/effects/bang.ogg'
	death_message = "collapses to the ground with a CLUNK, and begins to beep ominously."

	heat_level_1 = 1500
	heat_level_2 = 2000
	heat_level_3 = 5000

	body_temperature = null
	passive_temp_gain = 0

	flags = NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | NO_POISON
	spawn_flags = IS_RESTRICTED
	appearance_flags = HAS_HAIR_COLOR
	vision_flags = DEFAULT_SIGHT | SEE_MOBS

	blood_color = "#1F181F"
	flesh_color = "#575757"
	virus_immune = 1
	reagent_tag = IS_MACHINE

	inherent_verbs = list(
		/mob/living/carbon/human/proc/self_destruct,
		/mob/living/carbon/human/proc/detonate_flechettes,
		/mob/living/carbon/human/proc/state_laws
	)

	has_organ = list(
		"brain" = /obj/item/organ/mmi_holder/posibrain/terminator,
		"shielded cell" = /obj/item/organ/cell/terminator,
		"optics" = /obj/item/organ/eyes/optical_sensor/terminator,
		"data core" = /obj/item/organ/data
	)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/terminator),
		"groin" =  list("path" = /obj/item/organ/external/groin/terminator),
		"head" =   list("path" = /obj/item/organ/external/head/terminator),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/terminator),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/terminator),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/terminator),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/terminator),
		"l_hand" = list("path" = /obj/item/organ/external/hand/terminator),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/terminator),
		"l_foot" = list("path" = /obj/item/organ/external/foot/terminator),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/terminator)
		)


	heat_discomfort_level = 2000
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	stamina	= -1
	sprint_speed_factor = 1.25
	slowdown = 1

	sprint_temperature_factor = 0.6
	sprint_charge_factor = 0.3

/datum/species/machine/terminator/get_light_color(hair_style)
	return

/datum/species/machine/terminator/handle_death(var/mob/living/carbon/human/H)
	..()
	playsound(H.loc, 'sound/items/countdown.ogg', 125, 1)
	spawn(15)
		explosion(H.loc, -1, 1, 5)
		H.gib()
