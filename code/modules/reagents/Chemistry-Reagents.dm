/datum/reagent
	var/name = "Reagent"
	var/id = "reagent"
	var/description = "A non-descript chemical."
	var/taste_description = "old rotten bandaids"
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/datum/reagents/holder = null
	var/reagent_state = SOLID
	var/list/data = null
	var/volume = 0
	var/metabolism = REM // This would be 0.2 normally
	var/ingest_met = 0
	var/touch_met = 0
	var/breathe_met = 0
	var/ingest_mul = 0.5
	var/touch_mul = 0
	var/breathe_mul = 0.75
	var/dose = 0
	var/max_dose = 0
	var/overdose = 0
	var/scannable = 0 // Shows up on health analyzers.
	var/affects_dead = 0
	var/glass_icon_state = null
	var/glass_name = null
	var/glass_desc = null
	var/glass_center_of_mass = null
	var/color = "#000000"
	var/color_weight = 1
	var/unaffected_species = IS_DIONA | IS_MACHINE	// Species that aren't affected by this reagent. Does not prevent affect_touch.
	var/metabolism_min = 0.01 //How much for the medicine to be present in the system to actually have an effect.
	var/conflicting_reagent //Reagents that conflict with this medicine, and cause adverse effects when in the blood.

	var/default_temperature = T0C + 20 //This is it's default spawning temperature, if none is provided.
	var/thermal_energy = 0 //Internal value, should never change.
	var/specific_heat = -1 //The higher, the more difficult it is to change its difficult. 0 or lower values indicate that the specific heat has yet to be assigned.
	var/fallback_specific_heat = -1 //Setting this value above 0 will set the specific heat to this value only if the system could not find an appropriate specific heat to assign using the recipe system.
	//Never ever ever ever change this value for datum/reagent. This should only be used for massive, yet specific things like drinks or food where it is infeasible to assign a specific heat value.

/datum/reagent/proc/initialize_data(var/newdata) // Called when the reagent is created.
	if(!isnull(newdata))
		data = newdata

/datum/reagent/proc/remove_self(var/amount) // Shortcut
	if (!holder)
		//PROCLOG_WEIRD("Null holder found. Name: [name], id: [id]")
		return

	holder.remove_reagent(id, amount)

// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays. The difference is that reagent is not directly on the mob's skin - it might just be on their clothing.
/datum/reagent/proc/touch_mob(var/mob/living/M, var/amount)
	return

/datum/reagent/proc/touch_obj(var/obj/O, var/amount) // Acid melting, cleaner cleaning, etc
	return

/datum/reagent/proc/touch_turf(var/turf/T, var/amount) // Cleaner cleaning, lube lubbing, etc, all go here
	return

/datum/reagent/proc/on_mob_life(var/mob/living/carbon/M, var/alien, var/location) // Currently, on_mob_life is called on carbons. Any interaction with non-carbon mobs (lube) will need to be done in touch_mob.
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

	removed = min(removed, volume)
	max_dose = max(volume, max_dose)

	if(overdose && (dose > overdose) && (location != CHEM_TOUCH))
		overdose(M, alien, removed, dose/overdose)

	if(dose == 0)
		initial_effect(M,alien)

	dose = min(dose + removed, max_dose)

	var/bodytempchange = Clamp((get_temperature() - M.bodytemperature) * removed * REAGENTS_BODYTEMP,-REAGENTS_BODYTEMP_MAX * removed, REAGENTS_BODYTEMP_MAX * removed)
	if(abs(bodytempchange) >= REAGENTS_BODYTEMP_MIN)
		M.bodytemperature += round(bodytempchange,REAGENTS_BODYTEMP_MIN)

	for(var/datum/reagent/R in M.bloodstr.reagent_list)
		if(istype(R, conflicting_reagent))
			affect_conflicting(M,alien,removed,R)
	if(removed >= metabolism_min)
		switch(location)
			if(CHEM_BLOOD)
				affect_blood(M, alien, removed)
			if(CHEM_INGEST)
				affect_ingest(M, alien, removed)
			if(CHEM_TOUCH)
				affect_touch(M, alien, removed)
			if(CHEM_BREATHE)
				affect_breathe(M, alien, removed)

	remove_self(removed)

//Initial effect is called once when the reagent first starts affecting a mob.
/datum/reagent/proc/initial_effect(var/mob/living/carbon/M, var/alien)
	return

//Final effect is called once when the reagent finishes affecting a mob.
/datum/reagent/proc/final_effect(var/mob/living/carbon/M)
	return

/datum/reagent/proc/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	return

/datum/reagent/proc/affect_conflicting(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagent/conflicting_reagent)
	M.adjustToxLoss(removed)

/datum/reagent/proc/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ingest_mul)
		affect_blood(M, alien, removed * ingest_mul)

/datum/reagent/proc/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	if(touch_mul)
		affect_blood(M, alien, removed * touch_mul)

/datum/reagent/proc/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed)
	if(breathe_mul)
		affect_blood(M, alien, removed * breathe_mul)

/datum/reagent/proc/overdose(var/mob/living/carbon/M, var/alien, var/removed = 0, var/scale = 1) // Overdose effect. Doesn't happen instantly.
	M.adjustToxLoss(REM)

/datum/reagent/proc/mix_data(var/newdata, var/newamount) // You have a reagent with data, and new reagent with its own data get added, how do you deal with that?
	return

/datum/reagent/proc/get_data() // Just in case you have a reagent that handles data differently.
	if(islist(data))
		return data.Copy()
	else if(data)
		return data

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	. = ..()
	holder = null

/* DEPRECATED - TODO: REMOVE EVERYWHERE */

/datum/reagent/proc/reaction_turf(var/turf/target)
	touch_turf(target)

/datum/reagent/proc/reaction_obj(var/obj/target)
	touch_obj(target)

/datum/reagent/proc/reaction_mob(var/mob/target)
	touch_mob(target)




