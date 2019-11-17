/datum/species/vox
	name = "Vox"
	short_name = "vox"
	name_plural = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = LANGUAGE_VOX
	name_language = LANGUAGE_VOX
	num_alternate_languages = 1
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	rarity_value = 4
	blurb = "The Vox are the broken remnants of a once-proud race, now reduced to little more than \
	scavenging vermin who prey on isolated stations, ships or planets to keep their own ancient arkships \
	alive. They are four to five feet tall, reptillian, beaked, tailed and quilled; human crews often \
	refer to them as 'shitbirds' for their violent and offensive nature, as well as their horrible \
	smell.<br/><br/>Most humans will never meet a Vox raider, instead learning of this insular species through \
	dealing with their traders and merchants; those that do rarely enjoy the experience."

	fall_mod = 0.25 //nimble, winged little shitbirds

	stamina	=	120			  // Vox are even faster than unathi and can go longer, but recover slowly
	sprint_speed_factor = 3
	stamina_recovery = 1
	sprint_cost_factor = 1

	taste_sensitivity = TASTE_DULL

	speech_sounds = list('sound/voice/shriek1.ogg')
	speech_chance = 20

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	eyes = "vox_eyes_s"
	gluttonous = TRUE
	virus_immune = 1

	breath_type = "nitrogen"
	poison_type = "oxygen"
	siemens_coefficient = 0.2

	flags = NO_SCAN
	spawn_flags = IS_RESTRICTED
	appearance_flags = HAS_EYE_COLOR | HAS_HAIR_COLOR

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	reagent_tag = IS_VOX

	inherent_verbs = list(
		/mob/living/carbon/human/proc/leap
		)

	has_organ = list(
		"heart" =    /obj/item/organ/heart/vox,
		"lungs" =    /obj/item/organ/lungs/vox,
		"liver" =    /obj/item/organ/liver/vox,
		"kidneys" =  /obj/item/organ/kidneys/vox,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes,
		"stack" =    /obj/item/organ/stack/vox
		)

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw

	default_h_style = "Short Vox Quills"

/datum/species/vox/before_equip(mob/living/carbon/human/H, visualsOnly, datum/job/J)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/tank/nitrogen(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H), slot_r_hand)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/tank/nitrogen(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H.back), slot_in_backpack)
		H.internal = H.r_hand
	H.internals.icon_state = "internal1"
	H.gender = NEUTER

/datum/species/vox/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()

/datum/species/vox/get_station_variant()
	return "Vox Pariah"

// Joining as a station vox will give you this template, hence IS_RESTRICTED flag.
/datum/species/vox/pariah
	name = "Vox Pariah"
	rarity_value = 0.1
	speech_chance = 60        // No volume control.
	siemens_coefficient = 0.5 // Ragged scaleless patches.

	total_health = 80

	fall_mod = 0.8

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws, /datum/unarmed_attack/bite)

	// Pariahs have no stack.
	has_organ = list(
		"heart" =    /obj/item/organ/heart/vox,
		"lungs" =    /obj/item/organ/lungs/vox,
		"liver" =    /obj/item/organ/liver/vox,
		"kidneys" =  /obj/item/organ/kidneys/vox,
		"brain" =    /obj/item/organ/pariah_brain,
		"eyes" =     /obj/item/organ/eyes
		)
	spawn_flags = IS_RESTRICTED

	stamina	=	60
	sprint_speed_factor = 2
	stamina_recovery = 0.5
	sprint_cost_factor = 0.5

// No combat skills for you.
/datum/species/vox/pariah/can_shred(var/mob/living/carbon/human/H, var/ignore_intent)
	return 0

// Pariahs are really gross.
/datum/species/vox/pariah/handle_environment_special(var/mob/living/carbon/human/H)
	if(prob(5))
		var/datum/gas_mixture/vox = H.loc.return_air()
		var/stink_range = rand(3,5)
		for(var/mob/living/M in range(H,stink_range))
			if(M.stat || M == H || issilicon(M) || isbrain(M))
				continue
			var/datum/gas_mixture/mob_air = M.loc.return_air()
			if(!vox || !mob_air || vox != mob_air)
				continue
			var/mob/living/carbon/human/target = M
			if(istype(target))
				if(target.internal)
					continue
				if(target.head && (target.head.body_parts_covered & FACE) && (target.head.flags & AIRTIGHT))
					continue
				if(target.wear_mask && (target.wear_mask.body_parts_covered & FACE) && (target.wear_mask.flags & BLOCK_GAS_SMOKE_EFFECT))
					continue
				if(target.species.flags & NO_BREATHE)
					continue
			to_chat(M, "<span class='danger'>A terrible stench emanates from \the [H].</span>")

/datum/species/vox/pariah/get_bodytype()
	return "Vox"

/datum/species/vox/armalis
	name = "Vox Armalis"
	name_plural = "Vox"
	icobase = 'icons/mob/human_races/r_armalis.dmi'
	deform = 'icons/mob/human_races/r_armalis.dmi'
	tail = "armalis_tail"
	rarity_value = 10

	warning_low_pressure = 50
	hazard_low_pressure = 0

	stamina	=	120			  // Vox are even faster than unathi and can go longer, but recover slowly
	sprint_speed_factor = 3
	stamina_recovery = 1
	sprint_cost_factor = 0.7

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	brute_mod = 0.2
	burn_mod = 0.2
	fall_mod = 0.5

	eyes = "blank_eyes"
	breath_type = "nitrogen"
	poison_type = "oxygen"

	flags = NO_SCAN | NO_PAIN
	spawn_flags = IS_RESTRICTED

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	tail = "armalis_tail"
	icon_template = 'icons/mob/human_races/r_armalis.dmi'

	reagent_tag = IS_VOX

	inherent_verbs = list(
		/mob/living/carbon/human/proc/leap,
		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/commune,
		/mob/living/carbon/human/proc/quillboar,
		/mob/living/carbon/human/proc/sonar_ping
		)

