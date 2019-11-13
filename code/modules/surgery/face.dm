//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	priority = 2
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (!affected || (affected.status & ORGAN_ROBOT))
			return 0
		return target_zone == "mouth"

/datum/surgery_step/generic/cut_face
	allowed_tools = list(
	/obj/item/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target_zone == "mouth" && target.op_stage.face == 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].", \
		"You start to cut open [target]'s face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has cut open [target]'s face and neck with \the [tool].</span>" , \
		"<span class='notice'>You have cut open [target]'s face and neck with \the [tool].</span>",)
		target.op_stage.face = 1

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
		affected.createwound(CUT, 60)
		target.losebreath += 10


/datum/surgery_step/robotics/face
	priority = 2
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return target_zone == "mouth"

/datum/surgery_step/robotics/face/synthskin
	allowed_tools = list(
	/obj/item/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 0 && target.get_species() == "Shell Frame"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to cut open [target]'s synthskin face and neck with \the [tool].", \
		"You start to cut open [target]'s synthskin face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has cut open [target]'s synthskin face and neck with \the [tool].</span>" , \
		"<span class='notice'>You have cut open [target]'s synthskin face and neck with \the [tool].</span>",)
		target.op_stage.face = 1

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
		affected.createwound(CUT, 60)
