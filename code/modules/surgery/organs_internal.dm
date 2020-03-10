// Internal surgeries.
/datum/surgery_step/internal
	priority = 2
	can_infect = 1
	blood_level = 1

/datum/surgery_step/internal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == (affected.encased ? 3 : 2)

//////////////////////////////////////////////////////////////////
//				CHEST INTERNAL ORGAN SURGERY					//
//////////////////////////////////////////////////////////////////
/datum/surgery_step/internal/fix_organ
	allowed_tools = list(
	/obj/item/stack/medical/advanced/bruise_pack= 100,		\
	/obj/item/stack/medical/bruise_pack = 20
	)

	min_duration = 70
	max_duration = 90

/datum/surgery_step/internal/fix_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return
	var/is_organ_damaged = 0
	for(var/obj/item/organ/I in affected.internal_organs)
		if(I.damage > 0)
			is_organ_damaged = 1
			break
	return ..() && is_organ_damaged

/datum/surgery_step/internal/fix_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return

	var/tool_name = "\the [tool]"
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	else if(istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_ROBOTIC(I))
			user.visible_message("[user] starts treating damage to [target]'s [I.name] with [tool_name].", \
			"You start treating damage to [target]'s [I.name] with [tool_name]." )

	target.custom_pain("The pain in your [affected.name] is living hell!", 75)
	..()

/datum/surgery_step/internal/fix_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/tool_name = "\the [tool]"
	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		tool_name = "regenerative membrane"
	if(istype(tool, /obj/item/stack/medical/bruise_pack))
		tool_name = "the bandaid"

	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && I.damage > 0 && !BP_IS_ROBOTIC(I))
			user.visible_message("<span class='notice'>[user] treats damage to [target]'s [I.name] with [tool_name].</span>", \
				"<span class='notice'>You treat damage to [target]'s [I.name] with [tool_name].</span>" )
			I.surgical_fix(user)
			var/obj/item/organ/internal/brain/sponge = target.internal_organs_by_name[BP_BRAIN]
			if(sponge && istype(I, sponge))
				target.cure_all_traumas(cure_type = CURE_SURGERY)

/datum/surgery_step/internal/fix_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("<span class='warning'>[user]'s hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, getting mess and tearing the inside of [target]'s [affected.name] with \the [tool]!</span>")
	var/dam_amt = 2

	if(istype(tool, /obj/item/stack/medical/advanced/bruise_pack))
		target.adjustToxLoss(5)

	else if(istype(tool, /obj/item/stack/medical/bruise_pack))
		dam_amt = 5
		target.adjustToxLoss(10)
		target.apply_damage(5, BRUTE, target_zone, 0, tool)

	for(var/obj/item/organ/I in affected.internal_organs)
		if(I && I.damage > 0)
			I.take_damage(dam_amt,0)

