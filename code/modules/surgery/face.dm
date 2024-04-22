//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/generic/cut_face
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 70
	max_duration = 90

/singleton/surgery_step/generic/cut_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == FACE_NORMAL

/singleton/surgery_step/generic/cut_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].", \
		"You start to cut open [target]'s face and neck with \the [tool].")
	..()

/singleton/surgery_step/generic/cut_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has cut open [target]'s face and neck with \the [tool]." , \
		SPAN_NOTICE("You have cut open [target]'s face and neck with \the [tool]."),)
	target.op_stage.face = FACE_CUT_OPEN

/singleton/surgery_step/generic/cut_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!") , \
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!") )
	target.apply_damage(40, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	target.apply_damage(20, DAMAGE_OXY)
	target.losebreath += 10

/singleton/surgery_step/robotics/face/synthskin
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 70
	max_duration = 90

/singleton/surgery_step/robotics/face/synthskin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == FACE_NORMAL && target.get_species() == SPECIES_IPC_SHELL

/singleton/surgery_step/robotics/face/synthskin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s synthskin face and neck with \the [tool].", \
		"You start to cut open [target]'s synthskin face and neck with \the [tool].")
	..()

/singleton/surgery_step/robotics/face/synthskin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has cut open [target]'s synthskin face and neck with \the [tool]." , \
		SPAN_NOTICE("You have cut open [target]'s synthskin face and neck with \the [tool]."),)
	target.op_stage.face = FACE_CUT_OPEN

/singleton/surgery_step/robotics/face/synthskin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!") , \
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!") )
	target.apply_damage(40, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
