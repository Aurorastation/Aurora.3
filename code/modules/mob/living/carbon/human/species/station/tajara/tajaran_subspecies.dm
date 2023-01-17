/datum/species/tajaran/zhan_khazan
	name = SPECIES_TAJARA_ZHAN
	name_plural = "Zhan-Khazan Tajara"
	blurb = "The Zhan-Khazan are a race of Tajara known for their dark fur and large bulky figures. \
	They were at one point a race of cave-and-mountain dwelling Tajara that traditionally were \
	entrusted with physical work like mining, farming, ranching, and logging. Zhan-Khazan make \
	up a significant amount of Tajara employed in resource gathering, construction, civil jobs \
	such as law enforcement and even culinary work such as butchering. They experience a lot of racism \
	from their fellow Tajara who cite their lackluster test scores, even among Tajara, and their higher \
	crime rates."

	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_DELVAHII)

	slowdown = -0.8 //As opposed to -1 for Base tajara
	sprint_speed_factor = 0.55 // As opposed to 0.65
	standing_jump_range = 2
	stamina = 100 // As opposed to 90
	brute_mod = 1.1 // Less Brute Damage
	ethanol_resistance = 1 // Default value
	climb_coeff = 1.1

	maneuvers = list(
		/singleton/maneuver/leap
	)

	resist_mod = 1.5 // ZHAN POWERRRRRR

	cold_level_1 = 160 //RaceDefault 200 Default 260
	cold_level_2 = 100 //RaceDefault 140 Default 200
	cold_level_3 = 50  //RaceDefault 80 Default 120

	heat_level_1 = 320 //RaceDefault 330 Default 360
	heat_level_2 = 360 //RaceDefault 380 Default 400
	heat_level_3 = 700 //RaceDefault 800 Default 1000

	stomach_capacity = 7

	max_nutrition_factor = 1.3
	max_hydration_factor = 1.3

	nutrition_loss_factor = 0.7
	hydration_loss_factor = 0.7

	possible_cultures = list(
		/singleton/origin_item/culture/adhomian/zhan,
		/singleton/origin_item/culture/offworld_tajara/zhan
	)

/datum/species/tajaran/m_sai
	name = SPECIES_TAJARA_MSAI
	name_plural = "M'sai Tajara"
	blurb = "The M'sai are a race of Tajara with slender lithe bodies and \
	lightly covered fur which blends in with the snowy environments of Adhomai. \
	They aren't as well-insulated against Adhomai's cold as their brethren. \
	However, this gives them the benefit of being more agile. Hitorically, they often \
	worked as hunters, later becoming warriors and soldiers as civilization developed."

	slowdown = -1.2 //As opposed to -1 for Base tajara
	sprint_speed_factor = 0.75 // As opposed to 0.65
	standing_jump_range = 3
	stamina = 80 // As opposed to 90
	brute_mod = 1.3 // More Brute Damage
	ethanol_resistance = 0.6 // Species Default 0.8

	maneuvers = list(
		/singleton/maneuver/leap/tajara/msai
	)

	cold_level_1 = 220 //RaceDefault 200 Default 260
	cold_level_2 = 160 //RaceDefault 140 Default 200
	cold_level_3 = 100  //RaceDefault 80 Default 120

	heat_level_1 = 340 //RaceDefault 330 Default 360
	heat_level_2 = 390 //RaceDefault 380 Default 400
	heat_level_3 = 900 //RaceDefault 800 Default 1000

	hearing_sensitivity = HEARING_VERY_SENSITIVE // Species default 1

	default_h_style = "M'sai Ears"

	secondary_langs = list(LANGUAGE_SIIK_MAAS, LANGUAGE_SIIK_TAJR, LANGUAGE_SIGN_TAJARA)

	max_nutrition_factor = 1.2
	max_hydration_factor = 1.2

	nutrition_loss_factor = 0.9
	hydration_loss_factor = 0.9

	possible_cultures = list(
		/singleton/origin_item/culture/adhomian/msai,
		/singleton/origin_item/culture/offworld_tajara/msai
	)

