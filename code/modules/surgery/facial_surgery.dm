
//////////////////////////////////////////////////////////////////
//						MEDIBOTS DREAM COME TRUE!                //
//                       Plastic Surgery+Facial Repair          //
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

/datum/surgery_step/generic/prepare_face
	allowed_tools = list(
	/obj/item/surgery/retractor = 100,
	/obj/item/material/knife/tacknife = 75
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/prepare_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == 1

/datum/surgery_step/generic/prepare_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to retract [target]'s face with \the [tool].", \
		"You start to retract [target]'s face with \the [tool].")
	..()

/datum/surgery_step/generic/prepare_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has retracted [target]'s face with \the [tool] for his facial alteration.</span>" , \
		"<span class='notice'>You have retracted [target]'s face and neck with \the [tool] for plastic surgery.</span>",)
	target.op_stage.face = 2

/datum/surgery_step/generic/prepare_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)
	target.apply_damage(20, OXY)
	target.losebreath += 10


/datum/surgery_step/generic/alter_face
	allowed_tools = list(
	/obj/item/surgery/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 40
	max_duration = 90

/datum/surgery_step/generic/alter_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == 2

/datum/surgery_step/generic/alter_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to alter [target]'s face with \the [tool].", \
		"You start to alter [target]'s face and neck with \the [tool].")
	..()

/datum/surgery_step/generic/alter_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/head/head = target.get_organ(target_zone)
	if(head.disfigured || (HUSK in target.mutations))
		head.disfigured = FALSE
		target.mutations.Remove(HUSK)
		target.update_body()
		user.visible_message("[user] successfully restores [target]'s appearance!", "<span class='notice'>You successfully restore [target]'s appearance.</span>")

	var/getName = sanitize(input(user, "What is your patient's new identity?", "Name change") as null|text, MAX_NAME_LEN)
	if(getName)
		target.real_name = getName
		target.name = getName
		target.dna.real_name = getName
		if(target.mind)
			target.mind.name = target.name
		target.change_appearance(APPEARANCE_PLASTICSURGERY, usr, usr, check_species_whitelist = 1, state = z_state)
		target.op_stage.face = 3


/datum/surgery_step/generic/alter_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)
	target.apply_damage(20, OXY)
	target.losebreath += 10


/datum/surgery_step/face/cauterize
	allowed_tools = list(
	/obj/item/surgery/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/face/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face > 0

/datum/surgery_step/face/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool]." , \
		"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].")
	..()

/datum/surgery_step/face/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] cauterizes the incision on [target]'s face and neck with \the [tool].</span>", \
		"<span class='notice'>You cauterize the incision on [target]'s face and neck with \the [tool].</span>")
	affected.open = 0
	affected.status &= ~ORGAN_BLEEDING
	if(target.op_stage.face == 3)
		var/obj/item/organ/external/head/h = affected
		h.disfigured = 0
	target.op_stage.face = 0

/datum/surgery_step/face/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>")
	target.apply_damage(5, BURN, affected)

/datum/surgery_step/robotics/face
	priority = 2
	can_infect = 0

/datum/surgery_step/robotics/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return target_zone == BP_MOUTH

/datum/surgery_step/robotics/face/synthskinopen
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/robotics/face/synthskinopen/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 0 && target.get_species() == "Shell Frame"

/datum/surgery_step/robotics/face/synthskinopen/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s synthskin face and neck with \the [tool].", \
		"You start to cut open [target]'s synthskin face and neck with \the [tool].")
	..()

/datum/surgery_step/robotics/face/synthskinopen/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has cut open [target]'s synthskin face and neck with \the [tool].</span>" , \
		"<span class='notice'>You have cut open [target]'s synthskin face and neck with \the [tool].</span>",)
	target.op_stage.face = 1

/datum/surgery_step/robotics/face/synthskinopen/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/robotics/face/prepare_face
	allowed_tools = list(
	/obj/item/surgery/retractor = 100,
	/obj/item/material/knife/tacknife = 75
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/robotics/face/prepare_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == 1

/datum/surgery_step/robotics/face/prepare_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to retract [target]'s synthskin face with \the [tool].", \
		"You start to retract [target]'s face with \the [tool].")
	..()

/datum/surgery_step/robotics/face/prepare_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has retracted [target]'s synthskin face with \the [tool] for thier facial alteration.</span>" , \
		"<span class='notice'>You have retracted [target]'s synthskin face and neck with \the [tool] for plastic surgery.</span>",)
	target.op_stage.face = 2

/datum/surgery_step/robotics/face/prepare_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/robotics/face/alter_synthface
	allowed_tools = list(
	/obj/item/device/multitool = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 40
	max_duration = 90

/datum/surgery_step/robotics/face/alter_synthface/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_MOUTH && target.op_stage.face == 2

/datum/surgery_step/robotics/face/alter_synthface/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to alter [target]'s synthskin face with \the [tool].", \
		"You start to alter [target]'s synthskin face and neck with \the [tool].")
	..()

/datum/surgery_step/robotics/face/alter_synthface/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/head/head = target.get_organ(target_zone)
	if(head.disfigured || (HUSK in target.mutations))
		head.disfigured = FALSE
		target.mutations.Remove(HUSK)
		target.update_body()
		user.visible_message("[user] successfully restores [target]'s appearance!", "<span class='notice'>You successfully restore [target]'s appearance.</span>")

	var/getName = sanitize(input(user, "What is your patient's new identity?", "Name change") as null|text, MAX_NAME_LEN)
	if(getName)
		target.real_name = getName
		target.name = getName
		target.dna.real_name = getName
		if(target.mind)
			target.mind.name = target.name
		target.change_appearance(APPEARANCE_PLASTICSURGERY, usr, usr, check_species_whitelist = 1, state = z_state)
		target.op_stage.face = 3


/datum/surgery_step/robotics/face/alter_synthface/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	target.apply_damage(40, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/robotics/face/seal_face
	allowed_tools = list(
	/obj/item/surgery/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/robotics/face/seal_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face > 0

/datum/surgery_step/robotics/face/seal_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] is beginning to seal the incision on [target]'s synthskin face and neck with \the [tool]." , \
		"You are beginning to seal the incision on [target]'s synthskin face and neck with \the [tool].")
	..()

/datum/surgery_step/robotics/face/seal_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] seals the incision on [target]'s synthskin face and neck with \the [tool].</span>", \
		"<span class='notice'>You seal the incision on [target]'s synthskin face and neck with \the [tool].</span>")
	affected.open = 0
	if(target.op_stage.face == 3)
		var/obj/item/organ/external/head/h = affected
		h.disfigured = 0
	target.op_stage.face = 0

/datum/surgery_step/robotics/face/seal_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, leaving a small burn on [target]'s synthskin face with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, leaving a small burn on [target]'s synthskin face with \the [tool]!</span>")
	target.apply_damage(5, BURN, affected)