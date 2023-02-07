//Procedures in this file: Robotic Surgery Steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/robotics
	can_infect = FALSE

/singleton/surgery_step/robotics/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	if(isslime(target))
		return FALSE
	if(target_zone == BP_EYES)	//there are specific steps for eye surgery
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(isnull(affected))
		return FALSE
	if(affected.status & ORGAN_DESTROYED)
		return FALSE
	if(!(BP_IS_ROBOTIC(affected)))
		return FALSE
	return TRUE

/singleton/surgery_step/robotics/unscrew_hatch
	name = "Unscrew Hatch"
	allowed_tools = list(
		SCREWDRIVER = 100,
		/obj/item/coin = 50,
		/obj/item/material/kitchen/utensil/knife = 50
	)

	min_duration = 90
	max_duration = 110

	requires_surgery_compatibility = FALSE

/singleton/surgery_step/robotics/unscrew_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected?.open == ORGAN_CLOSED)
		return TRUE
	return FALSE

/singleton/surgery_step/robotics/unscrew_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You start to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool]."))
	..()

/singleton/surgery_step/robotics/unscrew_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has opened the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You have opened the maintenance hatch on [target]'s [affected.name] with \the [tool]."),)
	affected.open = ORGAN_OPEN_INCISION

/singleton/surgery_step/robotics/unscrew_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to unscrew [target]'s [affected.name]."), \
		SPAN_WARNING("Your [tool] slips, failing to unscrew [target]'s [affected.name]."))

/singleton/surgery_step/robotics/screw_hatch
	name = "Screw Hatch"
	allowed_tools = list(
		SCREWDRIVER = 100,
		/obj/item/coin = 50,
		/obj/item/material/kitchen/utensil/knife = 50
	)

	min_duration = 90
	max_duration = 110

	requires_surgery_compatibility = FALSE

/singleton/surgery_step/robotics/screw_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected?.open == ORGAN_OPEN_INCISION)
		return TRUE
	return FALSE

/singleton/surgery_step/robotics/screw_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts to screw the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You start to screw the maintenance hatch on [target]'s [affected.name] with \the [tool]."))
	..()

/singleton/surgery_step/robotics/screw_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has closed the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You have closed the maintenance hatch on [target]'s [affected.name] with \the [tool]."),)
	affected.open = ORGAN_CLOSED

/singleton/surgery_step/robotics/screw_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to screw [target]'s [affected.name]."), \
		SPAN_WARNING("Your [tool] slips, failing to screw [target]'s [affected.name]."))

/singleton/surgery_step/robotics/open_hatch
	name = "Open Hatch"
	allowed_tools = list(
		/obj/item/surgery/retractor = 100,
		CROWBAR = 100,
		/obj/item/material/kitchen/utensil = 50
	)

	min_duration = 30
	max_duration = 40

/singleton/surgery_step/robotics/open_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected?.open == ORGAN_OPEN_INCISION)
		return TRUE
	return FALSE

/singleton/surgery_step/robotics/open_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].",
		SPAN_NOTICE("You start to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool]."))
	..()

/singleton/surgery_step/robotics/open_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] opens the maintenance hatch on [target]'s [affected.name] with \the [tool]."), \
		SPAN_NOTICE("You open the maintenance hatch on [target]'s [affected.name] with \the [tool]."))
	affected.open = ORGAN_ENCASED_RETRACTED

/singleton/surgery_step/robotics/open_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to open the hatch on [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool] slips, failing to open the hatch on [target]'s [affected.name]."))

/singleton/surgery_step/robotics/close_hatch
	name = "Close Hatch"
	allowed_tools = list(
		/obj/item/surgery/retractor = 100,
		CROWBAR = 100,
		/obj/item/material/kitchen/utensil = 50
	)

	min_duration = 70
	max_duration = 100

/singleton/surgery_step/robotics/close_hatch/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected?.open > ORGAN_OPEN_INCISION)
		return TRUE
	return FALSE

/singleton/surgery_step/robotics/close_hatch/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> begins to close the hatch on [target]'s [affected.name] with \the [tool]." , \
		SPAN_NOTICE("You begin to close the hatch on [target]'s [affected.name] with \the [tool]."))
	..()

