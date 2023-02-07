//Procedures in this file: Robotic limbs attachment, meat limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/limb
	priority = 3 // Must be higher than /singleton/surgery_step/internal
	can_infect = FALSE

/singleton/surgery_step/limb/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected)
		return FALSE
	var/list/organ_data = target.species.has_limbs["[target_zone]"]
	var/obj/item/organ/external/E = tool
	if(E?.parent_organ)
		var/obj/item/organ/external/P = target.organs_by_name[E.parent_organ]
		if(!P || P.is_stump() || !P.supports_children || (BP_IS_ROBOTIC(P) && !BP_IS_ROBOTIC(E)))
			return FALSE // Parent organ non-existant or unsuitable
	return !isnull(organ_data)

/singleton/surgery_step/limb/attach
	name = "Replace Limb"
	allowed_tools = list(/obj/item/organ/external = 100)

	min_duration = 50
	max_duration = 70

/singleton/surgery_step/limb/attach/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("<b>[user]</b> starts attaching [E.name] to [target]'s [E.amputation_point].", \
		SPAN_NOTICE("You start attaching [E.name] to [target]'s [E.amputation_point]."))

/singleton/surgery_step/limb/attach/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message("<b>[user]</b> attaches [target]'s [E.name] to the [E.amputation_point].",	\
		SPAN_NOTICE("You have attached [target]'s [E.name] to the [E.amputation_point]."))
	user.drop_from_inventory(E)
	E.replaced(target)
	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

/singleton/surgery_step/limb/attach/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s [E.amputation_point]!"), \
		SPAN_WARNING("Your hand slips, damaging [target]'s [E.amputation_point]!"))
	target.apply_damage(10, BRUTE, null, damage_flags = DAM_EDGE)

/singleton/surgery_step/limb/connect
	name = "Connect Limb"
	allowed_tools = list(
	/obj/item/surgery/hemostat = 100,	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 20
	)
	can_infect = TRUE

	min_duration = 100
	max_duration = 120

/singleton/surgery_step/limb/connect/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/E = target.get_organ(target_zone)
	return E && !E.is_stump() && (E.status & ORGAN_DESTROYED)

/singleton/surgery_step/limb/connect/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("[user] starts connecting tendons and muscles in [target]'s [E.amputation_point] with [tool].", \
		"You start connecting tendons and muscle in [target]'s [E.amputation_point].")

/singleton/surgery_step/limb/connect/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has connected tendons and muscles in [target]'s [E.amputation_point] with [tool].",	\
		SPAN_NOTICE("You have connected tendons and muscles in [target]'s [E.amputation_point] with [tool]."))
	E.status &= ~ORGAN_DESTROYED
	if(E.children)
		for(var/obj/item/organ/external/C in E.children)
			C.status &= ~ORGAN_DESTROYED
	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

/singleton/surgery_step/limb/connect/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/E = tool
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s [E.amputation_point]!"), \
		SPAN_WARNING("Your hand slips, damaging [target]'s [E.amputation_point]!"))
	target.apply_damage(10, BRUTE, null, damage_flags = DAM_SHARP)

/singleton/surgery_step/limb/mechanize
	name = "Attach Prosthetic Limb"
	allowed_tools = list(/obj/item/robot_parts = 100)

	min_duration = 80
	max_duration = 100

/singleton/surgery_step/limb/mechanize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/robot_parts/p = tool
	if(p.part)
		if(!(target_zone in p.part))
			return FALSE
	return isnull(target.get_organ(target_zone))

/singleton/surgery_step/limb/mechanize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<b>[user]</b> starts attaching \the [tool] to [target].", \
		SPAN_NOTICE("You start attaching \the [tool] to [target]."))

/singleton/surgery_step/limb/mechanize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/robot_parts/L = tool
	user.visible_message("<b>[user]</b> has attached \the [tool] to [target].",	\
		SPAN_NOTICE("You have attached \the [tool] to [target]."))

	if(L.part)
		for(var/part_name in L.part)
			if(!isnull(target.get_organ(part_name)))
				continue
			var/list/organ_data = target.species.has_limbs["[part_name]"]
			if(!organ_data)
				continue
			var/new_limb_type = organ_data["path"]
			var/obj/item/organ/external/new_limb = new new_limb_type(target)
			new_limb.robotize(L.model_info)
			if(L.sabotaged)
				new_limb.sabotaged = 1

	target.update_body()
	target.updatehealth()
	target.UpdateDamageIcon()

	qdel(tool)

/singleton/surgery_step/limb/mechanize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, damaging [target]'s flesh!"), \
		SPAN_WARNING("Your hand slips, damaging [target]'s flesh!"))
	target.apply_damage(10, BRUTE, null, damage_flags = DAM_SHARP)