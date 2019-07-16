/datum/species/machine/shell
	name = "Shell Frame" 
	hide_name = TRUE
	short_name = "jak"
	name_plural = "Shells"
	bodytype = "Human"
	neuter_ipc = FALSE

	blurb = "IPCs with humanlike properties. Their focus is on service, civilian, and medical, but there are no \
	job restrictions. Created in the late days of 2457, the Shell is a controversial IPC model equipped with a synthskin weave applied over its metal chassis \
	to create an uncannily close approximation of the organic form. Early models of Shell had the advantage of being able to compose themselves of a wide \
	 variety of organic parts, but contemporary models have been restricted to a single species for the sake of prosthetic integrity. The additional weight of \
	 the synthskin on the original Hephaestus frame reduces the efficacy of the unit's already strained coolant systems, and increases charge consumption."

	num_alternate_languages = 3

	icobase = 'icons/mob/human_races/human/r_human.dmi'
	deform = 'icons/mob/human_races/ipc/robotic.dmi'

	light_range = 0
	light_power = 0

	eyes = "eyes_s"
	show_ssd = "completely quiescent"

	max_nutrition_factor = 0.8

	heat_level_1 = 400
	heat_level_2 = 800
	heat_level_3 = 1600

	heat_discomfort_level = 400
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!",
		"Your synthetic flesh crawls in the heat, swelling into a disgusting morass of plastic."
		)

	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_EYE_COLOR | HAS_FBP | HAS_UNDERWEAR | HAS_SOCKS

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/shell),
		"groin" =  list("path" = /obj/item/organ/external/groin/shell),
		"head" =   list("path" = /obj/item/organ/external/head/shell),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/shell),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/shell),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/shell),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/shell),
		"l_hand" = list("path" = /obj/item/organ/external/hand/shell),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/shell),
		"l_foot" = list("path" = /obj/item/organ/external/foot/shell),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/shell)
		)

	sprint_temperature_factor = 1.3
	sprint_charge_factor = 0.85

/datum/species/machine/shell/get_light_color()
	return

/datum/species/machine/shell/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/machine/industrial
	name = "Heavy Frame"
	short_name = "ind"
	name_plural = "Industrials"
	bald = 1
	bodytype = "Heavy Machine"

	slowdown = 4

	blurb = "The first commercialized attempt Hephaestus Industries made at a line of industrial-type IPC. Designed for extra durability and increased weight loads, the first generation Industrial was considered a success, though it possessed some issues. A limited power cell and actuators designed for heavy lifting and not locomotion resulted in a slow and frequently charging machine. A special addition to the chassis makes up for these drawbacks - the ability to simply slot a suit cooling unit onto the model's back and make use of its built-in heat transferal conduits, allowing the Industrial to perform EVA without any extra peripherals such as a voidsuit."

	icobase = 'icons/mob/human_races/ipc/r_industrial.dmi'
	deform = 'icons/mob/human_races/ipc/r_industrial.dmi'
	preview_icon = 'icons/mob/human_races/ipc/industrial_preview.dmi'

	eyes = "eyes_industry"
	show_ssd = "completely quiescent"

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/industrial),
		"groin" =  list("path" = /obj/item/organ/external/groin/industrial),
		"head" =   list("path" = /obj/item/organ/external/head/industrial),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/industrial),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/industrial),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/industrial),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/industrial),
		"l_hand" = list("path" = /obj/item/organ/external/hand/industrial),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/industrial),
		"l_foot" = list("path" = /obj/item/organ/external/foot/industrial),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/industrial)
		)

	has_organ = list(
		"brain"   = /obj/item/organ/mmi_holder/posibrain,
		"cell"    = /obj/item/organ/cell,
		"optics"  = /obj/item/organ/eyes/optical_sensor,
		"ipc tag" = /obj/item/organ/ipc_tag,
		"diagnostics unit" = /obj/item/organ/diagnosticsunit,
		"coolant pump" = /obj/item/organ/coolantpump/heavy,
		"calibration system" = /obj/item/organ/powercontrolunit
	)

	flags = IS_IPC | ACCEPTS_COOLER
	appearance_flags = HAS_EYE_COLOR

	heat_level_1 = 600
	heat_level_2 = 1200
	heat_level_3 = 2400

	heat_discomfort_level = 800

	max_nutrition_factor = 1.25
	nutrition_loss_factor = 2

	sprint_speed_factor = 1.4
	sprint_temperature_factor = 0.9
	sprint_charge_factor = 1.1

/datum/species/machine/industrial/get_light_color()
	return LIGHT_COLOR_TUNGSTEN

/datum/species/machine/industrial/handle_death(var/mob/living/carbon/human/H)
	return

