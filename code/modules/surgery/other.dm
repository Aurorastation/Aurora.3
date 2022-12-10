//Procedures in this file: Inernal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////


/decl/surgery_step/fix_vein
	name = "Repair Arterial Bleeding"
	priority = 3
	allowed_tools = list(
	/obj/item/surgery/fix_o_vein = 100, \
	/obj/item/stack/cable_coil = 75
	)
	can_infect = TRUE
	blood_level = 1

	min_duration = 70
	max_duration = 90

/decl/surgery_step/fix_vein/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return

	return affected.open >= ORGAN_OPEN_RETRACTED && (affected.status & ORGAN_ARTERY_CUT)

/decl/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool]." , \
		"You start patching the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is unbearable!", 100)
	..()

/decl/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has patched the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool]."), \
		SPAN_NOTICE("You have patched the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool]."))

	affected.status &= ~ORGAN_ARTERY_CUT
	affected.update_damages()
	if(ishuman(user) && prob(40))
		user:bloody_hands(target, 0)

/decl/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!") , \
		SPAN_WARNING("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"))
	affected.take_damage(5, 0)

/decl/surgery_step/internal/fix_dead_tissue //Debridement
	name = "Debride Damaged Tissue"
	priority = 4
	allowed_tools = list(
		/obj/item/surgery/scalpel = 100,
		/obj/item/material/knife = 75,
		/obj/item/material/shard = 50
	)

	can_infect = TRUE
	blood_level = 1

	min_duration = 110
	max_duration = 160

/decl/surgery_step/internal/fix_dead_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/organ/internal/organ
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if((I.status & ORGAN_DEAD) && !BP_IS_ROBOTIC(I))
			organ = I
			break
	if(!organ)
		return
	if(organ.damage > organ.max_damage)
		to_chat(user, SPAN_WARNING("\The [organ] is too damaged. Repair it first."))
		return 0

	return organ.status & ORGAN_DEAD

/decl/surgery_step/internal/fix_dead_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/organ/internal/organ
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if((I.status & ORGAN_DEAD) && !BP_IS_ROBOTIC(I))
			organ = I
			break
	user.visible_message("[user] starts cutting away necrotic tissue from [target]'s [organ.name] with \the [tool]." , \
	"You start cutting away necrotic tissue from [target]'s [organ.name] with \the [tool].[organ.max_damage > 15 ? " Some of it has to be cut away permanently." : ""]")
	target.custom_pain("The pain in your [affected.name] is unbearable!", 75)
	..()

/decl/surgery_step/internal/fix_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/obj/item/organ/internal/dead_organs = list()
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && !(I.status & ORGAN_CUT_AWAY) && (I.status & ORGAN_DEAD) && !BP_IS_ROBOTIC(I))
			dead_organs |= I
	var/obj/item/organ/internal/organ_to_fix = dead_organs[1]
	user.visible_message(SPAN_NOTICE("[user] has cut away necrotic tissue from [target]'s [organ_to_fix.name] with \the [tool]."), \
		SPAN_NOTICE("You have cut away necrotic tissue in [target]'s [organ_to_fix.name] with \the [tool]."))
	organ_to_fix.status &= ~ORGAN_DEAD
	organ_to_fix.heal_damage(10) //so that they don't insta-die again

/decl/surgery_step/internal/fix_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!"))
	affected.sever_artery()

/decl/surgery_step/treat_necrosis
	name = "Treat Necrosis"
	priority = 4
	allowed_tools = list(
		/obj/item/reagent_containers/dropper = 100,
		/obj/item/reagent_containers/glass/bottle = 75,
		/obj/item/reagent_containers/glass/beaker = 75,
		/obj/item/reagent_containers/spray = 50,
		/obj/item/reagent_containers/glass/bucket = 50
	)

	can_infect = FALSE
	blood_level = 0

	min_duration = 100
	max_duration = 110

/decl/surgery_step/treat_necrosis/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(!istype(tool, /obj/item/reagent_containers))
		return FALSE

	var/obj/item/reagent_containers/container = tool
	if(!container.reagents.has_reagent(/decl/reagent/peridaxon))
		return FALSE

	if (target_zone == BP_MOUTH)
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && IS_ORGAN_FULLY_OPEN && (affected.status & ORGAN_DEAD)

/decl/surgery_step/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]." , \
	"You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 75)
	..()

/decl/surgery_step/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)
		if(container.reagents.has_reagent(/decl/reagent/peridaxon))
			affected.status &= ~ORGAN_DEAD
			affected.owner.update_body(1)

		user.visible_message(SPAN_NOTICE("[user] applies [trans] units of the solution to affected tissue in [target]'s [affected.name]"), \
			SPAN_NOTICE("You apply [trans] units of the solution to affected tissue in [target]'s [affected.name] with \the [tool]."))

/decl/surgery_step/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool
	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message(SPAN_WARNING("[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!") , \
		SPAN_WARNING("Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!"))

	//no damage or anything, just wastes medicine

