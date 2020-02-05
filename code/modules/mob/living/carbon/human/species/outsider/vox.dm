/datum/species/vox
	name = "Vox"
	short_name = "vox"
	name_plural = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = LANGUAGE_VOX
	name_language = LANGUAGE_VOX
	num_alternate_languages = 1
	default_genders = list(NEUTER)
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
	gluttonous = 2
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
		BP_HEART =    /obj/item/organ/internal/heart/vox,
		BP_LUNGS =    /obj/item/organ/internal/lungs/vox,
		BP_LIVER =    /obj/item/organ/internal/liver/vox,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/vox,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes,
		"stack" =    /obj/item/organ/internal/stack/vox
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

/datum/species/vox/armalis/can_commune()
	return TRUE