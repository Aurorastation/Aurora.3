
//////////////////////////////////////////////////////////////////
//						MEDIBOTS DREAM COME TRUE!                //
//                       Plastic Surgery                         //
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



/datum/surgery_step/generic/prepare_face
	allowed_tools = list(
	/obj/item/weapon/retractor = 100,
	/obj/item/weapon/material/hatchet/tacknife = 75
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target_zone == "mouth" && target.op_stage.face == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to retract [target]'s face with \the [tool].", \
		"You start to retract [target]'s face with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has retracted [target]'s face with \the [tool] for his facial alteration.</span>" , \
		"<span class='notice'>You have retracted [target]'s face and neck with \the [tool] for plastic surgery.</span>",)
		target.op_stage.face = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
		affected.createwound(CUT, 60)
		target.losebreath += 10


/datum/surgery_step/generic/alter_face
	allowed_tools = list(
	/obj/item/stack/medical/advanced/bruise_pack = 100,
	/obj/item/weapon/material/hatchet/tacknife = 75
	)

	min_duration = 40
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target_zone == "mouth" && target.op_stage.face == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to alter [target]'s face with \the [tool].", \
		"You start to alter [target]'s face and neck with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/head/head = target.get_organ(target_zone)
		if(head.disfigured)
			head.disfigured = FALSE
			user.visible_message("[user] successfully restores [target]'s appearance!", "<span class='notice'>Closing the incision with the included suture kit, you successfully restore [target]'s appearance.</span>")

		var/getName = sanitize(input(user, "What is your patient's new identity?", "Name change") as null|text, MAX_NAME_LEN)
		if(getName)
			target.real_name = getName
			target.name = getName
			target.dna.real_name = getName
			if(target.mind)
				target.mind.name = target.name
			target.change_appearance(APPEARANCE_PLASTICSURGERY, usr, usr, check_species_whitelist = 1, state = z_state)
			target.op_stage.face = 0


	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
		affected.createwound(CUT, 60)
		target.losebreath += 10
