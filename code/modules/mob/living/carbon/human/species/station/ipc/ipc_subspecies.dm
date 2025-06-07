/datum/species/machine/shell
	name = SPECIES_IPC_SHELL
	hide_name = TRUE
	short_name = "jak"
	name_plural = "Shells"
	bodytype = BODYTYPE_HUMAN
	species_height = HEIGHT_CLASS_AVERAGE
	height_min = 145
	height_max = 230
	default_genders = list(MALE, FEMALE)
	selectable_pronouns = list(MALE, FEMALE, PLURAL, NEUTER)
	mob_weight = MOB_WEIGHT_MEDIUM // Would be really easy to find untagged shells otherwise.

	alterable_internal_organs = list(BP_EYES, BP_COOLING_UNIT, BP_REACTOR)

	burn_mod = 1.2
	grab_mod = 1

	blurb = "IPCs with humanlike properties. Their focus is on service, civilian, and medical, but there are no \
	job restrictions. Created in the late days of 2450, the Shell is a controversial IPC model equipped with a synthskin weave applied over its metal chassis \
	to create an uncannily close approximation of the organic form. Early models of Shell had the advantage of being able to compose themselves of a wide \
	variety of organic parts, but contemporary models have been restricted to a single species for the sake of prosthetic integrity. The additional weight of \
	the synthskin on the original Hephaestus frame reduces the efficacy of the unit's already strained coolant systems, and increases charge consumption."

	num_alternate_languages = 3

	icobase = 'icons/mob/human_races/human/r_human.dmi'
	deform = 'icons/mob/human_races/ipc/robotic.dmi'
	preview_icon = 'icons/mob/human_races/ipc/shell_preview.dmi'

	light_range = 0
	light_power = 0
	unarmed_types = list(
		/datum/unarmed_attack/punch/ipc,
		/datum/unarmed_attack/stomp/ipc,
		/datum/unarmed_attack/kick/ipc,
		/datum/unarmed_attack/bite
	)

	eyes = "eyes_s"
	show_ssd = "completely quiescent"

	heat_level_1 = 500
	heat_level_2 = 1000
	heat_level_3 = 2000

	heat_discomfort_level = 400
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!",
		"Your synthetic flesh crawls in the heat, swelling into a disgusting morass of plastic."
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_EYE_COLOR | HAS_FBP | HAS_SKIN_PRESET | HAS_UNDERWEAR | HAS_SOCKS | HAS_LIPS

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/ipc/shell),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/ipc/shell),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/ipc/shell),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/ipc/shell),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/ipc/shell),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/ipc/shell),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/ipc/shell),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc/shell),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc/shell),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc/shell),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc/shell)
		)

	base_color = "#25032"

	character_color_presets = list("Dark" = "#000000", "Warm" = "#250302", "Cold" = "#1e1e29", "Rubber" = "#000f36")

	sprint_temperature_factor = 1.3
	move_charge_factor = 0.85

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_tag,
		/mob/living/carbon/human/proc/tie_hair)

	bodyfall_sound = /singleton/sound_category/bodyfall_sound
	use_alt_hair_layer = FALSE

/datum/species/machine/shell/get_species(var/reference, var/mob/living/carbon/human/H, var/records)
	if(reference)
		return src
	if(records && H.client.prefs.hidden_shell_status)
		return "Human"
	return name

/datum/species/machine/shell/get_light_color()
	return

/datum/species/machine/shell/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/machine/shell/rogue
	name = SPECIES_IPC_SHELL_ROGUE
	short_name = "roguejak"
	name_plural = "Rogue Shells"

	spawn_flags = IS_RESTRICTED

	break_cuffs = TRUE

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_SURGE_PROTECTOR   = /obj/item/organ/internal/machine/surge/advanced
	)

	unarmed_types = list(
		/datum/unarmed_attack/stomp/ipc,
		/datum/unarmed_attack/kick/ipc,
		/datum/unarmed_attack/terminator,
		/datum/unarmed_attack/bite/strong)

/datum/species/machine/shell/rogue/check_tag(var/mob/living/carbon/human/new_machine, var/client/player)
	return

