#define PROCESS_REACTION_ITER 5 //when processing a reaction, iterate this many times

/datum/reagents
	var/primary_reagent
	var/list/reagent_volumes
	var/list/list/reagent_data
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom

	var/thermal_energy = 0

/datum/reagents/New(var/max = 100, atom/A)
	..()
	maximum_volume = max
	my_atom = A

/datum/reagents/Destroy()
	. = ..()
	if(SSchemistry)
		SSchemistry.active_holders -= src

	LAZYCLEARLIST(reagent_data)
	LAZYCLEARLIST(reagent_volumes)
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null

/* Internal procs */

/datum/reagents/proc/apply_force(var/force) // applies force to the reagents inside it
	for (var/_A in reagent_volumes)
		var/singleton/reagent/A = GET_SINGLETON(_A)
		A.apply_force(force, src)

/datum/reagents/proc/get_primary_reagent_name() // Returns the name of the reagent with the biggest volume.
	var/singleton/reagent/reagent = get_primary_reagent_decl()
	if(reagent)
		. = reagent.name

/datum/reagents/proc/get_primary_reagent_decl()
	return primary_reagent && GET_SINGLETON(primary_reagent)

/datum/reagents/proc/update_total() // Updates volume and temperature.
	total_volume = 0
	primary_reagent = null
	if(isemptylist(reagent_volumes))
		thermal_energy = 0
	for(var/R in reagent_volumes)
		var/vol = reagent_volumes[R]
		if(vol < MINIMUM_CHEMICAL_VOLUME)
			del_reagent(R, update = FALSE) // to avoid an infinite loop AND trigger final effects
		else
			total_volume += vol
			if(!primary_reagent || reagent_volumes[primary_reagent] < vol)
				primary_reagent = R
	if(total_volume > maximum_volume)
		remove_any(maximum_volume - total_volume)
	return max(total_volume,0)

/datum/reagents/proc/update_holder(var/reactions = TRUE)
	if(update_total() && reactions)
		handle_reactions()

	if(my_atom)
		my_atom.on_reagent_change()

/datum/reagents/proc/delete()
	if(my_atom)
		my_atom.reagents = null

/datum/reagents/proc/handle_reactions()
	if(SSchemistry)
		SSchemistry.mark_for_update(src)

/datum/reagents/proc/has_reactions()
	var/list/eligible_reactions = list()
	for(var/thing in reagent_volumes)
		eligible_reactions |= SSchemistry.chemical_reactions[thing]

	for(var/datum/chemical_reaction/C in eligible_reactions)
		if(C.can_happen(src))
			return TRUE

