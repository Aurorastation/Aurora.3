/datum/condition/organ/slash
	name = "Slash"
	desc = "This is a base type, report this if it somehow appears."
	injury_types = list(INJURY_TYPE_CUT)
	/// The wound connected to this condition.
	var/datum/wound/connected_wound

/datum/condition/organ/slash/pre_apply(atom/movable/new_parent, injury_type)
	var/obj/item/organ/external/affected = new_parent
	if(!istype(affected))
		return FALSE
	if(!..())
		return FALSE
	return TRUE

/datum/condition/organ/slash/on_clear()
	. = ..()
	if(connected_wound)
		connected_wound.damage = 0
		connected_wound.bandage()
		connected_wound.disinfect()

/datum/condition/organ/slash/incision
	name = "Deep Incision"
	desc = "The skin and muscle have been torn apart."
	max_condition_amount = 4 //slashing weapons are really good at stacking multiple conditions to cause bleed loss
	apply_sound = 'sound/effects/conditions/deep_incision.ogg'
	severity = CONDITION_SEVERITY_MEDIUM
	min_damage = 30

/datum/condition/organ/slash/incision/on_apply()
	. = ..()
	var/obj/item/organ/external/affected = parent
	connected_wound = new /datum/wound/cut/deep_incision(40, affected)
	if(!QDELETED(connected_wound))
		if(!LAZYISIN(affected.wounds, connected_wound))
			LAZYADD(affected.wounds, connected_wound)
	affected.owner.visible_message(SPAN_CONDITION("A giant tear opens up on the flesh of [affected.owner]'s [affected]!"), SPAN_CONDITION("A giant tear opens up on the flesh of your [affected]!"))
	affected.owner.drip(10)

/datum/condition/organ/slash/incision/get_visible_status()
	for(var/datum/condition/organ/slash/incision/incision in organ.conditions)
		if(incision != src)
			return SPAN_CONDITION("has multiple deep cuts that don't look like they'll stop bleeding")
	return SPAN_CONDITION("has a deep cut that looks like it won't stop bleeding")

/datum/wound/cut/deep_incision
	bleed_threshold = 999
	bleed_timer = 999
	stages = list(
		"deep incision" = 40,
		"sutured deep incision" = 5
	)

/datum/condition/organ/slash/disembowelment
	name = "Disemboweled"
	desc = "The guts are torn open."
	max_condition_amount = 1 //can't disembowel more than once
	apply_sound = 'sound/effects/conditions/disembowelment.ogg'
	severity = CONDITION_SEVERITY_HIGH
	min_damage = 60

/datum/condition/organ/slash/disembowelment/on_apply()
	. = ..()
	var/obj/item/organ/external/affected = parent
	affected.owner.visible_message(SPAN_CONDITION("[affected.owner]'s guts are violently torn open!"), SPAN_CONDITION("Your guts are violently torn open!"))
	affected.add_pain(60)
	connected_wound = new /datum/wound/cut/disembowelment(60, affected)
	if(!QDELETED(connected_wound))
		if(!LAZYISIN(affected.wounds, connected_wound))
			LAZYADD(affected.wounds, connected_wound)
	gibs(get_turf(affected.owner), fleshcolor = affected.species.flesh_color, bloodcolor = affected.species.blood_color)
	affected.owner.Weaken(3)
	affected.owner.emote("scream")
	affected.owner.make_jittery(5)
	affected.owner.flash_strong_pain()

/datum/wound/cut/disembowelment
	bleed_threshold = 999
	bleed_timer = 999
	stages = list(
		"disemboweled guts" = 60,
		"giant sutured scar" = 10
	)

/datum/condition/organ/slash/disembowelment/get_visible_status()
	return SPAN_CONDITION("torn open")
