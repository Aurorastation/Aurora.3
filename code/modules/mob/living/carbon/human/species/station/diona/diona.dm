/datum/species/diona
	name = "Diona"
	short_name = "dio"
	name_plural = "Dionaea"
	bodytype = "Diona"
	age_max = 1000
	economic_modifier = 3
	icobase = 'icons/mob/human_races/diona/r_diona.dmi'
	deform = 'icons/mob/human_races/diona/r_def_plant.dmi'
	preview_icon = 'icons/mob/human_races/diona/diona_preview.dmi'
	language = LANGUAGE_ROOTSONG
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/diona
	)
	inherent_verbs = list(
		/mob/living/carbon/human/proc/consume_nutrition_from_air
	)
	//primitive_form = "Nymph"
	slowdown = 7
	rarity_value = 4
	hud_type = /datum/hud_data/diona
	siemens_coefficient = 0.3
	eyes = "blank_eyes"
	show_ssd = "completely quiescent"
	num_alternate_languages = 1
	name_language = LANGUAGE_ROOTSONG
	ethanol_resistance = -1	//Can't get drunk
	taste_sensitivity = TASTE_DULL
	mob_size = 12	//Worker gestalts are 150kg
	remains_type = /obj/effect/decal/cleanable/ash //no bones, so, they just turn into dust
	blurb = "Commonly referred to (erroneously) as 'plant people', the Dionaea are a strange space-dwelling collective \
	species hailing from Epsilon Ursae Minoris. Each 'diona' is a cluster of numerous cat-sized organisms called nymphs; \
	there is no effective upper limit to the number that can fuse in gestalt, and reports exist	of the Epsilon Ursae \
	Minoris primary being ringed with a cloud of singing space-station-sized entities.<br/><br/>The Dionaea coexist peacefully with \
	all known species, especially the Skrell. Their communal mind makes them slow to react, and they have difficulty understanding \
	even the simplest concepts of other minds. Their alien physiology allows them survive happily off a diet of nothing but light, \
	water and other radiation."

	grab_mod = 1.1

	has_organ = list(
		"nutrient channel"   = /obj/item/organ/diona/nutrients,
		"neural strata"      = /obj/item/organ/diona/strata,
		"response node"      = /obj/item/organ/diona/node,
		"gas bladder"        = /obj/item/organ/diona/bladder,
		"polyp segment"      = /obj/item/organ/diona/polyp,
		"anchoring ligament" = /obj/item/organ/diona/ligament
	)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/diona),
		"groin" =  list("path" = /obj/item/organ/external/groin/diona),
		"head" =   list("path" = /obj/item/organ/external/head/diona),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/diona),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/diona),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/diona),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/diona),
		"l_hand" = list("path" = /obj/item/organ/external/hand/diona),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/diona),
		"l_foot" = list("path" = /obj/item/organ/external/foot/diona),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/diona)
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

	appearance_flags = HAS_HAIR_COLOR
	flags = NO_BREATHE | NO_SCAN | IS_PLANT | NO_BLOOD | NO_PAIN | NO_SLIP | NO_CHUBBY
	spawn_flags = CAN_JOIN | IS_WHITELISTED | NO_AGE_MINIMUM

	blood_color = "#97dd7c"
	flesh_color = "#907E4A"

	reagent_tag = IS_DIONA

	stamina = -1	// Diona sprinting uses energy instead of stamina
	sprint_speed_factor = 0.5	//Speed gained is minor
	sprint_cost_factor = 0.8
	climb_coeff = 1.3
	vision_organ = "head"

	max_hydration_factor = -1

	allowed_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_JARGON, CITIZENSHIP_SOL, CITIZENSHIP_FRONTIER, CITIZENSHIP_DOMINIA, CITIZENSHIP_IZWESKI, CITIZENSHIP_NONE)
	allowed_religions = list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_MOROZ, RELIGION_THAKH, RELIGION_SKAKH, RELIGION_NONE, RELIGION_OTHER)

/datum/species/diona/handle_sprint_cost(var/mob/living/carbon/H, var/cost)
	var/datum/dionastats/DS = H.get_dionastats()

	if (!DS)
		return 0 //Something is very wrong

	var/remainder = cost * H.sprint_cost_factor

	if (H.total_radiation && !DS.regening_organ)
		if (H.total_radiation > (cost*0.5))//Radiation counts as double energy
			H.apply_radiation(cost*(-0.5))
			return 1
		else
			remainder = cost - (H.total_radiation*2)
			H.total_radiation = 0

	if (DS.stored_energy > remainder)
		DS.stored_energy -= remainder
		return 1
	else
		remainder -= DS.stored_energy
		DS.stored_energy = 0
		H.adjustHalLoss(remainder*5, 1)
		H.updatehealth()
		H.m_intent = "walk"
		H.hud_used.move_intent.update_move_icon(H)
		to_chat(H, span("danger", "We have expended our energy reserves, and cannot continue to move at such a pace. We must find light!"))
		return 0

/datum/species/diona/can_understand(var/mob/other)
	var/mob/living/carbon/alien/diona/D = other
	if(istype(D))
		return 1
	return 0

/datum/species/diona/get_vision_organ(mob/living/carbon/human/H)
	return H.organs_by_name[vision_organ]

/datum/species/diona/equip_later_gear(var/mob/living/carbon/human/H)
	if(istype(H.get_equipped_item(slot_back), /obj/item/storage/backpack))
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H.back), slot_in_backpack)
	else
		H.equip_to_slot_or_del(new /obj/item/device/flashlight/flare(H), slot_r_hand)

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	if (ishuman(H))
		return ..()
	else//Most of the stuff in the parent function doesnt apply to nymphs
		add_inherent_verbs(H)

/datum/species/diona/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0)
	if (!gibbed)
		// This proc sleeps. Async it.
		INVOKE_ASYNC(H, /mob/living/carbon/human/proc/diona_split_into_nymphs)

/datum/species/diona/handle_speech_problems(mob/living/carbon/human/H, list/current_flags, message, message_verb, message_mode)
// Diona without head can live, but they cannot talk as loud anymore.
	var/obj/item/organ/external/O = H.organs_by_name["head"]
	current_flags[4] = O.is_stump() ? 3 : world.view
	return current_flags

/datum/species/diona/handle_speech_sound(mob/living/carbon/human/H, list/current_flags)
	current_flags = ..()
	var/obj/item/organ/external/O = H.organs_by_name["head"]
	current_flags[3] = O.is_stump()
	return current_flags
