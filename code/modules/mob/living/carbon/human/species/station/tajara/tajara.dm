/datum/species/tajaran
	name = SPECIES_TAJARA
	short_name = "taj"
	name_plural = "Tajara"
	category_name = "Tajara"
	bodytype = BODYTYPE_TAJARA
	icobase = 'icons/mob/human_races/tajara/r_tajaran.dmi'
	deform = 'icons/mob/human_races/tajara/r_def_tajaran.dmi'
	preview_icon = 'icons/mob/human_races/tajara/tajaran_preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	tail = "tajtail"
	tail_animation = 'icons/mob/species/tajaran/tail.dmi'
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/palm,
		/datum/unarmed_attack/bite/sharp
	)
	maneuvers = list(
		/singleton/maneuver/leap/tajara
	)
	darksight = 8
	slowdown = -1

	brute_mod = 1.2
	fall_mod = 0.5

	grab_mod = 1.25 // Fur easy to cling onto

	age_max = 80

	damage_overlays = 'icons/mob/human_races/masks/dam_tajara.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_tajara.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_tajara.dmi'

	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_YA_SSA)
	name_language = LANGUAGE_SIIK_MAAS
	ethanol_resistance = 0.8//Gets drunk a little faster
	rarity_value = 2
	economic_modifier = 7
	selectable_pronouns = null

	stamina = 90	// Tajara evolved to maintain a steady pace in the snow, sprinting wastes energy
	stamina_recovery = 4
	sprint_speed_factor = 0.65
	sprint_cost_factor = 0.75
	standing_jump_range = 3
	bp_base_systolic = 140 // Default 120
	bp_base_disatolic = 90 // Default 80
	low_pulse = 50 // Default 40
	norm_pulse = 70 // Default 60
	fast_pulse = 100 // Default 90
	v_fast_pulse = 130 // Default 120
	max_pulse = 170 // Default 160

	hearing_sensitivity = HEARING_SENSITIVE // Default HEARING_NORMAL

	blurb = "The Tajaran race is a species of feline-like bipeds hailing from the planet of Adhomai in the S'rendarr \
	system. They have been brought up into the space age by the Humans and Skrell, who alledgedly influenced their \
	eventual revolution that overthrew their ancient monarchies to become totalitarian - and NanoTrasen friendly - \
	republics. Adhomai is still enduring a global war in the aftermath of the new world order, and many Tajara are \
	fleeing their homeworld to seek safety and employment in human space. They prefer colder environments, and speak \
	a variety of languages, mostly Siik'Maas, using unique inflections their mouths form."

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80  //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive_form = SPECIES_MONKEY_TAJARA

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	flesh_color = "#AFA59E"
	base_color = "#333333"

	reagent_tag = IS_TAJARA

	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your fur prickles in the heat.",
		"You feel uncomfortably warm.",
		"Your overheated skin itches."
	)
	cold_discomfort_level = 275

	move_trail = /obj/effect/decal/cleanable/blood/tracks/paw

	default_h_style = "Tajaran Ears"

	possible_cultures = list(
		/singleton/origin_item/culture/adhomian,
		/singleton/origin_item/culture/offworld_tajara
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tie_hair)

	zombie_type = SPECIES_ZOMBIE_TAJARA

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/tajara,
		BP_LUNGS =    /obj/item/organ/internal/lungs/tajara,
		BP_LIVER =    /obj/item/organ/internal/liver/tajara,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/tajara,
		BP_STOMACH =  /obj/item/organ/internal/stomach/tajara,
		BP_BRAIN =    /obj/item/organ/internal/brain/tajara,
		BP_APPENDIX = /obj/item/organ/internal/appendix/tajara,
		BP_EYES =     /obj/item/organ/internal/eyes/night
		)

	stomach_capacity = 6

	max_nutrition_factor = 1.2
	max_hydration_factor = 1.2

	nutrition_loss_factor = 0.8
	hydration_loss_factor = 0.8
	metabolism_mod = 0.8

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai

/datum/species/tajaran/after_equip(var/mob/living/carbon/human/H)
	. = ..()
	if(H.shoes)
		return
	var/obj/item/clothing/shoes/sandal/S = new /obj/item/clothing/shoes/sandal(H)
	H.equip_to_slot_or_del(S,slot_shoes)
