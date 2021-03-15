/datum/species/getmorean
	name = SPECIES_GETMOREAN
	hide_name = FALSE
	short_name = "get"
	name_plural = "Getmoreans"
	bodytype = BODYTYPE_GETMOREAN
	category_name = "Getmorean"
	age_max = 20
	economic_modifier = 4 // Getmorean don't get paid much money at all, as they're technically a hired corperate entity.
	icobase = 'icons/mob/human_races/getmorean/r_getmorean.dmi'
	deform = 'icons/mob/human_races/getmorean/r_def_getmorean.dmi'
	preview_icon = 'icons/mob/human_races/getmorean/getmorean_preview.dmi'

	default_genders = list(MALE)

	// No need to eat or drink. They are drink.
	max_hydration_factor = -1
	max_nutrition_factor = -1

	flesh_color = "#333333"

	mob_size = MOB_SMALL

	hud_type = /datum/hud_data/getmorean // Doesn't have a head. No head slots.

	brute_mod =     3.0                  // Physical damage multiplier.
	burn_mod =      0.3                  // Burn damage multiplier.
	oxy_mod =       0                    // Oxyloss modifier
	toxins_mod =    0                    // Toxloss modifier
	radiation_mod = 0                    // Radiation modifier
	flash_mod =     0                    // Stun from blindness modifier.
	fall_mod =      0                    // Fall damage modifier, further modified by brute damage modifier
	inherent_eye_protection = 1          // If set, this species has this level of inherent eye protection.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = 1000
	heat_level_3 = 2000

	// Always looks like pepsi, regardless of the flavour.
	blood_color = "#654321"

	flags = NO_CHUBBY | NO_BREATHE | NO_SCAN | NO_PAIN | NO_POISON


	primitive_form = null

	unarmed_types = list(
		/datum/unarmed_attack/stomp,
		/datum/unarmed_attack/kick,
		/datum/unarmed_attack/punch
	)


	blurb = "The Getmore Chocolate Corperation, A Subsidiary of Nanotrasen, attempted to produce a \
	genetically modified line of sodas in order to dynamically appeal to customers. The Result? Getmoreans. \
	A sentient line of soda products with human features, these human-can hybrides are famous for speaking \
	corperate double speak, and generally being creepy. Instead of organs, they have a sweet tasting yet fizzy \
	syrup that seems to serve the same functions. Because of this, things like temperature and radation have little \
	effect on the cans, but being made of thin aluminum makes them extra weak to punches."
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SOL_COMMON)

	mob_size = 9
	spawn_flags = CAN_JOIN
	appearance_flags = 0
	remains_type = /obj/effect/decal/remains/human

	// Getmorean are cans, and so sprinting is clunky.
	stamina = 90
	stamina_recovery = 5
	sprint_speed_factor = 0.7
	sprint_cost_factor = 0.5

	climb_coeff = 0.2


	has_organ = list(

	)

	// Getmoreans don't need heads. Heads are for species that aren't part can.
	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right),
		"l_foot" = list("path" = /obj/item/organ/external/foot),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right)
	)

/datum/species/getmorean/handle_death_check(var/mob/living/carbon/human/H)
	if(H.get_total_health() <= config.health_threshold_dead)
		return TRUE
	return FALSE

/datum/species/getmorean/equip_later_gear(var/mob/living/carbon/human/H)
	var/obj/item/device/radio/R = new /obj/item/device/radio(H)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(R, slot_r_hand)
	else
		H.equip_to_slot_or_del(R, slot_in_backpack)
	if(!QDELETED(R))
		R.autodrobe_no_remove = 1