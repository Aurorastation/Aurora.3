//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/singleton/surgery_step/generic
	can_infect = TRUE

/singleton/surgery_step/generic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(isslime(target))
		return FALSE
	if(target_zone == BP_EYES)	//there are specific steps for eye surgery
		return FALSE
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected == null)
		return FALSE
	if(affected.is_stump())
		return FALSE
	if(BP_IS_ROBOTIC(affected))
		return FALSE
	return TRUE

/singleton/surgery_step/generic/keyhole
	name = "Make Keyhole Incision"
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100
	)
	priority = 2
	base_surgery_time = 8 SECONDS
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_TRAINED)

/singleton/surgery_step/generic/keyhole/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || affected.open != ORGAN_OPEN_INCISION)
		return FALSE

	var/obj/structure/machinery/optable/table = locate(/obj/structure/machinery/optable) in target.loc
	if(!table)
		to_chat(user, SPAN_WARNING("Keyhole surgery requires real time computer assisted imaging, from a patient monitoring console connected to an operating table."))
		return FALSE

	var/obj/structure/machinery/computer/operating/console = table.computer
	if(!console || console.table != table)
		to_chat(user, SPAN_WARNING("Keyhole surgery requires real time computer assisted imaging, from a patient monitoring console connected to the operating table."))
		return FALSE

	if(console.stat & BROKEN)
		to_chat(user, SPAN_WARNING("The patient monitoring console is broken, so keyhole surgery cannot be performed."))
		return FALSE
	if(console.stat & NOPOWER)
		to_chat(user, SPAN_WARNING("The patient monitoring console is unpowered, so keyhole surgery cannot be performed."))
		return FALSE

	if(!console.primer)
		to_chat(user, SPAN_WARNING("The patient monitoring console is missing a primer, so keyhole surgery cannot be performed."))
		return FALSE

	var/atom/primer_scan_target = console.primer.scan_target?.resolve()
	if(primer_scan_target != target)
		to_chat(user, SPAN_WARNING("The patient monitoring console's primer does not match this patient, so keyhole surgery cannot be performed."))
		return FALSE

	return TRUE

/singleton/surgery_step/generic/keyhole/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts cutting deep inside [target]'s [affected.name] with \the [tool].", \
		"You start cutting deep inside [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, deep stabbing pain in [affected.name]!", 135)
	..()

/singleton/surgery_step/generic/keyhole/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has made a keyhole incision on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You have made a keyhole incision on [target]'s [affected.name] with \the [tool]."))
	affected.open = ORGAN_OPEN_KEYHOLE

/singleton/surgery_step/generic/cut_with_laser
	name = "Make Laser Incision"
	allowed_tools = list(
	/obj/item/surgery/scalpel/laser = 100
	)
	priority = 2
	base_surgery_time = 7 SECONDS
	// Basic procedure any novice can do
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_FAMILIAR)

/singleton/surgery_step/generic/cut_with_laser/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
		"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!", 135)
	..()

/singleton/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has made a bloodless incision on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You have made a bloodless incision on [target]'s [affected.name] with \the [tool]."))
	affected.open = ORGAN_OPEN_INCISION

	if(istype(target) && !(target.species.flags & NO_BLOOD))
		affected.status |= ORGAN_BLEEDING
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 50, 1)

	target.apply_damage(1, DAMAGE_BRUTE, target_zone, 0)
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)

/singleton/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(7.5, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	target.apply_damage(12.5, DAMAGE_BURN, target_zone, 0, tool)

/singleton/surgery_step/generic/incision_manager
	name = "Make Managed Incision"
	allowed_tools = list(
	/obj/item/surgery/scalpel/manager = 100
	)
	priority = 2
	base_surgery_time = 8 SECONDS
	// Automated tool that requires no skill
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_UNFAMILIAR)

/singleton/surgery_step/generic/incision_manager/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/incision_manager/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
		"You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!", 135)
	..()

