/*

//Temporary modifiers system, by Nanako

//This system is designed to allow making non-permanant, reversible changes to variables of any atom,
//Though the system will be primarily used for altering properties of mobs, it can work on anything.

//Intended uses are to allow equipment and items that modify a mob's various stats and attributes
//As well as to replace the badly designed chem effects system


This system works through a few main procs which should be overridden:
All overridden procs should contain a call to parent at the start, before any other code


Activate: This applies the effects. its here that you change any variables.
	The author is also responsible here for storing any information necessary to later revert these changes

Deactivate: This proc removes the effects. The author is responsible for writing it to reverse the changes cleanly
	If using a strength var or any other kind of dynamic determinor of effects
	It is very important NOT to factor that in when deactivating, because it may be changed while active
	Instead, factor it in while activating and save the delta of the changed values.
	that is, how much you added/subtracted
	Apply that saved value in reverse when deactivating.

Both activate and deactivate are stateful. Activate will not run if active is true.
Deactivate will not run if active is false

Process: Called once every second while the effect is active. Usually this will only see if its time
	to recheck validity, but it can be overridden to add extra per-tick functionality.

When created, a status effect will take the following parameters in new
	Mandatory:
		1. Affected atom
		2. Modifier type
		3. Source atom (not mandatory if type is custom)

	Optional:
		4. Source data
		5. Strength
		6. Duration
		7. Check interval



//The affected atom is mandatory, without something to affect the modifier cannot exist

//Modifier type is one of a selection of constants which determines the automated validity checking.
	It does not enforce anything about the changes or other functionality. A valid option is mandatory

//Source object is the thing that this modifier is based on, or anchored to.
	//It is used as a point of reference in validity checks. Usually mandatory but some types do not require it

//Source data provides additional information for validity, such as a maximum range from the source.
	//Only required for certain types

//Strength can be passed in by the caller and used insetting or removing the variable changes.
	//It is never required for anything and not incorporated in base behaviour

//Duration can be used for any type except custom. The modifier will cease to be valid
	//this long after it is created
	//Duration is decremented every proc until it falls below zero.
	//This is used so that duration can be refreshed or increased before the modifier expires to prolong it

//Check interval is a time, in deciseconds, between validity checks. a >0 value is required here,
	//the default is 300 (every 30 seconds),
	//Check interval is used to generate a world time at which the next check will run


Please note that automated validity checking is primarily as a safety, to ensure things aren't left
when they shouldn't be. If you desire something removed in a timely manner, it's recommended to manually
call the effect's end proc from your code when you're done with it. For example, if a piece of equipment
applying a modifier is taken off.

Setting the check interval very low just to cause the effect to be removed quickly is bad practise
it should be avoided in favour of manual removal where possible
*/






//Modifier types
//These are needed globally and cannot be undefined

#define MODIFIER_EQUIPMENT	1
//The status effect remains valid as long as it is worn upon the affected mob.
//Worn here means it must be held in a valid equip slot, which does not include pockets, storage, or held in hands.
//The affected atom must be a mob

#define MODIFIER_ITEM	2
//The modifier remains valid as long as the item is in the target's contents,
//no matter how many layers deep, if it can be found by recursing up, it is valid
//This is essentially a more permissable version of equipment, and works when held, in backpacks, pockets, etc
//It can also be used on non-mob targets

#define MODIFIER_REAGENT	3
//The status effect remains valid as long as the dose of this chemical in a mob's reagents is above
//a specified dose value (specified in source data).
//The default of zero will keep it valid if the chemical is in them at all
//This checks for the reagent by type, in any of a mob's reagent holders - touching, blood, ingested
//Affected atom must be a mob

#define MODIFIER_AURA	4
//The modifier remains valid as long as the target's turf is within a range of the source's turf
//The range is defined in source data
//A range of zero is still valid if source and target are on the same turf. Sub-zero range is invalid
//Works on any affected atom

#define MODIFIER_TIMED	5
//The modifier remains valid as long as the duration has not expired.
//Note that a duration can be used on any time, this type is just one that does not
//check anything else but duration.
//Does not require or use a source atom
//Duration is mandatory for this type.
//Works on any atom


#define MODIFIER_CUSTOM	6
//The validity check will always return 1. The author is expected to override
//it with custom validity checking behaviour.
//Does not require or use a source atom
//Does not support duration



//Override Modes:
//An override parameter is passed in with New, which determines what to do if a modifier of
//the same type already exists on the target

#define MODIFIER_OVERRIDE_DENY	0
//The default. If a modifier of our type already exists, the new one is discarded. It will Qdel itself
//Without adding itself to any lists

#define MODIFIER_OVERRIDE_NEIGHBOR	1
//The new modifier ignores the existing one, and adds itself to the list alongside it
//This is not recommended but you may have a specific application
//Using the strength var and updating the effects is preferred if you want to stack multiples
//of the same type of modifier on one mob

#define MODIFIER_OVERRIDE_REPLACE 	2
//Probably the most common nondefault and most useful. If an old modifier of the same type exists,
//Then the old one is first stopped without suspending, and deleted.
//Then the new one will add itself as normal

