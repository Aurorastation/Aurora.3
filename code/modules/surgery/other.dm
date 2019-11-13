//Procedures in this file: Inernal wound patching, Implant removal.
//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////


/datum/surgery_step/fix_vein
	priority = 2
	allowed_tools = list(
	/obj/item/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(!hasorgans(target))
			return 0

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!affected) return
		var/internal_bleeding = 0
		for(var/datum/wound/W in affected.wounds) if(W.internal)
			internal_bleeding = 1
			break

		return affected.open >= 2 && internal_bleeding

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool]." , \
		"You start patching the damaged vein in [target]'s [affected.name] with \the [tool].")
		target.custom_pain("The pain in [affected.name] is unbearable!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has patched the damaged vein in [target]'s [affected.name] with \the [tool].</span>", \
			"<span class='notice'>You have patched the damaged vein in [target]'s [affected.name] with \the [tool].</span>")

		for(var/datum/wound/W in affected.wounds) if(W.internal)
			affected.wounds -= W
			affected.update_damages()
		if (ishuman(user) && prob(40)) user:bloody_hands(target, 0)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
		"<span class='warning'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")
		affected.take_damage(5, 0)

/datum/surgery_step/fix_dead_tissue		//Debridement
	priority = 2
	allowed_tools = list(
		/obj/item/scalpel = 100,
		/obj/item/material/knife = 75,
		/obj/item/material/shard = 50
	)

	can_infect = 1
	blood_level = 1

	min_duration = 110
	max_duration = 160

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(!hasorgans(target))
			return 0

		if (target_zone == "mouth" || target_zone == "eyes")
			return 0

		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		return affected && affected.open >= 2 && (affected.status & ORGAN_DEAD)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts cutting away necrotic tissue in [target]'s [affected.name] with \the [tool]." , \
		"You start cutting away necrotic tissue in [target]'s [affected.name] with \the [tool].")
		target.custom_pain("The pain in [affected.name] is unbearable!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has cut away necrotic tissue in [target]'s [affected.name] with \the [tool].</span>", \
			"<span class='notice'>You have cut away necrotic tissue in [target]'s [affected.name] with \the [tool].</span>")
		affected.status &= ~ORGAN_DEAD

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, slicing an artery inside [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(CUT, 20, 1)

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

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!istype(tool, /obj/item/reagent_containers))
			return 0

		var/obj/item/reagent_containers/container = tool
		if(!container.reagents.has_reagent("peridaxon"))
			return 0

		if(!hasorgans(target))
			return 0

		if (target_zone == "mouth" || target_zone == "eyes")
			return 0

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 3 && (affected.status & ORGAN_DEAD)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts applying medication to the affected tissue in [target]'s [affected.name] with \the [tool]." , \
		"You start applying medication to the affected tissue in [target]'s [affected.name] with \the [tool].")
		target.custom_pain("Something in your [affected.name] is causing you a lot of pain!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
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

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		if (!istype(tool, /obj/item/reagent_containers))
			return

		var/obj/item/reagent_containers/container = tool

		var/trans = container.reagents.trans_to_mob(target, container.amount_per_transfer_from_this, CHEM_BLOOD)

		user.visible_message("<span class='warning'>[user]'s hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!</span>" , \
		"<span class='warning'>Your hand slips, applying [trans] units of the solution to the wrong place in [target]'s [affected.name] with the [tool]!</span>")

		//no damage or anything, just wastes medicine

/datum/surgery_step/hardsuit
	allowed_tools = list(
		/obj/item/weldingtool = 80,
		/obj/item/circular_saw = 60,
		/obj/item/gun/energy/plasmacutter = 100
		)

	can_infect = 0
	blood_level = 0

	min_duration = 120
	max_duration = 180

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(!istype(target))
			return 0
		if(tool.iswelder())
			var/obj/item/weldingtool/welder = tool
			if(!welder.isOn() || !welder.remove_fuel(1,user))
				return 0
		return (target_zone == "chest") && istype(target.back, /obj/item/rig) && !(target.back.canremove)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts cutting through the support systems of [target]'s [target.back] with \the [tool]." , \
		"You start cutting through the support systems of [target]'s [target.back] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		var/obj/item/rig/rig = target.back
		if(!istype(rig))
			return
		rig.reset()
		user.visible_message("<span class='notice'>[user] has cut through the support systems of [target]'s [rig] with \the [tool].</span>", \
			"<span class='notice'>You have cut through the support systems of [target]'s [rig] with \the [tool].</span>")

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='danger'>[user]'s [tool] can't quite seem to get through the metal...</span>", \
		"<span class='danger'>Your [tool] can't quite seem to get through the metal. It's weakening, though - try again.</span>")