//returns 1 if the holder should continue reactiong, 0 otherwise.
/datum/reagents/proc/process_reactions()
	if(!my_atom?.loc)
		return FALSE
	if(my_atom.flags & NOREACT)
		return FALSE

	var/reaction_occured
	var/list/effect_reactions = list()
	var/list/eligible_reactions = list()
	for(var/i in 1 to PROCESS_REACTION_ITER)
		reaction_occured = FALSE

		//need to rebuild this to account for chain reactions
		for(var/thing in reagent_volumes)
			eligible_reactions |= SSchemistry.chemical_reactions[thing]

		for(var/datum/chemical_reaction/C in eligible_reactions)
			if(C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occured = TRUE
		eligible_reactions.Cut()
		if(!reaction_occured)
			break

	for(var/datum/chemical_reaction/C in effect_reactions)
		C.post_reaction(src)

	update_holder(reactions = reaction_occured)
	return has_reactions()

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/rtype, var/amount, var/data = null, var/safety = 0, var/temperature = 0, var/new_thermal_energy = 0)
	if(amount <= 0 || !REAGENTS_FREE_SPACE(src))
		return FALSE
	new_thermal_energy /= amount // Re-multiplied later
	amount = min(amount, REAGENTS_FREE_SPACE(src))
	new_thermal_energy *= amount
	var/singleton/reagent/newreagent = GET_SINGLETON(rtype)
	LAZYINITLIST(reagent_volumes)
	if(!reagent_volumes[rtype])	// New reagent
		reagent_volumes[rtype] = amount
		total_volume += amount // so temperature calculations work
		var/tmp_data = newreagent.initialize_data(data, src)
		if(LAZYLEN(tmp_data))
			LAZYSET(reagent_data, rtype, tmp_data)
		if(temperature <= 0)
			temperature = newreagent.default_temperature
		if(new_thermal_energy > 0)
			newreagent.set_thermal_energy(new_thermal_energy, src, safety = TRUE)
		else
			newreagent.set_temperature(temperature, src, safety = TRUE)
		if(!new_thermal_energy && round(temperature, 1) != round(get_temperature(), 1))
			crash_with("Temperature [temperature] did not match [get_temperature()] after adding NEW reagent [rtype]!")
	else	// Existing reagent
		var/old_energy = (newreagent.get_thermal_energy(src)/reagent_volumes[rtype]) * amount
		reagent_volumes[rtype] += amount
		total_volume += amount // so temperature calculations work
		if(!isnull(data))
			LAZYSET(reagent_data, rtype, newreagent.mix_data(data, amount, src))
		if(temperature <= 0)
			temperature = newreagent.default_temperature
		newreagent.add_thermal_energy(old_energy, src, safety = TRUE) // This part has the safety var set because thermal shock shouldn't occur due to it.
		if(new_thermal_energy > 0) // This if-else is for the change from the current temperature.
			newreagent.add_thermal_energy(new_thermal_energy - old_energy, src, FALSE)
		else
			newreagent.set_temperature(temperature, src, safety = FALSE)
	UNSETEMPTY(reagent_volumes)
	update_holder(!safety)
	return TRUE

/datum/reagents/proc/remove_reagent(var/rtype, var/amount, var/safety = 0)
	var/old_volume = REAGENT_VOLUME(src, rtype)
	if(!isnum(amount) || old_volume <= 0)
		return FALSE
	amount = min(amount, old_volume)
	var/singleton/reagent/current = GET_SINGLETON(rtype)
	thermal_energy -= current.get_thermal_energy(src) * (amount/old_volume)
	reagent_volumes[rtype] -= amount
	update_holder(!safety)
	return TRUE

/datum/reagents/proc/del_reagent(var/rtype, update = TRUE)
	var/singleton/reagent/current = GET_SINGLETON(rtype)
	if(REAGENT_VOLUME(src, rtype) > 0)
		thermal_energy -= current.get_thermal_energy(src)
	if(ismob(my_atom))
		current.final_effect(my_atom, src)
	if(primary_reagent == rtype)
		primary_reagent = null
	LAZYREMOVE(reagent_data, rtype)
	LAZYREMOVE(reagent_volumes, rtype)
	if(update)
		update_holder(FALSE)
	return FALSE

/datum/reagents/proc/has_reagent(var/rtype, var/amount = 0)
	return (rtype in reagent_volumes) && reagent_volumes[rtype] >= amount

/datum/reagents/proc/has_any_reagent(var/list/check_reagents)
	for(var/current in check_reagents)
		if(has_reagent(current))
			return TRUE
	return FALSE

/datum/reagents/proc/has_all_reagents(var/list/check_reagents)
	for(var/current in check_reagents)
		if(!has_reagent(current, check_reagents[current]))
			return FALSE
	return TRUE

/datum/reagents/proc/clear_reagents()
	if(ismob(my_atom))
		for(var/_current in reagent_volumes)
			var/singleton/reagent/current = GET_SINGLETON(_current)
			current.final_effect(my_atom, src)
	LAZYCLEARLIST(reagent_volumes)
	LAZYCLEARLIST(reagent_data)
	update_holder(FALSE)

/datum/reagents/proc/get_reagents()
	. = list()
	for(var/_current in reagent_volumes)
		var/singleton/reagent/current = GET_SINGLETON(_current)
		. += "[current.name] ([reagent_volumes[_current]])"
	return english_list(., "EMPTY", "", ", ", ", ")