#define MODIFIER_OVERRIDE_REFRESH 	3
//This mode will overwrite the variables of the old one with our new values
//It will also force it to remove and reapply its effects
//This is useful for applying a lingering modifier, by refreshing its duration

#define MODIFIER_OVERRIDE_STRENGTHEN	4
//Almost identical to refresh, but it will only apply if the new modifer has a higher strength value
//If the existing modifier's strength is higher than the new one, the new is discarded

#define MODIFIER_OVERRIDE_CUSTOM	5
//Calls a custom override function to be overwritten



//This is the main proc you should call to create a modifier on a target object
/datum/proc/add_modifier(var/typepath, var/_modifier_type, var/_source = null, var/_source_data = 0, var/_strength = 0, var/_duration = 0, var/_check_interval = 0, var/override = 0)
	var/datum/modifier/D = new typepath(src, _modifier_type, _source, _source_data, _strength, _duration, _check_interval)
	if (!QDELETED(D))
		return D.handle_registration(override)
	else
		return null//The modifier must have failed creation and deleted itself


/datum/modifier
//Config
	var/check_interval = 300//How often, in deciseconds, we will recheck the validity
	var/atom/target = null
	var/atom/source = null
	var/modifier_type = 0
	var/source_data = 0
	var/strength = 0
	var/duration = null

	//A list of equip slots which are considered 'worn'.
	//For equipment modifier type to be valid, the source object must be in a mob's contents
	//and equipped to one of these whitelisted slots
	//This list can be overridden if you want a custom slot whitelist
	var/list/valid_equipment_slots = list(slot_back, slot_wear_mask, slot_handcuffed, slot_belt, \
	slot_wear_id, slot_l_ear, slot_glasses, slot_gloves, slot_head, slot_shoes, slot_wear_suit, \
	slot_w_uniform,slot_legcuffed, slot_r_ear, slot_legs, slot_tie)



//Operating Vars
	var/active = 0//Whether or not the effects are currently applied
	var/next_check = 0
	var/last_tick = 0


//If creation of a modifier is successful, it will return a reference to itself
//If creation fails for any reason, it will return null as well as giving some debug output
/datum/modifier/New(var/atom/_target, var/_modifier_type, var/_source = null, var/_source_data = 0, var/_strength = 0, var/_duration = 0, var/_check_interval = 0)
	..()
	target = _target
	modifier_type = _modifier_type
	source = _source
	source_data = _source_data
	strength = _strength
	last_tick = world.time
	if (_duration)
		duration = _duration

	if (_check_interval)
		check_interval = _check_interval

	if (!target || !modifier_type)
		return invalid_creation("No target and/or no modifier type was submitted")

	switch (modifier_type)
		if (MODIFIER_EQUIPMENT)
			if (!istype(target, /mob))
				return invalid_creation("Equipment type requires a mob target")

			if (!source || !istype(source, /obj))
				return invalid_creation("Equipment type requires an object source")

			//TODO: Port equip slot var
		if (MODIFIER_ITEM)
			if (!source || !istype(source, /obj))
				return invalid_creation("Item type requires a source")

		if (MODIFIER_REAGENT)
			if (!istype(target, /mob) || !istype(source, /datum/reagent))
				return invalid_creation("Reagent type requires a mob target and a reagent source")

		if (MODIFIER_AURA)
			if (!source || !istype(source, /atom))
				return invalid_creation("Aura type requires an atom source")

		if (MODIFIER_TIMED)
			if (!duration || duration <= 0)
				return invalid_creation("Timed type requires a duration")
		if (MODIFIER_CUSTOM)
			//No code here, just to prevent else
		else
			return invalid_creation("Invalid or unrecognised modifier type")//Not a valid modifier type.
	return 1


/datum/modifier/proc/handle_registration(var/override = 0)
	var/datum/modifier/existing = null
	for (var/datum/modifier/D in target.modifiers)
		if (D.type == type)
			existing = D
	if (!existing)
		START_PROCESSING(SSmodifiers, src)
		LAZYADD(target.modifiers, src)
		activate()
		return src
	else
		return handle_override(override, existing)

/datum/modifier/proc/activate()
	if (!QDELING(src) && !active && target)
		active = 1
		return 1
	return 0

/datum/modifier/proc/deactivate()
	active = 0
	return 1

/datum/modifier/process()

	if (!active)
		last_tick = world.time
		return 0

	if (!isnull(duration))duration -= world.time - last_tick
	if (world.time > next_check)
		last_tick = world.time
		return check_validity()
	last_tick = world.time
	return 1

