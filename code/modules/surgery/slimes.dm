//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/slime
	is_valid_target(mob/living/carbon/slime/target)
		return istype(target, /mob/living/carbon/slime/)

	can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		return target.stat == 2

/datum/surgery_step/slime/cut_flesh
	allowed_tools = list(
	/obj/item/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 10
	max_duration = 35

	can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		return ..() && istype(target) && target.core_removal_stage == 0

	begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts cutting through [target]'s flesh with \the [tool].", \
		"You start cutting through [target]'s flesh with \the [tool].")

	end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] cuts through [target]'s flesh with \the [tool].</span>",	\
		"<span class='notice'>You cut through [target]'s flesh with \the [tool], revealing its silky innards.</span>")
		target.core_removal_stage = 1

	fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s flesh with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, tearing [target]'s flesh with \the [tool]!</span>")

/datum/surgery_step/slime/cut_innards
	allowed_tools = list(
	/obj/item/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 20
	max_duration = 45

	can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		return ..() && istype(target) && target.core_removal_stage == 1

	begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts cutting [target]'s silky innards apart with \the [tool].", \
		"You start cutting [target]'s silky innards apart with \the [tool].")

	end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] cuts [target]'s innards apart with \the [tool], exposing the cores.</span>",	\
		"<span class='notice'>You cut [target]'s innards apart with \the [tool], exposing the cores.</span>")
		target.core_removal_stage = 2

	fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips, tearing [target]'s innards with \the [tool]!</span>", \
		"<span class='warning'>Your hand slips, tearing [target]'s innards with \the [tool]!</span>")

/datum/surgery_step/slime/saw_core
	allowed_tools = list(
	/obj/item/circular_saw = 100, \
	/obj/item/material/hatchet = 75
	)

	min_duration = 35
	max_duration = 55

	can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		return ..() && (istype(target) && target.core_removal_stage == 2 && target.cores > 0) //This is being passed a human as target, unsure why.

	begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts cutting out one of [target]'s cores with \the [tool].", \
		"You start cutting out one of [target]'s cores with \the [tool].")

	end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		target.cores--
		user.visible_message("<span class='notice'>[user] cuts out one of [target]'s cores with \the [tool].</span>",,	\
		"<span class='notice'>You cut out one of [target]'s cores with \the [tool]. [target.cores] cores left.</span>")

		if(target.cores >= 0)
			new target.coretype(target.loc)
		if(target.cores <= 0)
			target.icon_state = "[target.colour] baby slime dead-nocore"


	fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'>[user]'s hand slips, causing \him to miss the core!</span>", \
		"<span class='warning'>Your hand slips, causing you to miss the core!</span>")
