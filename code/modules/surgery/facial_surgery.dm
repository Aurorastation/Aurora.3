
//////////////////////////////////////////////////////////////////
//						MEDIBOTS DREAM COME TRUE!                //
//                       Plastic Surgery+Facial Repair          //
//////////////////////////////////////////////////////////////////

/decl/surgery_step/face
	name = "Retract Facial Incisions"
	priority = 2
	can_infect = FALSE

/decl/surgery_step/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || BP_IS_ROBOTIC(affected))
		return FALSE
	return target_zone == BP_MOUTH

/decl/surgery_step/generic/prepare_face
	allowed_tools = list(
	/obj/item/surgery/retractor = 100,
	/obj/item/material/knife/tacknife = 75
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/generic/prepare_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == FACE_CUT_OPEN

/decl/surgery_step/generic/prepare_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to retract [target]'s face with \the [tool].", \
		"You start to retract [target]'s face with \the [tool].")
	..()

/decl/surgery_step/generic/prepare_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has retracted [target]'s face with \the [tool] for his facial alteration." , \
		SPAN_NOTICE("You have retracted [target]'s face and neck with \the [tool] for plastic surgery."),)
	target.op_stage.face = FACE_RETRACTED

/decl/surgery_step/generic/prepare_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!") , \
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!") )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	target.apply_damage(20, OXY)
	target.losebreath += 10


/decl/surgery_step/generic/alter_face
	name = "Alter Face"
	allowed_tools = list(
	/obj/item/surgery/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 40
	max_duration = 90

/decl/surgery_step/generic/alter_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == FACE_RETRACTED

/decl/surgery_step/generic/alter_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> starts to adjust [target]'s face with \the [tool].", \
		SPAN_NOTICE("You start to alter [target]'s face and neck with \the [tool]."))
	..()

/decl/surgery_step/generic/alter_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/head/head = target.get_organ(target_zone)
	if(head.disfigured || HAS_FLAG(target.mutations, HUSK))
		head.disfigured = FALSE
		target.mutations &= ~HUSK
		target.update_body()
		user.visible_message("<b>[user]</b> finishes adjusting the skin [target]'s face.", SPAN_NOTICE("You successfully restore [target]'s appearance."))

	var/getName = sanitize(input(user, "What is your patient's new identity?", "Name change") as null|text, MAX_NAME_LEN)
	if(getName)
		target.real_name = getName
		target.name = getName
		target.dna.real_name = getName
		if(target.mind)
			target.mind.name = target.name
		target.change_appearance(APPEARANCE_PLASTICSURGERY, user, TRUE, ui_state = default_state, state_object = target)
		target.op_stage.face = FACE_ALTERED


/decl/surgery_step/generic/alter_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!") , \
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!") )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	target.apply_damage(20, OXY)
	target.losebreath += 10


/decl/surgery_step/face/cauterize
	name = "Cauterize Face"
	allowed_tools = list(
	/obj/item/surgery/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/decl/surgery_step/face/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face > FACE_NORMAL

/decl/surgery_step/face/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool]." , \
		"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].")
	..()

/decl/surgery_step/face/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> cauterizes the incision on [target]'s face and neck with \the [tool].", \
		SPAN_NOTICE("You cauterize the incision on [target]'s face and neck with \the [tool]."))
	affected.open = ORGAN_CLOSED
	affected.status &= ~ORGAN_BLEEDING
	if(target.op_stage.face == 3)
		var/obj/item/organ/external/head/h = affected
		h.disfigured = 0
	target.op_stage.face = FACE_NORMAL

/decl/surgery_step/face/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, leaving a small burn on [target]'s face with \the [tool]!"))
	target.apply_damage(5, BURN, affected)

/decl/surgery_step/robotics/face
	priority = 2
	can_infect = FALSE

/decl/surgery_step/robotics/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH

/decl/surgery_step/robotics/face/synthskinopen
	name = "Retract facial incisions"
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/robotics/face/synthskinopen/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == FACE_NORMAL && target.get_species() == SPECIES_IPC_SHELL