/datum/modifier/proc/check_validity()
	next_check = world.time + check_interval
	if (QDELETED(target))
		return validity_fail("Target is gone!")

	if (modifier_type == MODIFIER_CUSTOM)
		if (custom_validity())
			return 1
		else
			return validity_fail("Custom failed")

	if (!isnull(duration) && duration <= 0)
		return validity_fail("Duration expired")

	else if (modifier_type == MODIFIER_TIMED)
		return 1

	if (QDELETED(source))//If we're not timed or custom, then we need a source. If our source is gone, we are invalid
		return validity_fail("Source is gone and we need one")

	switch (modifier_type)
		if (MODIFIER_EQUIPMENT)
			if (source.loc != target)
				return validity_fail("Not in contents of mob")

			var/obj/item/I = source
			if (!I.equip_slot || !(I.equip_slot in valid_equipment_slots))
				return validity_fail("Not equipped in the correct place")

			//TODO: Port equip slot var. this cant be done properly without it. This is a temporary implementation
		if (MODIFIER_ITEM)
			if (!source.find_up_hierarchy(target))//If source is somewhere inside target, this will be true
				return validity_fail("Not found in parent hierarchy")
		if (MODIFIER_REAGENT)
			var/totaldose = 0
			if (!istype(source, /datum/reagent))//this shouldnt happen
				return validity_fail("Source is not a reagent!")

			var/ourtype = source.type

			for (var/datum/reagent/R in target.reagents.reagent_list)
				if (istype(R, ourtype))
					totaldose += R.dose

			if (istype(target, /mob/living))
				var/mob/living/L = target

				for (var/datum/reagent/R in L.ingested.reagent_list)
					if (istype(R, ourtype))
						totaldose += R.dose

				if (istype(target, /mob/living/carbon))
					var/mob/living/carbon/C = target

					for (var/datum/reagent/R in C.bloodstr.reagent_list)
						if (istype(R, ourtype))
							totaldose += R.dose

					for (var/datum/reagent/R in C.touching.reagent_list)
						if (istype(R, ourtype))
							totaldose += R.dose

					for (var/datum/reagent/R in C.breathing.reagent_list)
						if (istype(R, ourtype))
							totaldose += R.dose

			if (totaldose < source_data)
				return validity_fail("Dose is too low!")

		if (MODIFIER_AURA)
			if (!(get_turf(target) in range(source_data, get_turf(source))))
				return validity_fail("Target not in range of source")

	return 1


//Override this without a call to parent, for custom validity conditions
/datum/modifier/proc/custom_validity()
	return 1

/datum/modifier/proc/validity_fail(var/reason)
	qdel(src)
	return 0

/datum/modifier/proc/invalid_creation(var/reason)
	log_debug("ERROR: [src] MODIFIER CREATION FAILED on [target]: [reason]")
	qdel(src)
	return 0

//called by any object to either pause or remove the proc.
/datum/modifier/proc/stop(var/instant = 0, var/suspend = 0)

	//Instant var removes us from the lists immediately, instead of waiting til next frame when qdel goes through
	if (instant)
		if (target)
			LAZYREMOVE(target.modifiers, src)
		STOP_PROCESSING(SSmodifiers, src)

	if (suspend)
		deactivate()
	else
		qdel(src)

//Suspends and immediately restarts the proc, thus reapplying its effects
/datum/modifier/proc/refresh()
	deactivate()
	activate()


/datum/modifier/Destroy()
	if (active)
		deactivate()
	if (target)
		LAZYREMOVE(target.modifiers, src)
	STOP_PROCESSING(SSmodifiers, src)
	return ..()


//Handles overriding an existing modifier of the same type.
//This function should return either src or the existing, depending on whether or not src will be kept
/datum/modifier/proc/handle_override(var/override, var/datum/modifier/existing)
	switch(override)
		if (MODIFIER_OVERRIDE_DENY)
			qdel(src)
			return existing
		if (MODIFIER_OVERRIDE_NEIGHBOR)
			START_PROCESSING(SSmodifiers, src)
			LAZYADD(target.modifiers, src)
			activate()
			return src
		if (MODIFIER_OVERRIDE_REPLACE)
			existing.stop()
			START_PROCESSING(SSmodifiers, src)
			LAZYADD(target.modifiers, src)
			activate()
			return src
		if (MODIFIER_OVERRIDE_REFRESH)
			existing.strength = strength
			existing.duration = duration
			existing.source = source
			existing.source_data = source_data
			if (existing.check_validity())
				existing.refresh()
				qdel(src)
				return existing
			else
				qdel(src)
				return null//this should only happen if you overwrote the existing with bad values.
				//It will result in both existing and src being deleted
				//The null return will allow the source to see this went wrong and remake the modifier
		if (MODIFIER_OVERRIDE_STRENGTHEN)
			if (strength > existing.strength)
				existing.strength = strength
				existing.duration = duration
				existing.source = source
				existing.source_data = source_data
				if (existing.check_validity())
					existing.refresh()
					qdel(src)
					return existing
				qdel(src)
				return null
			qdel(src)
			return existing

		if (MODIFIER_OVERRIDE_CUSTOM)
			return custom_override(existing)
		else
			qdel(src)
			return existing

//This function should be completely overwritten, without a call to parent, to specify custom override
/datum/modifier/proc/custom_override(var/datum/modifier/existing)
	qdel(src)
	return existing

/atom
	var/tmp/list/modifiers
