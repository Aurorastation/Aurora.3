/datum/condition/organ/fracture
	name = "Fracture"
	desc = "This is a base type, report this if it somehow appears."
	injury_types = list(INJURY_TYPE_BRUISE, INJURY_TYPE_PIERCE)
	/// If this particular fracture should be silent.
	var/silent = FALSE
	/// The minimum damage for each fracture is equal to the organ's min_broken_damage multiplied by this multiplier.
	var/min_damage_multiplier = 1.0
	/// The emote the owner makes when the fracture happens.
	var/fracture_emote = "groan"
	/// The volume at which the fracture sound plays.
	var/fracture_volume = 50
	/// The pain applied from the fracture.
	var/fracture_pain = 10

/datum/condition/organ/fracture/New(atom/movable/new_parent, injury_type, should_be_silent = FALSE)
	silent = should_be_silent
	if(silent)
		should_play_severity_sound = FALSE
	. = ..()

/datum/condition/organ/fracture/pre_apply(atom/movable/new_parent)
	var/obj/item/organ/external/affected = new_parent
	if(!istype(affected))
		return FALSE

	min_damage = affected.min_broken_damage * min_damage_multiplier
	if(!..())
		return FALSE

	if(affected.status & ORGAN_ROBOT)
		return FALSE	//ORGAN_BROKEN doesn't have the same meaning for robot limbs

	if(!(affected.limb_flags & ORGAN_CAN_BREAK))
		return FALSE

	if(QDELETED(affected.owner))
		return FALSE
	return TRUE

/datum/condition/organ/fracture/on_apply()
	. = ..()
	if(!silent)
		fracture_message()
		fracture_sound()

	var/obj/item/organ/external/affected = organ
	affected.perma_injury += fracture_pain

	// Fractures have a chance of getting you out of restraints
	if(prob(25))
		affected.release_restraints()

/datum/condition/organ/fracture/on_clear()
	. = ..()
	if(organ)
		var/list/datum/condition/organ/fracture/fractures = list()
		for(var/datum/condition/organ/fracture/frac in organ.conditions)
			if(istype(frac, /datum/condition/organ/fracture))
				if(frac != src && frac.severity > CONDITION_SEVERITY_LOW)
					fractures += frac
		if(!length(fractures))
			organ.status &= ~ORGAN_BROKEN
		var/obj/item/organ/external/affected = organ
		affected.perma_injury = fracture_pain
		affected.perma_injury = max(0, affected.perma_injury - fracture_pain)

/**
 * Actually play the fracture message, which can vary by fracture.
 */
/datum/condition/organ/fracture/proc/fracture_message()
	return

/**
 * After the message, play the sound if there is one.
 */
/datum/condition/organ/fracture/proc/fracture_sound()
	if(organ.owner?.species && organ.owner?.can_feel_pain())
		organ.owner?.emote(fracture_emote)
		organ.owner?.flash_pain(fracture_pain)
	playsound(organ?.owner, SFX_FRACTURE, fracture_volume, 1, -2)

/datum/condition/organ/fracture/hairline
	name = "Hairline Fracture"
	desc = "A small crack has formed in the bone."
	severity = CONDITION_SEVERITY_LOW
	apply_sound = SFX_FRACTURE
	max_condition_amount = 3
	min_damage_multiplier = 0.75

/datum/condition/organ/fracture/comminuted
	name = "Comminuted Fracture"
	desc = "The bone is shattered into several pieces."
	severity = CONDITION_SEVERITY_MEDIUM
	apply_sound = SFX_FRACTURE
	max_condition_amount = 2
	min_damage_multiplier = 1.0
	fracture_emote = "scream"
	fracture_volume = 90
	fracture_pain = 20

/datum/condition/organ/fracture/comminuted/on_apply()
	. = ..()
	organ.status |= ORGAN_BROKEN
	var/obj/item/organ/external/affected = organ
	affected.check_rigsplints()

/datum/condition/organ/fracture/comminuted/fracture_message()
	if(!silent)
		var/message = pick("broke in half", "shattered")
		organ.owner?.visible_message(FONT_LARGE(SPAN_CONDITION("You hear a loud cracking sound coming from \the [organ.owner]!")), \
			FONT_LARGE(SPAN_CONDITION("Something feels like it [message] in your [organ.name]!")), \
			"You hear a sickening crack!")