/datum/reagents/proc/get_ids_by_phase(var/phase) // this proc will probably need to be changed if you can have one reagent in multiple states at the same time
	. = list()
	for(var/_current in reagent_volumes)
		var/singleton/reagent/current = GET_SINGLETON(_current)
		if(phase == current.reagent_state)
			. += _current

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	amount = min(amount, total_volume)

	if(!amount)
		return 0

	var/part = amount / total_volume

	for(var/_current in reagent_volumes)
		var/singleton/reagent/current = GET_SINGLETON(_current)
		var/amount_to_remove = reagent_volumes[_current] * part
		remove_reagent(current.type, amount_to_remove, 1)

	update_holder()
	return amount

/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).

	if(!target || !istype(target))
		return 0

	if (amount <= 0 || multiplier <= 0)
		return 0

	amount = max(0, min(amount, total_volume, REAGENTS_FREE_SPACE(target) / multiplier))

	if(!amount)
		return 0

	var/part = amount / total_volume

	for(var/_current in reagent_volumes)
		var/singleton/reagent/current = GET_SINGLETON(_current)
		var/amount_to_transfer = reagent_volumes[_current] * part
		var/energy_to_transfer = current.get_thermal_energy(src) * part
		target.add_reagent(_current, amount_to_transfer * multiplier, REAGENT_DATA(src, _current), TRUE, new_thermal_energy = energy_to_transfer * multiplier) // We don't react until everything is in place
		if(!copy)
			remove_reagent(_current, amount_to_transfer, TRUE)

	if(!copy)
		update_holder()

	target.update_holder()

	return amount

/* Holder-to-atom and similar procs */

