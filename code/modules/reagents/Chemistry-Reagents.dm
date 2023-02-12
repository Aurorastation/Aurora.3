/singleton/reagent
	var/name = "Reagent"
	var/description = "A non-descript chemical."
	var/taste_description = "old rotten bandaids"
	var/list/species_taste_description
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/reagent_state = SOLID
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/breathe_met = 0
	var/ingest_mul = 0.5
	var/touch_mul = 0
	var/breathe_mul = 0.75
	var/overdose = 0 // Volume of a chemical required in the blood to meet overdose criteria.
	var/od_minimum_dose = 5 // Metabolised dose of a chemical required to meet overdose criteria.
	var/scannable = 0 // Shows up on health analyzers.
	var/spectro_hidden = FALSE // doesn't show up on basic mass spectrometers, only shows on the advanced variant
	var/affects_dead = 0
	var/glass_icon_state = null
	var/glass_name = null
	var/glass_desc = null
	var/glass_center_of_mass = null
	var/condiment_icon_state = null
	var/condiment_name = null
	var/condiment_desc = null
	var/condiment_center_of_mass = null
	var/color = "#000000"
	var/color_weight = 1
	var/unaffected_species = IS_DIONA | IS_MACHINE	// Species that aren't affected by this reagent. Does not prevent affect_touch.
	var/metabolism_min = 0.01 //How much for the medicine to be present in the system to actually have an effect.
	var/conflicting_reagent //Reagents that conflict with this medicine, and cause adverse effects when in the blood.

	var/default_temperature = T0C + 20 //This is its default spawning temperature, if none is provided.
	var/specific_heat = -1 //The higher, the more difficult it is to change its temperature. 0 or lower values indicate that the specific heat has yet to be assigned.
	var/fallback_specific_heat = -1 //Setting this value above 0 will set the specific heat to this value only if the system could not find an appropriate specific heat to assign using the recipe system.
	//Never ever ever ever change this value for singleton/reagent. This should only be used for massive, yet specific things like drinks or food where it is infeasible to assign a specific heat value.

	var/germ_adjust = 0 // for makeshift bandages/disinfectant
	var/carbonated = FALSE // if it's carbonated or not

/singleton/reagent/proc/initialize_data(var/newdata, var/datum/reagents/holder) // Called when the reagent is created.
	if(!isnull(newdata))
		return newdata

/singleton/reagent/proc/remove_self(var/amount, var/datum/reagents/holder) // Shortcut
	holder.remove_reagent(type, amount) // Don't typecheck this, fix anywhere this is called with a null holder.
	if(ishuman(holder.my_atom))
		var/mob/living/carbon/human/H = holder.my_atom
		if(H.vessel && (/singleton/reagent/blood in H.vessel.reagent_data))
			if(H.vessel.reagent_data[/singleton/reagent/blood]["trace_chem"][type])
				H.vessel.reagent_data[/singleton/reagent/blood]["trace_chem"][type] += amount
			else
				H.vessel.reagent_data[/singleton/reagent/blood]["trace_chem"][type] = amount

// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/singleton/reagent/proc/touch_mob(var/mob/living/M, var/amount, var/datum/reagents/holder)
	return

/singleton/reagent/proc/touch_obj(var/obj/O, var/amount, var/datum/reagents/holder) // Acid melting, cleaner cleaning, etc
	return

/singleton/reagent/proc/touch_turf(var/turf/T, var/amount, var/datum/reagents/holder) // Cleaner cleaning, lube lubbing, etc, all go here
	return

/singleton/reagent/proc/get_overdose(mob/living/carbon/M, location, datum/reagents/holder)
	return overdose

/singleton/reagent/proc/get_od_min_dose(mob/living/carbon/M, location, datum/reagents/holder)
	return od_minimum_dose

/singleton/reagent/proc/is_overdosing(mob/living/carbon/M, location, datum/reagents/holder)
	var/OD = get_overdose(M, location, holder)
	var/OD_min = get_od_min_dose(M, location, holder)
	return OD && (REAGENT_VOLUME(holder, type) > OD) && (LAZYACCESS(M.chem_doses, type) > OD_min) && (!location || (location != CHEM_TOUCH)) //OD based on volume in blood, but waits for a small amount of the drug to metabolise before kicking in.