/datum/species/tajaran/tesla_body
	name = SPECIES_TAJARA_TESLA_BODY
	name_plural = "Tesla Rejuvenation Suit Tajara"
	name_plural = "Created as part of the Tesla prosthetics program, the Tesla Rejuvenation Suit is a hulking suit that allows disabled Tajara to regain their vigor. \
	Its users are surgically grafted in the machine; their limbs are replaced by large, industrial replacements; their organs are placed in a tank full of healing chemicals \
	located inside their chest, and finally, a big tesla spine is installed. Only the head remains untouched. The suits are bulky and clumsy, restricting their wearers to jobs \
	involving weight lifting and other menial tasks. Since this invention is still in its early stage, reports of it malfunctioning or causing pain to its user are not unheard off; \
	however, the government is quick to claim that these are only subversive rumors. Because of extensive augmentation, Tajaran in these suits reports loss of sensations everywhere \
	except the face. The Rejuvenation Suit is only granted to loyal Hadiist Tajara living in the People's Republic. Tajara wearing it are colloquially called \"steelsuits\"."

	spawn_flags = IS_RESTRICTED
	bodytype = BODYTYPE_TESLA_BODY

	icon_x_offset = -8
	healths_x = 22
	healths_overlay_x = 9
	floating_chat_x_offset = 6

	slowdown = 2
	fall_mod = 1.2

	grab_mod = 3
	resist_mod = 3
	break_cuffs = TRUE
	mob_size = 25

	default_h_style = "Tesla Rejuvenation Suit Ears"

	eyes_icons = 'icons/mob/human_face/eyes48x48.dmi'
	eyes = "eyes_tesla_body"

	icon_template = 'icons/mob/human_races/tajara/r_tesla_body.dmi'
	icobase = 'icons/mob/human_races/tajara/r_tesla_body.dmi'
	deform = 'icons/mob/human_races/tajara/r_tesla_body.dmi'
	preview_icon = 'icons/mob/human_races/tajara/tesla_body_preview.dmi'
	canvas_icon = 'icons/mob/base_48.dmi'
	bandages_icon = null
	tail = null
	tail_animation = null

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/tesla_body,
		/datum/unarmed_attack/bite/sharp
	)

	maneuvers = list(
		/singleton/maneuver/leap/tesla_body
	)

	damage_overlays = 'icons/mob/human_races/masks/dam_mask_tesla_body.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_tesla_body.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_tesla_body.dmi'

	stamina = 30
	stamina_recovery = 3
	sprint_speed_factor = 0.25
	sprint_cost_factor = 0.25
	standing_jump_range = 1

	injection_mod = 2
	has_fine_manipulation = FALSE

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/tajara/tesla_body,
		BP_LUNGS =    /obj/item/organ/internal/lungs/tajara,
		BP_LIVER =    /obj/item/organ/internal/liver/tajara,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/tajara,
		BP_STOMACH =  /obj/item/organ/internal/stomach/tajara,
		BP_BRAIN =    /obj/item/organ/internal/brain/tajara,
		BP_APPENDIX = /obj/item/organ/internal/appendix/tajara,
		BP_EYES =     /obj/item/organ/internal/eyes/night,
		BP_AUG_TESLA = /obj/item/organ/internal/augment/tesla/massive
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/tesla_body),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/tesla_body),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/tesla_body),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/tesla_body),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/tesla_body),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/tesla_body),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/tesla_body),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/tesla_body),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/tesla_body),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/tesla_body)
	)

/datum/species/tajaran/tesla_body/New()
	..()
	equip_adjust = list(
		slot_head_str    = list(                                     "[EAST]" = list("x" = 16, "y" = 0),  "[SOUTH]" = list("x" = 9, "y" = 0), "[WEST]" = list("x" = 0, "y" = 0)),
		slot_glasses_str = list(                                     "[EAST]" = list("x" = 15, "y" = 0),  "[SOUTH]" = list("x" = 9, "y" = 0), "[WEST]" = list("x" = 1, "y" = 0)),
		slot_l_hand_str  = list("[NORTH]" = list("x" = 6, "y" = 0),  "[EAST]" = list("x" = 9, "y" = 2),  "[SOUTH]" = list("x" = 12, "y" = 0), "[WEST]" = list("x" = 4, "y" = 0)),
		slot_r_hand_str  = list("[NORTH]" = list("x" = 12, "y" = 0), "[EAST]" = list("x" = 12, "y" = 0), "[SOUTH]" = list("x" = 6, "y" = 0),  "[WEST]" = list("x" = 7, "y" = 2)),
		slot_l_ear_str   = list(                                     "[EAST]" = list("x" = 0, "y" = 0),  "[SOUTH]" = list("x" = 9, "y" = 0),  "[WEST]" = list("x" = 0, "y" = 0)),
		slot_r_ear_str   = list(                                     "[EAST]" = list("x" = 16, "y" = 0), "[SOUTH]" = list("x" = 9, "y" = 0),  "[WEST]" = list("x" = 0, "y" = 0)),
		slot_belt_str    = list("[NORTH]" = list("x" = 9, "y" = 2),  "[EAST]" = list("x" = 10, "y" = 1), "[SOUTH]" = list("x" = 9, "y" = 2),  "[WEST]" = list("x" = 6, "y" = 1)),
		slot_wear_id_str = list("[NORTH]" = list("x" = 0, "y" = 0),  "[EAST]" = list("x" = 12, "y" = 0), "[SOUTH]" = list("x" = 9, "y" = 0),  "[WEST]" = list("x" = 0, "y" = 0)),
		slot_wrists_str  = list("[NORTH]" = list("x" = 15, "y" = 0), "[EAST]" = list("x" = 12, "y" = 0), "[SOUTH]" = list("x" = 4, "y" = 0),  "[WEST]" = list("x" = 9, "y" = 0)),
		slot_shoes_str   = list("[NORTH]" = list("x" = 9, "y" = 0),  "[EAST]" = list("x" = 8, "y" = 0),  "[SOUTH]" = list("x" = 9, "y" = 0),  "[WEST]" = list("x" = 8, "y" = 0))
	)

/datum/species/tajaran/tesla_body/can_double_fireman_carry()
	return TRUE