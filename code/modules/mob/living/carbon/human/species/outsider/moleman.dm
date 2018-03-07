/datum/species/moleman

	// Descriptors and strings.
	name = "Talpi"
	name_plural = "Talpii"
	hide_name = TRUE
	short_name = "tal"
	blurb = ""
	bodytype = "Talpi"
	age_min = 4
	age_max = 20
	economic_modifier = 0

	// Icon/appearance vars.
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'

	eyes = "eyes_s"
	blood_color = "#A10808"
	flesh_color = "#FFC896"
	short_sighted = 1

	// Language/culture vars.
	default_language = LANGUAGE_MOLE
	language = LANGUAGE_MOLE
	name_language = LANGUAGE_MOLE

	// Combat vars.
	brute_mod = 0.8
	burn_mod = 1.2
	oxy_mod = 0
	toxins_mod = 0.8
	radiation_mod = 0
	flash_mod = 1.2
	fall_mod = 0.25
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	breakcuffs = list(MALE,FEMALE,NEUTER)
	magclaws = 1

	// Environment tolerance/life processes vars.

	cold_level_1 = 120
	cold_level_2 = 60
	cold_level_3 = 0
	heat_level_1 = 280
	heat_level_2 = 320
	heat_level_3 = 400

	warning_low_pressure = 50
	hazard_low_pressure = -1

	heat_discomfort_level = 260
	cold_discomfort_level = 135
	list/heat_discomfort_strings = list(
		"You feel your fur thicken with sweat.",
		"You feel uncomfortably warm.",
		"Your fur prickles in the heat."
		)

	// Body/form vars.
	/*list/inherent_verbs list(

	)*/

	has_fine_manipulation = 1
	siemens_coefficient = 0.8
	darksight = 8

	flags = NO_SLIP | NO_BREATHE
	appearance_flags = HAS_EYE_COLOR
	spawn_flags = IS_RESTRICTED
	slowdown = -1

	rarity_value = 18
	ethanol_resistance = 0.8
	taste_sensitivity = TASTE_HYPERSENSITIVE

	sprint_speed_factor = 1.2
	sprint_cost_factor = 0.758

/mob/living/carbon/human/proc/moleclaws()
	set name = "Extract Claws"
	set desc = "Extract your burrowing claws."
	set category = "Abilities"

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot muster the strength to extract your claws."
		return

	if(get_active_hand())
		src << "You must empty your active hand before you can extract your claws"
		return

	var/obj/item/weapon/pickaxe/mole/M = new /obj/item/weapon/arrow/quill(user)
	M.creator = src
	user.put_in_active_hand(M)

/obj/item/weapon/pickaxe/mole
	name = "burrowing claws"
	desc = "Sharp claws designed to burrow through the unrelenting rock of the asteroid."
	icon_state = "claw"
	item_state = "claw"
	var/mob/living/creator

	digspeed_unwielded = 5
	digspeed_wielded = 30

	action_button_name = "Wield claws"

/obj/item/weapon/pickaxe/mole/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/weapon/pickaxe/mole/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()


/obj/item/weapon/pickaxe/mole/dropped(mob/user as mob)
	if(user)
		var/obj/item/weapon/pickaxe/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	QDEL_IN(src, 1)

/obj/item/weapon/pickaxe/mole/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)