/datum/species/machine/terminator
	name = "Military Frame"
	short_name = "hks"
	name_plural = "HKs"
	bald = 1
	bodytype = "Heavy Machine"

	blurb = "\[REDACTED\]"

	icobase = 'icons/mob/human_races/ipc/r_terminator.dmi'
	deform = 'icons/mob/human_races/ipc/r_terminator.dmi'

	light_range = 0
	light_power = 0

	unarmed_types = list(/datum/unarmed_attack/terminator)
	rarity_value = 20

	language = "Hephaestus Darkcomms"
	name_language = "Hephaestus Darkcomms"

	eyes = "eyes_terminator"
	has_floating_eyes = 1

	flash_mod = 0
	siemens_coefficient = 0
	breakcuffs = list(MALE,FEMALE,NEUTER)
	mob_size = 20

	show_ssd = "laying inert, its activation glyph dark"
	death_sound = 'sound/effects/bang.ogg'
	death_message = "collapses to the ground with a CLUNK, and begins to beep ominously."

	heat_level_1 = 1500
	heat_level_2 = 2000
	heat_level_3 = 5000

	body_temperature = null
	passive_temp_gain = 0

	flags = IS_IPC | ACCEPTS_COOLER | NO_EMBED
	spawn_flags = IS_RESTRICTED
	appearance_flags = HAS_HAIR_COLOR
	vision_flags = DEFAULT_SIGHT | SEE_MOBS

	blood_color = "#1F181F"
	flesh_color = "#575757"
	virus_immune = 1
	reagent_tag = IS_MACHINE

	inherent_verbs = list(
		/mob/living/carbon/human/proc/self_destruct,
		/mob/living/carbon/human/proc/detonate_flechettes,
		/mob/living/carbon/human/proc/state_laws,
		/mob/living/carbon/human/proc/detach_limb,
		/mob/living/carbon/human/proc/attach_limb
	)

	has_organ = list(
		"brain" = /obj/item/organ/mmi_holder/posibrain/terminator,
		"shielded cell" = /obj/item/organ/cell/terminator,
		"optics" = /obj/item/organ/eyes/optical_sensor/terminator,
		"data core" = /obj/item/organ/data,
		"diagnostics unit" = /obj/item/organ/diagnosticsunit,
		"coolant pump" = /obj/item/organ/coolantpump,
		"calibration system" = /obj/item/organ/powercontrolunit,
		"tesla unit" = /obj/item/organ/augment/integratedtesla
	)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/terminator),
		"groin" =  list("path" = /obj/item/organ/external/groin/terminator),
		"head" =   list("path" = /obj/item/organ/external/head/terminator),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/terminator),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/terminator),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/terminator),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/terminator),
		"l_hand" = list("path" = /obj/item/organ/external/hand/terminator),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/terminator),
		"l_foot" = list("path" = /obj/item/organ/external/foot/terminator),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/terminator)
		)


	heat_discomfort_level = 2000
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	stamina	= -1
	sprint_speed_factor = 1.25
	slowdown = 1

	sprint_temperature_factor = 0.6
	sprint_charge_factor = 0.3

/datum/species/machine/terminator/get_light_color()
	return

/datum/species/machine/terminator/handle_death(var/mob/living/carbon/human/H)
	..()
	playsound(H.loc, 'sound/items/countdown.ogg', 125, 1)
	spawn(15)
		explosion(H.loc, -1, 1, 5)
		H.gib()

// -- Branded units --

/datum/species/machine/zenghu
	name = "Light Frame"
	short_name = "zhf"
	bodytype = null

	icobase = 'icons/mob/human_races/ipc/r_ind_zenghu.dmi'
	deform = 'icons/mob/human_races/ipc/r_ind_zenghu.dmi'
	preview_icon = 'icons/mob/human_races/ipc/ind_zenghu_preview.dmi'

	eyes = "zenghu_eyes"
	sprint_speed_factor = 1.5

	appearance_flags = HAS_EYE_COLOR

	examine_color = "#ff00ff"

	blurb = "Being a corporation focused primarily on medical sciences and treatments, Zeng-Hu Pharmaceuticals had little interest in the market of synthetics in the beginning (especially considering a good portion of Zeng-Hu employees are Skrellian). However, after seeing the advances in almost all fields of the galactic market after the advent of synthetics, Zeng-Hu set aside some funds for their own robotics department, focused mainly on medical service and even science related operations. Having taken some inspiration from biological life, the chassis has an interesting leg design: digitigrade legs provide the chassis with enhanced speed. A downside to this development was the reduction of metals on the chassis. Most plates covering the sensitive interior electronics are polymer casts to reduce the weight of the unit, resulting in a not-so-durable android."

	has_limbs = list(
		"chest"  = list("path" = /obj/item/organ/external/chest/industrial/zenghu),
		"groin"  = list("path" = /obj/item/organ/external/groin/industrial/zenghu),
		"head"   = list("path" = /obj/item/organ/external/head/industrial/zenghu),
		"l_arm"  = list("path" = /obj/item/organ/external/arm/industrial/zenghu),
		"r_arm"  = list("path" = /obj/item/organ/external/arm/right/industrial/zenghu),
		"l_leg"  = list("path" = /obj/item/organ/external/leg/industrial/zenghu),
		"r_leg"  = list("path" = /obj/item/organ/external/leg/right/industrial/zenghu),
		"l_hand" = list("path" = /obj/item/organ/external/hand/industrial/zenghu),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/industrial/zenghu),
		"l_foot" = list("path" = /obj/item/organ/external/foot/industrial/zenghu),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/industrial/zenghu)
	)

	has_organ = list(
		"brain"   = /obj/item/organ/mmi_holder/posibrain,
		"cell"    = /obj/item/organ/cell,
		"optics"  = /obj/item/organ/eyes/optical_sensor,
		"ipc tag" = /obj/item/organ/ipc_tag,
		"diagnostics unit" = /obj/item/organ/diagnosticsunit,
		"coolant pump" = /obj/item/organ/coolantpump,
		"calibration system" = /obj/item/organ/powercontrolunit
	)

/datum/species/machine/zenghu/get_light_color(mob/living/carbon/human/H)
	if (istype(H))
		return rgb(H.r_eyes, H.g_eyes, H.b_eyes)