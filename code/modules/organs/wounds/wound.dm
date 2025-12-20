
/****************************************************
					WOUNDS
****************************************************/
/datum/wound
	/// number representing the current stage
	var/current_stage = 0

	/// description of the wound
	var/desc = "wound" //default in case something borks

	/// amount of damage this wound causes
	var/damage = 0

	/// how many times we've tried to lower the bleed timer, used to determine whether hemophilia should let bleed timer lower
	var/bleed_timer_increment = 0

	/// ticks of bleeding left.
	var/bleed_timer = 0

	/// Above this amount wounds you will need to treat the wound to stop bleeding, regardless of bleed_timer
	var/bleed_threshold = 30

	/// amount of damage the current wound type requires(less means we need to apply the next healing stage)
	var/min_damage = 0

	/// is the wound bandaged?
	var/bandaged = FALSE
	/// Similar to bandaged, but works differently
	var/clamped = FALSE
	/// is the wound salved?
	var/salved = FALSE
	/// is the wound disinfected?
	var/disinfected = FALSE
	var/created = 0
	/// number of wounds of this type
	var/amount = 1
	/// amount of germs in the wound
	var/germ_level = 0
	/// the organ the wound is on, if on an organ
	var/obj/item/organ/external/parent_organ

	/*  These are defined by the wound type and should not be changed */

	/// stages such as "cut", "deep cut", etc.
	var/list/stages
	/// maximum stage at which bleeding should still happen. Beyond this stage bleeding is prevented.
	var/max_bleeding_stage = 0
	/// String (One of `DAMAGE_TYPE_*`). The wound's injury type.
	var/damage_type = INJURY_TYPE_CUT
	/// whether this wound needs a bandage/salve to heal at all
	/// the maximum amount of damage that this wound can have and still autoheal
	var/autoheal_cutoff = 15



	// helper lists
	var/list/embedded_objects
	var/tmp/list/desc_list = list()
	var/tmp/list/damage_list = list()

/datum/wound/New(damage, obj/item/organ/external/organ = null)

	created = world.time

	// reading from a list("stage" = damage) is pretty difficult, so build two separate
	// lists from them instead
	for(var/V in stages)
		desc_list += V
		damage_list += stages[V]

	src.damage = damage

	// initialize with the appropriate stage
	src.init_stage(damage)

	bleed_timer += damage

	if(istype(organ))
		parent_organ = organ

/datum/wound/Destroy()
	if(parent_organ)
		LAZYREMOVE(parent_organ.wounds, src)
		parent_organ = null
	LAZYCLEARLIST(embedded_objects)
	. = ..()

///Returns TRUE if there's a next stage, FALSE otherwise
/datum/wound/proc/init_stage(initial_damage)
	current_stage = length(stages)

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= initial_damage / src.amount)
		src.current_stage--

	src.min_damage = damage_list[current_stage]
	src.desc = desc_list[current_stage]

///The amount of damage per wound
/datum/wound/proc/wound_damage()
	return src.damage / src.amount

/datum/wound/proc/can_autoheal()
	if(LAZYLEN(embedded_objects))
		return FALSE

	return (wound_damage() <= autoheal_cutoff) ? TRUE : is_treated()

/// Checks whether the wound has been appropriately treated
/datum/wound/proc/is_treated()
	if(!LAZYLEN(embedded_objects))
		switch(damage_type)
			if(INJURY_TYPE_BRUISE, INJURY_TYPE_CUT, INJURY_TYPE_PIERCE)
				return bandaged
			if(INJURY_TYPE_BURN)
				return salved

/// Checks whether other other can be merged into src.
/datum/wound/proc/can_merge(datum/wound/other)
	if (other.type != src.type) return FALSE
	if (other.current_stage != src.current_stage) return FALSE
	if (other.damage_type != src.damage_type) return FALSE
	if (!(other.can_autoheal()) != !(src.can_autoheal())) return FALSE
	if (!(other.bandaged) != !(src.bandaged)) return FALSE
	if (!(other.clamped) != !(src.clamped)) return FALSE
	if (!(other.salved) != !(src.salved)) return FALSE
	if (!(other.disinfected) != !(src.disinfected)) return FALSE
	if (other.parent_organ != parent_organ) return FALSE
	return TRUE

