//Procedures in this file: Generic ribcage opening steps, Removing alien embryo, Fixing internal organs.
//////////////////////////////////////////////////////////////////
//				GENERIC	RIBCAGE SURGERY							//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/open_encased
	priority = 2
	can_infect = 1
	blood_level = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return 0

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !(affected.status & ORGAN_ROBOT) && affected.encased && affected.open >= 2


/datum/surgery_step/open_encased/saw
	allowed_tools = list(
	/obj/item/circular_saw = 100,
	/obj/item/melee/energy = 100,
	/obj/item/melee/chainsword = 70,
	/obj/item/material/hatchet = 75
	)

	min_duration = 50
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return ..() && affected && affected.open == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("[user] begins to cut through [target]'s [affected.encased] with \the [tool].", \
		"You begin to cut through [target]'s [affected.encased] with \the [tool].")
		target.custom_pain("Something hurts horribly in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='notice'>[user] has cut [target]'s [affected.encased] open with \the [tool].</span>",		\
		"<span class='notice'>You have cut [target]'s [affected.encased] open with \the [tool].</span>")
		affected.open = 2.5

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='warning'>[user]'s hand slips, cracking [target]'s [affected.encased] with \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, cracking [target]'s [affected.encased] with \the [tool]!</span>" )

		affected.createwound(CUT, 20)
		affected.fracture()


/datum/surgery_step/open_encased/retract
	allowed_tools = list(
	/obj/item/retractor = 100, 	\
	/obj/item/crowbar = 75
	)

	min_duration = 30
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return ..() && affected && affected.open == 2.5

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "[user] starts to force open the [affected.encased] in [target]'s [affected.name] with \the [tool]."
		var/self_msg = "You start to force open the [affected.encased] in [target]'s [affected.name] with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='notice'>[user] forces open [target]'s [affected.encased] with \the [tool].</span>"
		var/self_msg = "<span class='notice'>You force open [target]'s [affected.encased] with \the [tool].</span>"
		user.visible_message(msg, self_msg)

		affected.open = 3

		// Whoops!
		if(prob(10))
			affected.fracture()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='warning'>[user]'s hand slips, cracking [target]'s [affected.encased]!</span>"
		var/self_msg = "<span class='warning'>Your hand slips, cracking [target]'s  [affected.encased]!</span>"
		user.visible_message(msg, self_msg)

		affected.createwound(BRUISE, 20)
		affected.fracture()

/datum/surgery_step/open_encased/close
	allowed_tools = list(
	/obj/item/retractor = 100, 	\
	/obj/item/crowbar = 75
	)

	min_duration = 20
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return ..() && affected && affected.open == 3

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "[user] starts bending [target]'s [affected.encased] back into place with \the [tool]."
		var/self_msg = "You start bending [target]'s [affected.encased] back into place with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='notice'>[user] bends [target]'s [affected.encased] back into place with \the [tool].</span>"
		var/self_msg = "<span class='notice'>You bend [target]'s [affected.encased] back into place with \the [tool].</span>"
		user.visible_message(msg, self_msg)

		affected.open = 2.5

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='warning'>[user]'s hand slips, bending [target]'s [affected.encased] the wrong way!</span>"
		var/self_msg = "<span class='warning'>Your hand slips, bending [target]'s [affected.encased] the wrong way!</span>"
		user.visible_message(msg, self_msg)

		affected.createwound(BRUISE, 20)
		affected.fracture()

		if(affected.internal_organs && affected.internal_organs.len)
			if(prob(40))
				var/obj/item/organ/O = pick(affected.internal_organs) //TODO weight by organ size
				user.visible_message("<span class='danger'>A wayward piece of [target]'s [affected.encased] pierces \his [O.name]!</span>")
				O.bruise()

/datum/surgery_step/open_encased/mend
	allowed_tools = list(
	/obj/item/bonegel = 100,	\
	/obj/item/tape_roll = 60
	)

	min_duration = 20
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return ..() && affected && affected.open == 2.5

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "[user] starts applying \the [tool] to [target]'s [affected.encased]."
		var/self_msg = "You start applying \the [tool] to [target]'s [affected.encased]."
		user.visible_message(msg, self_msg)
		target.custom_pain("Something hurts horribly in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		var/msg = "<span class='notice'>[user] applied \the [tool] to [target]'s [affected.encased].</span>"
		var/self_msg = "<span class='notice'>You applied \the [tool] to [target]'s [affected.encased].</span>"
		user.visible_message(msg, self_msg)

		affected.open = 2