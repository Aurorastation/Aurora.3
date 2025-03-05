/datum/species/bug/type_b
	name = SPECIES_VAURCA_WARRIOR
	name_plural = "Type BA"
	language = LANGUAGE_VAURCA
	species_height = HEIGHT_CLASS_TALL
	height_min = 150
	height_max = 250
	primitive_form = SPECIES_VAURCA_WORKER
	greater_form = SPECIES_VAURCA_BREEDER
	icobase = 'icons/mob/human_races/vaurca/r_vaurcab.dmi'
	slowdown = 0

	brute_mod = 0.8
	oxy_mod = 1
	radiation_mod = 0.5
	standing_jump_range = 3
	bleed_mod = 1.5
	burn_mod = 1.0
	grab_mod = 1.25
	resist_mod = 2.5 //Most are weaker then a Unathi, but have an evolutionary disposition towards close-combat.

	mob_size = 10 //fairly lighter than the worker type.
	taste_sensitivity = TASTE_DULL
	blurb = "Type BA, a sub-type of the generic Type B Warriors, are the second most prominent type of Vaurca society, taking the form of hive security and military grunts. \
	Type BA can range in size from 6ft tall to 9ft tall, and are bipedal. Unlike most other Type B's, Type BA are deprived of advanced augments, especially aboard \
	SCC facilities. Warriors in general, unlike other types of Vaurca, are not typically passive. This means that they tend to be more suitable for combat \
	orientated positions, more passive unlike workers. Compared to workers, they are more physically intimidating and more resistant to heat, but have a thinner carapace \
	allowing for greater mobility at the cost of some trauma resistance. \
	<b>Type BA are most comfortable obviously in security positions, but can rarely be found in the lower hierarchies of other departments.</b>"

	heat_level_1 = 360 //Default 360
	heat_level_2 = 400 //Default 400
	heat_level_3 = 800 //Default 1000

	stamina = 115
	sprint_speed_factor = 1.0
	sprint_cost_factor = 0.40
	stamina_recovery = 3

	unarmed_types = list(
		/datum/unarmed_attack/bite/warrior,
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/palm
	)

	valid_prosthetics = list(PROSTHETIC_VAURCA, PROSTHETIC_VAURCA_WARRIOR)

	character_color_presets = list(
		"Zo'ra: Unbound Vaur" = "#3D0000",
		"Zo'ra: Unbound Zoleth" = "#650015",
		"Zo'ra: Unbound Athvur" = "#83290B",
		"Zo'ra: Unbound Scay" = "#47001F",
		"Zo'ra: Unbound Xakt" = "#5B1F00",

		"K'lax: Unbound Zkaii" = "#0B2B1B",
		"K'lax: Unbound Tupii" = "#299617",
		"K'lax: Unbound Vedhra" = "#829614",
		"K'lax: Unbound Leto" = "#00503C",
		"K'lax: Unbound Vetju" = "#0B541F",

		"C'thur: Unbound C'thur" = "#002373",
		"C'thur: Unbound Vytel" = "#141437",
		"C'thur: Unbound Mouv" = "#96B4FF",
		"C'thur: Unbound Xetl" = "#370078"
	)

/datum/species/bug/type_b/type_bb
	name = SPECIES_VAURCA_ATTENDANT
	name_plural = "Type BB"
	species_height = HEIGHT_CLASS_HUGE
	icobase = 'icons/mob/human_races/vaurca/r_vaurcabb.dmi'
	eyes = "vaurca_attendant_eyes"

	slowdown = -0.8
	brute_mod = 0.9
	oxy_mod = 1
	radiation_mod = 0.5
	bleed_mod = 2.5
	burn_mod = 1.2
	sprint_speed_factor = 0.6
	sprint_cost_factor = 0.40
	grab_mod = 1.1
	resist_mod = 4
	standing_jump_range = 3
	pain_mod = 1.5

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/palm
	)

	mob_size = 8
	blurb = "Type BB Warriors or \"Attendants\" are digitigrade bipeds, built to be agile and quick. They are primarily made to be scouts or serve in support positions and \
	they excel at guerilla tactics. They can possess the same roles as regular warriors, but their speed-built forms are not as hardy. They are commonly attributed to the \
	role of combat medics, providing medical assistance on the field, or removal of the neural socket if the individual cannot be saved." //Copied from the wiki

	stamina = 100

	tail = "Gaster"
	tail_animation = 'icons/mob/species/vaurca/tail.dmi'
	selectable_tails = list("Gaster")

