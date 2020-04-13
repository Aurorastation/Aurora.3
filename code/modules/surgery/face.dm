//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	priority = 2
	can_infect = 0

/datum/surgery_step/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || (affected.status & ORGAN_ROBOT))
		return 0
	return target_zone == BP_MOUTH

/datum/surgery_step/generic/cut_face
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == 0

/datum/surgery_step/generic/cut_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].", \
		"You start to cut open [target]'s face and neck with \the [tool].")
	..()

/datum/surgery_step/generic/cut_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has cut open [target]'s face and neck with \the [tool].</span>" , \
		"<span class='notice'>You have cut open [target]'s face and neck with \the [tool].</span>",)
	target.op_stage.face = 1

/datum/surgery_step/generic/cut_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)
	target.apply_damage(20, OXY)
	target.losebreath += 10


/datum/surgery_step/robotics/face
	priority = 2
	can_infect = 0

/datum/surgery_step/robotics/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return target_zone == BP_MOUTH

/datum/surgery_step/robotics/face/synthskin
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/robotics/face/synthskin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 0 && target.get_species() == "Shell Frame"

/datum/surgery_step/robotics/face/synthskin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s synthskin face and neck with \the [tool].", \
		"You start to cut open [target]'s synthskin face and neck with \the [tool].")
	..()

/datum/surgery_step/robotics/face/synthskin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has cut open [target]'s synthskin face and neck with \the [tool].</span>" , \
		"<span class='notice'>You have cut open [target]'s synthskin face and neck with \the [tool].</span>",)
	target.op_stage.face = 1

/datum/surgery_step/robotics/face/synthskin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)