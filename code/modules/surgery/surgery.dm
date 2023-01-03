/* SURGERY STEPS */

/singleton/surgery_step
	var/name
	var/priority = 0	//steps with higher priority would be attempted first

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null
	// type paths referencing races that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = list("Nymph")

	// duration of the step
	var/min_duration = 0
	var/max_duration = 0

	// evil infection stuff that will make everyone hate me
	var/can_infect = FALSE
	//How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

	var/requires_surgery_compatibility = TRUE

	//returns how well tool is suited for this step
/singleton/surgery_step/proc/tool_quality(obj/item/tool)
	for(var/T in allowed_tools)
		var/return_value = check_tool_quality(tool, T, allowed_tools[T], requires_surgery_compatibility)
		if(return_value)
			return return_value
		if(istype(tool,T))
			return allowed_tools[T]
	return FALSE

	// Checks if this step applies to the user mob at all
/singleton/surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
	if(!ishuman(target))
		return FALSE

	if(allowed_species)
		for(var/species in allowed_species)
			if(target.species.get_bodytype() == species)
				return TRUE

	if(disallowed_species)
		for(var/species in disallowed_species)
			if(target.species.get_bodytype() == species)
				return FALSE

	return TRUE


// checks whether this step can be applied with the given user and target
/singleton/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return FALSE
	return TRUE

// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/singleton/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(can_infect && affected)
		spread_germs_to_organ(affected, user)
	if(ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if(blood_level)
			H.bloody_hands(target,0)
		if(blood_level > 1)
			H.bloody_body(target,0)
	return

// does stuff to end the step, which is normally print a message + do whatever this step changes
/singleton/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return FALSE

// stuff that happens when the step fails
/singleton/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null

proc/spread_germs_to_organ(var/obj/item/organ/external/E, var/mob/living/carbon/human/user)
	if(!istype(user) || !istype(E))
		return FALSE

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/proc/do_surgery(mob/living/carbon/M, mob/living/user, obj/item/tool, var/autofail = FALSE)
	// Check for the Hippocratic oath.
	if(!istype(M) || user.a_intent == I_HURT)
		return FALSE

	var/static/list/safety_check_exceptions = list(
		/obj/item/auto_cpr,
		/obj/item/device/healthanalyzer,
		/obj/item/modular_computer,
		/obj/item/reagent_containers,
		/obj/item/device/advanced_healthanalyzer,
		/obj/item/device/robotanalyzer,
		/obj/item/stack/medical,
		/obj/item/stack/nanopaste,
		/obj/item/device/breath_analyzer,
		/obj/item/personal_inhaler,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/autopsy_scanner,
		/obj/item/grab
		)
	// Check for multi-surgery drifting.
	var/zone = user.zone_sel.selecting
	if(zone in M.op_stage.in_progress)
		to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		return TRUE

	// What surgeries does our tool/target enable?
	var/list/possible_surgeries
	var/list/all_surgeries = Singletons.GetSubtypeList(/singleton/surgery_step)
	for(var/decl in all_surgeries)
		var/singleton/surgery_step/S = all_surgeries[decl]
		if(S.tool_quality(tool) && S.can_use(user, M, zone, tool))
			LAZYSET(possible_surgeries, S, TRUE)

	// Which surgery, if any, do we actually want to do?
	var/singleton/surgery_step/S
	if(LAZYLEN(possible_surgeries) == 1)
		S = possible_surgeries[1]
	else if(LAZYLEN(possible_surgeries) >= 1)
		if(user.client) // In case of future autodocs.
			S = input(user, "Which surgery would you like to perform?", "Surgery") as null|anything in possible_surgeries

	// We didn't find a surgery, or decided not to perform one.
	if(!istype(S))
		if(is_type_in_list(tool, safety_check_exceptions))
			return FALSE//These tools are safe to bypass hippocratic oath
		to_chat(user, SPAN_WARNING("You aren't sure what you could do to \the [M] with \the [tool]."))
		return TRUE

	// Otherwise we can make a start on surgery!
	else if(istype(M) && !QDELETED(M) && tool)
		// Double-check this in case it changed between initial check and now.
		if(zone in M.op_stage.in_progress)
			to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		else if(S.is_valid_target(M))
			M.op_stage.in_progress += zone
			S.begin_step(user, M, zone, tool)
			var/duration = rand(S.min_duration, S.max_duration)
			if(prob(S.tool_quality(tool)) && do_mob(user, M, duration))
				S.end_step(user, M, zone, tool)
			else if ((tool in user.contents) && user.Adjacent(M))
				S.fail_step(user, M, zone, tool)
			else
				to_chat(user, SPAN_WARNING("You must remain close to your patient to conduct surgery."))
			if(!QDELETED(M))
				M.op_stage.in_progress -= zone
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.update_surgery()
		return TRUE
	return TRUE

/datum/surgery_status/
	var/eyes	=	0
	var/face	=	0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/list/in_progress = list()