/decl/surgery_step/fix_tendon
	name = "Repair Tendons"
	priority = 2
	allowed_tools = list(
		/obj/item/surgery/fix_o_vein = 100, \
		/obj/item/stack/cable_coil = 75
	)
	can_infect = TRUE
	blood_level = 1

	min_duration = 70
	max_duration = 90

/decl/surgery_step/fix_tendon/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.tendon_status() & TENDON_CUT) && affected.open >= ORGAN_OPEN_RETRACTED

/decl/surgery_step/fix_tendon/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts reattaching the damaged [affected.tendon_name] in [target]'s [affected.name] with \the [tool]." , \
		"You start reattaching the damaged [affected.tendon_name] in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is unbearable!", 100)
	..()

/decl/surgery_step/fix_tendon/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_NOTICE("[user] has reattached the [affected.tendon_name] in [target]'s [affected.name] with \the [tool]."), \
		SPAN_NOTICE("You have reattached the [affected.tendon_name] in [target]'s [affected.name] with \the [tool]."))
	affected.tendon.rejuvenate()
	affected.update_damages()

/decl/surgery_step/fix_tendon/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!") , \
		SPAN_WARNING("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"))
	target.apply_damage(15, PAIN)

/decl/surgery_step/hardsuit
	name = "Remove Hardsuit"
	allowed_tools = list(
		/obj/item/weldingtool = 80,
		/obj/item/surgery/circular_saw = 60,
		/obj/item/gun/energy/plasmacutter = 100
	)

	can_infect = FALSE
	blood_level = 0

	min_duration = 120
	max_duration = 180

/decl/surgery_step/hardsuit/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(!istype(target))
		return FALSE
	if(tool.iswelder())
		var/obj/item/weldingtool/welder = tool
		if(!welder.isOn() || !welder.use(1,user))
			return FALSE
	return (target_zone == BP_CHEST) && istype(target.back, /obj/item/rig) && !(target.back.canremove)

/decl/surgery_step/hardsuit/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through the support systems of [target]'s [target.back] with \the [tool]." , \
		"You start cutting through the support systems of [target]'s [target.back] with \the [tool].")
	..()

/decl/surgery_step/hardsuit/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		return
	rig.reset()
	user.visible_message(SPAN_NOTICE("[user] has cut through the support systems of [target]'s [rig] with \the [tool]."), \
		SPAN_NOTICE("You have cut through the support systems of [target]'s [rig] with \the [tool]."))

/decl/surgery_step/amputate
	name = "Amputate Limb"
	allowed_tools = list(
	/obj/item/surgery/circular_saw = 100,
	/obj/item/melee/energy = 100,
	/obj/item/melee/chainsword = 100,
	/obj/item/material/hatchet = 55
	)

	min_duration = 110
	max_duration = 160

/decl/surgery_step/amputate/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!..())
		return FALSE

	if(target_zone == BP_EYES)	//there are specific steps for eye surgery
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected == null)
		return FALSE

	if(istype(tool, /obj/item/melee/energy))
		var/obj/item/melee/energy/E = tool
		if(!E.active)
			to_chat(user, SPAN_WARNING("The energy blade is not turned on!"))
			return FALSE

	if(istype(tool, /obj/item/melee/chainsword))
		var/obj/item/melee/chainsword/E = tool
		if(!E.active)
			to_chat(user, SPAN_WARNING("The blades aren't spinning, you can't cut anything!"))
			return FALSE

	if(affected.limb_flags & ORGAN_CAN_AMPUTATE)
		var/confirmation = alert("You are about to amputate [target]'s [affected.name]! Are you sure you want to do that?", "Amputation confirmation", "Yes", "No")
		return confirmation == "Yes"

/decl/surgery_step/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_DANGER("[user] is beginning to amputate [target]'s [affected.name] with \the [tool].") , \
		SPAN_DANGER("You begin to cut through [target]'s [affected.amputation_point] with \the [tool]."))
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!", 75)
	..()

/decl/surgery_step/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_DANGER("[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool]."), \
		SPAN_DANGER("You amputate [target]'s [affected.name] with \the [tool]."))

	var/clean = TRUE
	if(istype(tool, /obj/item/melee/chainsword))//Chainswords rip and tear, so the limb removal is not clean
		clean = FALSE

	var/obj/item/organ/external/parent = affected.parent//Cache the parent organ of the limb before we sever it
	affected.droplimb(clean,DROPLIMB_EDGE)

	if(istype(tool, /obj/item/melee/energy))//Code for energy weapons cauterising the cut
		affected = parent
		affected.open = ORGAN_CLOSED//Close open wounds
		for(var/datum/wound/lost_limb/W in affected.wounds)
			W.disinfected = TRUE//Cleanse the wound of any germs
			W.autoheal_cutoff = INFINITY//Allow the wound to auto-heal, regardless of damage
			W.max_bleeding_stage = 0//Stop bleeding

/decl/surgery_step/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!"))
	target.apply_damage(30, BRUTE, target_zone, 0, tool, damage_flags = tool.damage_flags())
	affected.fracture()