/datum/species/machine/industrial
	name = SPECIES_IPC_G1
	short_name = "ind"
	name_plural = "Industrials"
	bald = 1
	bodytype = BODYTYPE_IPC_INDUSTRIAL
	species_height = HEIGHT_CLASS_HUGE
	height_min = 180
	mob_size = 12

	unarmed_types = list(/datum/unarmed_attack/industrial, /datum/unarmed_attack/palm/industrial)

	brute_mod = 0.8
	burn_mod = 1.1

	grab_mod = 0.8 // Big, easy to grab onto
	resist_mod = 10 // Good luck wrestling against this powerhouse.

	slowdown = 4

	blurb = "The first commercialized attempt Hephaestus Industries made at an industrial-type IPC. Designed for extra durability and increased weight loads, the first generation Industrial was considered a success, though it possessed some issues. A limited power cell and actuators designed for heavy lifting and not locomotion resulted in a slow and frequently charging machine. A special addition to the chassis makes up for these drawbacks - the ability to simply slot a suit cooling unit onto the model's back and make use of its built-in heat transferal conduits, allowing the Industrial to perform EVA without any extra peripherals such as a voidsuit."

	icobase = 'icons/mob/human_races/ipc/r_industrial.dmi'
	deform = 'icons/mob/human_races/ipc/r_industrial.dmi'
	preview_icon = 'icons/mob/human_races/ipc/industrial_preview.dmi'

	eyes = "eyes_industry"
	show_ssd = "completely quiescent"

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/ipc/industrial),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/ipc/industrial),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/ipc/industrial),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/ipc/industrial),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/ipc/industrial),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/ipc/industrial),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/ipc/industrial),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc/industrial),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc/industrial),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc/industrial),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc/industrial)
		)

	flags = IS_IPC | ACCEPTS_COOLER
	appearance_flags = HAS_EYE_COLOR | HAS_UNDERWEAR | HAS_SOCKS

	maneuvers = list(
		/singleton/maneuver/leap/industrial
	)

	heat_level_1 = 800
	heat_level_2 = 1600
	heat_level_3 = 3200

	heat_discomfort_level = 700

	sprint_speed_factor = 1.4
	sprint_temperature_factor = 0.9
	move_charge_factor = 1.1

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_tag
		)

	machine_ui_theme = "hephaestus"

/datum/species/machine/industrial/get_light_color()
	return LIGHT_COLOR_TUNGSTEN

/datum/species/machine/industrial/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/machine/hunter_killer
	name = SPECIES_IPC_PURPOSE_HK
	short_name = "hks"
	name_plural = "HKs"
	bald = 1
	bodytype = BODYTYPE_IPC_INDUSTRIAL
	species_height = HEIGHT_CLASS_TALL

	blurb = "\[REDACTED\]"

	icobase = 'icons/mob/human_races/ipc/r_hunter_killer.dmi'
	deform = 'icons/mob/human_races/ipc/r_hunter_killer.dmi'

	light_range = 0
	light_power = 0

	unarmed_types = list(/datum/unarmed_attack/terminator)
	rarity_value = 20

	language = LANGUAGE_PURPOSE
	name_language = LANGUAGE_PURPOSE

	eyes = "eyes_terminator"
	has_floating_eyes = 1

	brute_mod = 0.3
	burn_mod = 0.5

	grab_mod = 0.9
	resist_mod = 10

	flash_mod = 0
	siemens_coefficient = 0
	break_cuffs = TRUE
	mob_size = 20

	show_ssd = "laying inert, its activation glyph dark"

	death_sound = 'sound/effects/bang.ogg'
	death_message = "collapses to the ground with a CLUNK, and begins to beep ominously."
	death_message_range = 7

	heat_level_1 = 1500
	heat_level_2 = 2000
	heat_level_3 = 5000

	body_temperature = null

	flags = IS_IPC | ACCEPTS_COOLER
	spawn_flags = IS_RESTRICTED
	appearance_flags = HAS_HAIR_COLOR | HAS_UNDERWEAR | HAS_SOCKS
	vision_flags = DEFAULT_SIGHT | SEE_MOBS

	reagent_tag = IS_MACHINE

	inherent_verbs = list(
		/mob/living/carbon/human/proc/self_destruct,
		/mob/living/carbon/human/proc/detonate_flechettes,
		/mob/living/carbon/human/proc/state_laws
	)

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_DATACORE = /obj/item/organ/internal/machine/data,
		BP_SURGE_PROTECTOR = /obj/item/organ/internal/machine/surge/advanced
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/terminator),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/terminator),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/terminator),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/terminator),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/terminator),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/terminator),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/terminator),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/terminator),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/terminator),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/terminator),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/terminator)
		)


	heat_discomfort_level = 2000
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	stamina	= -1
	sprint_speed_factor = 1.25
	sprint_cost_factor = 1
	slowdown = 1

	sprint_temperature_factor = 0.6
	move_charge_factor = 0.3

	machine_ui_theme = "syndicate"

