/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/carbon/human/var/datum/reagents/vessel	//Container for blood and BLOOD ONLY. Do not transfer other chems here.

//Initializes blood vessels
/mob/living/carbon/human/proc/make_blood()
	if(vessel)
		return

	vessel = new/datum/reagents(species.blood_volume, src)

	if(species && species.flags & NO_BLOOD) //We want the var for safety but we can do without the actual blood.
		return

	vessel.add_reagent(/singleton/reagent/blood, species.blood_volume, temperature = species?.body_temperature)
	fixblood()

//Resets blood data
/mob/living/carbon/human/proc/fixblood()
	if(!REAGENT_VOLUME(vessel, /singleton/reagent/blood))
		return
	LAZYINITLIST(vessel.reagent_data)
	LAZYSET(vessel.reagent_data, /singleton/reagent/blood, get_blood_data())

//Makes a blood drop, leaking amt units of blood from the mob
/mob/living/carbon/human/proc/drip(var/amt as num, var/tar = src, var/spraydir)

	if(!amt || species && species.flags & NO_BLOOD) //TODO: Make drips come from the reagents instead.
		return

	vessel.remove_reagent(/singleton/reagent/blood,amt)
	blood_splatter(tar, src, spray_dir = spraydir)

/mob/living/carbon/human/proc/blood_squirt(var/amt, var/turf/sprayloc, var/blood_spray_distance)
	if(amt <= 0 || !istype(sprayloc))
		return
	var/spraydir = pick(GLOB.alldirs)
	amt = Ceiling(amt/blood_spray_distance)
	var/bled = 0
	for(var/i = 1 to blood_spray_distance)
		sprayloc = get_step(sprayloc, spraydir)
		if(!istype(sprayloc) || (sprayloc.density && !iswall(sprayloc)))
			break
		var/hit_mob
		for(var/thing in sprayloc)
			var/atom/A = thing
			if(!A.simulated || !ishuman(A) || !(A.CanPass(src, sprayloc)) || hit_mob)
				continue

			var/mob/living/carbon/human/H = A
			if(H.lying)
				continue

			H.bloody_body(src)
			H.bloody_hands(src)
			var/blinding = FALSE
			if(ran_zone(BP_HEAD, 75))
				blinding = TRUE
				for(var/obj/item/I in list(H.head, H.glasses, H.wear_mask))
					if(I && (I.body_parts_covered & EYES))
						blinding = FALSE
						break
			if(blinding)
				H.eye_blurry = max(H.eye_blurry, 10)
				H.eye_blind = max(H.eye_blind, 5)
				to_chat(H, SPAN_DANGER("You are blinded by a spray of blood!"))
			else
				to_chat(H, SPAN_DANGER("You are hit by a spray of blood!"))
			hit_mob = TRUE

		drip(amt, sprayloc, spraydir)
		bled += amt
		if(hit_mob || iswall(sprayloc))
			break
	return bled

/mob/living/carbon/human/proc/get_blood_volume()
	return round((REAGENT_VOLUME(vessel, /singleton/reagent/blood)/species.blood_volume)*100)

/mob/living/carbon/human/proc/get_blood_circulation()
	var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]

	var/blood_volume = get_blood_volume()

	if(!heart)
		return 0.25 * blood_volume

	var/recent_pump = LAZYACCESS(heart.external_pump, 1) > world.time - (20 SECONDS)
	var/pulse_mod = heart.base_pump_rate
	var/min_efficiency = recent_pump ? 0.5 : 0.3

	// Check if any components on the user wish to mess with the pump rate.
	SEND_SIGNAL(src, COMSIG_HEART_PUMP_EVENT, heart, &blood_volume, &recent_pump, &pulse_mod, &min_efficiency)

	if((status_flags & FAKEDEATH) || BP_IS_ROBOTIC(heart))
		pulse_mod = heart.norm_pump_modifier
	else
		switch(heart.pulse)
			if(PULSE_NONE)
				if(recent_pump)
					pulse_mod = LAZYACCESS(heart.external_pump, 2)
				else
					pulse_mod *= heart.none_pump_modifier
			if(PULSE_SLOW)
				pulse_mod *= heart.slow_pump_modifier
			if(PULSE_NORM)
				pulse_mod *= heart.norm_pump_modifier
			if(PULSE_FAST)
				pulse_mod *= heart.fast_pump_modifier
			if(PULSE_2FAST)
				pulse_mod *= heart.too_fast_pump_modifier
			if(PULSE_THREADY)
				pulse_mod *= heart.thready_pump_modifier
	blood_volume *= pulse_mod * max(min_efficiency, (1-(heart.damage / heart.max_damage)))

	return min(blood_volume, 100)

