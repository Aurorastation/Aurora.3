// Internal surgeries.
/decl/surgery_step/internal
	priority = 2
	can_infect = TRUE
	blood_level = 1

/decl/surgery_step/internal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.encased)
		return affected && IS_ORGAN_FULLY_OPEN
	if(BP_IS_ROBOTIC(affected))
		return affected.augment_limit && affected.open == ORGAN_ENCASED_RETRACTED
	else
		return affected.augment_limit && affected.open == ORGAN_OPEN_RETRACTED

//////////////////////////////////////////////////////////////////
//				CHEST INTERNAL ORGAN SURGERY					//
//////////////////////////////////////////////////////////////////
/decl/surgery_step/internal/fix_organ
	name = "Repair Internal Organs"
	allowed_tools = list(
	/obj/item/stack/medical/advanced/bruise_pack= 100,		\
	/obj/item/stack/medical/bruise_pack = 20
	)

	min_duration = 70
	max_duration = 90

/decl/surgery_step/internal/fix_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/is_organ_damaged = FALSE
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I.is_damaged())
			is_organ_damaged = TRUE
			break
	return is_organ_damaged

/decl/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/tool_name = "\the [tool]"
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if(istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "some bandaids"
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.is_damaged() && !BP_IS_ROBOTIC(I) && (~I.status & ORGAN_DEAD || I.can_recover()))
			user.visible_message("[user] starts treating damage to [target]'s [I.name] with [tool_name].", \
			"You start treating damage to [target]'s [I.name] with [tool_name]." )
	target.custom_pain("The pain in your [affected.name] is living hell!",100, affecting = affected)

	..()

/decl/surgery_step/internal/fix_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	if(istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "some bandaids"

	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.is_damaged() && !BP_IS_ROBOTIC(I))
			if(I.status & ORGAN_DEAD && I.can_recover())
				user.visible_message("<span class='notice'>\The [user] treats damage to [target]'s [I.name] with [tool_name], though it needs to be recovered further.</span>", \
				"<span class='notice'>You treat damage to [target]'s [I.name] with [tool_name], though it needs to be recovered further.</span>" )
			else
				user.visible_message("<span class='notice'>[user] treats damage to [target]'s [I.name] with [tool_name].</span>", \
				"<span class='notice'>You treat damage to [target]'s [I.name] with [tool_name].</span>")
			I.surgical_fix(user)
			user.visible_message("\The [user] finishes treating damage within \the [target]'s [affected.name] with [tool_name].", \
			"You finish treating damage within \the [target]'s [affected.name] with [tool_name].")
			if(I.status & ORGAN_DEAD)
				to_chat(user, SPAN_DANGER("This organ is still dead! You must remove the dead tissue with a scalpel!"))

/decl/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!"))
	var/dam_amt = 2

	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		target.adjustToxLoss(5)

	else if(istype(tool, /obj/item/stack/medical/bruise_pack))
		dam_amt = 5
		target.adjustToxLoss(10)
		target.apply_damage(5, BRUTE, target_zone, 0, tool)

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.is_damaged())
			I.take_damage(dam_amt,0)

/decl/surgery_step/internal/fix_organ_robotic //For artificial organs
	name = "Repair Robotic Organ"
	allowed_tools = list(
	/obj/item/stack/nanopaste = 100,
	/obj/item/surgery/bone_gel = 30,
	SCREWDRIVER = 70
	)

	min_duration = 70
	max_duration = 90

/decl/surgery_step/internal/fix_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/is_organ_damaged = 0
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I.is_damaged() && I.robotic >= 2)
			is_organ_damaged = TRUE
			break
	return is_organ_damaged && IS_ORGAN_FULLY_OPEN

/decl/surgery_step/internal/fix_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.is_damaged())
			if(I.robotic >= 2)
				user.visible_message("<b>[user]</b> starts mending the damage to [target]'s [I.name]'s mechanisms.", \
					SPAN_NOTICE("You start mending the damage to [target]'s [I.name]'s mechanisms." ))

	target.custom_pain("The pain in your [affected.name] is living hell!", 75)
	..()

/decl/surgery_step/internal/fix_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.is_damaged())
			if(I.robotic >= 2)
				user.visible_message("<b>[user]</b> repairs [target]'s [I.name] with [tool].", \
					SPAN_NOTICE("You repair [target]'s [I.name] with [tool].") )
				I.surgical_fix(user)
				if(istype(tool, /obj/item/stack/nanopaste))
					var/obj/item/stack/nanopaste/nanopaste = tool
					nanopaste.use(1)
					return