//The general proc for applying reagents to things. This proc assumes the reagents are being applied externally,
//not directly injected into the contents. It first calls touch, then the appropriate trans_to_*() or splash_mob().
//If for some reason touch effects are bypassed (e.g. injecting stuff directly into a reagent container or person),
//call the appropriate trans_to_*() proc.
/datum/reagents/proc/trans_to(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	touch(target) //First, handle mere touch effects

	if(ismob(target))
		return splash_mob(target, amount, multiplier, copy)
	if(isturf(target))
		return trans_to_turf(target, amount, multiplier, copy)
	if(isobj(target))
		return trans_to_obj(target, amount, multiplier, copy)
	return 0

//Splashing reagents is messier than trans_to, the target's loc gets some of the reagents as well.
/datum/reagents/proc/splash(var/atom/target, var/amount = 1, var/multiplier = 1, var/copy = 0, var/min_spill=0, var/max_spill=60)
	var/spill = 0
	if(!isturf(target) && target.loc)
		spill = amount*(rand(min_spill, max_spill)/100)
		amount -= spill
	if(spill)
		splash(target.loc, spill, multiplier, copy, min_spill, max_spill)

	trans_to(target, amount, multiplier, copy)

/datum/reagents/proc/trans_type_to(var/target, var/rtype, var/amount = 1)
	if (!target)
		return

	var/singleton/reagent/transfering_reagent = GET_SINGLETON(rtype)

	if (istype(target, /atom))
		var/atom/A = target
		if (!A.reagents || !A.simulated)
			return

	amount = min(amount, REAGENT_VOLUME(src, rtype))

	if(!amount)
		return


	var/datum/reagents/F = new /datum/reagents(amount)
	var/tmpdata = REAGENT_DATA(src, rtype)
	var/transfering_thermal_energy = transfering_reagent.get_thermal_energy(src) * (amount/REAGENT_VOLUME(src, rtype))
	F.add_reagent(rtype, amount, tmpdata, new_thermal_energy = transfering_thermal_energy)
	remove_reagent(rtype, amount)


	if (istype(target, /atom))
		return F.trans_to(target, amount) // Let this proc check the atom's type
	else if (istype(target, /datum/reagents))
		return F.trans_to_holder(target, amount)

/datum/reagents/proc/trans_ids_to(var/target, var/list/rtypes, var/amount = 1) // amount is distributed equally over all reagents
	if(!target)
		return
	if(!LAZYLEN(rtypes)) // it's always going to be defined but, you know, good practice and all
		return
	var/amounteach = amount / rtypes.len
	. = 0
	for(var/rtype in rtypes)
		. += src.trans_type_to(target, rtype, amounteach)

// When applying reagents to an atom externally, touch() is called to trigger any on-touch effects of the reagent.
// This does not handle transferring reagents to things.
// For example, splashing someone with water will get them wet and extinguish them if they are on fire,
// even if they are wearing an impermeable suit that prevents the reagents from contacting the skin.
/datum/reagents/proc/touch(var/atom/target)
	if(ismob(target))
		touch_mob(target)
	if(isturf(target))
		touch_turf(target)
	if(isobj(target))
		touch_obj(target)
	return

/datum/reagents/proc/touch_mob(var/mob/living/target)
	if(!target || !istype(target) || !target.simulated)
		return
	var/temperature = src.get_temperature()
	if(temperature >= REAGENTS_BURNING_TEMP_HIGH)
		var/burn_damage = Clamp(total_volume*(temperature - REAGENTS_BURNING_TEMP_HIGH)*REAGENTS_BURNING_TEMP_HIGH_DAMAGE,0,min(total_volume*2,REAGENTS_BURNING_TEMP_HIGH_DAMAGE_CAP))
		target.adjustFireLoss(burn_damage)
		target.visible_message(SPAN_DANGER("The hot liquid burns [target]!"))
	else if(temperature <= REAGENTS_BURNING_TEMP_LOW)
		var/burn_damage = Clamp(total_volume*(REAGENTS_BURNING_TEMP_LOW - temperature)*REAGENTS_BURNING_TEMP_LOW_DAMAGE,0,min(total_volume*2,REAGENTS_BURNING_TEMP_LOW_DAMAGE_CAP))
		target.adjustFireLoss(burn_damage)
		target.visible_message(SPAN_DANGER("The freezing liquid burns [target]!"))

	for(var/_current in reagent_volumes)
		var/singleton/reagent/current = GET_SINGLETON(_current)
		current.touch_mob(target, reagent_volumes[_current], src)

	update_holder()

/datum/reagents/proc/touch_turf(var/turf/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/_current in reagent_volumes)
		var/singleton/reagent/current = GET_SINGLETON(_current)
		current.touch_turf(target, reagent_volumes[_current], src)

	update_holder()

/datum/reagents/proc/touch_obj(var/obj/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/_current in reagent_volumes)
		var/singleton/reagent/current = GET_SINGLETON(_current)
		current.touch_obj(target, reagent_volumes[_current], src)

	update_holder()

// Attempts to place a reagent on the mob's skin.
// Reagents are not guaranteed to transfer to the target.
// DO NOT CALL THIS DIRECTLY, call trans_to() instead.
/datum/reagents/proc/splash_mob(var/mob/target, var/amount = 1, var/multiplier = 1, var/copy = 0)
	var/perm = 1
	if(isliving(target)) //will we ever even need to tranfer reagents to non-living mobs?
		var/mob/living/L = target
		perm = L.reagent_permeability()
	multiplier *= perm

	return trans_to_mob(target, amount*0.75, CHEM_TOUCH, multiplier, copy) + trans_to_mob(target, amount*0.25, CHEM_BREATHE, multiplier, copy)

/datum/reagents/proc/trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_BLOOD, var/multiplier = 1, var/copy = 0, var/bypass_checks = FALSE) // Transfer after checking into which holder...

	if(!target || !istype(target) || !target.simulated)
		return 0

	var/mob/living/carbon/C = target
	if(istype(C))
		switch(type)
			if(CHEM_BREATHE)
				var/datum/reagents/R = C.breathing
				return C.inhale(src, R, amount, multiplier, copy, bypass_checks)
			if(CHEM_BLOOD)
				var/datum/reagents/R = C.reagents
				return trans_to_holder(R, amount, multiplier, copy)
			if(CHEM_INGEST)
				var/datum/reagents/R = C.get_ingested_reagents()
				return C.ingest(src, R, amount, multiplier, copy)
			if(CHEM_TOUCH)
				var/datum/reagents/R = C.touching
				return trans_to_holder(R, amount, multiplier, copy)
	else
		//If the target has a reagent holder, we'll try to put it there instead. This allows feeding simple animals
		if(target.reagents && type == CHEM_BLOOD || type == CHEM_INGEST)
			return trans_to_holder(target.reagents, amount, multiplier, copy)
		else
			var/datum/reagents/R = new /datum/reagents(amount)
			. = trans_to_holder(R, amount, multiplier, copy)
			R.touch_mob(target)
			return