/datum/surgery_step/internal/detach_organ
	priority = 1
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/internal/detach_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if(!(affected && !(affected.status & ORGAN_ROBOT)))
		return 0

	target.op_stage.current_organ = null

	var/list/attached_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && !(I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			attached_organs |= organ

	var/organ_to_remove = input(user, "Which organ do you want to prepare for removal?") as null|anything in attached_organs
	if(!organ_to_remove)
		return 0

	target.op_stage.current_organ = organ_to_remove

	return ..() && organ_to_remove

/datum/surgery_step/internal/detach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	user.visible_message("[user] starts to separate [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start to separate [target]'s [target.op_stage.current_organ] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!", 75)
	..()

/datum/surgery_step/internal/detach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has separated [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
		"<span class='notice'>You have separated [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status |= ORGAN_CUT_AWAY

/datum/surgery_step/internal/detach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>")
	affected.sever_artery()
	target.apply_damage(rand(30, 50), BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/internal/remove_organ
	allowed_tools = list(
	/obj/item/surgery/hemostat = 100,	\
	/obj/item/wirecutters = 75,	\
	/obj/item/material/kitchen/utensil/fork = 20
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/internal/remove_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return 0

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if((I.status & ORGAN_CUT_AWAY) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_remove = input(user, "Which organ do you want to remove?") as null|anything in removable_organs
	if(!organ_to_remove)
		return 0

	target.op_stage.current_organ = organ_to_remove
	return ..()

/datum/surgery_step/internal/remove_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts removing [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start removing [target]'s [target.op_stage.current_organ] with \the [tool].")
	target.custom_pain("Someone's ripping out your [target.op_stage.current_organ]!", 75)
	..()

/datum/surgery_step/internal/remove_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has removed [target]'s [target.op_stage.current_organ] with \the [tool].</span>", \
		"<span class='notice'>You have removed [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

	// Extract the organ!
	if(target.op_stage.current_organ)
		var/obj/item/organ/O = target.internal_organs_by_name[target.op_stage.current_organ]
		if(O && istype(O))
			O.removed(user)
		target.op_stage.current_organ = null
		if(!(O.status & ORGAN_ROBOT))
			playsound(target.loc, 'sound/effects/squelch1.ogg', 15, 1)
		else
			playsound(target.loc, 'sound/items/Ratchet.ogg', 50, 1)

/datum/surgery_step/internal/remove_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	target.apply_damage(20, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/internal/replace_organ
	allowed_tools = list(
	/obj/item/organ = 100
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/internal/replace_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/O = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if(!affected)
		return

	var/organ_compatible
	var/organ_missing

	if(!istype(O))
		return 0

	if((affected.status & ORGAN_ROBOT) && !(O.status & ORGAN_ROBOT))
		to_chat(user, "<span class='danger'>You cannot install a naked organ into a robotic body.</span>")
		return SURGERY_FAILURE

	if(!target.species)
		to_chat(user, "<span class='danger'>You have no idea what species this person is. Report this on the bug tracker.</span>")
		return SURGERY_FAILURE

	var/o_is = (O.gender == PLURAL) ? "are" : "is"
	var/o_a =  (O.gender == PLURAL) ? "" : "a "
	var/o_do = (O.gender == PLURAL) ? "don't" : "doesn't"

	if(O.organ_tag == "limb")
		return 0
	else if(target.species.has_organ[O.organ_tag])

		if(O.damage > (O.max_damage * 0.75))
			to_chat(user, "<span class='warning'>\The [O.organ_tag] [o_is] in no state to be transplanted.</span>")
			return SURGERY_FAILURE

		if(!target.internal_organs_by_name[O.organ_tag])
			organ_missing = 1
		else
			to_chat(user, "<span class='warning'>\The [target] already has [o_a][O.organ_tag].</span>")
			return SURGERY_FAILURE

		if(O && affected.limb_name == O.parent_organ)
			organ_compatible = 1
		else
			to_chat(user, "<span class='warning'>\The [O.organ_tag] [o_do] normally go in \the [affected.name].</span>")
			return SURGERY_FAILURE
	else
		to_chat(user, "<span class='warning'>You're pretty sure [target.species.name_plural] don't normally have [o_a][O.organ_tag].</span>")
		return SURGERY_FAILURE

	return ..() && organ_missing && organ_compatible

/datum/surgery_step/internal/replace_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts transplanting \the [tool] into [target]'s [affected.name].", \
		"You start transplanting \the [tool] into [target]'s [affected.name].")
	target.custom_pain("Someone's rooting around in your [affected.name]!", 75)
	..()

/datum/surgery_step/internal/replace_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has transplanted \the [tool] into [target]'s [affected.name].</span>", \
		"<span class='notice'>You have transplanted \the [tool] into [target]'s [affected.name].</span>")
	var/obj/item/organ/O = tool
	if(istype(O) && user.unEquip(O))
		O.replaced(target,affected)
		playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)

/datum/surgery_step/internal/replace_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, damaging \the [tool]!</span>")
	var/obj/item/organ/I = tool
	if(istype(I))
		I.take_damage(rand(3,5),0)

/datum/surgery_step/internal/attach_organ
	allowed_tools = list(
	/obj/item/surgery/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)

	min_duration = 100
	max_duration = 120

/datum/surgery_step/internal/attach_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return 0

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && (I.status & ORGAN_CUT_AWAY) && !(I.status & ORGAN_ROBOT) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(!organ_to_replace)
		return 0

	target.op_stage.current_organ = organ_to_replace
	return ..()

/datum/surgery_step/internal/attach_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool].")
	target.custom_pain("Someone's digging needles into your [target.op_stage.current_organ]!", 75)
	..()

/datum/surgery_step/internal/attach_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
		"<span class='notice'>You have reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status &= ~ORGAN_CUT_AWAY

/datum/surgery_step/internal/attach_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>")
	target.apply_damage(20, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/internal/lobotomize
	allowed_tools = list(
	/obj/item/surgery/scalpel/manager = 95,
	/obj/item/surgery/surgicaldrill = 75,
	/obj/item/pickaxe/ = 5
	)

	min_duration = 100
	max_duration = 120

/datum/surgery_step/internal/lobotomize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/organ/internal/brain/sponge = target.internal_organs_by_name[BP_BRAIN]
	if(!affected || !istype(sponge) || !(sponge in affected.internal_organs))
		return 0

	if(!sponge.can_lobotomize || sponge.lobotomized)
		return 0

	target.op_stage.current_organ = sponge
	return ..()

/datum/surgery_step/internal/lobotomize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/brain/B = target.op_stage.current_organ
	user.visible_message("[user] begins to modify [target]'s [B] to remove their memory recall with \the [tool].", \
		"You start to modify [target]'s [B] to remove their memory recall with \the [tool].")
	target.custom_pain("Someone's scraping away at your [B]!", 75)
	..()

/datum/surgery_step/internal/lobotomize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/internal/brain/B = target.op_stage.current_organ
	user.visible_message("<span class='notice'>[user] has modified [target]'s [B] to remove their memory recall with \the [tool].</span>" , \
		"<span class='notice'>You have removed [target]'s memory recall with \the [tool].</span>")
	B.lobotomize(user)

/datum/surgery_step/internal/lobotomize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, damaging the flesh in [target]'s [affected.name] with \the [tool]!</span>")
	target.apply_damage(20, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)