/singleton/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/location, var/datum/reagents/holder) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
	if(!istype(M))
		return
	if(!affects_dead && M.stat == DEAD)
		return
	if(alien & unaffected_species && location != CHEM_TOUCH)
		return

	var/removed = metabolism
	if(ingest_met && (location == CHEM_INGEST))
		removed = ingest_met
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met
	if(breathe_met && (location == CHEM_BREATHE))
		removed = breathe_met

	removed = M.get_metabolism(removed)

	if(is_overdosing(M, location, holder))
		overdose(M, alien, removed, LAZYACCESS(M.chem_doses, type)/get_overdose(M, location, holder), holder) //Actual overdose threshold now = overdose + od_minimum_dose. ie. Synaptizine; 5u OD threshold + 1 unit min. metab'd dose = 6u actual OD threshold.

	if(LAZYACCESS(M.chem_doses, type) <= 0)
		initial_effect(M,alien, holder)

	LAZYSET(M.chem_doses, type, LAZYACCESS(M.chem_doses, type) + removed)

	var/bodytempchange = Clamp((holder.get_temperature() - M.bodytemperature) * removed * REAGENTS_BODYTEMP,-REAGENTS_BODYTEMP_MAX * removed, REAGENTS_BODYTEMP_MAX * removed)
	if(abs(bodytempchange) >= REAGENTS_BODYTEMP_MIN)
		M.bodytemperature += round(bodytempchange,REAGENTS_BODYTEMP_MIN)
		holder.set_temperature(holder.get_temperature() - round(bodytempchange,REAGENTS_BODYTEMP_MIN))

	for(var/_R in M.bloodstr.reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		if(istype(R, conflicting_reagent))
			affect_conflicting(M,alien,removed,R, holder)

	if(removed >= metabolism_min)
		switch(location)
			if(CHEM_BLOOD)
				affect_blood(M, alien, removed, holder)
			if(CHEM_INGEST)
				affect_ingest(M, alien, removed, holder)
			if(CHEM_TOUCH)
				affect_touch(M, alien, removed, holder)
			if(CHEM_BREATHE)
				affect_breathe(M, alien, removed, holder)

	remove_self(removed, holder)

// Called when a beaker is thrown or something is hit with it, AND the beaker doesn't break.
/singleton/reagent/proc/apply_force(var/force, var/datum/reagents/holder)
	return force

//Initial effect is called once when the reagent first starts affecting a mob.
/singleton/reagent/proc/initial_effect(var/mob/living/carbon/M, var/alien, var/datum/reagents/holder)
	return

//Final effect is called once when the reagent finishes affecting a mob.
/singleton/reagent/proc/final_effect(var/mob/living/carbon/M, var/datum/reagents/holder)
	return

/singleton/reagent/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	return

// if your chem directly affects other chems, use this to make sure all the chem_effects are applied before the standard chem affect_thing is run
/singleton/reagent/proc/affect_chem_effect(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return FALSE
	if(!affects_dead && M.stat == DEAD)
		return FALSE
	if(alien & unaffected_species)
		return FALSE
	return TRUE

/singleton/reagent/proc/affect_conflicting(var/mob/living/carbon/M, var/alien, var/removed, var/singleton/reagent/conflicting_reagent, var/datum/reagents/holder)
	M.adjustToxLoss(removed)

/singleton/reagent/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ingest_mul)
		affect_blood(M, alien, removed * ingest_mul, holder)

/singleton/reagent/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(touch_mul)
		affect_blood(M, alien, removed * touch_mul, holder)

/singleton/reagent/proc/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(breathe_mul)
		affect_blood(M, alien, removed * breathe_mul, holder)

/singleton/reagent/proc/overdose(var/mob/living/carbon/M, var/alien, var/removed = 0, var/scale = 1, var/datum/reagents/holder) // Overdose effect. Doesn't happen instantly.
	M.adjustToxLoss(REM)

/singleton/reagent/proc/mix_data(var/newdata, var/newamount, var/datum/reagents/holder) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	return REAGENT_DATA(holder, type)

//Check to use when seeing if the person has the minimum dose of the reagent. Useful for stopping minimum transfer rate IV drips from applying chem effects
/singleton/reagent/proc/check_min_dose(var/mob/living/carbon/M, var/min_dose = 1)
	return (REAGENT_VOLUME(M.reagents, type) >= min_dose)