/datum/species/bug/type_b/type_bb/New()
	..()
	default_emotes += /singleton/emote/audible/rattle // Appends an emote unique to Attendants.

/datum/species/bug/type_b/type_bb/can_hold_s_store(obj/item/I)
	if(I.w_class <= WEIGHT_CLASS_NORMAL)
		return TRUE
	return FALSE

/datum/species/bug/type_c
	name = SPECIES_VAURCA_BREEDER
	short_name = "vab"
	name_plural = "Type CB"
	bodytype = BODYTYPE_VAURCA_BREEDER
	primitive_form = SPECIES_VAURCA_WARRIOR
	species_height = HEIGHT_CLASS_GIGANTIC
	height_min = 220
	height_max = 335
	icon_template = 'icons/mob/human_races/vaurca/r_vaurcac.dmi'
	icobase = 'icons/mob/human_races/vaurca/r_vaurcac.dmi'
	deform = 'icons/mob/human_races/vaurca/r_vaurcac.dmi'
	icon_x_offset = -8
	floating_chat_x_offset = 8
	floating_chat_y_offset = 24
	typing_indicator_x_offset = 16
	typing_indicator_y_offset = 12
	healths_x = 22
	healths_overlay_x = 9
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick,  /datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)
	rarity_value = 10
	slowdown = 2
	eyes = "breeder_eyes" //makes it so that eye colour is not changed when skin colour is.
	eyes_icons = 'icons/mob/human_face/eyes48x48.dmi'
	grab_mod = 4
	toxins_mod = 1 //they're not used to all our weird human bacteria.
	break_cuffs = TRUE
	mob_size = 30
	taste_sensitivity = TASTE_DULL
	blurb = {"Type CB Vaurcae, also known as Breeders, are the leaders of the Vaurca Society. Type C, being the only fertile caste, provide life to the Hive. Most of them, however, are not producing more eggs but in charge of hive-cells of other castes, coordinating their everyday life.<br>
	Some Type CB Vaurcae have been recently used as representatives for their respective queens, due their keen social intelligence, making them ideal candidates for negotiating with aliens on economic and political matters. They easily grasp the nuances of social context, contracts, and systems that other castes have difficulty navigating.<br>
	The Type C caste is not suitable for physical work and will often delegate any duties to the rest of the Vaurcae, which are below them in the hierarchy.<br>
	<b>Vaurca Breeders can only be played as Hive Representatives of Queens affiliated to the Court of Queens.</b>"}

	age_max = 30000
	default_genders = list(FEMALE)
	economic_modifier = 12

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	death_sound = 'sound/voice/hiss6.ogg'
	damage_overlays = 'icons/mob/human_races/masks/dam_breeder.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_breeder.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_breeder.dmi'
	canvas_icon = 'icons/mob/base_48.dmi'

	stamina = 175
	sprint_speed_factor = 1
	sprint_cost_factor = 0.80
	stamina_recovery = 3

	flags =  NO_SLIP | NO_ARTERIES | PHORON_IMMUNE | NO_COLD_SLOWDOWN

	possible_cultures = list(
		/singleton/origin_item/culture/zora_breeder,
		/singleton/origin_item/culture/klax_breeder,
		/singleton/origin_item/culture/cthur_breeder
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/bugbite,
		/mob/living/carbon/human/proc/hivenet_neuralshock,
		/mob/living/carbon/human/proc/hivenet_lattice,
		/mob/living/carbon/human/proc/hivenet_encrypt,
		/mob/living/carbon/human/proc/hivenet_recieve,
		/mob/living/carbon/human/proc/hivenet_decrypt,
		/mob/living/carbon/human/proc/hivenet_camera,
		/mob/living/carbon/human/proc/hivemute,
		/mob/living/carbon/human/proc/hiveban,
		/mob/living/carbon/human/proc/hiveuntether,
		/mob/living/carbon/human/proc/hivenet_transmit,
		/mob/living/carbon/human/proc/hivenet_manifest
	)

	default_h_style = "Bald"

	has_organ = list(
		BP_BRAIN               = /obj/item/organ/internal/brain/vaurca,
		BP_EYES                = /obj/item/organ/internal/eyes/night/vaurca,
		BP_NEURAL_SOCKET        = /obj/item/organ/internal/vaurca/neuralsocket/admin,
		BP_LUNGS               = /obj/item/organ/internal/lungs/vaurca,
		BP_FILTRATION_BIT       = /obj/item/organ/internal/vaurca/filtrationbit,
		BP_HEART               = /obj/item/organ/internal/heart/vaurca,
		BP_PHORON_RESERVE  = /obj/item/organ/internal/vaurca/preserve,
		BP_LIVER               = /obj/item/organ/internal/liver/vaurca,
		BP_KIDNEYS             = /obj/item/organ/internal/kidneys/vaurca,
		BP_STOMACH             = /obj/item/organ/internal/stomach/vaurca,
		BP_APPENDIX            = /obj/item/organ/internal/appendix/vaurca,
		BP_HIVENET_SHIELD	   = /obj/item/organ/internal/augment/hiveshield
	)
	possible_external_organs_modifications = list("Normal", "Amputated") //We don't have any limb modfications for this species
	valid_prosthetics = null

	character_color_presets = list(
		"Zo'ra: Vaur" = "#3D000F",
		"Zo'ra: Zoleth" = "#730015",
		"Zo'ra: Athvur" = "#7A1F00",
		"Zo'ra: Scay" = "#470029",
		"Zo'ra: Xakt" = "#51230A",

		"K'lax: Zkaii" = "#2B483A",
		"K'lax: Tupii" = "#067C12",
		"K'lax: Vedhra" = "#627308",
		"K'lax: Leto" = "#1C6654",

		"C'thur" = "#0F2962",
		"C'thur: Vytel" = "#191937",
		"C'thur: Mouv" = "#7D75FF"
	)

/datum/species/bug/type_c/New()
	..()
	equip_adjust = list(
		slot_l_ear_str   = list("[EAST]" = list("x" = 8, "y" = 10),  "[SOUTH]" = list("x" = 9, "y" = 10),  "[WEST]" = list("x" = -8, "y" = 10)),
		slot_r_ear_str   = list("[EAST]" = list("x" = 24, "y" = 10), "[SOUTH]" = list("x" = 7, "y" = 10),  "[WEST]" = list("x" = -8, "y" = 10)),
		slot_l_hand_str = list("[EAST]" = list("x" = 15, "y" = 5), "[SOUTH]" = list("x" = 10, "y" = 8), "[WEST]" = list("x" = -9, "y" = 4)),
		slot_r_hand_str = list("[EAST]" = list("x" = 25, "y" = 4), "[SOUTH]" = list("x" = 4, "y" = 8),  "[WEST]" = list("x" = 1, "y" = 5))
	)

/datum/species/bug/type_c/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.gender = FEMALE
	return

/datum/species/bug/type_big
	name = SPECIES_VAURCA_WARFORM
	short_name = "vam"
	name_plural = "Type BA"
	bodytype = BODYTYPE_VAURCA_WARFORM
	primitive_form = SPECIES_VAURCA_WARRIOR
	icon_template = 'icons/mob/human_races/vaurca/r_vaurcamecha.dmi'
	icobase = 'icons/mob/human_races/vaurca/r_vaurcamecha.dmi'
	deform = 'icons/mob/human_races/vaurca/r_vaurcamecha.dmi'
	default_language = LANGUAGE_GIBBERING
	language = LANGUAGE_VAURCA
	species_height = HEIGHT_NOT_USED
	icon_x_offset = -8
	unarmed_types = list(/datum/unarmed_attack/claws/cleave, /datum/unarmed_attack/bite/strong)
	rarity_value = 10
	slowdown = 0
	eyes = "warform_eyes"
	eyes_icons = 'icons/mob/human_face/warform_eyes.dmi'
	brute_mod = 0.5
	burn_mod = 0.1
	fall_mod = 0
	toxins_mod = 1
	grab_mod = 10
	total_health = 200
	break_cuffs = TRUE
	mob_size = 30

	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	death_sound = 'sound/voice/hiss6.ogg'
	damage_overlays = 'icons/mob/human_races/masks/dam_mask_warform.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_warform.dmi'
	blood_mask = 'icons/mob/human_races/masks/dam_mask_warform.dmi'


	stamina = 200
	stamina_recovery = 5
	sprint_speed_factor = 0.9
	sprint_cost_factor = 0.5

	heat_level_1 = 1000 //Default 360
	heat_level_2 = 4000 //Default 400
	heat_level_3 = 16000 //Default 1000
	hazard_high_pressure = 55000 //Default 550
	warning_high_pressure = 3250 //Default 325

	spawn_flags = IS_RESTRICTED
	flags = NO_SCAN | NO_SLIP | NO_PAIN | NO_BREATHE | NO_ARTERIES | PHORON_IMMUNE | NO_COLD_SLOWDOWN

	inherent_verbs = list(
		/mob/living/carbon/human/proc/rebel_yell,
		/mob/living/carbon/human/proc/devour_head,
		/mob/living/carbon/human/proc/formic_spray,
		/mob/living/carbon/human/proc/trample,
		/mob/living/carbon/human/proc/hivenet_recieve,
		/mob/living/carbon/human/proc/hivenet_manifest
		)

	has_organ = list(
		BP_BRAIN              = /obj/item/organ/internal/brain/vaurca,
		BP_EYES               = /obj/item/organ/internal/eyes/night/vaurca,
		BP_NEURAL_SOCKET       = /obj/item/organ/internal/vaurca/neuralsocket,
		BP_LUNGS              = /obj/item/organ/internal/lungs/vaurca,
		BP_HEART              = /obj/item/organ/internal/heart/vaurca,
		BP_PHORON_RESERVOIR    = /obj/item/organ/internal/vaurca/reservoir,
		BP_VAURCA_LIVER    = /obj/item/organ/internal/liver/vaurca/robo,
		BP_VAURCA_KIDNEYS  = /obj/item/organ/internal/kidneys/vaurca/robo,
		BP_STOMACH            = /obj/item/organ/internal/stomach,
		BP_FILTRATION_BIT      = /obj/item/organ/internal/vaurca/filtrationbit,
		BP_HIVENET_SHIELD	   = /obj/item/organ/internal/augment/hiveshield/advanced
	)

	default_h_style = "Bald"
	possible_external_organs_modifications = list("Normal", "Amputated") //We don't have any limb modfications for this species
	valid_prosthetics = null

/datum/species/bug/type_big/handle_post_spawn(var/mob/living/carbon/human/H)
	H.mutations |= HULK
	return ..()

/datum/species/bug/type_e
	name = SPECIES_VAURCA_BULWARK
	short_name = "vak"
	name_plural = "Type E"
	bodytype = BODYTYPE_VAURCA_BULWARK
	species_height = HEIGHT_CLASS_GIGANTIC
	height_min = 220
	height_max = 320
	preview_icon = 'icons/mob/human_races/vaurca/r_vaurcae.dmi'
	icon_template = 'icons/mob/human_races/vaurca/r_vaurcae.dmi'
	icobase = 'icons/mob/human_races/vaurca/r_vaurcae.dmi'
	deform = 'icons/mob/human_races/vaurca/r_vaurcae.dmi'
	canvas_icon = 'icons/mob/base_48.dmi'
	talk_bubble_icon = 'icons/mob/talk_bulwark.dmi'

	default_h_style = "Bulwark Classic Antennae"

	icon_x_offset = -9
	healths_x = 22
	healths_overlay_x = 9
	floating_chat_x_offset = 6

	damage_overlays = 'icons/mob/human_races/masks/dam_mask_bulwark.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_bulwark.dmi'
	blood_mask = 'icons/mob/human_races/masks/dam_mask_bulwark.dmi'

	eyes_icons = 'icons/mob/human_face/eyes48x48.dmi'
	eyes = "bulwark_eyes"

	slowdown = 2

	unarmed_types = list(/datum/unarmed_attack/vaurca_bulwark)
	maneuvers = list(
		/singleton/maneuver/leap/bulwark
	)

	natural_armor = list(
		MELEE = ARMOR_MELEE_MEDIUM
	)

	brute_mod = 0.4
	burn_mod = 1.25
	pain_mod = 0.75 //thick carapace, getting hit doesn't hurt them as much
	oxy_mod = 1
	radiation_mod = 0
	toxins_mod = 3

	grab_mod = 0.5 //very big, very easy to grab
	resist_mod = 14 //also very strong

	mob_size = 28
	taste_sensitivity = TASTE_DULL
	blurb = {"Type E Vaurca, otherwise known as the Bulwarks, are a new bodyform derived from the worker caste in a collaboration by the C'thur and Nralakk scientists. Originally only the C'thur had access to these behemoths, but after a short amount of time, the bodyform started appearing in the ranks of the Zo'ra and K'lax as well, causing an even more strained relationship between the Hives.<br>
Similar to Workers, Bulwarks are generally passive, and prefer to flee a fight rather than resist. Though due to their speed, they may still choose to defend themselves should they be unable to properly escape a battle. The main exception to this is when another Vaurca is in danger. When this occurs, they tend to put themselves in between the attacker and the Vaurca, acting as a shield of sorts. They won't go out of their way to take down the attacker, but will ensure the others get away safely.<br>
Bulwarks are much larger and have significantly thicker carapaces than most Vaurca, making them slow but resistant to most hits, including a complete immunity to radiation. Their powerful arms and claws grant them stronger punches, enough to bend metal, and is often used to pry open non-functional doors.<br>
<b>Type E Vaurca are typically used for heavy lifting, agricultural and industrial work, thus they can typically be found as Engineers, Cargo Technicians, Miners and similar jobs, though they can also be found in positions such as janitor and Assistant should they be needed.</b>"}

	heat_level_1 = 360 //Default 360
	heat_level_2 = 400 //Default 400
	heat_level_3 = 800 //Default 1000

	sprint_speed_factor = 1.0
	stamina = 50
	possible_external_organs_modifications = list("Normal", "Amputated") //We don't have any limb modfications for this species, yet
	valid_prosthetics = null

	flags = NO_SLIP | NO_CHUBBY | NO_ARTERIES | PHORON_IMMUNE | NO_COLD_SLOWDOWN | NO_EQUIP_SPEEDMODS

	character_color_presets = list(
		"Zo'ra: Unbound Vaur" = "#3D000F", "Zo'ra: Bound Vaur" = "#37000F",
		"Zo'ra: Unbound Zoleth" = "#730015", "Zo'ra: Bound Zoleth" = "#610015",
		"Zo'ra: Unbound Athvur" = "#7A1F00", "Zo'ra: Bound Athvur" = "#691B00",
		"Zo'ra: Unbound Scay" = "#470029", "Zo'ra: Bound Scay" = "#470519",
		"Zo'ra: Unbound Xakt" = "#51230A", "Zo'ra: Bound Xakt" = "#491D05",

		"K'lax: Unbound Zkaii" = "#2B483A", "K'lax: Bound Zkaii" = "#263B10",
		"K'lax: Unbound Tupii" = "#067C12", "K'lax: Bound Tupii" = "#7D881D",
		"K'lax: Unbound Vedhra" = "#627308", "K'lax: Bound Vedhra" = "#006400",
		"K'lax: Unbound Leto" = "#1C6654", "K'lax: Bound Leto" = "#1A280F",
		"K'lax: Unbound Vetju" = "#0D421B", "K'lax: Bound Vetju" = "#314831",

		"C'thur: Unbound C'thur" = "#0F2962", "C'thur: Bound C'thur" = "#0A213F",
		"C'thur: Unbound Vytel" = "#191937", "C'thur: Bound Vytel" = "#0E0E2B",
		"C'thur: Unbound Mouv" = "#7D75FF", "C'thur: Bound Mouv" = "#4A8AFC",
		"C'thur: Unbound Xetl" = "#3F0876", "C'thur: Bound Xetl" = "#330563"
	)

/datum/species/bug/type_e/New()
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

/datum/species/bug/type_e/can_double_fireman_carry()
	return TRUE
