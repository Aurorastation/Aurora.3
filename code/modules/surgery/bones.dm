//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/glue_bone
	allowed_tools = list(
	/obj/item/surgery/bonegel = 100,	\
	/obj/item/tape_roll = 60
	)
	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/glue_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !(affected.status & ORGAN_ROBOT) && affected.open >= 2 && affected.open < 3 && affected.stage == 0

/datum/surgery_step/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message("[user] starts applying medication to the damaged bones in [target]'s [affected.name] with \the [tool]." , \
		"You start applying medication to the damaged bones in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!",1)
	..()

/datum/surgery_step/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] applies some [tool] to [target]'s bone in [affected.name]</span>", \
		"<span class='notice'>You apply some [tool] to [target]'s bone in [affected.name] with \the [tool].</span>")
	affected.stage = 1

/datum/surgery_step/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	target.apply_damage(15, PAIN)

/datum/surgery_step/set_bone
	allowed_tools = list(
	/obj/item/surgery/bonesetter = 100,	\
	/obj/item/wrench = 75		\
	)

	min_duration = 60
	max_duration = 70

/datum/surgery_step/set_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.name != BP_HEAD && !(affected.status & ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to set the bone in [target]'s [affected.name] in place with \the [tool]." , \
		"You are beginning to set the bone in [target]'s [affected.name] in place with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!",1)
	..()

/datum/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.status & ORGAN_BROKEN)
		user.visible_message("<span class='notice'>[user] sets the bone in [target]'s [affected.name] in place with \the [tool].</span>", \
			"<span class='notice'>You set the bone in [target]'s [affected.name] in place with \the [tool].</span>")
		affected.stage = 2
	else
		user.visible_message("<span class='notice'>[user] sets the bone in [target]'s [affected.name]</span><span class='warning'>in the WRONG place with \the [tool].</span>", \
			"<span class='notice'>You set the bone in [target]'s [affected.name]</span><span class='warning'>in the WRONG place with \the [tool].</span>")
		affected.fracture()

/datum/surgery_step/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>")
	target.apply_damage(5, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/mend_skull
	allowed_tools = list(
	/obj/item/surgery/bonesetter = 100,	\
	/obj/item/wrench = 75		\
	)

	min_duration = 60
	max_duration = 70

/datum/surgery_step/mend_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.name == BP_HEAD && !(affected.status & ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to piece together [target]'s skull with \the [tool]."  , \
		"You are beginning to piece together [target]'s skull with \the [tool].")
	..()

/datum/surgery_step/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] sets [target]'s skull with \the [tool].</span>" , \
		"<span class='notice'>You set [target]'s skull with \the [tool].</span>")
	affected.stage = 2

/datum/surgery_step/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s face with \the [tool]!</span>"  , \
		"<span class='warning'>Your hand slips, damaging [target]'s face with \the [tool]!</span>")
	var/obj/item/organ/external/head/h = affected
	target.apply_damage(10, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)
	h.disfigured = 1

/datum/surgery_step/finish_bone
	allowed_tools = list(
	/obj/item/surgery/bonegel = 100,	\
	/obj/item/tape_roll = 60
	)
	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/finish_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open >= 2 && affected.open < 3 && !(affected.status & ORGAN_ROBOT) && affected.stage == 2

/datum/surgery_step/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].", \
		"You start to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].")
	..()

/datum/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has mended the damaged bones in [target]'s [affected.name] with \the [tool].</span>"  , \
		"<span class='notice'>You have mended the damaged bones in [target]'s [affected.name] with \the [tool].</span>" )
	affected.status &= ~ORGAN_BROKEN
	affected.status &= ~ORGAN_SPLINTED
	affected.stage = 0
	affected.perma_injury = 0

/datum/surgery_step/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
		"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	target.apply_damage(15, PAIN)