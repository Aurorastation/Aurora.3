//////////////////////////////////////////////////////////////////
//				SLIME CORE EXTRACTION							//
//////////////////////////////////////////////////////////////////

/decl/surgery_step/slime/is_valid_target(mob/living/carbon/slime/target)
	return istype(target, /mob/living/carbon/slime/)

/decl/surgery_step/slime/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	SHOULD_CALL_PARENT(FALSE)
	return isslime(target) && target.stat == DEAD

/decl/surgery_step/slime/cut_flesh
	name = "Open Slime"
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 10
	max_duration = 35

/decl/surgery_step/slime/cut_flesh/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == ORGAN_CLOSED

/decl/surgery_step/slime/cut_flesh/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting through [target]'s flesh with \the [tool].", \
		"You start cutting through [target]'s flesh with \the [tool].")

/decl/surgery_step/slime/cut_flesh/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] cuts through [target]'s flesh with \the [tool]."),	\
		SPAN_NOTICE("You cut through [target]'s flesh with \the [tool], revealing its silky innards."))
	target.core_removal_stage = ORGAN_OPEN_INCISION

/decl/surgery_step/slime/cut_flesh/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing [target]'s flesh with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, tearing [target]'s flesh with \the [tool]!"))

/decl/surgery_step/slime/cut_innards
	name = "Cut Innards"
	allowed_tools = list(
	/obj/item/surgery/scalpel = 100,
	/obj/item/material/knife = 75,
	/obj/item/material/shard = 50
	)

	min_duration = 20
	max_duration = 45

/decl/surgery_step/slime/cut_innards/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && istype(target) && target.core_removal_stage == ORGAN_OPEN_INCISION

/decl/surgery_step/slime/cut_innards/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting [target]'s silky innards apart with \the [tool].", \
		"You start cutting [target]'s silky innards apart with \the [tool].")

/decl/surgery_step/slime/cut_innards/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_NOTICE("[user] cuts [target]'s innards apart with \the [tool], exposing the cores."),	\
		SPAN_NOTICE("You cut [target]'s innards apart with \the [tool], exposing the cores."))
	target.core_removal_stage = ORGAN_OPEN_RETRACTED

/decl/surgery_step/slime/cut_innards/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, tearing [target]'s innards with \the [tool]!"), \
		SPAN_WARNING("Your hand slips, tearing [target]'s innards with \the [tool]!"))

/decl/surgery_step/slime/saw_core
	name = "Detach core"
	allowed_tools = list(
	/obj/item/surgery/circular_saw = 100, \
	/obj/item/material/hatchet = 75
	)

	min_duration = 35
	max_duration = 55

/decl/surgery_step/slime/saw_core/can_use(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	return ..() && (istype(target) && target.core_removal_stage == ORGAN_OPEN_RETRACTED && target.cores > 0) //This is being passed a human as target, unsure why.

/decl/surgery_step/slime/saw_core/begin_step(mob/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts cutting out one of [target]'s cores with \the [tool].", \
		"You start cutting out one of [target]'s cores with \the [tool].")

/decl/surgery_step/slime/saw_core/end_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	target.cores--
	user.visible_message(SPAN_NOTICE("[user] cuts out one of [target]'s cores with \the [tool]."),,	\
		SPAN_NOTICE("You cut out one of [target]'s cores with \the [tool]. [target.cores] cores left."))

	if(target.cores >= 0)
		new target.coretype(target.loc)
	if(target.cores < 0)
		target.icon_state = "[target.colour] baby slime dead-nocore"


/decl/surgery_step/slime/saw_core/fail_step(mob/living/user, mob/living/carbon/slime/target, target_zone, obj/item/tool)
	user.visible_message(SPAN_WARNING("[user]'s hand slips, causing \him to miss the core!"), \
		SPAN_WARNING("Your hand slips, causing you to miss the core!"))