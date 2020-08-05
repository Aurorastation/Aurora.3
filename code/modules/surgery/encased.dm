//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/open_encased
	name = "Saw through bone"
	priority = 2
	can_infect = TRUE
	blood_level = 1

/decl/surgery_step/open_encased/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !BP_IS_ROBOTIC(affected) && affected.encased && affected.open >= ORGAN_OPEN_RETRACTED


/decl/surgery_step/open_encased/saw
	allowed_tools = list(
	/obj/item/surgery/circular_saw = 100,
	/obj/item/melee/energy = 100,
	/obj/item/melee/chainsword = 70,
	/obj/item/material/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

/decl/surgery_step/open_encased/saw/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_OPEN_RETRACTED

/decl/surgery_step/open_encased/saw/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("[user] begins to cut through [target]'s [affected.encased] with \the [tool].", \
		"You begin to cut through [target]'s [affected.encased] with \the [tool].")
	target.custom_pain("Something hurts horribly in your [affected.name]!", 75)
	..()

/decl/surgery_step/open_encased/saw/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<b>[user]</b> has cut [target]'s [affected.encased] open with \the [tool].",		\
		SPAN_NOTICE("You have cut [target]'s [affected.encased] open with \the [tool]."))
	affected.open = ORGAN_ENCASED_OPEN

/decl/surgery_step/open_encased/saw/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!") , \
		SPAN_WARNING("Your hand slips, cracking [target]'s [affected.encased] with \the [tool]!") )

	target.apply_damage(20, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	affected.fracture()


/decl/surgery_step/open_encased/retract
	name = "Retract bone"
	allowed_tools = list(
	/obj/item/surgery/retractor = 100, 	\
	/obj/item/crowbar = 75
	)

	min_duration = 30
	max_duration = 40

/decl/surgery_step/open_encased/retract/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_ENCASED_OPEN

/decl/surgery_step/open_encased/retract/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "[user] starts to force open the [affected.encased] in [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to force open the [affected.encased] in [target]'s [affected.name] with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your [affected.name]!", 75)
	..()

/decl/surgery_step/open_encased/retract/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<b>[user]</b> forces open [target]'s [affected.encased] with \the [tool]."
	var/self_msg = "You force open [target]'s [affected.encased] with \the [tool]."
	user.visible_message(msg, SPAN_NOTICE(self_msg))
	..()

	affected.open = ORGAN_ENCASED_RETRACTED

/decl/surgery_step/open_encased/retract/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = SPAN_WARNING("[user]'s hand slips, cracking [target]'s [affected.encased]!")
	var/self_msg = SPAN_WARNING("Your hand slips, cracking [target]'s [affected.encased]!")
	user.visible_message(msg, self_msg)

	target.apply_damage(20, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	affected.fracture()

/decl/surgery_step/open_encased/close
	allowed_tools = list(
	/obj/item/surgery/retractor = 100, 	\
	/obj/item/crowbar = 75
	)

	min_duration = 20
	max_duration = 40

/decl/surgery_step/open_encased/close/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_ENCASED_RETRACTED

/decl/surgery_step/open_encased/close/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "[user] starts bending [target]'s [affected.encased] back into place with \the [tool]."
	var/self_msg = "You start bending [target]'s [affected.encased] back into place with \the [tool]."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your [affected.name]!", 75)
	..()

/decl/surgery_step/open_encased/close/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "<b>[user]</b> bends [target]'s [affected.encased] back into place with \the [tool]."
	var/self_msg = "You bend [target]'s [affected.encased] back into place with \the [tool]."
	user.visible_message(msg, SPAN_NOTICE(self_msg))
	target.custom_pain("Something hurts horribly in your [affected.name]!", 75)
	..()

	affected.open = ORGAN_ENCASED_OPEN

/decl/surgery_step/open_encased/close/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = SPAN_WARNING("[user]'s hand slips, bending [target]'s [affected.encased] the wrong way!")
	var/self_msg = SPAN_WARNING("Your hand slips, bending [target]'s [affected.encased] the wrong way!")
	user.visible_message(msg, self_msg)

	target.apply_damage(20, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	affected.fracture()

	if(affected.internal_organs && affected.internal_organs.len)
		if(prob(40))
			var/obj/item/organ/O = pick(affected.internal_organs) //TODO weight by organ size
			user.visible_message(SPAN_DANGER("A wayward piece of [target]'s [affected.encased] pierces \his [O.name]!"))
			O.bruise()

/decl/surgery_step/open_encased/mend
	allowed_tools = list(
	/obj/item/surgery/bonegel = 100,	\
	/obj/item/tape_roll = 60
	)

	min_duration = 20
	max_duration = 40

/decl/surgery_step/open_encased/mend/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_ENCASED_OPEN

/decl/surgery_step/open_encased/mend/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "[user] starts applying \the [tool] to [target]'s [affected.encased]."
	var/self_msg = "You start applying \the [tool] to [target]'s [affected.encased]."
	user.visible_message(msg, self_msg)
	target.custom_pain("Something hurts horribly in your [affected.name]!", 75)
	..()

/decl/surgery_step/open_encased/mend/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/msg = "<b>[user]</b> starts applying \the [tool] to [target]'s [affected.encased]."
	var/self_msg = "You start applying \the [tool] to [target]'s [affected.encased]."
	user.visible_message(msg, SPAN_NOTICE(self_msg))
	target.custom_pain("Something hurts horribly in your [affected.name]!", 75)
	..()

	affected.open = ORGAN_OPEN_RETRACTED