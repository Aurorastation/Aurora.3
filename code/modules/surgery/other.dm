//Procedures in this file: Inernal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////


/datum/surgery_step/fix_vein
	priority = 3
	allowed_tools = list(
	/obj/item/surgery/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90

/datum/surgery_step/fix_vein/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected)
		return

	return affected.open >= 2 && (affected.status & ORGAN_ARTERY_CUT)

/datum/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool]." , \
		"You start patching the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has patched the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have patched the damaged [affected.artery_name] in [target]'s [affected.name] with \the [tool].</span>")

	affected.status &= ~ORGAN_ARTERY_CUT
	affected.update_damages()
	if(ishuman(user) && prob(40))
		user:bloody_hands(target, 0)

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
		"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	affected.take_damage(5, 0)

/datum/surgery_step/fix_dead_tissue		//Debridement
	priority = 3
	allowed_tools = list(
		/obj/item/surgery/scalpel = 100,
		/obj/item/material/knife = 75,
		/obj/item/material/shard = 50
	)

	can_infect = 1
	blood_level = 1

	min_duration = 110
	max_duration = 160

/datum/surgery_step/fix_dead_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/obj/item/organ/internal/organ
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if((I.status & ORGAN_DEAD) && !BP_IS_ROBOTIC(I))
			organ = I
			break
	if(!organ)
		return
	if(organ.damage >= organ.max_damage)
		to_chat(user, span("warning", "\The [organ] is too damaged. Repair it first."))
		return 0

	return organ && affected.open >= 2 && (organ.status & ORGAN_DEAD)

/datum/surgery_step/fix_dead_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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

/datum/surgery_step/fix_dead_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/list/obj/item/organ/internal/dead_organs = list()
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	for(var/obj/item/organ/internal/I in affected.internal_organs)
		if(I && !(I.status & ORGAN_CUT_AWAY) && (I.status & ORGAN_DEAD) && !BP_IS_ROBOTIC(I))
			dead_organs |= I
	var/obj/item/organ/internal/organ_to_fix = dead_organs[1]
	user.visible_message("<span class='notice'>[user] has cut away necrotic tissue from [target]'s [organ_to_fix.name] with \the [tool].</span>", \
		"<span class='notice'>You have cut away necrotic tissue in [target]'s [organ_to_fix.name] with \the [tool].</span>")
	organ_to_fix.status &= ~ORGAN_DEAD

/datum/surgery_step/fix_dead_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>")
	affected.sever_artery()

/datum/surgery_step/treat_necrosis
	priority = 2
	allowed_tools = list(
		/obj/item/reagent_containers/dropper = 100,
		/obj/item/reagent_containers/glass/bottle = 75,
		/obj/item/reagent_containers/glass/beaker = 75,
		/obj/item/reagent_containers/spray = 50,
		/obj/item/reagent_containers/glass/bucket = 50
	)

	can_infect = 0
	blood_level = 0

	min_duration = 50
	max_duration = 60

/datum/surgery_step/treat_necrosis/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(tool, /obj/item/reagent_containers))
		return 0

	var/obj/item/reagent_containers/container = tool
	if(!container.reagents.has_reagent("peridaxon"))
		return 0

	if(!ishuman(target))
		return 0

		if (target_zone == BP_MOUTH || target_zone == BP_EYES)
			return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open == 3 && (affected.status & ORGAN_DEAD)

/datum/surgery_step/treat_necrosis/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]." , \
	"You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 75)
	..()

/datum/surgery_step/treat_necrosis/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool

	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD) //technically it's contact, but the reagents are being applied to internal tissue
	if (trans > 0)
		if(container.reagents.has_reagent("peridaxon"))
			affected.status &= ~ORGAN_DEAD
			affected.owner.update_body(1)

		user.visible_message("<span class='notice'>[user] applies [trans] units of the solution to affected tissue in [target]'s [affected.name]</span>", \
			"<span class='notice'>You apply [trans] units of the solution to affected tissue in [target]'s [affected.name] with \the [tool].</span>")

/datum/surgery_step/treat_necrosis/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!istype(tool, /obj/item/reagent_containers))
		return

	var/obj/item/reagent_containers/container = tool
	var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

	user.visible_message("<span class='warning'>[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!</span>")

	//no damage or anything, just wastes medicine

/datum/surgery_step/fix_tendon
	priority = 2
	allowed_tools = list(
		/obj/item/surgery/FixOVein = 100, \
		/obj/item/stack/cable_coil = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90

/datum/surgery_step/fix_tendon/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.status & ORGAN_TENDON_CUT) && affected.open >= 2

/datum/surgery_step/fix_tendon/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts reattaching the damaged [affected.tendon_name] in [target]'s [affected.name] with \the [tool]." , \
		"You start reattaching the damaged [affected.tendon_name] in [target]'s [affected.name] with \the [tool].")
	target.custom_pain("The pain in your [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/fix_tendon/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has reattached the [affected.tendon_name] in [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have reattached the [affected.tendon_name] in [target]'s [affected.name] with \the [tool].</span>")
	affected.status &= ~ORGAN_TENDON_CUT
	affected.update_damages()

/datum/surgery_step/fix_tendon/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
		"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
	target.apply_damage(15, PAIN)

/datum/surgery_step/hardsuit
	allowed_tools = list(
		/obj/item/weldingtool = 80,
		/obj/item/surgery/circular_saw = 60,
		/obj/item/gun/energy/plasmacutter = 100
	)

	can_infect = 0
	blood_level = 0

	min_duration = 120
	max_duration = 180

/datum/surgery_step/hardsuit/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(target))
		return 0
	if(tool.iswelder())
		var/obj/item/weldingtool/welder = tool
		if(!welder.isOn() || !welder.remove_fuel(1,user))
			return 0
	return (target_zone == BP_CHEST) && istype(target.back, /obj/item/rig) && !(target.back.canremove)

/datum/surgery_step/hardsuit/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through the support systems of [target]'s [target.back] with \the [tool]." , \
		"You start cutting through the support systems of [target]'s [target.back] with \the [tool].")
	..()

/datum/surgery_step/hardsuit/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		return
	rig.reset()
	user.visible_message("<span class='notice'>[user] has cut through the support systems of [target]'s [rig] with \the [tool].</span>", \
		"<span class='notice'>You have cut through the support systems of [target]'s [rig] with \the [tool].</span>")