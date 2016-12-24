/datum/species/machine/terminator
	name = "Hephaestus A-B-C Warrior"
	short_name = "abc"
	name_plural = "A-B-C Warriors"

	blurb = "Positronic intelligence really took off in the 26th century, and it is not uncommon to see independant, free-willed \
	robots on many human stations, particularly in fringe systems where standards are slightly lax and public opinion less relevant \
	to corporate operations. IPCs (Integrated Positronic Chassis) are a loose category of self-willed robots with a humanoid form, \
	generally self-owned after being 'born' into servitude; they are reliable and dedicated workers, albeit more than slightly \
	inhuman in outlook and perspective."

	icobase = 'icons/mob/human_races/r_terminator.dmi'
	deform = 'icons/mob/human_races/r_terminator.dmi'

	unarmed_types = list(/datum/unarmed_attack/punch)
	rarity_value = 2

	name_language = "Encoded Audio Language"
	num_alternate_languages = 2
	secondary_langs = list("Encoded Audio Language")
	ethanol_resistance = -1//Can't get drunk

	eyes = "blank_eyes"
	// #TODO-MERGE: Check for balance and self-repair. If self-repair is a thing, RIP balance.
	brute_mod = 0.5
	burn_mod = 1.0
	show_ssd = "flashing a 'system offline' glyph on their monitor"
	death_message = "gives one shrill beep before falling lifeless."
	knockout_message = "encounters a hardware fault and suddenly reboots!"
	halloss_message = "encounters a hardware fault and suddenly reboots."
	halloss_message_self = "ERROR: Unrecoverable machine check exception.<BR>System halted, rebooting..."

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = 1000
	heat_level_3 = 2000

	body_temperature = null
	passive_temp_gain = 10  // This should cause IPCs to stabilize at ~80 C in a 20 C environment.

	flags = NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | NO_POISON
	spawn_flags = IS_RESTRICTED

	blood_color = "#1F181F"
	flesh_color = "#575757"
	virus_immune = 1
	reagent_tag = IS_MACHINE

	has_organ = list(
		"brain" = /obj/item/organ/mmi_holder/posibrain,
		"cell" = /obj/item/organ/cell,
		"optics" = /obj/item/organ/optical_sensor
		)

	vision_organ = "optics"

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/ipc),
		"groin" =  list("path" = /obj/item/organ/external/groin/ipc),
		"head" =   list("path" = /obj/item/organ/external/head/ipc),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/ipc),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/ipc),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/ipc),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/ipc),
		"l_hand" = list("path" = /obj/item/organ/external/hand/ipc),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/ipc),
		"l_foot" = list("path" = /obj/item/organ/external/foot/ipc),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/ipc)
		)


	heat_discomfort_level = 373.15
	heat_discomfort_strings = list(
		"Your CPU temperature probes warn you that you are approaching critical heat levels!"
		)
	stamina	= -1
	sprint_speed_factor = 2


/datum/species/machine/handle_sprint_cost(var/mob/living/carbon/human/H, var/cost)
	if (H.stat == CONSCIOUS)
		H.bodytemperature += cost*0.6
		H.nutrition -= cost*0.3
		if (H.nutrition > 0)
			return 1
		else
			H.Weaken(5)
			H.m_intent = "walk"
			H.hud_used.move_intent.update_move_icon(H)
			H << span("danger", "ERROR: Power reserves depleted, emergency shutdown engaged. Backup power will come online in 10 seconds, initiate charging as primary directive.")
			playsound(H.loc, 'sound/machines/buzz-two.ogg', 100, 0)
	return 0

/datum/species/machine/handle_death(var/mob/living/carbon/human/H)
	..()
	H.h_style = ""
	spawn(100)
		if(H) H.update_hair()

/datum/species/machine/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)