/decl/surgery_step/internal/fix_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!"))

	target.adjustToxLoss(5)
	target.apply_damage(5, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I)
			I.take_damage(rand(3,5),0)


/decl/surgery_step/internal/detach_organ
	name = "Separate Organ"
	priority = 1
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

/decl/surgery_step/internal/detach_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if(!(affected && !BP_IS_ROBOTIC(affected)))
		return FALSE

	target.op_stage.current_organ = null

	var/list/attached_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			attached_organs |= organ

	var/organ_to_remove = input(user, "Which organ do you want to prepare for removal?") as null|anything in attached_organs
	if(!organ_to_remove)
		return FALSE

	target.op_stage.current_organ = organ_to_remove

	return organ_to_remove

/decl/surgery_step/internal/detach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<b>[user]</b> starts to separate [target]'s [target.op_stage.current_organ] with \the [tool].", \
		SPAN_NOTICE("You start to separate [target]'s [target.op_stage.current_organ] with \the [tool]." ))
	target.custom_pain("The pain in your [affected.name] is living hell!", 75)
	..()

/decl/surgery_step/internal/detach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has separated [target]'s [target.op_stage.current_organ] with \the [tool]." , \
		SPAN_NOTICE("You have separated [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status |= ORGAN_CUT_AWAY

	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

