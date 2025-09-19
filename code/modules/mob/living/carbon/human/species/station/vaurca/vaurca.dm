/datum/species/bug
	name = SPECIES_VAURCA_WORKER
	short_name = "vau"
	name_plural = "Type A"
	category_name = "Vaurca"
	bodytype = BODYTYPE_VAURCA
	species_height = HEIGHT_CLASS_TALL
	height_min = 150
	height_max = 250
	age_min = 1
	age_max = 20
	default_genders = list(NEUTER)
	selectable_pronouns = null
	economic_modifier = 7
	language = LANGUAGE_VAURCA
	primitive_form = SPECIES_MONKEY_VAURCA
	greater_form = SPECIES_VAURCA_WARRIOR
	icobase = 'icons/mob/human_races/vaurca/r_vaurca.dmi'
	deform = 'icons/mob/human_races/vaurca/r_vaurca.dmi'
	preview_icon = 'icons/mob/human_races/vaurca/vaurca_preview.dmi'
	bandages_icon = 'icons/mob/bandage.dmi'
	name_language = LANGUAGE_VAURCA
	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/palm,
		/datum/unarmed_attack/bite/sharp
	)
	meat_type = /obj/item/reagent_containers/food/snacks/meat/bug
	rarity_value = 4
	slowdown = 1
	darksight = 8 //Allows you to see through black k'ois if the night vision is on
	eyes = "vaurca_eyes" //makes it so that eye colour is not changed when skin colour is.
	eyes_are_impermeable = TRUE

	brute_mod = 0.5
	burn_mod = 1.5 //2x was a bit too much. we'll see how this goes.
	toxins_mod = 2 //they're not used to all our weird human bacteria.
	oxy_mod = 0.6
	radiation_mod = 0.2 //almost total radiation protection
	bleed_mod = 2.2
	injection_mod = 2

	grab_mod = 1.1
	resist_mod = 1.75

	warning_low_pressure = 50
	hazard_low_pressure = 0
	ethanol_resistance = 2
	taste_sensitivity = TASTE_SENSITIVE
	reagent_tag = IS_VAURCA
	siemens_coefficient = 1 //setting it to 0 would be redundant due to LordLag's snowflake checks, plus batons/tasers use siemens now too.
	breath_type = GAS_PHORON
	breath_vol_mul = 1/6 // 0.5 liters * breath_vol_mul = breath volume
	breath_eff_mul = 6 // 1/6 * breath_eff_mul = fraction of gas consumed
	poison_type = GAS_NITROGEN //a species that breathes plasma shouldn't be poisoned by it.
	breathing_sound = null //They don't work that way I guess? I'm a coder not a purple man.
	mob_size = 10 //their half an inch thick exoskeleton and impressive height, plus all of their mechanical organs.
	natural_climbing = TRUE
	climb_coeff = 0.75

	blurb = "Type A are the most common type of Vaurca and can be seen as the 'backbone' of Vaurcae societies. Their most prevalent feature is their hardened exoskeleton, varying in colors \
	in accordance to their hive. It is approximately half an inch thick among all Type A Vaurca. The carapace provides protection against harsh radiation, solar \
	and otherwise, and acts as a pressure-suit to seal their soft inner core from the outside world. This allows most Type A Vaurca to have extended EVA \
	expeditions, assuming they have internals. They are bipedal, and compared to warriors they are better suited for EVA and environments, and more resistant to brute force thanks to their \
	thicker carapace, but also a fair bit slower and less agile. \
	<b>Type A are comfortable in any department except security. There will almost never be a Worker in a security position, as they are as a type disposed against combat.</b>"

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 600 //Default 1000
	flags = NO_SLIP | NO_CHUBBY | NO_ARTERIES | PHORON_IMMUNE | NO_COLD_SLOWDOWN
	spawn_flags = CAN_JOIN | IS_WHITELISTED | NO_AGE_MINIMUM
	appearance_flags = HAS_SKIN_COLOR | HAS_HAIR_COLOR | HAS_SKIN_PRESET
	blood_color = COLOR_VAURCA_BLOOD // dark yellow
	flesh_color = "#E6E600"
	base_color = "#575757"

	halloss_message = "crumbles to the ground, too weak to continue fighting."

	heat_discomfort_strings = list(
		"Your blood feels like its boiling in the heat.",
		"You feel uncomfortably warm.",
		"Your carapace feels hot as the sun."
	)

	cold_discomfort_strings = list(
		"You chitter in the cold.",
		"You shiver suddenly.",
		"Your carapace is ice to the touch."
	)

	stamina = 100			  // Long period of sprinting, but relatively low speed gain
	sprint_speed_factor = 0.7
	sprint_cost_factor = 0.30
	stamina_recovery = 2	//slow recovery

	has_organ = list(
		BP_BRAIN               = /obj/item/organ/internal/brain/vaurca,
		BP_EYES                = /obj/item/organ/internal/eyes/night/vaurca,
		BP_NEURAL_SOCKET        = /obj/item/organ/internal/vaurca/neuralsocket,
		BP_LUNGS               = /obj/item/organ/internal/lungs/vaurca,
		BP_FILTRATION_BIT       = /obj/item/organ/internal/vaurca/filtrationbit,
		BP_HEART               = /obj/item/organ/internal/heart/vaurca,
		BP_PHORON_RESERVE  = /obj/item/organ/internal/vaurca/preserve,
		BP_LIVER               = /obj/item/organ/internal/liver/vaurca,
		BP_KIDNEYS             = /obj/item/organ/internal/kidneys/vaurca,
		BP_STOMACH             = /obj/item/organ/internal/stomach/vaurca,
		BP_APPENDIX            = /obj/item/organ/internal/appendix/vaurca
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/vaurca),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/vaurca),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/vaurca),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/vaurca),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/vaurca),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/vaurca),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/vaurca),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/vaurca),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/vaurca),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/vaurca),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/vaurca)
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/hivenet_recieve,
		/mob/living/carbon/human/proc/hivenet_manifest
	)

	default_h_style = "Classic Antennae"

	move_trail = /obj/effect/decal/cleanable/blood/tracks/claw


	possible_cultures = list(
		/singleton/origin_item/culture/zora,
		/singleton/origin_item/culture/klax,
		/singleton/origin_item/culture/cthur
	)


	alterable_internal_organs = list(BP_HEART, BP_EYES, BP_LUNGS, BP_STOMACH, BP_APPENDIX)
	psi_deaf = TRUE
	possible_speech_bubble_types = list("robot", "default")
	valid_prosthetics = list(PROSTHETIC_VAURCA)

	sleeps_upright = TRUE
	snore_key = "chitter"
	indefinite_sleep = TRUE

	character_color_presets = list(
		"Zo'ra: Unbound Vaur" = "#3D0000", "Zo'ra: Bound Vaur" = "#290000",
		"Zo'ra: Unbound Zoleth" = "#650015", "Zo'ra: Bound Zoleth" = "#6F1515",
		"Zo'ra: Unbound Athvur" = "#83290B", "Zo'ra: Bound Athvur" = "#6F1500",
		"Zo'ra: Unbound Scay" = "#47001F", "Zo'ra: Bound Scay" = "#470B33",
		"Zo'ra: Unbound Xakt" = "#5B1F00", "Zo'ra: Bound Xakt" = "#511500",

		"K'lax: Unbound Zkaii" = "#0B2B1B", "K'lax: Bound Zkaii" = "#335115",
		"K'lax: Unbound Tupii" = "#299617", "K'lax: Bound Tupii" = "#74B72E",
		"K'lax: Unbound Vedhra" = "#829614", "K'lax: Bound Vedhra" = "#14AA14",
		"K'lax: Unbound Leto" = "#00503C", "K'lax: Bound Leto" = "#293B1A",
		"K'lax: Unbound Vetju" = "#0B541F", "K'lax: Bound Vetju" = "#213F21",

		"C'thur: Unbound C'thur" = "#002373", "C'thur: Bound C'thur" = "#00285A",
		"C'thur: Unbound Vytel" = "#141437", "C'thur: Bound Vytel" = "#0A2337",
		"C'thur: Unbound Mouv" = "#96B4FF", "C'thur: Bound Mouv" = "#5A96FF",
		"C'thur: Unbound Xetl" = "#370078", "C'thur: Bound Xetl" = "#3C0F5F"
	)

