/*
This represents Geras Dionae, the older variant of the species. Coeus can be accessed via the subspecies file, and are the younger variant.
They are very slow, reasonably strong, and quite durable. They also require light to survive, and build nutrition from being exposed to it.
*/
/datum/species/diona
	name = SPECIES_DIONA
	short_name = "dio"
	name_plural = "Dionaea"
	category_name = "Diona"
	bodytype = BODYTYPE_DIONA
	species_height = HEIGHT_CLASS_AVERAGE
	height_min = 100
	height_max = 250
	total_health = 240
	age_min = 1
	age_max = 1000
	default_genders = list(PLURAL)
	selectable_pronouns = list(NEUTER, PLURAL)
	economic_modifier = 7
	icobase = 'icons/mob/human_races/diona/r_diona.dmi'
	deform = 'icons/mob/human_races/diona/r_def_plant.dmi'
	preview_icon = 'icons/mob/human_races/diona/diona_preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	language = LANGUAGE_ROOTSONG
	secondary_langs = list(LANGUAGE_SKRELLIAN, LANGUAGE_AZAZIBA, LANGUAGE_UNATHI)
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/diona
	)
	inherent_verbs = list(
		/mob/living/carbon/human/proc/consume_nutrition_from_air,
		/mob/living/carbon/human/proc/create_structure,
		/mob/living/carbon/human/proc/root_to_ground,
		/mob/living/carbon/proc/sample,
	)
	//primitive_form = "Nymph"
	slowdown = 4
	rarity_value = 4
	hud_type = /datum/hud_data/diona
	siemens_coefficient = 0.3
	eyes = "blank_eyes"
	show_ssd = "completely quiescent"
	num_alternate_languages = 2
	name_language = LANGUAGE_ROOTSONG
	ethanol_resistance = -1	//Can't get drunk
	taste_sensitivity = TASTE_NUMB
	mob_size = 12	//Worker gestalts are 150kg
	remains_type = /obj/effect/decal/cleanable/ash //no bones, so, they just turn into dust
	dust_remains_type = /obj/effect/decal/cleanable/ash
	gluttonous = GLUT_ITEM_ANYTHING|GLUT_SMALLER
	stomach_capacity = 10 //Big boys.
	blurb = "A mysterious plant-like race hailing from the depths of space. Dionae (D. Primis) are a rather strange, cryptic species in comparison to the rest found in the \
	Orion Spur. They have various forms comprised of cat-sized caterpillar-like creatures with a curious, childlike disposition - called Dionae Nymphs. \
	Almost every aspect of the species is a mystery; their origins, their behaviour, and functions. What is known is that they are capable of great intellectual and biological \
	feats that are studied across the Spur. Biologically, Dionae are a form of gestalt consciousness, however, it is only evident in forms that amount to two or more Nymphs.\
	Dionae survive primarily on off of the electromagnetic spectrum and biological matter."

	organ_low_pain_message = "<b>The nymph making up our %PARTNAME% feels injured.</b>"
	organ_med_pain_message = "<b><font size=3>The nymph making up our %PARTNAME% can barely manage the pain!</font></b>"
	organ_high_pain_message = "<b><font size=3>The nymph making up our %PARTNAME% screams out in pain!</font></b>"

	organ_low_burn_message = "<b>The nymph making up our %PARTNAME% notes a burning injury.</b>"
	organ_med_burn_message = SPAN_DANGER("<font size=3>The nymph making up our %PARTNAME% burns terribly!</font>")
	organ_high_burn_message = SPAN_DANGER("<font size=3>The nymph making up our %PARTNAME% screams in agony at the burning!</font>")

	halloss_message = "creaks and crumbles to the floor."
	halloss_message_self = "We can't take this much pain..."
	pain_messages = list("We're in pain", "We hurt so much", "We can't stand the pain")
	pain_item_drop_cry = list("creaks loudly and ", "rustles erratically and ", "twitches for a moment and ")

	natural_armor = list(
		MELEE = ARMOR_MELEE_MEDIUM
	)

	pain_mod = 0.5
	grab_mod = 0.6 // Viney Tentacles and shit to cling onto
	resist_mod = 1.5 // Reasonably stronk, not moreso than an Unathi or robot.

	has_organ = list(BP_STOMACH = /obj/item/organ/internal/stomach/diona)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/diona),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/diona),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/diona),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/diona),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/diona),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/diona),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/diona),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/diona),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/diona),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/diona),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/diona)
		)

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 273
	cold_level_2 = 223
	cold_level_3 = 173

	heat_level_1 = 800 //Default 360 - Higher is better
	heat_level_2 = 850 //Default 400
	heat_level_3 = 1500 //Default 1000

	body_temperature = T0C + 15		//make the plant people have a bit lower body temperature, why not

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_PRESET
	flags = NO_BREATHE | NO_SCAN | IS_PLANT | NO_BLOOD | NO_SLIP | NO_CHUBBY | NO_ARTERIES
	spawn_flags = CAN_JOIN | IS_WHITELISTED | NO_AGE_MINIMUM

	character_color_presets = list("Default Bark" = "#000000", "Light Bark" = "#141414", "Brown Bark" = "#2b1d0e", "Green Bark" = "#001400")

	blood_type = "sap"
	blood_color = COLOR_DIONA_BLOOD
	flesh_color = "#907E4A"

	reagent_tag = IS_DIONA

	climb_coeff = 1.3
	vision_organ = BP_HEAD

	max_hydration_factor = -1

	possible_cultures = list(
		/singleton/origin_item/culture/hieroaetheria,
		/singleton/origin_item/culture/xrim,
		/singleton/origin_item/culture/narrows,
		/singleton/origin_item/culture/diona_biesel,
		/singleton/origin_item/culture/diona_sol,
		/singleton/origin_item/culture/diona_eridani,
		/singleton/origin_item/culture/dionae_moghes,
		/singleton/origin_item/culture/dionae_nralakk,
		/singleton/origin_item/culture/diona_coalition,
		/singleton/origin_item/culture/deep_space,
		/singleton/origin_item/culture/diona_voidtamer
	)

	alterable_internal_organs = list()
	psi_deaf = TRUE

	sleeps_upright = TRUE
	snore_key = "chirp"
	indefinite_sleep = TRUE

	tail = "No Tail"
	tail_animation = 'icons/mob/species/diona/tail.dmi'
	selectable_tails = list("No Tail", "Unathi Tail")

