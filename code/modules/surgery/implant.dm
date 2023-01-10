//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/cavity
	priority = 1

/singleton/surgery_step/cavity/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && IS_ORGAN_FULLY_OPEN && !(affected.status & ORGAN_BLEEDING)

/singleton/surgery_step/cavity/proc/get_max_wclass(var/obj/item/organ/external/affected)
	switch(affected.name)
		if(BP_HEAD)
			return ITEMSIZE_TINY
		if("upper body")
			return ITEMSIZE_NORMAL
		if("lower body")
			return ITEMSIZE_SMALL
	return 0

/singleton/surgery_step/cavity/proc/get_cavity(var/obj/item/organ/external/affected)
	switch(affected.name)
		if(BP_HEAD)
			return "cranial"
		if("upper body")
			return "thoracic"
		if("lower body")
			return "abdominal"
	return ""

/singleton/surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(20, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/singleton/surgery_step/cavity/make_space
	name = "Hollow Out Cavity"
	allowed_tools = list(
	/obj/item/surgery/surgicaldrill = 100,	\
	/obj/item/pen = 75,	\
	/obj/item/stack/rods = 50
	)

	min_duration = 60
	max_duration = 80

/singleton/surgery_step/cavity/make_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && !affected.cavity

/singleton/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].", \
		"You start making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = CAVITY_OPEN
	playsound(target.loc, 'sound/effects/squelch1.ogg', 25, 1)
	..()

/singleton/surgery_step/cavity/make_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> pushes apart some organs inside [target]'s [get_cavity(affected)] cavity with \the [tool].", \
		SPAN_NOTICE("You make some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].") )

/singleton/surgery_step/cavity/close_space
	name = "Close Cavity"
	priority = 2
	allowed_tools = list(
	/obj/item/surgery/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 80

/singleton/surgery_step/cavity/close_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.cavity

/singleton/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts mending [target]'s [get_cavity(affected)] cavity wall with \the [tool].", \
		"You start mending [target]'s [get_cavity(affected)] cavity wall with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!", 75)
	affected.cavity = CAVITY_CLOSED
	..()

/singleton/surgery_step/cavity/close_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> mends [target]'s [get_cavity(affected)] cavity walls with \the [tool].", \
		SPAN_NOTICE("You mend [target]'s [get_cavity(affected)] cavity walls with \the [tool].") )

/singleton/surgery_step/cavity/place_item
	name = "Place Item in Cavity"
	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

/singleton/surgery_step/cavity/place_item/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(user,/mob/living/silicon/robot))
		return
	if(affected && affected.cavity)
		var/total_volume = tool.w_class
		for(var/obj/item/I in affected.implants)
			if(istype(I,/obj/item/implant))
				continue
			total_volume += I.w_class
		return total_volume <= get_max_wclass(affected)

/singleton/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts putting \the [tool] inside [target]'s [get_cavity(affected)] cavity.", \
		SPAN_NOTICE("You start putting \the [tool] inside [target]'s [get_cavity(affected)] cavity." ))
	target.custom_pain("The pain in your chest is living hell!", 75)
	playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)
	..()

/singleton/surgery_step/cavity/place_item/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	user.visible_message("<b>[user]</b> puts \the [tool] inside [target]'s [get_cavity(affected)] cavity.", \
		SPAN_NOTICE("You put \the [tool] inside [target]'s [get_cavity(affected)] cavity.") )
	if(tool.w_class > get_max_wclass(affected)/2 && prob(50) && !BP_IS_ROBOTIC(affected))
		to_chat(user, SPAN_WARNING("You tear \the [affected.artery_name] trying to fit an object so big!"))
		affected.sever_artery()
		affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1)
	user.drop_item()
	affected.implants += tool
	if(istype(tool, /obj/item/device/gps))
		var/obj/item/device/gps/gps = tool
		moved_event.register(target, gps, /obj/item/device/gps/proc/update_position)
		gps.implanted_into = target
	tool.forceMove(affected)
	affected.cavity = CAVITY_CLOSED

//////////////////////////////////////////////////////////////////
//					IMPLANT/ITEM REMOVAL SURGERY						//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/cavity/implant_removal
	name = "Remove Foreign Body"
	allowed_tools = list(
	/obj/item/surgery/hemostat = 100,	\
	WIRECUTTER = 75,	\
	/obj/item/material/kitchen/utensil/fork = 20
	)

	min_duration = 80
	max_duration = 100

/singleton/surgery_step/cavity/implant_removal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected

/singleton/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
		"You start poking around inside [target]'s [affected.name] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!", 50)
	..()

/singleton/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	var/find_prob = 0
	var/list/implants = list()

	if(affected.implants.len)
		implants = affected.implants

		var/obj/item/obj = pick(implants)

		if(istype(obj,/obj/item/implant))
			var/obj/item/implant/imp = obj
			if(imp.islegal())
				find_prob += 60
			else
				find_prob += 40
		else
			find_prob += 75

		if(prob(find_prob))
			user.visible_message("<b>[user]</b> takes something out of incision on [target]'s [affected.name] with \the [tool].", \
				SPAN_NOTICE("You take [obj] out of incision on [target]'s [affected.name]s with \the [tool].") )
			target.remove_implant(obj, TRUE, affected)

			BITSET(target.hud_updateflag, IMPLOYAL_HUD)

			//Handle possessive brain borers.
			if(istype(obj,/mob/living/simple_animal/borer))
				var/mob/living/simple_animal/borer/worm = obj
				if(worm.controlling)
					target.release_control()
				worm.detach()
				worm.leave_host()

			else if(istype(obj, /obj/item/device/gps))
				var/obj/item/device/gps/gps = obj
				moved_event.unregister(target, gps)
				gps.implanted_into = null
			playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)
		else
			user.visible_message("<b>[user]</b> removes \the [tool] from [target]'s [affected.name].", \
				SPAN_NOTICE("There's something inside [target]'s [affected.name], but you just missed it this time.") )
	else
		user.visible_message("<b>[user]</b> could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.", \
			SPAN_NOTICE("You could not find anything inside [target]'s [affected.name].") )

/singleton/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user] loses their grip and stabs [target] with \the [tool]!"), SPAN_WARNING("You lose your grip on \the [tool] and stab [target]!"))
	affected.sever_artery()
	target.apply_damage(25, BRUTE, target_zone)

