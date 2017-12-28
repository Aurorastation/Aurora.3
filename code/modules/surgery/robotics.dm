//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/robotics/
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (user == target && isipc(user))
			to_chat(user, span("warning","You can't repair damage to your own body - it's against OH&S."))
			return 0		//self-surgery isn't allowed!
		if (isslime(target))
			return 0
		if (target_zone == "eyes")	//there are specific steps for eye surgery
			return 0
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.status & ORGAN_DESTROYED)
			return 0
		if (!(affected.status & ORGAN_ROBOT))
			return 0
		return 1

/datum/surgery_step/robotics/unscrew_hatch
	allowed_tools = list(
		/obj/item/weapon/screwdriver = 100,
		/obj/item/weapon/coin = 50,
		/obj/item/weapon/material/kitchen/utensil/knife = 50
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open == 0 && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].", \
		"You start to unscrew the maintenance hatch on [target]'s [affected.name] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has opened the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have opened the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>",)
		affected.open = 1

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to unscrew [target]'s [affected.name].</span>", \
		"<span class='warning'>Your [tool] slips, failing to unscrew [target]'s [affected.name].</span>")

/datum/surgery_step/robotics/open_hatch
	allowed_tools = list(
		/obj/item/weapon/retractor = 100,
		/obj/item/weapon/crowbar = 100,
		/obj/item/weapon/material/kitchen/utensil = 50
	)

	min_duration = 30
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].",
		"You start to pry open the maintenance hatch on [target]'s [affected.name] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] opens the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>", \
		 "<span class='notice'>You open the maintenance hatch on [target]'s [affected.name] with \the [tool].</span>")
		affected.open = 3

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to open the hatch on [target]'s [affected.name].</span>",
		"<span class='warning'>Your [tool] slips, failing to open the hatch on [target]'s [affected.name].</span>")

/datum/surgery_step/robotics/close_hatch
	allowed_tools = list(
		/obj/item/weapon/retractor = 100,
		/obj/item/weapon/crowbar = 100,
		/obj/item/weapon/material/kitchen/utensil = 50
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] begins to close and secure the hatch on [target]'s [affected.name] with \the [tool]." , \
		"You begin to close and secure the hatch on [target]'s [affected.name] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] closes and secures the hatch on [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You close and secure the hatch on [target]'s [affected.name] with \the [tool].</span>")
		affected.open = 0
		affected.germ_level = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s [tool.name] slips, failing to close the hatch on [target]'s [affected.name].</span>",
		"<span class='warning'>Your [tool.name] slips, failing to close the hatch on [target]'s [affected.name].</span>")

/datum/surgery_step/robotics/repair_brute
	allowed_tools = list(
		/obj/item/weapon/weldingtool = 100,
		/obj/item/weapon/gun/energy/plasmacutter = 50
	)

	min_duration = 50
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			if(iswelder(tool))
				var/obj/item/weapon/weldingtool/welder = tool
				if(!welder.isOn() || !welder.remove_fuel(1,user))
					return 0
			return affected && affected.open == 3 && affected.brute_dam > 0 && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] begins to patch damage to [target]'s [affected.name]'s support structure with \the [tool]." , \
		"You begin to patch damage to [target]'s [affected.name]'s support structure with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] finishes patching damage to [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You finish patching damage to [target]'s [affected.name] with \the [tool].</span>")
		affected.heal_damage(rand(30,50),0,1,1)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s [tool.name] slips, damaging the internal structure of [target]'s [affected.name].</span>",
		"<span class='warning'>Your [tool.name] slips, damaging the internal structure of [target]'s [affected.name].</span>")
		target.apply_damage(rand(5,10), BURN, affected)

/datum/surgery_step/robotics/repair_burn
	allowed_tools = list(
		/obj/item/stack/cable_coil = 100
	)

	min_duration = 50
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/stack/cable_coil/C = tool
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			var/limb_can_operate = (affected && affected.open == 3 && affected.burn_dam > 0 && target_zone != "mouth")
			if(limb_can_operate)
				if(istype(C))
					if(!C.get_amount() >= 3)
						user << "<span class='danger'>You need three or more cable pieces to repair this damage.</span>"
						return SURGERY_FAILURE
					C.use(3)
				return 1
			return 0

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] begins to splice new cabling into [target]'s [affected.name]." , \
		"You begin to splice new cabling into [target]'s [affected.name].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] finishes splicing cable into [target]'s [affected.name].</span>", \
		"<span class='notice'>You finishes splicing new cable into [target]'s [affected.name].</span>")
		affected.heal_damage(0,rand(30,50),1,1)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user] causes a short circuit in [target]'s [affected.name]!</span>",
		"<span class='warning'>You cause a short circuit in [target]'s [affected.name]!</span>")
		target.apply_damage(rand(5,10), BURN, affected)