/mob/living/carbon/human/proc/get_blood_oxygenation()
	var/blood_volume = get_blood_circulation()

	if(is_asystole() || (status_flags & FAKEDEATH)) // Heart is missing or isn't beating and we're not breathing (hardcrit)
		return min(blood_volume, BLOOD_VOLUME_SURVIVE)

	if(!need_breathe())
		return blood_volume

	var/blood_volume_mod = max(0, 1 - getOxyLoss()/(species.total_health/2))
	var/oxygenated_add = 0

	// Check if any components on the user wish to mess with the blood oxygenation.
	SEND_SIGNAL(src, COMSIG_BLOOD_OXYGENATION_EVENT, &blood_volume, &blood_volume_mod, &oxygenated_add)

	if(chem_effects[CE_OXYGENATED] == 1) // Dexalin.
		oxygenated_add += 0.5
	else if(chem_effects[CE_OXYGENATED] >= 2) // Dexplus.
		oxygenated_add += 0.8
	blood_volume_mod = blood_volume_mod + oxygenated_add - (blood_volume_mod * oxygenated_add)
	blood_volume = blood_volume * blood_volume_mod
	return min(blood_volume, 100)

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to the container, preserving all data in it.
/mob/living/carbon/proc/take_blood(obj/item/reagent_containers/container, var/amount)
	container.reagents.add_reagent(/singleton/reagent/blood, amount, get_blood_data(), temperature = species?.body_temperature)
	return TRUE

//For humans, blood does not appear from blue, it comes from vessels.
/mob/living/carbon/human/take_blood(obj/item/reagent_containers/container, var/amount)
	if(!should_have_organ(BP_HEART))
		reagents.trans_to_obj(container, amount)
		return TRUE

	if(vessel.total_volume < amount)
		return FALSE

	vessel.trans_to_holder(container.reagents, amount)

	if(vessel.has_reagent(/singleton/reagent/blood))
		LAZYSET(vessel.reagent_data, /singleton/reagent/blood, get_blood_data())
	vessel.trans_to_holder(container.reagents, amount)
	return TRUE

//Transfers blood from container to vessels
/mob/living/carbon/proc/inject_blood(var/amount, var/datum/reagents/donor)
	var/list/injected_data = REAGENT_DATA(donor, /singleton/reagent/blood)
	var/chems = LAZYACCESS(injected_data, "trace_chem")
	for(var/C in chems)
		reagents.add_reagent(C, (text2num(chems[C]) / species.blood_volume) * amount)//adds trace chemicals to owner's blood

//Transfers blood from reagents to vessel, respecting blood types compatability.
/mob/living/carbon/human/inject_blood(var/amount, var/datum/reagents/donor)
	if(!should_have_organ(BP_HEART))
		reagents.add_reagent(/singleton/reagent/blood, amount, REAGENT_DATA(donor, /singleton/reagent/blood), temperature = species?.body_temperature)
		return
	// Incompatibility is handled in mix_data now.
	vessel.add_reagent(/singleton/reagent/blood, amount, REAGENT_DATA(donor, /singleton/reagent/blood), temperature = species?.body_temperature)
	..()

/// Returns true if blood is incompatible, false otherwise.
/// Checks donor and receiver blood types, both args are strings.
/proc/blood_incompatible(var/donor, var/receiver, var/donor_species, var/receiver_species)
	// Early exit so as to not check bad args
	if(!donor || !receiver)
		return FALSE

	// Check species
	if(donor_species && receiver_species)
		if(donor_species != receiver_species)
			return TRUE

	// Check for Synthetic Blood Substitute (SBS).
	// SBS is supposed to be incompatible with non-SBS, and the other way around.
	if(donor=="SBS" || receiver=="SBS")
		if(donor!=receiver)
			return TRUE

	// Parse the blood type
	var/donor_antigen = copytext(donor,1,length(donor))
	var/receiver_antigen = copytext(receiver,1,length(receiver))
	var/donor_rh = (findtext(donor,"+")>0)
	var/receiver_rh = (findtext(receiver,"+")>0)

	// Do the actual check
	if(donor_rh && !receiver_rh)
		return TRUE
	switch(receiver_antigen)
		if("A")
			if(donor_antigen != "A" && donor_antigen != "O") return TRUE
		if("B")
			if(donor_antigen != "B" && donor_antigen != "O") return TRUE
		if("O")
			if(donor_antigen != "O") return TRUE
		//AB is a universal receiver.
	return FALSE