/singleton/surgery_step/robotics/close_hatch/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> closes the hatch on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You close the hatch on [target]'s [affected.name] with \the [tool]."))
	affected.open = ORGAN_OPEN_INCISION
	affected.germ_level = 0

/singleton/surgery_step/robotics/close_hatch/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, failing to close the hatch on [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool.name] slips, failing to close the hatch on [target]'s [affected.name]."))

/singleton/surgery_step/robotics/repair_brute
	name = "Repair Damage"
	allowed_tools = list(
		/obj/item/weldingtool = 100,
		/obj/item/gun/energy/plasmacutter = 50
	)

	min_duration = 50
	max_duration = 60

/singleton/surgery_step/robotics/repair_brute/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(tool.iswelder())
		var/obj/item/weldingtool/welder = tool
		if(!welder.isOn() || !welder.use(2,user))
			return FALSE
	return affected && affected.open == ORGAN_ENCASED_RETRACTED && affected.brute_dam > 0 && target_zone != BP_MOUTH

/singleton/surgery_step/robotics/repair_brute/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> begins to patch damage to [target]'s [affected.name]'s support structure with \the [tool]." , \
		SPAN_NOTICE("You begin to patch damage to [target]'s [affected.name]'s support structure with \the [tool]."))
	..()

/singleton/surgery_step/robotics/repair_brute/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(tool.iswelder())
		var/obj/item/weldingtool/welder = tool
		if(!welder.isOn())
			user.visible_message(SPAN_WARNING("[user]'s [tool] shut off before the procedure was finished."), \
			SPAN_WARNING("Your [tool] is shut off!"))
			return
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> finishes patching damage to [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You finish patching damage to [target]'s [affected.name] with \the [tool]."))
	affected.heal_damage(rand(30,50),0,1,1)

/singleton/surgery_step/robotics/repair_brute/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s [tool.name] slips, damaging the internal structure of [target]'s [affected.name]."),
		SPAN_WARNING("Your [tool.name] slips, damaging the internal structure of [target]'s [affected.name]."))
	target.apply_damage(rand(5,10), BURN, affected)

/singleton/surgery_step/robotics/repair_burn
	name = "Repair Burns"
	allowed_tools = list(
		/obj/item/stack/cable_coil = 100,
		/obj/item/stack/cable_coil/cyborg = 100
	)

	min_duration = 50
	max_duration = 60

/singleton/surgery_step/robotics/repair_burn/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/stack/cable_coil/C = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/limb_can_operate = (affected && affected.open == ORGAN_ENCASED_RETRACTED && affected.burn_dam > 0 && target_zone != BP_MOUTH)
	if(limb_can_operate)
		if(istype(C))
			if(!C.get_amount() >= 6)
				to_chat(user, SPAN_DANGER("You need six or more cable pieces to repair this damage."))
				return SURGERY_FAILURE
			C.use(3)
		return TRUE
	return FALSE

/singleton/surgery_step/robotics/repair_burn/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> begins to splice new cabling into [target]'s [affected.name]." , \
		SPAN_NOTICE("You begin to splice new cabling into [target]'s [affected.name]."))
	..()

/singleton/surgery_step/robotics/repair_burn/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> finishes splicing cable into [target]'s [affected.name]", \
		SPAN_NOTICE("You finishes splicing new cable into [target]'s [affected.name]."))
	affected.heal_damage(0,rand(30,50),1,1)

/singleton/surgery_step/robotics/repair_burn/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user] causes a short circuit in [target]'s [affected.name]!"),
		SPAN_WARNING("You cause a short circuit in [target]'s [affected.name]!"))
	target.apply_damage(rand(5,10), BURN, affected)

/singleton/surgery_step/robotics/detach_organ_robotic
	name = "Detach Robotic Organ"
	allowed_tools = list(
	/obj/item/device/multitool = 100
	)

	min_duration = 90
	max_duration = 110

/singleton/surgery_step/robotics/detach_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.open != ORGAN_ENCASED_RETRACTED)
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

/singleton/surgery_step/robotics/detach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> starts to decouple [target]'s [target.op_stage.current_organ] with \the [tool].", \
		SPAN_NOTICE("You start to decouple [target]'s [target.op_stage.current_organ] with \the [tool]." ))
	..()