/datum/species/machine/hunter_killer/get_light_color()
	return

/datum/species/machine/hunter_killer/handle_death(var/mob/living/carbon/human/H)
	..()
	playsound(H.loc, 'sound/items/countdown.ogg', 125, 1)
	spawn(15)
		explosion(H.loc, -1, 1, 5)
		H.gib()

// -- Branded units --

/datum/species/machine/industrial/hephaestus
	name = SPECIES_IPC_G2
	short_name = "hif"
	bodytype = BODYTYPE_IPC_INDUSTRIAL

	icobase = 'icons/mob/human_races/ipc/r_ind_hephaestus.dmi'
	deform = 'icons/mob/human_races/ipc/r_ind_hephaestus.dmi'
	preview_icon = 'icons/mob/human_races/ipc/ind_hephaestus_preview.dmi'

	eyes = "heph_eyes"

	unarmed_types = list(/datum/unarmed_attack/industrial/heavy, /datum/unarmed_attack/palm/industrial)

	slowdown = 6
	brute_mod = 0.7
	grab_mod = 0.7 // Bulkier and bigger than the G1
	resist_mod = 12 // Overall stronger than G1

	heat_level_1 = 1000
	heat_level_2 = 2000
	heat_level_3 = 4000

	heat_discomfort_level = 900

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_tag,
		/mob/living/carbon/human/proc/discard_limb,
		/mob/living/carbon/human/proc/attach_hephaestus_limb
	)

	examine_color = "#688359"

	blurb = "An extremely durable and heavy Industrial model branded by Hephaestus Industries. It is their improved Industrial model, with thicker plating and improved power cell. Its actuators struggle to carry the immense weight, however, making the unit quite slow. This chassis would be seen in roles where it would be dangerous or inefficient to use a less durable unit, such as engineering and mining. While this unit still possesses built-in cooling conduits, the increased plating and thickness of said plating proved a difficult challenge for the engineers to develop good cooling, so the unit suffers somewhat from increased heat loads. Overtaxing its hardware will quickly lead to overheating."

	has_limbs = list(
		BP_CHEST  = list("path" = /obj/item/organ/external/chest/ipc/industrial/hephaestus),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/ipc/industrial/hephaestus),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/ipc/industrial/hephaestus),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/ipc/industrial/hephaestus),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/ipc/industrial/hephaestus),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/ipc/industrial/hephaestus),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/ipc/industrial/hephaestus),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc/industrial/hephaestus),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc/industrial/hephaestus),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc/industrial/hephaestus),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc/industrial/hephaestus)
	)


	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_INTERNAL_STORAGE = /obj/item/organ/internal/machine/internal_storage,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/machine/ipc_tag
	)

	flags = IS_IPC | ACCEPTS_COOLER | NO_EQUIP_SPEEDMODS

	machine_ui_theme = "hephaestus"

	natural_armor = list(
		ballistic = ARMOR_BALLISTIC_SMALL,
		melee = ARMOR_MELEE_KEVLAR
	)

/mob/living/carbon/human/proc/discard_limb()
	set name = "Discard Limb"
	set category = "Object"

	if(incapacitated(INCAPACITATION_DEFAULT))
		return

	if(get_active_hand())
		to_chat(src, SPAN_WARNING("You need your hand to be free!"))
		return

	var/limb_list = list()
	for(var/obj/item/organ/external/limb in organs)
		if(limb.limb_name in list(BP_CHEST, BP_GROIN, BP_HEAD))
			continue

		if(limb.robotize_type == PROSTHETIC_HI)
			limb_list[capitalize_first_letters(limb.name)] = limb

	var/chosen_limb = tgui_input_list(src, "Choose a limb to discard.", "Discard Limb", limb_list)
	if(!chosen_limb)
		return

	var/obj/item/organ/external/oopsie = limb_list[chosen_limb]
	visible_message(SPAN_DANGER("[src] ejects [get_pronoun("his")] [oopsie] with a hiss!"))
	oopsie.droplimb(TRUE, DROPLIMB_EDGE)

