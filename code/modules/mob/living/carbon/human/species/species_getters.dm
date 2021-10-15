/datum/species/proc/get_pain_mod(var/mob/living/carbon/human/H)
	return pain_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_PAIN_MOD)

/datum/species/proc/get_brute_mod(var/mob/living/carbon/human/H)
	return brute_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_BRUTE_MOD)

/datum/species/proc/get_burn_mod(var/mob/living/carbon/human/H)
	return burn_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_BURN_MOD)

/datum/species/proc/get_oxy_mod(var/mob/living/carbon/human/H)
	return oxy_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_OXY_MOD)

/datum/species/proc/get_toxins_mod(var/mob/living/carbon/human/H)
	return toxins_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_TOXINS_MOD)

/datum/species/proc/get_radiation_mod(var/mob/living/carbon/human/H)
	return radiation_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_RADIATION_MOD)

/datum/species/proc/get_flash_mod(var/mob/living/carbon/human/H)
	return flash_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_FLASH_MOD)

/datum/species/proc/get_fall_mod(var/mob/living/carbon/human/H)
	return fall_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_FALL_MOD)

/datum/species/proc/get_grab_mod(var/mob/living/carbon/human/H)
	return grab_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_GRAB_MOD)

/datum/species/proc/get_resist_mod(var/mob/living/carbon/human/H)
	return resist_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_RESIST_MOD)

/datum/species/proc/get_metabolism_mod(var/mob/living/carbon/human/H)
	return metabolism_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_METABOLISM_MOD)

/datum/species/proc/get_bleed_mod(var/mob/living/carbon/human/H)
	return bleed_mod + LAZYACCESS(H.species_mod_modifiers, SPECIES_BLEED_MOD)


/datum/species/proc/get_hazard_high_pressure(var/mob/living/carbon/human/H)
	return hazard_high_pressure + LAZYACCESS(H.species_mod_modifiers, SPECIES_HAZARD_HIGH_PRESSURE)

/datum/species/proc/get_warning_high_pressure(var/mob/living/carbon/human/H)
	return warning_high_pressure + LAZYACCESS(H.species_mod_modifiers, SPECIES_WARNING_HIGH_PRESSURE)

/datum/species/proc/get_warning_low_pressure(var/mob/living/carbon/human/H)
	return warning_low_pressure + LAZYACCESS(H.species_mod_modifiers, SPECIES_WARNING_LOW_PRESSURE)

/datum/species/proc/get_hazard_low_pressure(var/mob/living/carbon/human/H)
	return hazard_low_pressure + LAZYACCESS(H.species_mod_modifiers, SPECIES_HAZARD_LOW_PRESSURE)


/datum/species/proc/get_slowdown(var/mob/living/carbon/human/H)
	return slowdown + LAZYACCESS(H.species_mod_modifiers, SPECIES_SLOWDOWN)


/datum/species/proc/get_stamina_recovery(var/mob/living/carbon/human/H, var/baseline)
	if(baseline)
		return stamina_recovery + LAZYACCESS(H.species_mod_modifiers, SPECIES_STAMINA_RECOVERY)
	return H.stamina_recovery + LAZYACCESS(H.species_mod_modifiers, SPECIES_STAMINA_RECOVERY)


/datum/species/proc/get_sprint_speed_factor(var/mob/living/carbon/human/H, var/baseline)
	if(baseline)
		return sprint_speed_factor + LAZYACCESS(H.species_mod_modifiers, SPECIES_SPRINT_SPEED_FACTOR)
	return H.sprint_speed_factor + LAZYACCESS(H.species_mod_modifiers, SPECIES_SPRINT_SPEED_FACTOR)

/datum/species/proc/get_sprint_cost_factor(var/mob/living/carbon/human/H, var/baseline)
	if(baseline)
		return sprint_cost_factor + LAZYACCESS(H.species_mod_modifiers, SPECIES_SPRINT_COST_FACTOR)
	return H.sprint_cost_factor + LAZYACCESS(H.species_mod_modifiers, SPECIES_SPRINT_COST_FACTOR)

/datum/species/proc/get_exhaust_threshold(var/mob/living/carbon/human/H, var/baseline)
	if(baseline)
		return exhaust_threshold + LAZYACCESS(H.species_mod_modifiers, SPECIES_EXHAUST_THRESHOLD)
	return H.exhaust_threshold + LAZYACCESS(H.species_mod_modifiers, SPECIES_EXHAUST_THRESHOLD)
