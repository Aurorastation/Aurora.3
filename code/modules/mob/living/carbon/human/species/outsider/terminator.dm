/datum/species/machine/terminator
	name = "Hunter-Killer"
	short_name = "hks"
	name_plural = "HKs"

	icobase = 'icons/mob/human_races/r_terminator.dmi'
	deform = 'icons/mob/human_races/r_terminator.dmi'

	unarmed_types = list(/datum/unarmed_attack/terminator)
	rarity_value = 20

	language = "Ceti Basic"
	name_language = "Hephaestus Darkcomms"

	eyes = "eyes_terminator"
	has_floating_eyes = 1

	brute_mod = 0.2
	burn_mod = 0.4
	flash_mod = 0
	siemens_coefficient = 0

	show_ssd = "laying inert, its activation glyph dark."
	death_sound = 'sound/effects/bang.ogg'
	death_message = "collapses to the ground with a CLUNK, and begins to beep ominously."

	heat_level_1 = 1500
	heat_level_2 = 2000
	heat_level_3 = 5000

	body_temperature = null
	passive_temp_gain = 0

	flags = NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | NO_POISON
	spawn_flags = IS_RESTRICTED
	vision_flags = SEE_SELF | SEE_MOBS

	blood_color = "#1F181F"
	flesh_color = "#575757"
	virus_immune = 1
	reagent_tag = IS_MACHINE

	inherent_verbs = list(
		/mob/living/carbon/human/proc/self_destruct,
		/mob/living/carbon/human/proc/detonate_flechettes,
		/mob/living/carbon/human/proc/state_laws
		)

	has_organ = list(
		"brain" = /obj/item/organ/mmi_holder/posibrain/terminator,
		"shielded cell" = /obj/item/organ/cell/terminator,
		"optics" = /obj/item/organ/optical_sensor,
		"data core" = /obj/item/organ/data
		)

	vision_organ = "optics"

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
	sprint_speed_factor = 2.5
	slowdown = 1


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
	spawn(10)
		playsound(H.loc, 'sound/items/countdown.ogg', 125, 1)
		spawn(20)
			explosion(H, -1, -1, 4)
			H.gib()

/datum/species/machine/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)