/singleton/surgery_step/robotics/detach_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has decoupled [target]'s [target.op_stage.current_organ] with \the [tool]." , \
		SPAN_NOTICE("You have decoupled [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status |= ORGAN_CUT_AWAY

/singleton/surgery_step/robotics/detach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, disconnecting \the [tool]."), \
	SPAN_WARNING("Your hand slips, disconnecting \the [tool]."))

/singleton/surgery_step/robotics/attach_organ_robotic
	name = "Attach Robotic Organ"
	allowed_tools = list(
		SCREWDRIVER = 100
	)

	min_duration = 100
	max_duration = 120

	requires_surgery_compatibility = FALSE

/singleton/surgery_step/robotics/attach_organ_robotic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.open != ORGAN_ENCASED_RETRACTED)
		return FALSE

	target.op_stage.current_organ = null

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/I = target.internal_organs_by_name[organ]
		if(I && (I.status & ORGAN_CUT_AWAY) && (I.status & ORGAN_ROBOT) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
	if(!organ_to_replace)
		return FALSE

	target.op_stage.current_organ = organ_to_replace
	return TRUE

/singleton/surgery_step/robotics/attach_organ_robotic/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
		SPAN_NOTICE("You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool]."))
	..()

/singleton/surgery_step/robotics/attach_organ_robotic/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> has reattached [target]'s [target.op_stage.current_organ] with \the [tool]." , \
		SPAN_NOTICE("You have reattached [target]'s [target.op_stage.current_organ] with \the [tool]."))

	var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
	if(I && istype(I))
		I.status &= ~ORGAN_CUT_AWAY

/singleton/surgery_step/robotics/attach_organ_robotic/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, disconnecting \the [tool]."), \
		SPAN_WARNING("Your hand slips, disconnecting \the [tool]."))

/singleton/surgery_step/robotics/install_mmi
	name = "Install MMI"
	allowed_tools = list(
	/obj/item/device/mmi = 100
	)

	min_duration = 60
	max_duration = 80

/singleton/surgery_step/robotics/install_mmi/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(target_zone != BP_HEAD)
		return FALSE

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected && affected.open == ORGAN_ENCASED_RETRACTED))
		return FALSE

	if(!istype(M))
		return FALSE

	if(!M.brainmob || !M.brainmob.client || !M.brainmob.ckey || M.brainmob.stat >= DEAD)
		to_chat(user, SPAN_DANGER("That brain is not usable."))
		return SURGERY_FAILURE

	if(!BP_IS_ROBOTIC(affected))
		to_chat(user, SPAN_DANGER("You cannot install a computer brain into a meat skull."))
		return SURGERY_FAILURE

	if(!target.isSynthetic())
		to_chat(user, SPAN_DANGER("You cannot install a computer brain into an organic body."))
		return SURGERY_FAILURE

	if(!target.species)
		to_chat(user, SPAN_DANGER("You have no idea what species this person is. Report this on the bug tracker."))
		return SURGERY_FAILURE

	if(!target.species.has_organ[BP_BRAIN])
		to_chat(user, SPAN_DANGER("You're pretty sure [target.species.name_plural] don't normally have a brain."))
		return SURGERY_FAILURE

	if(!isnull(target.internal_organs[BP_BRAIN]))
		to_chat(user, SPAN_DANGER("Your subject already has a brain."))
		return SURGERY_FAILURE

	return TRUE

/singleton/surgery_step/robotics/install_mmi/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts installing \the [tool] into [target]'s [affected.name].", \
		SPAN_NOTICE("You start installing \the [tool] into [target]'s [affected.name]."))
	..()

/singleton/surgery_step/robotics/install_mmi/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has installed \the [tool] into [target]'s [affected.name].", \
		SPAN_NOTICE("You have installed \the [tool] into [target]'s [affected.name]."))

	var/obj/item/device/mmi/M = tool
	var/obj/item/organ/internal/mmi_holder/holder = new(target, 1)
	target.internal_organs_by_name[BP_BRAIN] = holder
	user.drop_from_inventory(tool,holder)
	holder.stored_mmi = tool
	holder.update_from_mmi()

	if(M.brainmob && M.brainmob.mind)
		M.brainmob.mind.transfer_to(target)

/singleton/surgery_step/robotics/install_mmi/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips."), \
		SPAN_WARNING("Your hand slips."))