/singleton/surgery_step/generic/incision_manager/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> constructs a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool]."),)
	affected.open = ORGAN_OPEN_INCISION

	if(istype(target) && !(target.species.flags & NO_BLOOD))
		affected.status |= ORGAN_BLEEDING

	target.apply_damage(1, DAMAGE_BRUTE, target_zone, 0)
	affected.clamp_organ()
	affected.open = ORGAN_OPEN_RETRACTED

/singleton/surgery_step/generic/incision_manager/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(20, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	target.apply_damage(15, DAMAGE_BURN, target_zone, 0, tool)

/singleton/surgery_step/generic/cut_open
	name = "Make Incision"
	allowed_tools = list(
	TOOL_SCALPEL = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)
	base_surgery_time = 8 SECONDS
	// Basic surgery any novice surgeon can do
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_FAMILIAR)

/singleton/surgery_step/generic/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	if(isvaurca(target))
		return FALSE
	else
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts the incision on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You start the incision on [target]'s [affected.name] with \the [tool]."))
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!", 145)
	..()

/singleton/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has made an incision on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You have made an incision on [target]'s [affected.name] with \the [tool]."),)
	affected.open = ORGAN_OPEN_INCISION

	if(istype(target) && !(target.species.flags & NO_BLOOD))
		affected.status |= ORGAN_BLEEDING

	target.apply_damage(1, DAMAGE_BRUTE, target_zone, 0)
	playsound(target.loc, 'sound/weapons/bladeslice.ogg', 15, 1)

/singleton/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!"))
	target.apply_damage(10, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/singleton/surgery_step/generic/cut_open_vaurca
	name = "Cut Open Vaurca"
	allowed_tools = list(
	TOOL_DRILL = 100,
	/obj/item/pickaxe/ = 15
	)
	base_surgery_time = 10 SECONDS
	// Basic surgery any novice surgeon can do
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_FAMILIAR)

/singleton/surgery_step/generic/cut_open_vaurca/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE
	if(!(isvaurca(target)))
		return FALSE
	else
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/cut_open_vaurca/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts drilling into [target]'s [affected.name] carapace with \the [tool].", \
		"You start drilling into [target]'s [affected.name] carapace with \the [tool].")
	target.custom_pain("You feel a horrible pain as if from a jackhammer in your [affected.name]!", 145)
	..()

/singleton/surgery_step/generic/cut_open_vaurca/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> has drilled into [target]'s [affected.name] carapace with \the [tool].", \
							SPAN_NOTICE("You have drilled into [target]'s [affected.name] carapace with \the [tool]."),)
	affected.open = ORGAN_OPEN_INCISION

	if(istype(target) && !(target.species.flags & NO_BLOOD))
		affected.status |= ORGAN_BLEEDING

	target.apply_damage(1, DAMAGE_BRUTE, target_zone, 0)

/singleton/surgery_step/generic/cut_open_vaurca/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, cracking [target]'s [affected.name] carapace in the wrong place with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, cracking [target]'s [affected.name] carapace in the wrong place with \the [tool]!"))
	target.apply_damage(15, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/singleton/surgery_step/generic/clamp_bleeders
	name = "Clamp Bleeders"
	allowed_tools = list(
	TOOL_HEMOSTAT = 100,	\
	TOOL_CABLECOIL = 75, 	\
	/obj/item/assembly/mousetrap = 20
	)
	base_surgery_time = 3 SECONDS
	// Basic surgery any novice surgeon can do
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_FAMILIAR)

/singleton/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open > ORGAN_CLOSED && (affected.status & ORGAN_BLEEDING)

/singleton/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
		"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is maddening!", 120)
	..()

/singleton/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> clamps bleeders in [target]'s [affected.name] with \the [tool].",	\
		SPAN_NOTICE("You clamp bleeders in [target]'s [affected.name] with \the [tool]."))
	affected.clamp_organ()
	spread_germs_to_organ(affected, user)
	playsound(target.loc, 'sound/items/Welder.ogg', 15, 1)

