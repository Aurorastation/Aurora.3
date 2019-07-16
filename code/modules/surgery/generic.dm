//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic/
	can_infect = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (isslime(target))
			return 0
		if (target_zone == "eyes")	//there are specific steps for eye surgery
			return 0
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0
		if (affected.is_stump())
			return 0
		if (affected.status & ORGAN_ROBOT)
			return 0
		return 1

/datum/surgery_step/generic/cut_with_laser
	allowed_tools = list(
	/obj/item/weapon/scalpel/laser3 = 95, \
	/obj/item/weapon/scalpel/laser2 = 85, \
	/obj/item/weapon/scalpel/laser1 = 75, \
	//Removed energy sword from here. with a 5% chance of success, it's a feature nobody ever used anyway
	//Energy swords amputate instead now
	)
	priority = 2
	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open == 0 && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].", \
		"You start the bloodless incision on [target]'s [affected.name] with \the [tool].")
		target.custom_pain("You feel a horrible, searing pain in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>",)
		//Could be cleaner ...
		affected.open = 1

		if(istype(target) && !(target.species.flags & NO_BLOOD))
			affected.status |= ORGAN_BLEEDING
		playsound(target.loc, 'sound/weapons/bladeslice.ogg', 50, 1)

		affected.createwound(CUT, 1)
		affected.clamp()
		spread_germs_to_organ(affected, user)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(CUT, 7.5)
		affected.createwound(BURN, 12.5)

/datum/surgery_step/generic/incision_manager
	allowed_tools = list(
	/obj/item/weapon/scalpel/manager = 100
	)
	priority = 2
	min_duration = 80
	max_duration = 120

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open == 0 && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].", \
		"You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].")
		target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>",)
		affected.open = 1

		if(istype(target) && !(target.species.flags & NO_BLOOD))
			affected.status |= ORGAN_BLEEDING

		affected.createwound(CUT, 1)
		affected.clamp()
		affected.open = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(CUT, 20)
		affected.createwound(BURN, 15)

/datum/surgery_step/generic/cut_open
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,
	/obj/item/weapon/material/knife = 75,
	/obj/item/weapon/material/shard = 50
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(isvaurca(target))
			return 0
		else
			if(..())
				var/obj/item/organ/external/affected = target.get_organ(target_zone)
				return affected && affected.open == 0 && target_zone != "mouth"


	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts the incision on [target]'s [affected.name] with \the [tool].", \
		"You start the incision on [target]'s [affected.name] with \the [tool].")
		target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has made an incision on [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have made an incision on [target]'s [affected.name] with \the [tool].</span>",)
		affected.open = 1

		if(istype(target) && !(target.species.flags & NO_BLOOD))
			affected.status |= ORGAN_BLEEDING

		affected.createwound(CUT, 1)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</span>")
		affected.createwound(CUT, 10)

/datum/surgery_step/generic/cut_openvaurca
	allowed_tools = list(
	/obj/item/weapon/surgicaldrill = 85,
	/obj/item/weapon/pickaxe/ = 15
	)

	min_duration = 110
	max_duration = 130

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(!(isvaurca(target)))
			return 0
		else
			if(..())
				var/obj/item/organ/external/affected = target.get_organ(target_zone)
				return affected && affected.open == 0 && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts drilling into [target]'s [affected.name] carapace with \the [tool].", \
		"You start drilling into [target]'s [affected.name] carapace with \the [tool].")
		target.custom_pain("You feel a horrible pain as if from a jackhammer in your [affected.name]!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has drilled into [target]'s [affected.name] carapace with \the [tool].</span>", \
		"<span class='notice'>You have drilled into [target]'s [affected.name] carapace with \the [tool].</span>",)
		affected.open = 1

		if(istype(target) && !(target.species.flags & NO_BLOOD))
			affected.status |= ORGAN_BLEEDING

		affected.createwound(CUT, 1)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, cracking [target]'s [affected.name] carapace in the wrong place with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, cracking [target]'s [affected.name] carapace in the wrong place with \the [tool]!</span>")
		affected.createwound(CUT, 15)

/datum/surgery_step/generic/clamp_bleeders
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100,	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 20
	)

	min_duration = 40
	max_duration = 60

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open && (affected.status & ORGAN_BLEEDING)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].", \
		"You start clamping bleeders in [target]'s [affected.name] with \the [tool].")
		target.custom_pain("The pain in your [affected.name] is maddening!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] clamps bleeders in [target]'s [affected.name] with \the [tool].</span>",	\
		"<span class='notice'>You clamp bleeders in [target]'s [affected.name] with \the [tool].</span>")
		affected.clamp()
		spread_germs_to_organ(affected, user)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",	\
		"<span class='warning'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",)
		affected.createwound(CUT, 10)

