/datum/condition/organ/burn
	name = "Severe Burns"
	desc = "This is a base type. Report this if you somehow see this."
	/// The wound connected to this condition.
	var/datum/wound/connected_wound

/datum/condition/organ/burn/pre_apply(atom/movable/new_parent, injury_type)
	var/obj/item/organ/external/affected = new_parent
	if(!istype(affected))
		return FALSE
	if(!..())
		return FALSE
	return TRUE

/datum/condition/organ/burn/eschar
	name = "Eschar"
	desc = "The tissue has melted away into a necrotic mess."
	max_condition_amount = 1
	severity = CONDITION_SEVERITY_LOW
	apply_sound = 'sound/effects/conditions/eschar.ogg'
	min_damage = 30
	/// The amount of times an eschar is stacked on the same organ. Each eschar applied increases this count.
	var/stacks = 1
	/// Maximum amount of stacks we can have.
	var/maximum_stacks = 6

/datum/condition/organ/burn/eschar/pre_apply(atom/movable/new_parent, injury_type)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = new_parent
	for(var/datum/condition/organ/burn/eschar/eschar in affected.conditions)
		eschar.add_stacks()
		return FALSE
	return TRUE

/datum/condition/organ/burn/eschar/on_apply()
	. = ..()
	var/obj/item/organ/external/affected = parent
	connected_wound = new /datum/wound/burn/eschar(20, affected)
	if(!QDELETED(connected_wound))
		if(!LAZYISIN(affected.wounds, connected_wound))
			LAZYADD(affected.wounds, connected_wound)
		affected.owner.visible_message(SPAN_CONDITION("The flesh on [affected.owner]'s [affected.name] burns horribly!"), SPAN_CONDITION("You feel your flesh burn off of your [affected.name]!"))

/datum/condition/organ/burn/eschar/proc/add_stacks()
	if(stacks < maximum_stacks)
		stacks++
		var/obj/item/organ/external/affected = parent
		affected.owner.visible_message(SPAN_CONDITION("The flesh on [affected.owner]'s [affected.name] melts away!"), SPAN_CONDITION("The flesh and muscle on your [affected.name] melt away further!"))
		connected_wound.damage += 20
		affected.add_pain(20)
		affected.owner.flash_strong_pain()
		playsound(affected.owner, 'sound/effects/conditions/eschar.ogg', 100, FALSE)
		switch(stacks)
			if(3)
				name = "Third-Degree Burn Eschar"
				severity = CONDITION_SEVERITY_MEDIUM
				to_chat(affected.owner, SPAN_CONDITION("You feel the burns reach deeply inside your [affected.name]!"))
			if(6)
				name = "Fourth-Degree Burn Eschar"
				affected.owner.visible_message(SPAN_CONDITION("[affected.owner]'s [affected.name] melts into almost nothingness!"), SPAN_CONDITION("Your [affected.name] melts into almost nothingness!"))
				severity = CONDITION_SEVERITY_HIGH
				ADD_TRAIT(affected, TRAIT_FOURTH_DEGREE_ESCHAR, TRAIT_ORIGIN_CONDITION)
		return TRUE
	return FALSE

/datum/condition/organ/burn/eschar/on_clear()
	. = ..()
	if(stacks >= 6)
		REMOVE_TRAIT(parent, TRAIT_FOURTH_DEGREE_ESCHAR, TRAIT_ORIGIN_CONDITION)

/datum/wound/burn/eschar
	autoheal_cutoff = 10
	stages = list(
		"eschar" = 20,
		"necrotic tissue" = 10,
		"healing burn scar" = 5
	)