/mob/living/carbon/human/proc/attach_hephaestus_limb()
	set name = "Attach Limb"
	set category = "Object"

	if(incapacitated(INCAPACITATION_DEFAULT))
		return

	var/obj/item/organ/external/limb = get_active_hand()
	if(!istype(limb))
		to_chat(src, SPAN_WARNING("You need to be holding a compatible Hephaestus Industries limb!"))
		return

	if(!limb.robotic)
		to_chat(src, SPAN_WARNING("That is not a compatible Hephaestus Industries limb!"))
		return

	if(limb.robotize_type != PROSTHETIC_HI)
		to_chat(src,SPAN_WARNING("That prosthetic does not have the right ports for your joint!"))
		return

	if(organs_by_name[limb.limb_name])
		to_chat(src,SPAN_WARNING("You already have a limb of this type!"))
		return

	if(!organs_by_name[limb.parent_organ])
		to_chat(src,SPAN_WARNING("You are missing the appropriate joint to attach that limb!"))
		return

	visible_message(SPAN_NOTICE("[src] begins attaching \the [limb] to the appropriate joint..."))
	if(!do_after(src, 10 SECONDS))
		return


	drop_from_inventory(limb)
	limb.replaced(src)

	visible_message(SPAN_NOTICE("[src] attaches \the [limb] to their body!"))
	update_body()
	updatehealth()
	UpdateDamageIcon()

/datum/species/machine/industrial/hephaestus/get_light_color(mob/living/carbon/human/H)
	if (istype(H))
		return rgb(H.r_eyes, H.g_eyes, H.b_eyes)

/datum/species/machine/industrial/xion
	name = SPECIES_IPC_XION
	short_name = "xmf"
	bodytype = BODYTYPE_IPC_INDUSTRIAL
	species_height = HEIGHT_CLASS_TALL
	height_min = 180

	icobase = 'icons/mob/human_races/ipc/r_ind_xion.dmi'
	deform = 'icons/mob/human_races/ipc/r_ind_xion.dmi'
	preview_icon = 'icons/mob/human_races/ipc/ind_xion_preview.dmi'

	unarmed_types = list(
		/datum/unarmed_attack/industrial/xion,
		/datum/unarmed_attack/palm/industrial
	)

	brute_mod = 0.9
	grab_mod = 0.9
	resist_mod = 8

	cold_level_1 = -1 //RaceDefault 50 Default -1
	cold_level_2 = -1 //RaceDefault -1 Default -1
	cold_level_3 = -1  //RaceDefault -1 Default -1

	heat_level_1 = 700  //RaceDefault 600 Default 700
	heat_level_2 = 1400  //RaceDefault 1200 Default 1400
	heat_level_3 = 2800  //RaceDefault 2400 Default 2800

	heat_discomfort_level = 600
	slowdown = 3

	eyes = "xion_eyes"
	flags = IS_IPC

	examine_color = "#bc4b00"

	blurb = "The Xion Manufacturing Group, being a subsidiary of Hephaestus Industries, saw the original Industrial models and wanted to develop their own chassis based off of the original design. The result is the Xion Industrial model. Sturdy and strong, this chassis is quite powerful and equally durable, with an ample power cell and improved actuators for carrying the increased weight of the body. The Xion model also retains sturdiness without covering the chassis in plating, allowing for the cooling systems to vent heat much easier than the Hephaestus-brand model. This unit can perform EVA without assistance."

	has_limbs = list(
		BP_CHEST  = list("path" = /obj/item/organ/external/chest/ipc/industrial/xion),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/ipc/industrial/xion),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/ipc/industrial/xion),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/ipc/industrial/xion),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/ipc/industrial/xion),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/ipc/industrial/xion),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/ipc/industrial/xion),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc/industrial/xion),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc/industrial/xion),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc/industrial/xion),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc/industrial/xion)
	)

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit/xion,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/machine/ipc_tag
	)

	machine_ui_theme = "hephaestus"

