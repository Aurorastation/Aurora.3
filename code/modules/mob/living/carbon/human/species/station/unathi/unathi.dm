/datum/species/unathi
	name = SPECIES_UNATHI
	short_name = "una"
	name_plural = "Azaziba"
	category_name = "Unathi"
	bodytype = BODYTYPE_UNATHI
	species_height = HEIGHT_CLASS_HUGE
	height_min = 200
	height_max = 250
	age_min = 18
	selectable_pronouns = list(NEUTER, MALE, FEMALE, PLURAL)
	icobase = 'icons/mob/human_races/unathi/r_unathi.dmi'
	deform = 'icons/mob/human_races/unathi/r_def_unathi.dmi'
	preview_icon = 'icons/mob/human_races/unathi/unathi_preview.dmi'
	skeleton_icon = 'icons/mob/human_races/unathi/unathi_skeleton.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	tail = "Tail"
	tail_animation = 'icons/mob/species/unathi/tail.dmi'
	selectable_tails = list("Tail", "Damaged Tail", "Stubby Tail")
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws/strongunathi,
		/datum/unarmed_attack/palm/unathi,
		/datum/unarmed_attack/bite/strongunathi
	)
	primitive_form = SPECIES_MONKEY_UNATHI
	default_lighting_alpha = LIGHTING_PLANE_ALPHA_ALMOST_VISIBLE
	gluttonous = GLUT_MESSY|GLUT_ITEM_TINY
	stomach_capacity = 7
	max_nutrition_factor = 1.4
	max_hydration_factor = 1.4
	nutrition_loss_factor = 0.7
	hydration_loss_factor = 0.7

	mob_strength = MOB_STRENGTH_STRONG
	pain_mod = 0.9				// Crocodilian pain tolerance
	fall_mod = 1.2				// They are heavy and ungraceful.
	grab_mod = 1.5				// Huge, usually have horns
	resist_mod = 2.5 			// Arguably our strongest organic species

	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_SMALL,
		melee = ARMOR_MELEE_MEDIUM,
		laser = ARMOR_LASER_MINOR,
		rad =  ARMOR_RAD_SMALL
	)							// Crocodilian integumentary system

	ethanol_resistance = 0.8
	taste_sensitivity = TASTE_SENSITIVE
	economic_modifier = 9

	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	name_language = LANGUAGE_UNATHI

	stamina	=	120			 // Azaziba are ambush predators
	stamina_recovery = 5

	slowdown = 0.5 				// They are generally lethargic
	sprint_cost_factor = 1.5		// Their high-speed low-duration sprint is very well known at this time and remains
	sprint_speed_factor = 2
	exhaust_threshold = 65
	bp_base_systolic = 80		// Default 120
	bp_base_disatolic = 50		// Default 80
	low_pulse = 20				// Default 40
	norm_pulse = 40				// Default 60
	fast_pulse = 60				// Default 90
	v_fast_pulse = 80			// Default 120
	max_pulse = 100				// Default 160
	body_temperature = T0C + 24

	rarity_value = 3
	break_cuffs = TRUE
	mob_size = 11
	mob_weight = MOB_WEIGHT_HEAVY
	climb_coeff = 1.35
	standing_jump_range = 1

	blurb = "Sinta'unathi (Unathi by outsiders, Sinta by themselves) are a reptilian species native to \
	Moghes, a planet in the Uueoa-Esa system in the Badlands. First contact was made with them in 2403, \
	and they have since become a major player in galactic politics. Often known for their martial prowess, \
	they are a storied and proud species, with a history of honor, tradition and spirituality.<br><br>\
	Azaziba sinta hail from the Thuykreshani continent of Moghes, and are a larger, more ofen crocodilian \
	variant of sinta that are known for relying on brute strength and ambush tactics. \
	Often mistakenly viewed by outsiders as the standard species of unathi, they are not the first species \
	of unathi to be encountered. Being seen as a more aggressive species when compared to Urawani sinta, they are \
	often viewed as wild, unpredictable and dangerous by humans. Azaziba simply view themselves as \
	a more storied, traditional and culturally diverse variant of sinta, and are often more traditionalist \
	than their cousins, whereas Urawani sinta simply view Azaziba as no more inherently dangerous than themselves."

	cold_level_1 = 270 //Default 260 - Lower is better
	cold_level_2 = 210 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 400 //Default 360 - Higher is better
	heat_level_2 = 440 //Default 400
	heat_level_3 = 1040 //Default 1000

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tongue_flick
	)


	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#34AF10"

	reagent_tag = IS_UNATHI
	base_color = "#066000"

	heat_discomfort_level = 308 // 35°C
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

	footsound = SFX_FOOTSTEP_UNATHI

	has_organ = list(
		BP_BRAIN =    /obj/item/organ/internal/brain/unathi,
		BP_EYES =    /obj/item/organ/internal/eyes/unathi,
		BP_HEART =    /obj/item/organ/internal/heart/unathi,
		BP_LIVER =    /obj/item/organ/internal/liver/unathi,
		BP_LUNGS =    /obj/item/organ/internal/lungs/unathi,
		BP_KIDNEYS =    /obj/item/organ/internal/kidneys/unathi,
		BP_STOMACH =    /obj/item/organ/internal/stomach/unathi
	)

	alterable_internal_organs = list(BP_HEART, BP_EYES, BP_LUNGS, BP_LIVER, BP_KIDNEYS, BP_STOMACH)

	pain_messages = list("It hurts so much", "You really need some painkillers", "Ancestors, it hurts")

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	possible_cultures = list(
		/singleton/origin_item/culture/izweski,
		/singleton/origin_item/culture/traditionalists,
		/singleton/origin_item/culture/spaceborn,
		/singleton/origin_item/culture/dominian_unathi,
		/singleton/origin_item/culture/queendom,
		/singleton/origin_item/culture/autakh
	)

	zombie_type = SPECIES_ZOMBIE_UNATHI

	possible_external_organs_modifications = list("Normal","Amputated","Prosthesis", "Diona Nymph")
	valid_prosthetics = list(PROSTHETIC_AUTAKH)
	mass_modifier = REFERENCE_MASS_UNATHI / REFERENCE_MASS_HUMAN

	character_color_presets = list(
		"Szera: Skalamar Red" = "#A02C2C",

		"Thuy: Janvir Black" = "#1C1C1C"
	)

/datum/species/unathi/after_equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.shoes)
		return
	var/obj/item/clothing/shoes/sandals/S = new /obj/item/clothing/shoes/sandals(H)
	H.equip_to_slot_or_del(S,slot_shoes)