/datum/surgery_step/generic/retract_skin
	allowed_tools = list(
	/obj/item/weapon/retractor = 100, 	\
	/obj/item/weapon/crowbar = 75,	\
	/obj/item/weapon/material/kitchen/utensil/fork = 50
	)

	min_duration = 30
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open == 1 //&& !(affected.status & ORGAN_BLEEDING)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		var/msg = "[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool]."
		var/self_msg = "You start to pry open the incision on [target]'s [affected.name] with \the [tool]."
		if (target_zone == "chest")
			msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
			self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		if (target_zone == "groin")
			msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
			self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		user.visible_message(msg, self_msg)
		target.custom_pain("It feels like the skin on your [affected.name] is on fire!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		var/msg = "<span class='notice'>[user] keeps the incision open on [target]'s [affected.name] with \the [tool].</span>"
		var/self_msg = "<span class='notice'>You keep the incision open on [target]'s [affected.name] with \the [tool].</span>"
		if (target_zone == "chest")
			msg = "<span class='notice'>[user] keeps the ribcage open on [target]'s torso with \the [tool].</span>"
			self_msg = "<span class='notice'>You keep the ribcage open on [target]'s torso with \the [tool].</span>"
		if (target_zone == "groin")
			msg = "<span class='notice'>[user] keeps the incision open on [target]'s lower abdomen with \the [tool].</span>"
			self_msg = "<span class='notice'>You keep the incision open on [target]'s lower abdomen with \the [tool].</span>"
		user.visible_message(msg, self_msg)
		affected.open = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		var/msg = "<span class='warning'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>"
		var/self_msg = "<span class='warning'>Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>"
		if (target_zone == "chest")
			msg = "<span class='warning'>[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!</span>"
			self_msg = "<span class='warning'>Your hand slips, damaging several organs in [target]'s torso with \the [tool]!</span>"
		if (target_zone == "groin")
			msg = "<span class='warning'>[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]</span>"
			self_msg = "<span class='warning'>Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</span>"
		user.visible_message(msg, self_msg)
		target.apply_damage(12, BRUTE, affected, sharp=1)

/datum/surgery_step/generic/cauterize
	//Fixed these tool probabilities because they were dumb
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,
	/obj/item/clothing/mask/smokable/cigarette = 25,
	/obj/item/weapon/flame/lighter = 50,
	/obj/item/weapon/weldingtool = 75
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/organ/external/affected = target.get_organ(target_zone)
			return affected && affected.open && target_zone != "mouth"

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("[user] is beginning to cauterize the incision on [target]'s [affected.name] with \the [tool]." , \
		"You are beginning to cauterize the incision on [target]'s [affected.name] with \the [tool].")
		target.custom_pain("Your [affected.name] is being burned!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] cauterizes the incision on [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You cauterize the incision on [target]'s [affected.name] with \the [tool].</span>")
		affected.open = 0
		affected.germ_level = 0
		affected.status &= ~ORGAN_BLEEDING

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</span>")
		target.apply_damage(3, BURN, affected)

/datum/surgery_step/generic/amputate
	allowed_tools = list(
	/obj/item/weapon/circular_saw = 100,
	/obj/item/weapon/melee/energy = 100,
	/obj/item/weapon/melee/chainsword = 100,
	/obj/item/weapon/material/hatchet = 55
	)

	min_duration = 110
	max_duration = 160

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (target_zone == "eyes")	//there are specific steps for eye surgery
			return 0
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected == null)
			return 0

		if (istype(tool, /obj/item/weapon/melee/energy))
			var/obj/item/weapon/melee/energy/E = tool
			if (!E.active)
				to_chat(user, "<span class='warning'>The energy blade is not turned on!</span>")
				return 0

		if (istype(tool, /obj/item/weapon/melee/chainsword))
			var/obj/item/weapon/melee/chainsword/E = tool
			if (!E.active)
				to_chat(user, "<span class='warning'>The blades aren't spinning, you can't cut anything!</span>")
				return 0

		return !affected.cannot_amputate

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)

		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user] is beginning to amputate [target]'s [affected.name] with \the [tool].</span>" , \
		"<span class='danger'>You begin to cut through [target]'s [affected.amputation_point] with \the [tool].</span>")
		target.custom_pain("Your [affected.amputation_point] is being ripped apart!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool].</span>", \
		"<span class='danger'>You amputate [target]'s [affected.name] with \the [tool].</span>")

		var/clean = 1
		if (istype(tool, /obj/item/weapon/melee/chainsword))//Chainswords rip and tear, so the limb removal is not clean
			clean = 0

		var/var/obj/item/organ/external/parent = affected.parent//Cache the parent organ of the limb before we sever it
		affected.droplimb(clean,DROPLIMB_EDGE)

		if (istype(tool, /obj/item/weapon/melee/energy))//Code for energy weapons cauterising the cut
			spawn(1)
				affected = parent
				affected.open = 0//Close open wounds
				for (var/datum/wound/lost_limb/W in affected.wounds)
					W.disinfected = 1//Cleanse the wound of any germs
					W.autoheal_cutoff = INFINITY//Allow the wound to auto-heal, regardless of damage
					W.max_bleeding_stage = 0//Stop bleeding

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='warning'>[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!</span>")
		affected.createwound(CUT, 30)
		affected.fracture()
