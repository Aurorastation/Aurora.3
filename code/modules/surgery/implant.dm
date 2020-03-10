//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/cavity
	priority = 1

/datum/surgery_step/cavity/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == (affected.encased ? 3 : 2) && !(affected.status & ORGAN_BLEEDING)

/datum/surgery_step/cavity/proc/get_max_wclass(var/obj/item/organ/external/affected)
	switch(affected.name)
		if(BP_HEAD)
			return 1
		if("upper body")
			return 3
		if("lower body")
			return 2
	return 0

/datum/surgery_step/cavity/proc/get_cavity(var/obj/item/organ/external/affected)
	switch(affected.name)
		if(BP_HEAD)
			return "cranial"
		if("upper body")
			return "thoracic"
		if("lower body")
			return "abdominal"
	return ""

/datum/surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>")
	target.apply_damage(20, BRUTE, target_zone, 0, tool, tool.sharp, tool.edge)

/datum/surgery_step/cavity/make_space
	allowed_tools = list(
	/obj/item/surgery/surgicaldrill = 100,	\
	/obj/item/pen = 75,	\
	/obj/item/stack/rods = 50
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/make_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.cavity

/datum/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].", \
		"You start making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 1
	playsound(target.loc, 'sound/effects/squelch1.ogg', 25, 1)
	..()

/datum/surgery_step/cavity/make_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] makes some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].</span>", \
		"<span class='notice'>You make some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].</span>" )

/datum/surgery_step/cavity/close_space
	priority = 2
	allowed_tools = list(
	/obj/item/surgery/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/close_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.cavity

/datum/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts mending [target]'s [get_cavity(affected)] cavity wall with \the [tool].", \
		"You start mending [target]'s [get_cavity(affected)] cavity wall with \the [tool]." )
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 0
	..()

/datum/surgery_step/cavity/close_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] mends [target]'s [get_cavity(affected)] cavity walls with \the [tool].</span>", \
		"<span class='notice'>You mend [target]'s [get_cavity(affected)] cavity walls with \the [tool].</span>" )

/datum/surgery_step/cavity/place_item
	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/place_item/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
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

/datum/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts putting \the [tool] inside [target]'s [get_cavity(affected)] cavity.", \
		"You start putting \the [tool] inside [target]'s [get_cavity(affected)] cavity." )
	target.custom_pain("The pain in your chest is living hell!",1)
	playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)
	..()

/datum/surgery_step/cavity/place_item/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	user.visible_message("<span class='notice'>[user] puts \the [tool] inside [target]'s [get_cavity(affected)] cavity.</span>", \
		"<span class='notice'>You put \the [tool] inside [target]'s [get_cavity(affected)] cavity.</span>" )
	if(tool.w_class > get_max_wclass(affected)/2 && prob(50) && !(affected.status & ORGAN_ROBOT))
		to_chat(user, "<span class='warning'>You tear \the [affected.artery_name] trying to fit an object so big!</span>")
		affected.sever_artery()
		affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1)
	user.drop_item()
	affected.implants += tool
	tool.forceMove(affected)
	affected.cavity = 0

//////////////////////////////////////////////////////////////////
//					IMPLANT/ITEM REMOVAL SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/implant_removal
	allowed_tools = list(
	/obj/item/surgery/hemostat = 100,	\
	/obj/item/wirecutters = 75,	\
	/obj/item/material/kitchen/utensil/fork = 20
	)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/implant_removal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected

/datum/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
		"You start poking around inside [target]'s [affected.name] with \the [tool]." )
	target.custom_pain("The pain in your [affected.name] is living hell!", 50)
	..()

/datum/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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
			find_prob += 50

		if(prob(find_prob))
			user.visible_message("<span class='notice'>[user] takes something out of incision on [target]'s [affected.name] with \the [tool].</span>", \
				"<span class='notice'>You take [obj] out of incision on [target]'s [affected.name]s with \the [tool].</span>" )
			target.remove_implant(obj, TRUE, affected)

			BITSET(target.hud_updateflag, IMPLOYAL_HUD)

			//Handle possessive brain borers.
			if(istype(obj,/mob/living/simple_animal/borer))
				var/mob/living/simple_animal/borer/worm = obj
				if(worm.controlling)
					target.release_control()
				worm.detach()
				worm.leave_host()

			playsound(target.loc, 'sound/effects/squelch1.ogg', 50, 1)
		else
			user.visible_message("<span class='notice'>[user] removes \the [tool] from [target]'s [affected.name].</span>", \
				"<span class='notice'>There's something inside [target]'s [affected.name], but you just missed it this time.</span>" )
	else
		user.visible_message("<span class='notice'>[user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.</span>", \
			"<span class='notice'>You could not find anything inside [target]'s [affected.name].</span>" )

/datum/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user] loses their grip and stabs [target] with \the [tool]!</span>", "<span class='warning'>You lose your grip on \the [tool] and stab [target]!</span>")
	affected.sever_artery()
	target.apply_damage(25, BRUTE, target_zone)

