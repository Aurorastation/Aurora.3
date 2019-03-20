#define PROCESS_REACTION_ITER 5 //when processing a reaction, iterate this many times

/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom = null

/datum/reagents/New(var/max = 100, atom/A = null)
	..()
	maximum_volume = max
	my_atom = A

/datum/reagents/Destroy()
	. = ..()
	if(SSchemistry)
		SSchemistry.active_holders -= src

	for(var/datum/reagent/R in reagent_list)
		qdel(R)
	reagent_list.Cut()
	reagent_list = null
	if(my_atom && my_atom.reagents == src)
		my_atom.reagents = null

/* Internal procs */

/datum/reagents/proc/get_free_space() // Returns free space.
	return maximum_volume - total_volume

/datum/reagents/proc/get_master_reagent() // Returns reference to the reagent with the biggest volume.
	var/the_reagent = null
	var/the_volume = 0

	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_reagent = A

	return the_reagent

/datum/reagents/proc/get_reagent(var/id) // Returns reference to reagent matching passed ID
	for(var/datum/reagent/A in reagent_list)
		if (A.id == id)
			return A

	return null

/datum/reagents/proc/get_master_reagent_name() // Returns the name of the reagent with the biggest volume.
	var/the_name = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagents/proc/get_master_reagent_id() // Returns the id of the reagent with the biggest volume.
	var/the_id = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/datum/reagents/proc/update_total() // Updates volume and temperature.

	total_volume = 0

	for(var/datum/reagent/R in reagent_list)
		if(R.volume < MINIMUM_CHEMICAL_VOLUME)
			del_reagent(R.id)
		else
			total_volume += R.volume

	return max(total_volume,0)

/datum/reagents/proc/update_holder(var/reactions = TRUE)
	if(update_total() && reactions)
		handle_reactions()

	if(my_atom)
		my_atom.on_reagent_change()

/datum/reagents/proc/delete()
	for(var/datum/reagent/R in reagent_list)
		R.holder = null
	if(my_atom)
		my_atom.reagents = null

/datum/reagents/proc/handle_reactions()
	if(SSchemistry)
		SSchemistry.mark_for_update(src)

//returns 1 if the holder should continue reactiong, 0 otherwise.
/datum/reagents/proc/process_reactions()
	if(!my_atom || !my_atom.loc || my_atom.flags & NOREACT)
		return 0

	var/reaction_occured
	var/list/effect_reactions = list()
	var/list/eligible_reactions = list()
	for(var/i in 1 to PROCESS_REACTION_ITER)
		reaction_occured = 0

		//need to rebuild this to account for chain reactions
		for(var/datum/reagent/R in reagent_list)
			eligible_reactions |= SSchemistry.chemical_reactions[R.id]

		for(var/datum/chemical_reaction/C in eligible_reactions)
			if(C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occured = 1

		eligible_reactions.Cut()

		if(!reaction_occured)
			break

	for(var/datum/chemical_reaction/C in effect_reactions)
		C.post_reaction(src)

	update_holder(equalize_temperature()) //If the thermal energy of the reagents is different after a reaction, then run process_reactions again.
	return reaction_occured

/* Holder-to-chemical */

/datum/reagents/proc/add_reagent(var/id, var/amount, var/data = null, var/safety = 0, var/temperature = 0, var/thermal_energy = 0)
	if(!isnum(amount) || amount <= 0)
		return 0

	update_total() //Does this need to be here? It's called in update_holder.
	var/old_amount = amount
	amount = min(amount, get_free_space())

	for(var/datum/reagent/R in reagent_list)
		if(R.id == id) //Existing reagent
			R.volume += amount
			if(thermal_energy > 0 && old_amount > 0)
				R.add_thermal_energy(thermal_energy * (amount/old_amount) )
			else
				if(temperature <= 0)
					temperature = R.default_temperature
				R.add_thermal_energy(temperature * R.specific_heat * amount)
			if(!isnull(data)) // For all we know, it could be zero or empty string and meaningful
				R.mix_data(data, amount)
			update_holder(!safety)
			return 1

	var/datum/reagent/D = SSchemistry.chemical_reagents[id] //New reagent
	if(D)
		var/datum/reagent/R = new D.type()
		reagent_list += R
		R.holder = src
		R.volume = amount
		R.specific_heat = SSchemistry.check_specific_heat(R)
		R.thermal_energy = 0
		if(thermal_energy > 0 && old_amount > 0)
			R.set_thermal_energy(thermal_energy * (amount/old_amount) )
		else
			if(temperature <= 0)
				temperature = R.default_temperature
			R.set_temperature(temperature)
		R.initialize_data(data)
		update_holder(!safety)
		return 1
	else
		warning("[my_atom] attempted to add a reagent called '[id]' which doesn't exist. ([usr])")
	return 0

/datum/reagents/proc/remove_reagent(var/id, var/amount, var/safety = 0)
	if(!isnum(amount))
		return 0

	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			amount = min(amount,current.volume)
			var/old_volume = current.volume
			current.volume -= amount
			current.add_thermal_energy( -(current.thermal_energy * (amount/old_volume)) )
			update_holder(!safety)
			return 1
	return 0

/datum/reagents/proc/del_reagent(var/id)
	for(var/datum/reagent/current in reagent_list)
		if (current.id == id)
			if(ismob(my_atom))
				current.final_effect(my_atom)
			reagent_list -= current
			qdel(current)
			update_holder(FALSE)
			return 0

/datum/reagents/proc/has_reagent(var/id, var/amount = 0)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			if(current.volume >= amount)
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_any_reagent(var/list/check_reagents)
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents[current.id])
				return 1
			else
				return 0
	return 0