/decl/surgery_step/internal/detach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"))
	affected.sever_artery()
	target.apply_damage(rand(30, 50), BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/decl/surgery_step/internal/remove_organ
	name = "Remove Organ"
	allowed_tools = list(
	/obj/item/surgery/hemostat = 100,	\
	WIRECUTTER = 75,	\
	/obj/item/material/kitchen/utensil/fork = 20
	)

	min_duration = 60
	max_duration = 80

/decl/surgery_step/internal/remove_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if((I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_remove = input(user, "Which organ do you want to remove?") as null|anything in removable_organs
	if(!organ_to_remove)
		return FALSE

	target.op_stage.current_organ = organ_to_remove
	return ..()

/decl/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts removing [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start removing [target]'s [target.op_stage.current_organ] with \the [tool].")
	target.custom_pain("Someone's ripping out your [target.op_stage.current_organ]!", 75)
	..()

/decl/surgery_step/internal/remove_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has removed [target]'s [target.op_stage.current_organ] with \the [tool]."), \
		SPAN_NOTICE("You have removed [target]'s [target.op_stage.current_organ] with \the [tool]."))

	// Extract the organ!
	if(target.op_stage.current_organ)
		var/obj/item/organ/O = target.internal_organs_by_name[target.op_stage.current_organ]
		if(O && istype(O))
			O.removed(target, user)
		target.op_stage.current_organ = null
		if(!(O.status & ORGAN_ROBOT))
			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)
		else
			playsound(target.loc, 'sound/items/wrench.ogg', 50, 1)

		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

/decl/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, damaging [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(20, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/decl/surgery_step/internal/replace_organ
	name = "Replace Organ"
	allowed_tools = list(
	/obj/item/organ = 100
	)

	min_duration = 60
	max_duration = 80

/decl/surgery_step/internal/replace_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		testing("Attempting to install [tool] failed with parent check!")
		return FALSE

	var/obj/item/organ/O = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/organ_compatible
	var/organ_missing

	if(!istype(O))
		return FALSE

	if(BP_IS_ROBOTIC(affected) && !BP_IS_ROBOTIC(O))
		to_chat(user, SPAN_DANGER("You cannot install a naked organ into a robotic body."))
		return SURGERY_FAILURE

	if(!target.species)
		to_chat(user, SPAN_DANGER("You have no idea what species this person is. Report this on the bug tracker."))
		return SURGERY_FAILURE

	var/o_is = (O.gender == PLURAL) ? "are" : "is"
	var/o_a =  (O.gender == PLURAL) ? "" : "a "
	var/o_do = (O.gender == PLURAL) ? "don't" : "doesn't"

	if(O.organ_tag == "limb")
		return FALSE
	else if(target.species.has_organ[O.organ_tag] || O.is_augment)

		if(O.damage > (O.max_damage * 0.75))
			to_chat(user, SPAN_WARNING("\The [O.organ_tag] [o_is] in no state to be transplanted."))
			return SURGERY_FAILURE

		if(O.species_restricted)
			if(!(target.species.name in O.species_restricted))
				to_chat(user, SPAN_WARNING("\The [O] is not compatible with \the [target]'s biology."))
				return SURGERY_FAILURE

		if(O.is_augment)
			if(affected.augment_limit)
				var/total_augments
				for(var/obj/item/organ/internal/I in affected.internal_organs)
					if(I.is_augment)
						total_augments += 1
					if(total_augments >= affected.augment_limit)
						to_chat(user, SPAN_WARNING("There is no space left in \the [affected] to implant \the [O]."))
						return SURGERY_FAILURE
			else
				to_chat(user, SPAN_WARNING("There is no space in \the [affected] to implant \the [O]."))
				return SURGERY_FAILURE

		if(!target.internal_organs_by_name[O.organ_tag])
			organ_missing = TRUE
		else
			to_chat(user, SPAN_WARNING("\The [target] already has [o_a][O.organ_tag]."))
			return SURGERY_FAILURE

		if(O && affected.limb_name == O.parent_organ)
			organ_compatible = TRUE
		else
			to_chat(user, SPAN_WARNING("\The [O.organ_tag] [o_do] normally go in \the [affected.name]."))
			return SURGERY_FAILURE
	else
		to_chat(user, SPAN_WARNING("You're pretty sure [target.species.name_plural] don't normally have [o_a][O.organ_tag]."))
		return SURGERY_FAILURE

	return organ_missing && organ_compatible

/decl/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts transplanting \the [tool] into [target]'s [affected.name].", \
		"You start transplanting \the [tool] into [target]'s [affected.name].")
	target.custom_pain("Someone's rooting around in your [affected.name]!", 75)
	..()

/decl/surgery_step/internal/replace_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has transplanted \the [tool] into [target]'s [affected.name]."), \
		SPAN_NOTICE("You have transplanted \the [tool] into [target]'s [affected.name]."))
	var/obj/item/organ/O = tool
	if(istype(O) && user.unEquip(O))
		O.replaced(target,affected)
		playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)

		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

/decl/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging \the [tool]!"), \
		SPAN_WARNING("Your hand slips, damaging \the [tool]!"))
	var/obj/item/organ/I = tool
	if(istype(I))
		I.take_damage(rand(3,5),0)

/decl/surgery_step/internal/attach_organ
	name = "Attach Organ"
	allowed_tools = list(
	/obj/item/surgery/fix_o_vein = 100, \
	/obj/item/stack/cable_coil = 75
	)

	min_duration = 100
	max_duration = 120

/decl/surgery_step/internal/attach_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && (I.status & ORGAN_CUT_AWAY) && !BP_IS_ROBOTIC(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(!organ_to_replace)
		return FALSE

	target.op_stage.current_organ = organ_to_replace
	return TRUE

/decl/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool].")
	target.custom_pain("Someone's digging needles into your [target.op_stage.current_organ]!", 75)
	..()

/decl/surgery_step/internal/attach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] has reattached [target]'s [target.op_stage.current_organ] with \the [tool].") , \
		SPAN_NOTICE("You have reattached [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status &= ~ORGAN_CUT_AWAY

		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

/decl/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(20, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/decl/surgery_step/internal/prepare
	name = "Prepare Brain"
	allowed_tools = list(
	/obj/item/surgery/scalpel/manager = 95,
	/obj/item/surgery/surgicaldrill = 75,
	/obj/item/pickaxe/ = 5
	)

	min_duration = 100
	max_duration = 120

/decl/surgery_step/internal/prepare/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/organ/internal/brain/sponge = target.internal_organs_by_name[BP_BRAIN]
	if(!istype(sponge) || !(sponge in affected.internal_organs))
		return FALSE

	if(!sponge.can_prepare || sponge.prepared)
		return FALSE

	target.op_stage.current_organ = sponge
	return TRUE

/decl/surgery_step/internal/prepare/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/brain/B = target.op_stage.current_organ
	user.visible_message("[user] begins to modify [target]'s [B] to prepare it for Man-Machine-Interface compatibility with \the [tool].", \
		"You start to modify [target]'s [B] to prepare it for Man-Machine-Interface compatibility with \the [tool].")
	target.custom_pain("Someone's scraping away at your [B]!", 75)
	..()

/decl/surgery_step/internal/prepare/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/brain/B = target.op_stage.current_organ
	user.visible_message(SPAN_NOTICE("[user] has modified [target]'s [B] to prepare it for Man-Machine-Interface compatibility with \the [tool].") , \
		SPAN_NOTICE("You prepare \the [target]'s brain for Man-Machine-Interface compatibility with \the [tool]."))
	B.prepared = TRUE

/decl/surgery_step/internal/prepare/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(20, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