/datum/surgery_step/robotics/fix_organ_robotic //For artificial organs
	allowed_tools = list(
	/obj/item/stack/nanopaste = 100,
	/obj/item/weapon/bonegel = 30,
	/obj/item/weapon/screwdriver = 70
	)

	min_duration = 70
	max_duration = 90

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!affected)
			return
		var/is_organ_damaged = 0
		for(var/obj/item/organ/I in affected.internal_organs)
			if(I.damage > 0 && I.robotic >= 2)
				is_organ_damaged = 1
				break
		return affected.open == 3 && is_organ_damaged

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		for(var/obj/item/organ/I in affected.internal_organs)
			if(I && I.damage > 0)
				if(I.robotic >= 2)
					user.visible_message("[user] starts mending the damage to [target]'s [I.name]'s mechanisms.", \
					"You start mending the damage to [target]'s [I.name]'s mechanisms." )

		target.custom_pain("The pain in your [affected.name] is living hell!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		for(var/obj/item/organ/I in affected.internal_organs)

			if(I && I.damage > 0)
				if(I.robotic >= 2)
					user.visible_message("<span class='notice'>[user] repairs [target]'s [I.name] with [tool].</span>", \
					"<span class='notice'>You repair [target]'s [I.name] with [tool].</span>" )
					I.damage = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if (!hasorgans(target))
			return
		var/obj/item/organ/external/affected = target.get_organ(target_zone)

		user.visible_message("<span class='warning'>[user]'s hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, gumming up the mechanisms inside of [target]'s [affected.name] with \the [tool]!</span>")

		target.adjustToxLoss(5)
		affected.createwound(CUT, 5)

		for(var/obj/item/organ/I in affected.internal_organs)
			if(I)
				I.take_damage(rand(3,5),0)

/datum/surgery_step/robotics/detatch_organ_robotic

	allowed_tools = list(
	/obj/item/device/multitool = 100
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!(affected && (affected.status & ORGAN_ROBOT)))
			return 0
		if(affected.open != 3)
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

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to decouple [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start to decouple [target]'s [target.op_stage.current_organ] with \the [tool]." )
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has decoupled [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
		"<span class='notice'>You have decoupled [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

		var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
		if(I && istype(I))
			I.status |= ORGAN_CUT_AWAY

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips, disconnecting \the [tool].</span>", \
		"<span class='warning'>Your hand slips, disconnecting \the [tool].</span>")

/datum/surgery_step/robotics/attach_organ_robotic
	allowed_tools = list(
		/obj/item/weapon/screwdriver = 100
	)

	min_duration = 100
	max_duration = 120

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!(affected && (affected.status & ORGAN_ROBOT)))
			return 0
		if(affected.open != 3)
			return 0

		target.op_stage.current_organ = null

		var/list/removable_organs = list()
		for(var/organ in target.internal_organs_by_name)
			var/obj/item/organ/I = target.internal_organs_by_name[organ]
			if(I && (I.status & ORGAN_CUT_AWAY) && (I.status & ORGAN_ROBOT) && I.parent_organ == target_zone)
				removable_organs |= organ

		var/organ_to_replace = input(user, "Which organ do you want to reattach?") as null|anything in removable_organs
		if(!organ_to_replace)
			return 0

		target.op_stage.current_organ = organ_to_replace
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] begins reattaching [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start reattaching [target]'s [target.op_stage.current_organ] with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>" , \
		"<span class='notice'>You have reattached [target]'s [target.op_stage.current_organ] with \the [tool].</span>")

		var/obj/item/organ/I = target.internal_organs_by_name[target.op_stage.current_organ]
		if(I && istype(I))
			I.status &= ~ORGAN_CUT_AWAY

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips, disconnecting \the [tool].</span>", \
		"<span class='warning'>Your hand slips, disconnecting \the [tool].</span>")

/datum/surgery_step/robotics/install_mmi
	allowed_tools = list(
	/obj/item/device/mmi = 100
	)

	min_duration = 60
	max_duration = 80

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		if(target_zone != "head")
			return

		var/obj/item/device/mmi/M = tool
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(!(affected && affected.open == 3))
			return 0

		if(!istype(M))
			return 0

		if(!M.brainmob || !M.brainmob.client || !M.brainmob.ckey || M.brainmob.stat >= DEAD)
			user << "<span class='danger'>That brain is not usable.</span>"
			return SURGERY_FAILURE

		if(!(affected.status & ORGAN_ROBOT))
			user << "<span class='danger'>You cannot install a computer brain into a meat skull.</span>"
			return SURGERY_FAILURE

		if(!target.species)
			user << "<span class='danger'>You have no idea what species this person is. Report this on the bug tracker.</span>"
			return SURGERY_FAILURE

		if(!target.species.has_organ["brain"])
			user << "<span class='danger'>You're pretty sure [target.species.name_plural] don't normally have a brain.</span>"
			return SURGERY_FAILURE

		if(!isnull(target.internal_organs["brain"]))
			user << "<span class='danger'>Your subject already has a brain.</span>"
			return SURGERY_FAILURE

		return 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts installing \the [tool] into [target]'s [affected.name].", \
		"You start installing \the [tool] into [target]'s [affected.name].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has installed \the [tool] into [target]'s [affected.name].</span>", \
		"<span class='notice'>You have installed \the [tool] into [target]'s [affected.name].</span>")

		var/obj/item/device/mmi/M = tool
		var/obj/item/organ/mmi_holder/holder = new(target, 1)
		target.internal_organs_by_name["brain"] = holder
		user.drop_from_inventory(tool)
		tool.loc = holder
		holder.stored_mmi = tool
		holder.update_from_mmi()

		if(M.brainmob && M.brainmob.mind)
			M.brainmob.mind.transfer_to(target)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips.</span>", \
		"<span class='warning'>Your hand slips.</span>")

//////////////////////////////////////////////////////////////////
//					ROBOTIC IMPLANT SURGERY						//
//////////////////////////////////////////////////////////////////
		
/datum/surgery_step/robotics/cavity
	priority = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == (affected.encased ? 3 : 2) && !(affected.status & ORGAN_BLEEDING) // robot check is handled in the base robotics surgery type

	proc/get_max_wclass(var/obj/item/organ/external/affected)
		switch (affected.name)
			if ("head")
				return 1
			if ("upper body")
				return 3
			if ("lower body")
				return 2
		return 0

	proc/get_cavity(var/obj/item/organ/external/affected)
		return affected.name // head compartment, upper body compartment, and lower body compartment work quite well for IPCs

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(CUT, 20)

/datum/surgery_step/robotics/cavity/place_item
	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			if(istype(user,/mob/living/silicon/robot))
				return
			if(affected && affected.open == (affected.encased ? 3 : 2)) // no need for special cavity code, we're all robots here. just check if the panel is open.
				var/total_volume = tool.w_class
				for(var/obj/item/I in affected.implants)
					if(istype(I,/obj/item/weapon/implant))
						continue
					total_volume += I.w_class
				return total_volume <= get_max_wclass(affected)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts putting \the [tool] inside [target]'s [get_cavity(affected)] compartment.", \
		"You start putting \the [tool] inside [target]'s [get_cavity(affected)] compartment." )
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

		user.visible_message("<span class='notice'>[user] puts \the [tool] inside [target]'s [get_cavity(affected)] compartment.</span>", \
		"<span class='notice'>You put \the [tool] inside [target]'s [get_cavity(affected)] compartment.</span>" )
		user.drop_item()
		affected.implants += tool
		tool.loc = affected

//////////////////////////////////////////////////////////////////
//					ROBOTIC IMPLANT/ITEM REMOVAL SURGERY		//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/robotics/cavity/implant_removal
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,	\
	/obj/item/weapon/wirecutters = 75,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 20
	)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/brain/sponge = target.internal_organs_by_name["brain"]
		return ..() && (!sponge || !sponge.damage)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts poking around inside [target]'s [affected.name] with \the [tool].", \
		"You start poking around inside [target]'s [affected.name] with \the [tool]" )
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

		var/find_prob = 0

		if (affected.implants.len)

			var/obj/item/obj = pick(affected.implants)

			if(istype(obj,/obj/item/weapon/implant))
				var/obj/item/weapon/implant/imp = obj
				if (imp.islegal())
					find_prob +=60
				else
					find_prob +=40
			else
				find_prob +=50

			if (prob(find_prob))
				user.visible_message("<span class='notice'>[user] takes something out of incision on [target]'s [affected.name] with \the [tool].</span>", \
				"<span class='notice'>You take [obj] out of incision on [target]'s [affected.name]s with \the [tool].</span>" )
				affected.implants -= obj

				BITSET(target.hud_updateflag, IMPLOYAL_HUD)

				//No need to handle borers, IPCs only.
				obj.loc = get_turf(target)
				obj.add_blood(target)
				obj.update_icon()
				if(istype(obj,/obj/item/weapon/implant))
					var/obj/item/weapon/implant/imp = obj
					imp.imp_in = null
					imp.implanted = 0
			else
				user.visible_message("<span class='notice'>[user] removes \the [tool] from [target]'s [affected.name].</span>", \
				"<span class='notice'>There's something inside [target]'s [affected.name], but you just missed it this time.</span>" )
		else
			user.visible_message("<span class='notice'>[user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out.</span>", \
			"<span class='notice'>You could not find anything inside [target]'s [affected.name].</span>" )

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		..()
		var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
		if (affected.implants.len)
			var/fail_prob = 10
			fail_prob += 100 - tool_quality(tool)
			if (prob(fail_prob))
				var/obj/item/weapon/implant/imp = affected.implants[1]
				user.visible_message("<span class='warning'>Something beeps inside [target]'s [affected.name]!</span>")
				playsound(imp.loc, 'sound/items/countdown.ogg', 75, 1, -3)
				addtimer(CALLBACK(imp, /obj/item/weapon/implant/.proc/activate), 25)