/datum/wound/proc/merge_wound(datum/wound/other)
	if(LAZYLEN(other.embedded_objects))
		LAZYDISTINCTADD(src.embedded_objects, other.embedded_objects)
	src.damage += other.damage
	src.amount += other.amount
	src.bleed_timer += other.bleed_timer
	src.bleed_timer_increment += other.bleed_timer_increment
	src.germ_level = max(src.germ_level, other.germ_level)
	src.created = max(src.created, other.created)	//take the newer created time
	qdel(other)

/// checks if wound is considered open for external infections
/// untreated cuts (and bleeding bruises) and burns are possibly infectable, chance higher if wound is bigger
/datum/wound/proc/infection_check()
	if (damage < 10)	//small cuts, tiny bruises, and moderate burns shouldn't be infectable.
		return FALSE
	if (is_treated() && damage < 25)	//anything less than a flesh wound (or equivalent) isn't infectable if treated properly
		return FALSE
	if (disinfected)
		germ_level = 0	//reset this, just in case
		return FALSE

	if (damage_type == INJURY_TYPE_BRUISE && !bleeding()) //bruises only infectable if bleeding
		return FALSE

	var/dam_coef = round(damage/10)
	switch (damage_type)
		if (INJURY_TYPE_BRUISE)
			return prob(dam_coef*5)
		if (INJURY_TYPE_BURN)
			return prob(dam_coef*10)
		if (INJURY_TYPE_CUT)
			return prob(dam_coef*20)

	return FALSE

/datum/wound/proc/bandage()
	bandaged = TRUE

/datum/wound/proc/salve()
	salved = TRUE

/datum/wound/proc/disinfect()
	disinfected = TRUE

/// Heal the given amount of damage, and if the given amount of damage was more than what esd needed to be healed, return how much heal was left
/datum/wound/proc/heal_damage(amount)
	if(LAZYLEN(embedded_objects))
		return amount // heal nothing
	if(parent_organ)
		if (damage_type == INJURY_TYPE_BURN && !(parent_organ.burn_ratio < 100))
			return amount // We don't want to heal wounds on irreparable organs
		else if(!(parent_organ.brute_ratio < 100))
			return amount

	var/healed_damage = min(src.damage, amount)
	amount -= healed_damage
	src.damage -= healed_damage

	while(src.wound_damage() < damage_list[current_stage] && current_stage < length(src.desc_list))
		current_stage++
	desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	// return amount of healing still leftover, can be used for other wounds
	return amount

/// Opens the wound again
/datum/wound/proc/open_wound(damage)
	src.damage += damage
	bleed_timer += damage

	while(src.current_stage > 1 && src.damage_list[current_stage-1] <= src.damage / src.amount)
		src.current_stage--

	src.desc = desc_list[current_stage]
	src.min_damage = damage_list[current_stage]

	src.bandaged = FALSE

///returns whether this wound can absorb the given amount of damage.
///this will prevent large amounts of damage being trapped in less severe wound types
/datum/wound/proc/can_worsen(damage_type, damage)
	if (src.damage_type != damage_type)
		return FALSE //incompatible damage types

	if (src.amount > 1)
		return FALSE //merged wounds cannot be worsened.

	//with 1.5*, a shallow cut will be able to carry at most 30 damage,
	//37.5 for a deep cut
	//52.5 for a flesh wound, etc.
	var/max_wound_damage = 1.5*src.damage_list[1]
	if (src.damage + damage > max_wound_damage)
		return FALSE

	return TRUE

/datum/wound/proc/bleeding()
	for(var/obj/item/thing in embedded_objects)
		if(thing.w_class > WEIGHT_CLASS_SMALL)
			return FALSE

	if (bandaged||clamped)
		return FALSE

	return ((bleed_timer > 0 || wound_damage() > bleed_threshold) && current_stage <= max_bleeding_stage)

/// Called in organ_external.dm update_damages, this will update the limb's status to bleeding, and lowers the bleed_timer if applicable
/datum/wound/proc/handle_bleeding(var/mob/victim, var/obj/item/organ/external/limb)
	limb.status |= ORGAN_BLEEDING

	var/can_lower_bleed = TRUE
	if(HAS_TRAIT(victim, TRAIT_DISABILITY_HEMOPHILIA_MAJOR)) // major will NEVER lower
		can_lower_bleed = FALSE
	else if(HAS_TRAIT(victim, TRAIT_DISABILITY_HEMOPHILIA) && bleed_timer_increment % 2 != 0) // basic will lower half as fast
		can_lower_bleed = FALSE

	if(can_lower_bleed)
		bleed_timer--
	bleed_timer_increment++

/datum/wound/proc/close()
	return