/singleton/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!"),	\
		SPAN_WARNING("Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!"),)
	affected.sever_artery()

/singleton/surgery_step/generic/retract_skin
	name = "Widen Incision"
	allowed_tools = list(
	TOOL_RETRACTOR = 100, 	\
	TOOL_CROWBAR = 75,	\
	/obj/item/material/kitchen/utensil/fork = 50
	)
	base_surgery_time = 3 SECONDS
	// Basic surgery any novice surgeon can do
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_FAMILIAR)

/singleton/surgery_step/generic/retract_skin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.open == ORGAN_OPEN_INCISION || affected.open == ORGAN_OPEN_KEYHOLE)

/singleton/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<b>[user]</b> starts to pry open the incision on [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to pry open the incision on [target]'s [affected.name] with \the [tool]."
	if(target_zone == BP_CHEST)
		msg = "<b>[user]</b> starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
	if(target_zone == BP_GROIN)
		msg = "<b>[user]</b> starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
	user.visible_message(msg, SPAN_NOTICE(self_msg))
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!", 175)
	..()

/singleton/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<b>[user]</b> keeps the incision open on [target]'s [affected.name] with \the [tool]."
	var/self_msg = SPAN_NOTICE("You keep the incision open on [target]'s [affected.name] with \the [tool].")
	if(target_zone == BP_CHEST)
		msg = "<b>[user]</b> keeps the ribcage open on [target]'s torso with \the [tool]."
		self_msg = SPAN_NOTICE("You keep the ribcage open on [target]'s torso with \the [tool].")
	if(target_zone == BP_GROIN)
		msg = "<b>[user]</b> keeps the incision open on [target]'s lower abdomen with \the [tool]."
		self_msg = SPAN_NOTICE("You keep the incision open on [target]'s lower abdomen with \the [tool].")
	user.visible_message(msg, self_msg)
	affected.open = ORGAN_OPEN_RETRACTED

	if(!affected.encased)
		for(var/obj/item/implant/I in affected.implants)
			I.exposed()

/singleton/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = SPAN_WARNING("[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!")
	var/self_msg = SPAN_WARNING("Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!")
	if (target_zone == BP_CHEST)
		msg = SPAN_WARNING("[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!")
		self_msg = SPAN_WARNING("Your hand slips, damaging several organs in [target]'s torso with \the [tool]!")
	if (target_zone == BP_GROIN)
		msg = SPAN_WARNING("[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]")
		self_msg = SPAN_WARNING("Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!")
	user.visible_message(msg, self_msg)
	target.apply_damage(12, DAMAGE_BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())

/singleton/surgery_step/generic/cauterize
	name = "Cauterize Incision"
	allowed_tools = list(
	TOOL_CAUTERY = 100,
	/obj/item/clothing/mask/smokable/cigarette = 25,
	/obj/item/flame/lighter = 50,
	/obj/item/weldingtool = 75
	)
	base_surgery_time = 7 SECONDS
	// Basic surgery any novice surgeon can do
	skill_requirements = alist(SURGERY_SKILL_COMPONENT = SKILL_LEVEL_FAMILIAR)

/singleton/surgery_step/generic/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open > ORGAN_CLOSED && target_zone != BP_MOUTH

/singleton/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> is beginning to cauterize the incision on [target]'s [affected.name] with \the [tool]." , \
		SPAN_NOTICE("You are beginning to cauterize the incision on [target]'s [affected.name] with \the [tool]."))
	target.custom_pain("Your [affected.name] is being burned!", 120)
	..()

/singleton/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<b>[user]</b> cauterizes the incision on [target]'s [affected.name] with \the [tool].", \
		SPAN_NOTICE("You cauterize the incision on [target]'s [affected.name] with \the [tool]."))
	affected.open = ORGAN_CLOSED
	affected.germ_level = 0
	affected.status &= ~ORGAN_BLEEDING

/singleton/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(5, DAMAGE_BURN, affected, tool)