/datum/species/machine/industrial/xion/remote
	name = SPECIES_IPC_XION_REMOTE
	short_name = "rem_xmf"

	spawn_flags = IS_RESTRICTED

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/machine/ipc_tag
	)

/datum/species/machine/industrial/xion/get_light_color(mob/living/carbon/human/H)
	if (istype(H))
		return rgb(H.r_eyes, H.g_eyes, H.b_eyes)

/datum/species/machine/zenghu
	name = SPECIES_IPC_ZENGHU
	short_name = "zhf"
	bodytype = BODYTYPE_IPC_ZENGHU

	icobase = 'icons/mob/human_races/ipc/r_ind_zenghu.dmi'
	deform = 'icons/mob/human_races/ipc/r_ind_zenghu.dmi'
	preview_icon = 'icons/mob/human_races/ipc/ind_zenghu_preview.dmi'

	eyes = "zenghu_eyes"
	brute_mod = 1.5

	slowdown = -0.8
	sprint_speed_factor = 0.6
	sprint_cost_factor = 2
	move_charge_factor = 2
	standing_jump_range = 3

	grab_mod = 1.1 // Smooth, fast
	resist_mod = 4 // Not super strong, but still rather strong

	appearance_flags = HAS_EYE_COLOR | HAS_UNDERWEAR | HAS_SOCKS
	flags = IS_IPC | NO_SLIP

	examine_color = "#ff00ff"

	blurb = "Being a corporation focused primarily on medical sciences and treatments, Zeng-Hu Pharmaceuticals had little interest in the market of synthetics in the beginning (especially considering a good portion of Zeng-Hu employees are Skrellian). However, after seeing the advances in almost all fields of the galactic market after the advent of synthetics, Zeng-Hu set aside some funds for their own robotics department, focused mainly on medical service and even science related operations. Having taken some inspiration from biological life, the chassis has an interesting leg design: digitigrade legs provide the chassis with enhanced speed. A downside to this development was the reduction of metals on the chassis. Most plates covering the sensitive interior electronics are polymer casts to reduce the weight of the unit, resulting in a not-so-durable android."

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit/zenghu,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/machine/ipc_tag
	)

	has_limbs = list(
		BP_CHEST  = list("path" = /obj/item/organ/external/chest/ipc/industrial/zenghu),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/ipc/industrial/zenghu),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/ipc/industrial/zenghu),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/ipc/industrial/zenghu),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/ipc/industrial/zenghu),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/ipc/industrial/zenghu),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/ipc/industrial/zenghu),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc/industrial/zenghu),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc/industrial/zenghu),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc/industrial/zenghu),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc/industrial/zenghu)
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_tag
		)
	maneuvers = list(
		/singleton/maneuver/leap/zenghu
	)

	machine_ui_theme = "zenghu"


/datum/species/machine/zenghu/get_light_color(mob/living/carbon/human/H)
	if (istype(H))
		return rgb(H.r_eyes, H.g_eyes, H.b_eyes)

