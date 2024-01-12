//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/glue_bone
	name = "Repair Broken Bone"
	allowed_tools = list(
	/obj/item/surgery/bone_gel = 100,	\
	/obj/item/tape_roll = 60
	)
	can_infect = TRUE
	blood_level = 1

	min_duration = 30
	max_duration = 40

/singleton/surgery_step/glue_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !BP_IS_ROBOTIC(affected) && affected.open >= ORGAN_OPEN_RETRACTED && affected.open < ORGAN_ENCASED_RETRACTED && affected.stage == BONE_PRE_OP && HAS_FLAG(affected.status, ORGAN_BROKEN)

/singleton/surgery_step/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == BONE_PRE_OP)
		user.visible_message("<b>[user]</b> starts applying some of [tool] to the damaged bones in [target]'s [affected.name]." , \
		SPAN_NOTICE("You start applying some of [tool] to the damaged bones in [target]'s [affected.name]."))
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!",1)
	..()

/singleton/surgery_step/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> applies some of [tool] to [target]'s bone in [affected.name].", \
		SPAN_NOTICE("You apply some of [tool] to [target]'s bone in [affected.name]."))
	affected.stage = BONE_GLUED

/singleton/surgery_step/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, smearing some of [tool] in the incision in [target]'s [affected.name]!") , \
	SPAN_WARNING("Your hand slips, smearing some of [tool] in the incision in [target]'s [affected.name]!"))
	target.apply_damage(15, DAMAGE_PAIN)

/singleton/surgery_step/set_bone
	name = "Set Broken Bone"
	allowed_tools = list(
	/obj/item/surgery/bonesetter = 100,	\
	WRENCH = 75		\
	)

	min_duration = 30
	max_duration = 50

/singleton/surgery_step/set_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.name != BP_HEAD && !BP_IS_ROBOTIC(affected) && affected.open >= ORGAN_OPEN_RETRACTED && affected.stage == BONE_GLUED

/singleton/surgery_step/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] is beginning to set the bone in [target]'s [affected.name] in place with \the [tool]." , \
		"You are beginning to set the bone in [target]'s [affected.name] in place with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!",1)
	..()

/singleton/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.status & ORGAN_BROKEN)
		user.visible_message("<b>[user]</b> sets the bone in [target]'s [affected.name] in place with \the [tool].", \
			SPAN_NOTICE("You set the bone in [target]'s [affected.name] in place with \the [tool]."))
		affected.stage = BONE_SET
	else
		user.visible_message(SPAN_NOTICE("[user] sets the bone in [target]'s [affected.name] [SPAN_WARNING("in the WRONG place with \the [tool].")]"), \
			SPAN_NOTICE("You set the bone in [target]'s [affected.name] [SPAN_WARNING("in the WRONG place with \the [tool].")]"))
		affected.fracture()

/singleton/surgery_step/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!") , \
		SPAN_WARNING("Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(5, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/singleton/surgery_step/mend_skull
	name = "Repair Broken Skull"
	allowed_tools = list(
	/obj/item/surgery/bonesetter = 100,	\
	WRENCH = 75		\
	)

	min_duration = 40
	max_duration = 50

/singleton/surgery_step/mend_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.name == BP_HEAD && !BP_IS_ROBOTIC(affected) && affected.open >= ORGAN_OPEN_RETRACTED && affected.stage == BONE_GLUED

/singleton/surgery_step/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to piece together [target]'s skull with \the [tool]."  , \
		"You are beginning to piece together [target]'s skull with \the [tool].")
	..()

/singleton/surgery_step/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> sets [target]'s skull with \the [tool]." , \
		SPAN_NOTICE("You set [target]'s skull with \the [tool]."))
	affected.stage = ORGAN_OPEN_RETRACTED

/singleton/surgery_step/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s face with \the [tool]!")  , \
		SPAN_WARNING("Your hand slips, damaging [target]'s face with \the [tool]!"))
	var/obj/item/organ/external/head/h = affected
	target.apply_damage(10, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	h.disfigured = 1

/singleton/surgery_step/finish_bone
	name = "Finish Repairing Broken Bone"
	allowed_tools = list(
	/obj/item/surgery/bone_gel = 100,	\
	/obj/item/tape_roll = 60
	)
	can_infect = TRUE
	blood_level = 1

	min_duration = 30
	max_duration = 40

/singleton/surgery_step/finish_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open >= ORGAN_OPEN_RETRACTED && affected.open < ORGAN_ENCASED_RETRACTED && !BP_IS_ROBOTIC(affected) && affected.stage == BONE_SET

/singleton/surgery_step/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].", \
		"You start to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].")
	..()

/singleton/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has mended the damaged bones in [target]'s [affected.name] with \the [tool]."  , \
		SPAN_NOTICE("You have mended the damaged bones in [target]'s [affected.name] with \the [tool].") )
	affected.status &= ~ORGAN_BROKEN
	affected.status &= ~ORGAN_SPLINTED
	affected.stage = BONE_PRE_OP
	affected.perma_injury = 0

/singleton/surgery_step/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!") , \
		SPAN_WARNING("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"))
	target.apply_damage(15, DAMAGE_PAIN)