/datum/species/diona/can_understand(var/mob/other)
	var/mob/living/carbon/alien/diona/D = other
	if(istype(D))
		return 1
	return 0

/datum/species/diona/get_vision_organ(mob/living/carbon/human/H)
	return H.organs_by_name[vision_organ]

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	if (ishuman(H))
		return ..()
	else//Most of the stuff in the parent function doesnt apply to nymphs
		add_inherent_verbs(H)

/datum/species/diona/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0)
	if (!gibbed)
		// This proc sleeps. Async it.
		INVOKE_ASYNC(H, TYPE_PROC_REF(/mob/living/carbon/human, diona_split_into_nymphs))

/datum/species/diona/handle_speech_problems(mob/living/carbon/human/H, message, say_verb, message_mode, message_range)
// Diona without head can live, but they cannot talk as loud anymore.
	var/obj/item/organ/external/O = H.organs_by_name[BP_HEAD]
	if(O.is_stump())
		message_range = 3
		return list(HSP_MSGRANGE = message_range)

/datum/species/diona/handle_speech_sound(mob/living/carbon/human/H, list/current_flags)
	current_flags = ..()
	var/obj/item/organ/external/O = H.organs_by_name[BP_HEAD]
	current_flags[3] = O.is_stump()
	return current_flags

/datum/species/diona/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= GLOB.config.health_threshold_dead)
		return TRUE
	return FALSE

/datum/species/diona/handle_despawn(var/mob/living/carbon/human/H)
	for(var/mob/living/carbon/alien/diona/D in H.contents)
		if((!D.client && !D.mind) || D.stat == DEAD)
			qdel(D)

//This handles nymphs, which are the only diona specie that can run, since they don't breathe they just take pain damage instead
/datum/species/diona/handle_sprint_cost(mob/living/carbon/human/H, cost, pre_move)
	if(!pre_move)
		H.adjustHalLoss(cost*0.3)
		H.updatehealth()

	if(H.getHalLoss() > (H.maxHealth*0.6))
		var/shock = H.get_shock()
		if(prob(shock * 2))
			to_chat(H, SPAN_DANGER("You feel a sharp pain in your nervous system! You can't run anymore, or you might die!"))
			H.m_intent = M_WALK

	if(!pre_move)
		H.hud_used.move_intent.update_move_icon(H)
	return 1


/datum/species/diona/after_equip(mob/living/carbon/human/H, visualsOnly, datum/job/J)
	. = ..()
	var/obj/item/storage/box/survival/SB = locate() in H
	if(!SB)
		for(var/obj/item/storage/S in H)
			SB = locate() in S
			if(SB)
				break
	if(SB)
		SB.handle_item_insertion(new /obj/item/device/flashlight/survival(get_turf(H)), TRUE)

/datum/species/diona/is_naturally_insulated()
	return TRUE

/datum/species/diona/bypass_food_fullness(var/mob/living/carbon/human/H)
	return TRUE

/datum/species/diona/sleep_msg(var/mob/M)
	M.visible_message(SPAN_NOTICE("\The [M] creaks, entering an introspective state."))
	to_chat(M, SPAN_NOTICE("You creak, entering an introspective state."))

/datum/species/diona/sleep_examine_msg(var/mob/M)
	return SPAN_NOTICE("[M.get_pronoun("He")] sways and creaks, in a dormant state.\n")