/datum/reagents/proc/has_all_reagents(var/list/check_reagents)
	//this only works if check_reagents has no duplicate entries... hopefully okay since it expects an associative list
	var/missing = check_reagents.len
	for(var/datum/reagent/current in reagent_list)
		if(current.id in check_reagents)
			if(current.volume >= check_reagents[current.id])
				missing--
	return !missing

/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/current in reagent_list)
		del_reagent(current.id)
	return

/datum/reagents/proc/get_reagent_amount(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.volume
	return 0

/datum/reagents/proc/get_data(var/id)
	for(var/datum/reagent/current in reagent_list)
		if(current.id == id)
			return current.get_data()
	return 0

/datum/reagents/proc/get_reagents()
	. = list()
	for(var/datum/reagent/current in reagent_list)
		. += "[current.id] ([current.volume])"
	return english_list(., "EMPTY", "", ", ", ", ")

/* Holder-to-holder and similar procs */

/datum/reagents/proc/remove_any(var/amount = 1) // Removes up to [amount] of reagents from [src]. Returns actual amount removed.
	amount = min(amount, total_volume)

	if(!amount)
		return 0

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_remove = current.volume * part
		remove_reagent(current.id, amount_to_remove, 1)

	update_holder()
	return amount

/datum/reagents/proc/trans_to_holder(var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) // Transfers [amount] reagents from [src] to [target], multiplying them by [multiplier]. Returns actual amount removed from [src] (not amount transferred to [target]).

	if(!target || !istype(target))
		return 0

	if (amount <= 0 || multiplier <= 0)
		return 0

	amount = max(0, min(amount, total_volume, target.get_free_space() / multiplier))

	if(!amount)
		return 0

	var/part = amount / total_volume

	for(var/datum/reagent/current in reagent_list)
		var/amount_to_transfer = current.volume * part
		var/energy_to_transfer = current.get_thermal_energy() * (amount_to_transfer / current.volume)
		target.add_reagent(current.id, amount_to_transfer * multiplier, current.get_data(), TRUE, thermal_energy = energy_to_transfer * multiplier) // We don't react until everything is in place
		if(!copy)
			remove_reagent(current.id, amount_to_transfer, TRUE)

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

/datum/reagents/proc/trans_id_to(var/target, var/id, var/amount = 1)
	if (!target)
		return

	var/datum/reagent/transfering_reagent = get_reagent(id)

	if (istype(target, /atom))
		var/atom/A = target
		if (!A.reagents || !A.simulated)
			return

	amount = min(amount, transfering_reagent.volume)

	if(!amount)
		return


	var/datum/reagents/F = new /datum/reagents(amount)
	var/tmpdata = get_data(id)
	var/transfering_thermal_energy = transfering_reagent.get_thermal_energy() * (amount/transfering_reagent.volume)
	F.add_reagent(id, amount, tmpdata, thermal_energy = transfering_thermal_energy)
	remove_reagent(id, amount)


	if (istype(target, /atom))
		return F.trans_to(target, amount) // Let this proc check the atom's type
	else if (istype(target, /datum/reagents))
		return F.trans_to_holder(target, amount)

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
		var/burn_damage = Clamp(total_volume*(temperature - REAGENTS_BURNING_TEMP_HIGH)*REAGENTS_BURNING_TEMP_HIGH_DAMAGE,0,REAGENTS_BURNING_TEMP_HIGH_DAMAGE_CAP)
		target.adjustFireLoss(burn_damage)
		target.visible_message(span("danger","The hot liquid burns \the [target]!"))
	else if(temperature <= REAGENTS_BURNING_TEMP_LOW)
		var/burn_damage = Clamp(total_volume*(REAGENTS_BURNING_TEMP_LOW - temperature)*REAGENTS_BURNING_TEMP_LOW_DAMAGE,0,REAGENTS_BURNING_TEMP_LOW_DAMAGE_CAP)
		target.adjustFireLoss(burn_damage)
		target.visible_message(span("danger","The freezing liquid burns \the [target]!"))

	for(var/datum/reagent/current in reagent_list)
		current.touch_mob(target, current.volume)

	update_holder()

/datum/reagents/proc/touch_turf(var/turf/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_turf(target, current.volume)

	update_holder()

/datum/reagents/proc/touch_obj(var/obj/target)
	if(!target || !istype(target) || !target.simulated)
		return

	for(var/datum/reagent/current in reagent_list)
		current.touch_obj(target, current.volume)

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
		if(type == CHEM_BREATHE)
			var/datum/reagents/R = C.breathing
			return C.inhale(src, R, amount, multiplier, copy, bypass_checks)
		if(type == CHEM_BLOOD)
			var/datum/reagents/R = C.reagents
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_INGEST)
			var/datum/reagents/R = C.ingested
			return C.ingest(src, R, amount, multiplier, copy)
		if(type == CHEM_TOUCH)
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
	reagents = new/datum/reagents(max_vol, src)