/mob/living/carbon/proc/get_blood_color()
	if(dna?.b_type == "SBS") // synthetic blood substitute
		return COLOR_SYNTH_BLOOD
	else if(species)
		return species.blood_color
	else
		return COLOR_HUMAN_BLOOD

/mob/living/carbon/proc/get_blood_data()
	var/data = list()
	data["donor"] = WEAKREF(src)
	if(dna)
		data["blood_DNA"] = dna.unique_enzymes
		data["blood_type"] = dna.b_type
	else
		data["blood_DNA"] = md5(REF(src))
		data["blood_type"] = "O+"
	if(species)
		data["species"] = species.bodytype
		data["blood_colour"] = get_blood_color()
	var/list/temp_chem = list()
	for(var/R in reagents.reagent_volumes)
		temp_chem[R] = REAGENT_VOLUME(reagents, R)
	data["trace_chem"] = temp_chem
	data["dose_chem"] = chem_doses.Copy()
	return data

/mob/living/carbon/human/get_blood_data()
	. = ..()
	var/list/trace_chems = list()
	if(LAZYLEN(vessel.reagent_data))
		trace_chems = LAZYACCESS(vessel.reagent_data[/singleton/reagent/blood], "trace_chem") || list()
	.["trace_chem"] = trace_chems.Copy()

/proc/blood_splatter(var/target, var/source, var/large, var/spray_dir, var/sourceless_color)
	var/obj/effect/decal/cleanable/blood/splatter
	var/decal_type = /obj/effect/decal/cleanable/blood/splatter
	if(sourceless_color == COLOR_OIL)
		decal_type = /obj/effect/decal/cleanable/blood/oil/streak
	if(ishuman(source))
		var/mob/living/carbon/human/H = source
		if(H.isSynthetic())
			decal_type = /obj/effect/decal/cleanable/blood/oil/streak
	var/turf/T = get_turf(target)

	// Are we dripping or splattering?
	var/list/drips = list()
	// Only a certain number of drips (or one large splatter) can be on a given turf.
	for(var/obj/effect/decal/cleanable/blood/drip/drop in T)
		drips |= drop.drips
		qdel(drop)
	if(!large && length(drips) < 3)
		decal_type = /obj/effect/decal/cleanable/blood/drip
		if(sourceless_color == COLOR_OIL)
			decal_type = /obj/effect/decal/cleanable/blood/drip/oil

	// Find a blood decal or create a new one.
	if(T)
		var/list/existing = filter_list(T.contents, decal_type)
		if(length(existing) > 3)
			splatter = pick(existing)
	if(!splatter)
		splatter = new decal_type(T)

	var/obj/effect/decal/cleanable/blood/drip/drop = splatter
	if(istype(drop) && drips && drips.len && !large)
		drop.overlays |= drips
		drop.drips |= drips

	// If there's no data to copy, call it quits here.
	var/list/blood_data
	if(islist(source))
		blood_data = source
	if(ishuman(source))
		var/mob/living/carbon/human/donor = source
		blood_data = donor.get_blood_data()
	else if(isatom(source))
		var/atom/donor = source
		blood_data = REAGENT_DATA(donor.reagents, /singleton/reagent/blood)
	else if(!source)
		if(sourceless_color)
			splatter.basecolor = sourceless_color
			splatter.update_icon()
		return splatter
	if(!islist(blood_data))
		return splatter

	// Update appearance.
	if(blood_data["blood_colour"])
		splatter.basecolor = blood_data["blood_colour"]
		splatter.update_icon()
	if(spray_dir)
		splatter.icon_state = "squirt"
		splatter.set_dir(spray_dir)

	// Update blood information.
	if(blood_data["blood_DNA"])
		splatter.blood_DNA = list()
		if(blood_data["blood_type"])
			splatter.blood_DNA[blood_data["blood_DNA"]] = blood_data["blood_type"]
		else
			splatter.blood_DNA[blood_data["blood_DNA"]] = "O+"

	splatter.fluorescent  = 0
	splatter.set_invisibility(0)
	return splatter