/datum/species/machine/bishop
	name = SPECIES_IPC_BISHOP
	short_name = "bcf"
	bodytype = BODYTYPE_IPC_BISHOP
	species_height = HEIGHT_CLASS_AVERAGE

	icobase = 'icons/mob/human_races/ipc/r_ind_bishop.dmi'
	deform = 'icons/mob/human_races/ipc/r_ind_bishop.dmi'
	preview_icon = 'icons/mob/human_races/ipc/ind_bishop_preview.dmi'

	eyes = "bishop_eyes"
	eyes_icon_blend = ICON_MULTIPLY

	brute_mod = 1.2
	grab_mod = 1.1
	resist_mod = 4
	num_alternate_languages = 3

	appearance_flags = HAS_EYE_COLOR | HAS_UNDERWEAR | HAS_SOCKS

	examine_color = "#00afea"

	blurb = "Bishop Cybernetics frames are among the sleeker, flashier frames widely produced for IPCs. This brand-new, high end design has a focus on pioneering energy efficiency without sacrifice, fitting to Bishop's company vision. Cutting-edge technology in power management means this frame can operate longer while running more demanding processing algorithms than most. This extreme push to minimize power draw means this frame can be equipped with all sorts of extra equipment: a hologram for a face, flashing status displays and embedded lights solely meant for show. The one thing holding this frame back from perfection is the same common criticism leveled against almost all Bishop products: the shiny chrome and glass meant to put all of this tech on display means it's exposed and fragile. It's because of Bishop's unrelenting pursuit of vanity in their designs that these frames often suffer from issues with reliability and struggle to safely perform the same work as cheaper, more rugged frames."

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_ACCESS_PORT = /obj/item/organ/internal/machine/access_port,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/machine/ipc_tag,
		BP_WIRELESS_ACCESS = /obj/item/organ/internal/machine/wireless_access
	)

	has_limbs = list(
		BP_CHEST  = list("path" = /obj/item/organ/external/chest/ipc/industrial/bishop),
		BP_GROIN  = list("path" = /obj/item/organ/external/groin/ipc/industrial/bishop),
		BP_HEAD   = list("path" = /obj/item/organ/external/head/ipc/industrial/bishop),
		BP_L_ARM  = list("path" = /obj/item/organ/external/arm/ipc/industrial/bishop),
		BP_R_ARM  = list("path" = /obj/item/organ/external/arm/right/ipc/industrial/bishop),
		BP_L_LEG  = list("path" = /obj/item/organ/external/leg/ipc/industrial/bishop),
		BP_R_LEG  = list("path" = /obj/item/organ/external/leg/right/ipc/industrial/bishop),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc/industrial/bishop),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc/industrial/bishop),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc/industrial/bishop),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc/industrial/bishop)
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_tag
		)

	machine_ui_theme = "zenghu"

/datum/species/machine/bishop/get_light_color(mob/living/carbon/human/H)
	if (istype(H))
		return rgb(H.r_eyes, H.g_eyes, H.b_eyes)

/datum/species/machine/unbranded
	name = SPECIES_IPC_UNBRANDED
	short_name = "unbran"
	name_plural = "Unbranded Frames"

	blurb = "A simple and archaic robotic frame, used mostly as a temporary body before posibrains are transferred to any specialized chassis."

	icobase = 'icons/mob/human_races/ipc/robotic.dmi'
	deform = 'icons/mob/human_races/ipc/robotic.dmi'
	eyes = "eyes_s"

	bald = 1
	grab_mod = 1.1 //pity points - geeves

	appearance_flags = HAS_EYE_COLOR
	spawn_flags = IS_RESTRICTED

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/ipc/unbranded),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/ipc/unbranded),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/ipc/unbranded),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/ipc/unbranded),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/ipc/unbranded),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/ipc/unbranded),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/ipc/unbranded),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/ipc/unbranded),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/ipc/unbranded),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/ipc/unbranded),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/ipc/unbranded)
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/check_tag
		)

/datum/species/machine/unbranded/remote
	name = SPECIES_IPC_UNBRANDED_REMOTE
	short_name = "rem_unbran"
	name_plural = "Remote Unbranded Frames"

	spawn_flags = IS_RESTRICTED

	has_organ = list(
		BP_BRAIN   = /obj/item/organ/internal/machine/posibrain,
		BP_VOICE_SYNTHESIZER = /obj/item/organ/internal/machine/voice_synthesizer,
		BP_DIAGNOSTICS_SUITE = /obj/item/organ/internal/machine/internal_diagnostics,
		BP_HYDRAULICS = /obj/item/organ/internal/machine/hydraulics,
		BP_ACTUATORS_LEFT = /obj/item/organ/internal/machine/actuators/left,
		BP_ACTUATORS_RIGHT = /obj/item/organ/internal/machine/actuators/right,
		BP_COOLING_UNIT = /obj/item/organ/internal/machine/cooling_unit,
		BP_REACTOR = /obj/item/organ/internal/machine/reactor,
		BP_CELL    = /obj/item/organ/internal/machine/power_core,
		BP_EYES  = /obj/item/organ/internal/eyes/optical_sensor,
		BP_IPCTAG = /obj/item/organ/internal/machine/ipc_tag
	)

/datum/species/machine/unbranded/get_light_color(mob/living/carbon/human/H)
	if (istype(H))
		return rgb(H.r_eyes, H.g_eyes, H.b_eyes)
