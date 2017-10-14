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
	/obj/item/weapon/scalpel = 100,
	/obj/item/weapon/material/knife = 75,
	/obj/item/weapon/material/shard = 50
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

/datum/surgery_step/face/mend_vocal
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts mending [target]'s vocal cords with \the [tool].", \
		"You start mending [target]'s vocal cords with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] mends [target]'s vocal cords with \the [tool].</span>", \
		"<span class='notice'>You mend [target]'s vocal cords with \the [tool].</span>")
		target.op_stage.face = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!</span>")
		target.losebreath += 10

/datum/surgery_step/face/fix_face
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 55,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 75)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts pulling the skin on [target]'s face back in place with \the [tool].", \
		"You start pulling the skin on [target]'s face back in place with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] pulls the skin on [target]'s face back in place with \the [tool].</span>",	\
		"<span class='notice'>You pull the skin on [target]'s face back in place with \the [tool].</span>")
		target.op_stage.face = 3

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, tearing skin on [target]'s face with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, tearing skin on [target]'s face with \the [tool]!</span>")
		target.apply_damage(10, BRUTE, affected, sharp=1, sharp=1)

/datum/surgery_step/face/cauterize
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face > 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool]." , \
		"You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] cauterizes the incision on [target]'s face and neck with \the [tool].</span>", \
		"<span class='notice'>You cauterize the incision on [target]'s face and neck with \the [tool].</span>")
		affected.open = 0
		affected.status &= ~ORGAN_BLEEDING
		if (target.op_stage.face == 3)
			var/obj/item/organ/external/head/h = affected
			h.disfigured = 0
		target.op_stage.face = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>")
		target.apply_damage(4, BURN, affected)

/datum/surgery_step/robotics/face
	priority = 2
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return target_zone == "mouth"

/datum/surgery_step/robotics/face/synthskin
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,
	/obj/item/weapon/material/knife = 75,
	/obj/item/weapon/material/shard = 50
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

/datum/surgery_step/robotics/face/mend_voice
	allowed_tools = list(
	/obj/item/device/multitool = 100, 	\
	/obj/item/stack/cable_coil = 75
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts mending [target]'s voice synthesiser with \the [tool].", \
		"You start mending [target]'s voice synthesiser with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] mends [target]'s voice synthesiser with \the [tool].</span>", \
		"<span class='notice'>You mend [target]'s voice synthesiser with \the [tool].</span>")
		target.op_stage.face = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips!</span>", \
		"<span class='warning'>Your hand slips!</span>")

/datum/surgery_step/robotics/face/fix_face
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/wirecutters = 85,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 55)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts pulling the synthskin on [target]'s face back in place with \the [tool].", \
		"You start pulling the synthskin on [target]'s face back in place with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] pulls the synthskin on [target]'s face back in place with \the [tool].</span>",	\
		"<span class='notice'>You pull the synthskin on [target]'s face back in place with \the [tool].</span>")
		target.op_stage.face = 3

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, tearing the synthskin on [target]'s face with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, tearing the synthskin on [target]'s face with \the [tool]!</span>")
		target.apply_damage(10, BRUTE, affected, sharp=1, sharp=1)

/datum/surgery_step/robotics/face/seal_face
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/weapon/flame/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.face > 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] is beginning to seal the incision on [target]'s synthskin face and neck with \the [tool]." , \
		"You are beginning to seal the incision on [target]'s synthskin face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] seals the incision on [target]'s synthskin face and neck with \the [tool].</span>", \
		"<span class='notice'>You seal the incision on [target]'s synthskin face and neck with \the [tool].</span>")
		affected.open = 0
		if (target.op_stage.face == 3)
			var/obj/item/organ/external/head/h = affected
			h.disfigured = 0
		target.op_stage.face = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, leaving a small burn on [target]'s synthskin face with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, leaving a small burn on [target]'s synthskin face with \the [tool]!</span>")
		target.apply_damage(4, BURN, affected)