/datum/reagents/proc/trans_to_turf(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Turfs don't have any reagents (at least, for now). Just touch it.
	if(!target || !target.simulated)
		return 0

	var/datum/reagents/R = new /datum/reagents(amount * multiplier)
	. = trans_to_holder(R, amount, multiplier, copy)
	R.touch_turf(target)


/datum/reagents/proc/trans_to_obj(var/turf/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Objects may or may not; if they do, it's probably a beaker or something and we need to transfer properly; otherwise, just touch.
	if(!target || !target.simulated)
		return 0

	if(!target.reagents)
		var/datum/reagents/R = new /datum/reagents(amount * multiplier)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_obj(target)
		return

	return trans_to_holder(target.reagents, amount, multiplier, copy)


//Spreads the contents of this reagent holder all over the vicinity of the target turf.
/datum/reagents/proc/splash_area(var/turf/epicentre, var/range = 3, var/portion = 1.0, var/multiplier = 1, var/copy = 0)
	var/list/things = list()
	DVIEW(things, range, epicentre, INVISIBILITY_LIGHTING)

	var/list/turfs = list()
	for (var/turf/T in things)
		turfs += T

	if (!turfs.len)
		return//Nowhere to splash to, somehow

	//Create a temporary holder to hold all the amount that will be spread
	var/datum/reagents/R = new /datum/reagents(total_volume * portion * multiplier)
	trans_to_holder(R, total_volume * portion, multiplier, copy)

	//The exact amount that will be given to each turf
	var/turfportion = R.total_volume / turfs.len
	for (var/turf/T in turfs)
		var/datum/reagents/TR = new /datum/reagents(turfportion)
		R.trans_to_holder(TR, turfportion, 1, 0)
		TR.splash_turf(T)

	qdel(R)


//Spreads the contents of this reagent holder all over the target turf, dividing among things in it.
//50% is divided between mobs, 20% between objects, and whatever is left on the turf itself
/datum/reagents/proc/splash_turf(var/turf/T, var/amount = null, var/multiplier = 1, var/copy = 0)
	if (isnull(amount))
		amount = total_volume
	else
		amount = min(amount, total_volume)
	if (amount <= 0)
		return

	var/list/mobs = list()
	for (var/mob/M in T)
		mobs += M

	var/list/objs = list()
	for (var/obj/O in T)
		//Todo: Add some check here to not hit wires/pipes that are hidden under floor tiles.
		//Maybe also not hit things under tables.
		objs += O



	if (objs.len)
		var/objportion = (amount * 0.2) / objs.len
		for (var/o in objs)
			var/obj/O = o

			trans_to(O, objportion, multiplier, copy)

	amount = min(amount, total_volume)

	if (mobs.len)
		var/mobportion = (amount * 0.5) / mobs.len
		for (var/m in mobs)
			var/mob/M = m
			trans_to(M, mobportion, multiplier, copy)

	trans_to(T, total_volume, multiplier, copy)

	if (total_volume <= 0)
		qdel(src)

/* Atom reagent creation - use it all the time */

/atom/proc/create_reagents(var/max_vol)
	if(reagents)
		reagents.maximum_volume = max(reagents.maximum_volume, max_vol)
	else
		reagents = new/datum/reagents(max_vol, src)