/decl/surgery_step/robotics/face/synthskinopen/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s synthskin face and neck with \the [tool].", \
		"You start to cut open [target]'s synthskin face and neck with \the [tool].")
	..()

/decl/surgery_step/robotics/face/synthskinopen/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has cut open [target]'s synthskin face and neck with \the [tool]." , \
		SPAN_NOTICE("You have cut open [target]'s synthskin face and neck with \the [tool]."),)
	target.op_stage.face = FACE_CUT_OPEN

/decl/surgery_step/robotics/face/synthskinopen/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!") , \
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!") )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/decl/surgery_step/robotics/face/prepare_face
	name = "Prepare Face"
	allowed_tools = list(
	/obj/item/surgery/retractor = 100,
	/obj/item/material/knife/tacknife = 75
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/robotics/face/prepare_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == FACE_CUT_OPEN

/decl/surgery_step/robotics/face/prepare_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to retract [target]'s synthskin face with \the [tool].", \
		"You start to retract [target]'s face with \the [tool].")
	..()

/decl/surgery_step/robotics/face/prepare_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has retracted [target]'s synthskin face with \the [tool] for thier facial alteration." , \
		SPAN_NOTICE("You have retracted [target]'s synthskin face and neck with \the [tool] for plastic surgery."),)
	target.op_stage.face = FACE_RETRACTED

/decl/surgery_step/robotics/face/prepare_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!") , \
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!") )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/decl/surgery_step/robotics/face/alter_synthface
	name = "Alter Face"
	allowed_tools = list(
	/obj/item/device/multitool = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 40
	max_duration = 90

/decl/surgery_step/robotics/face/alter_synthface/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == FACE_RETRACTED

/decl/surgery_step/robotics/face/alter_synthface/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> starts to alter [target]'s synthskin face with \the [tool].", \
		SPAN_NOTICE("You start to alter [target]'s synthskin face and neck with \the [tool]."))
	..()

/decl/surgery_step/robotics/face/alter_synthface/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/head/head = target.get_organ(target_zone)
	if(head.disfigured || HAS_FLAG(target.mutations, HUSK))
		head.disfigured = FALSE
		target.mutations &= ~HUSK
		target.update_body()
		user.visible_message("<b>[user]</b> finishes adjusting [target]'s synthetic face.", \
							 SPAN_NOTICE("You successfully adjust [target]'s appearance."))

	var/getName = sanitize(input(user, "What is your patient's new identity?", "Name change") as null|text, MAX_NAME_LEN)
	if(getName)
		target.real_name = getName
		target.name = getName
		target.dna.real_name = getName
		if(target.mind)
			target.mind.name = target.name
		target.change_appearance(APPEARANCE_PLASTICSURGERY, user, TRUE, ui_state = default_state, state_object = target)
		target.op_stage.face = FACE_ALTERED


/decl/surgery_step/robotics/face/alter_synthface/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing [target]'s throat wth \the [tool]!") , \
		SPAN_WARNING("Your hand slips, slicing [target]'s throat wth \the [tool]!") )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/decl/surgery_step/robotics/face/seal_face
	name = "Seal face"
	allowed_tools = list(
	/obj/item/surgery/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/decl/surgery_step/robotics/face/seal_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face > FACE_NORMAL

/decl/surgery_step/robotics/face/seal_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to seal the incision on [target]'s synthskin face and neck with \the [tool]." , \
		"You are beginning to seal the incision on [target]'s synthskin face and neck with \the [tool].")
	..()

/decl/surgery_step/robotics/face/seal_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] seals the incision on [target]'s synthskin face and neck with \the [tool]."), \
		SPAN_NOTICE("You seal the incision on [target]'s synthskin face and neck with \the [tool]."))
	affected.open = ORGAN_CLOSED
	if(target.op_stage.face == FACE_ALTERED)
		var/obj/item/organ/external/head/h = affected
		h.disfigured = FALSE
	target.op_stage.face = FACE_NORMAL

/decl/surgery_step/robotics/face/seal_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, leaving a small burn on [target]'s synthskin face with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, leaving a small burn on [target]'s synthskin face with \the [tool]!"))
	target.apply_damage(5, BURN, affected)