/datum/species/bug/before_equip(var/mob/living/carbon/human/H)
	. = ..()
	H.gender = NEUTER
	var/obj/item/clothing/mask/gas/vaurca/filter/M = new /obj/item/clothing/mask/gas/vaurca/filter(H)
	H.equip_to_slot_or_del(M, slot_wear_mask)

/datum/species/bug/after_equip(var/mob/living/carbon/human/H)
	if(H.shoes)
		return
	var/obj/item/clothing/shoes/sandals/S = new /obj/item/clothing/shoes/sandals(H)
	H.equip_to_slot_or_del(S,slot_shoes)

/datum/species/bug/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER
	return ..()

/datum/species/bug/is_naturally_insulated()
	return TRUE

/datum/species/bug/can_hold_s_store(obj/item/I)
	if(I.w_class <= WEIGHT_CLASS_SMALL)
		return TRUE
	return FALSE

/datum/species/bug/sleep_msg(var/mob/M)
	M.visible_message(SPAN_NOTICE("\The [M] locks [M.get_pronoun("his")] carapace in place, becoming completely still."))
	to_chat(M, SPAN_NOTICE("You lock your carapace into place, becoming completely still."))

/datum/species/bug/sleep_examine_msg(var/mob/M)
	return SPAN_NOTICE("[M.get_pronoun("He")] has locked [M.get_pronoun("his")] carapace in place, and is standing completely still.\n")