/datum/condition/organ/fracture/compound
	name = "Compound Fracture"
	desc = "The bone is totally broken and has pierced the skin."
	severity = CONDITION_SEVERITY_HIGH
	apply_sound = SFX_FRACTURE
	max_condition_amount = 1
	min_damage_multiplier = 1.5
	fracture_emote = "scream"
	fracture_volume = 100
	fracture_pain = 30

/datum/condition/organ/fracture/compound/on_apply()
	. = ..()
	organ.status |= ORGAN_BROKEN
	var/obj/item/organ/external/affected = organ
	affected.createwound(INJURY_TYPE_CUT, 20)
	affected.check_rigsplints()

/datum/condition/organ/fracture/compound/fracture_message()
	if(!silent)
		organ.owner?.visible_message(FONT_LARGE(SPAN_CONDITION("The bone shatters and pierces through [organ.owner]'s [organ.name]!")), \
			FONT_LARGE(SPAN_CONDITION("The bone in your [organ.name] shatters and pierces through!")), \
			"You hear a sickening, wet crack!")

/datum/condition/organ/blunt/fracture/broken_spine
	name = "Broken Spine"
	desc = "The spinal cord has been broken."
	severity = CONDITION_SEVERITY_HIGH
	traits = list(TRAIT_BROKEN_SPINE)
	injury_types = list(INJURY_TYPE_BRUISE)
	apply_sound = 'sound/effects/conditions/broken_spine.ogg'
	max_condition_amount = 1
	min_damage = 100

/datum/condition/organ/blunt/fracture/broken_spine/pre_apply(atom/movable/new_parent, injury_type)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = new_parent
	var/frac_count = 0
	for(var/datum/condition/organ/fracture/fracture in affected.conditions)
		if(fracture.severity >= CONDITION_SEVERITY_MEDIUM)
			frac_count += 2
		else
			frac_count++

	if(frac_count >= 3)
		return TRUE
	return FALSE

/datum/condition/organ/blunt/fracture/broken_spine/on_apply()
	. = ..()
	organ.owner?.visible_message(SPAN_CONDITION("[organ?.owner]'s spine breaks in half!"), SPAN_CONDITION("Your spine breaks in half!"))
	organ.owner?.Weaken(3)
	organ.owner?.make_jittery(20)

//blunt
/datum/condition/organ/blunt
	name = "Blunt Damage"
	desc = "This is a base type. Report this if you see this."
	injury_types = list(INJURY_TYPE_BRUISE)

/datum/condition/organ/blunt/pre_apply(atom/movable/new_parent, injury_type)
	var/obj/item/organ/external/affected = new_parent
	if(!istype(affected))
		return FALSE
	if(!..())
		return FALSE
	return TRUE

/datum/condition/organ/blunt/intracranial_bleeding
	name = "Intracranial Bleeding"
	desc = "Excessive blunt damage to the skull has damaged the brain."
	max_condition_amount = 1
	apply_sound = 'sound/effects/conditions/concussion.ogg'
	severity = CONDITION_SEVERITY_HIGH
	flags = CONDITION_FLAG_PROCESS

	/// The concussed mob, need this to not do a typecast every process.
	var/mob/living/carbon/human/concussee

/datum/condition/organ/blunt/intracranial_bleeding/pre_apply(atom/movable/new_parent, injury_type)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = new_parent
	var/frac_count = 0
	for(var/datum/condition/organ/fracture/fracture in affected.conditions)
		if(fracture.severity >= CONDITION_SEVERITY_MEDIUM)
			frac_count += 2
		else
			frac_count++

	if(frac_count >= 3)
		concussee = affected.owner
		return TRUE
	return FALSE

/datum/condition/organ/blunt/intracranial_bleeding/on_apply()
	. = ..()
	concussee.visible_message(SPAN_CONDITION("[concussee]'s skull cracks with a wet noise and [concussee.get_pronoun("he")] goes unconscious!"), SPAN_CONDITION("You feel a heavy impact on your skull - and the world goes dark."))
	concussee.SetParalysis(5)

/datum/condition/organ/blunt/intracranial_bleeding/process()
	if(concussee)
		concussee.vessel.remove_reagent(/singleton/reagent/blood, 2) //slow, invisible bleeding, basically internal bleeding
		concussee.SetParalysis(5)
		var/obj/item/organ/internal/brain/sponge = concussee.internal_organs_by_name[BP_BRAIN]
		if(istype(sponge) && sponge.damage < (sponge.max_damage * 0.5))
			sponge.take_damage(2)
