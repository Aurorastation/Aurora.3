/* SURGERY STEPS */

/singleton/surgery_step
	var/name
	var/priority = 0	//steps with higher priority would be attempted first

	/// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null
	/// type paths referencing races that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = list("Nymph")

	/// The amount of time (in seconds) required to perform this surgery, before any modifiers are applied.
	var/base_surgery_time = 5 SECONDS

	/// evil infection stuff that will make everyone hate me
	var/can_infect = FALSE
	/// How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0

	var/requires_surgery_compatibility = TRUE
	/// Whether this step may be performed on oneself while standing and away from an operating surface.
	var/standing_self_surgery = FALSE

	/**
	 * The associative list of skills and their paired requirement levels to be able to perform a given surgery.
	 * These are considered soft requirements, so if a surgery requires skill level 3 in something, and you're at level 1
	 * Then the surgery will take a penalty of twice the skill_diff_fail_modifier (30% by default).
	 * Exceeding the skill requirement can also offset having lower success rates from things like tools.
	 */
	var/alist/skill_requirements

	/// The bonus (or penalty) fail rate to a surgery per point of skill diff. As a percent chance.
	var/skill_diff_fail_modifier = SURGERY_DIFFICULTY_EASY

/// Returns how well tool is suited for this step.
/singleton/surgery_step/proc/tool_quality(obj/item/tool)
	for(var/T in allowed_tools)
		var/return_value = check_tool_quality(tool, T, allowed_tools[T], requires_surgery_compatibility)
		if(return_value)
			return return_value
		if(istype(tool,T))
			return allowed_tools[T]
	return FALSE

/** Returns the skills used for this step after user- and target-specific modifiers. */
/singleton/surgery_step/proc/get_skill_requirements(mob/living/user, mob/living/carbon/human/target)
	return skill_requirements

/**
 * Returns the skills used for this particular operation. Most steps use their
 * static requirements, but procedures that can cross organic and mechanical
 * anatomy may select a requirement from the patient state.
 *
 * preferred_skill_component is used by specialized planners to ask whether a
 * step can be performed using their skill. Live surgery leaves it unset.
 */
/singleton/surgery_step/proc/get_surgery_skill_requirements(mob/living/user, mob/living/carbon/human/target, target_zone, preferred_skill_component)
	var/list/effective_skill_requirements = get_skill_requirements(user, target)
	if(preferred_skill_component && (!effective_skill_requirements || isnull(effective_skill_requirements[preferred_skill_component])))
		return null
	return effective_skill_requirements

/** Selects one permitted skill, preferring the surgeon's strongest skill live. */
/singleton/surgery_step/proc/get_alternative_surgery_skill_requirements(mob/living/user, list/permitted_skills, required_level, preferred_skill_component)
	if(!length(permitted_skills))
		return null

	var/selected_skill
	if(preferred_skill_component)
		if(!(preferred_skill_component in permitted_skills))
			return null
		selected_skill = preferred_skill_component
	else
		var/best_level = -1
		for(var/skill_component in permitted_skills)
			var/skill_level = GET_SKILL_LEVEL(user, skill_component)
			if(isnull(skill_level))
				continue
			if(!selected_skill || skill_level > best_level)
				selected_skill = skill_component
				best_level = skill_level
		if(!selected_skill)
			selected_skill = permitted_skills[1]

	var/list/requirements = list()
	requirements[selected_skill] = required_level
	return requirements

/// Returns the time required to perform this step after step-specific user and target modifiers.
/singleton/surgery_step/proc/get_surgery_time(mob/living/user, mob/living/carbon/human/target)
	return base_surgery_time

/// Checks if this step applies to the user mob at all
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


/// Checks whether this step can be applied with the given user and target
/singleton/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return FALSE

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/canceled = FALSE
	SEND_SIGNAL(target, COMSIG_BEGIN_SURGERY, &canceled, affected, user, src)
	if(canceled)
		return FALSE

	return TRUE

/// Does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
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
	playsound(target.loc, tool.surgerysound, 50, TRUE)
	return TRUE

/// Does stuff to end the step, which is normally print a message + do whatever this step changes
/singleton/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return FALSE

/// Stuff that happens when the step fails
/singleton/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null

/proc/spread_germs_to_organ(var/obj/item/organ/external/E, var/mob/living/carbon/human/user)
	if(!istype(user) || !istype(E))
		return FALSE

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/proc/do_surgery(mob/living/carbon/M, mob/living/user, obj/item/tool, var/autofail = FALSE, var/standing_self_surgery_only = FALSE)
	// Check for the Hippocratic oath.
	if(!istype(M) || user.a_intent == I_HURT)
		return FALSE

	// Check for multi-surgery drifting.
	var/zone = user.zone_sel.selecting
	if(zone in M.op_stage.in_progress)
		to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		return TRUE

	//Check that one surgeon is not doing multiple surgeries at once
	for(var/surg in M.op_stage.in_progress)
		var/current_surgeon = M.op_stage.in_progress[surg]
		if(user == current_surgeon)
			to_chat(user, SPAN_WARNING("You can only focus on one surgery at a time!"))
			return TRUE

	// What surgeries does our tool/target enable?
	var/list/possible_surgeries
	var/is_surgery_tool = FALSE
	var/list/all_surgeries = GET_SINGLETON_SUBTYPE_MAP(/singleton/surgery_step)
	for(var/decl in all_surgeries)
		var/singleton/surgery_step/S = all_surgeries[decl]
		if(standing_self_surgery_only && !S.standing_self_surgery)
			continue
		if(!S.tool_quality(tool))
			continue
		is_surgery_tool = TRUE
		if(S.can_use(user, M, zone, tool))
			LAZYSET(possible_surgeries, S, TRUE)

	// Which surgery, if any, do we actually want to do?
	var/singleton/surgery_step/S
	if(LAZYLEN(possible_surgeries) == 1)
		S = possible_surgeries[1]
	else if(LAZYLEN(possible_surgeries) >= 1)
		if(user.client) // In case of future autodocs.
			S = tgui_input_list(user, "Which surgery would you like to perform?", "Surgery", possible_surgeries)

	// We didn't find a surgery, or decided not to perform one.
	if(!istype(S))
		if(standing_self_surgery_only)
			return FALSE
		var/can_repair_externally = FALSE
		if(user.a_intent == I_HELP && istype(tool, /obj/item/weldingtool) && ishuman(M))
			var/mob/living/carbon/human/human_target = M
			var/obj/item/organ/external/affected = human_target.get_organ(zone)
			can_repair_externally = affected?.status & ORGAN_ASSISTED
		var/normal_attack_is_harmful = tool.force && !(tool.item_flags & ITEM_FLAG_NO_BLUDGEON) && !can_repair_externally
		if((is_surgery_tool && normal_attack_is_harmful) || (tool.item_flags & ITEM_FLAG_SURGERY)) //Is this supposed to be used for surgery?
			to_chat(user, SPAN_WARNING("You aren't sure what you could do to \the [M] with \the [tool]."))
			return TRUE
		return FALSE //Just do the normal use for the tool instead
	// Otherwise we can make a start on surgery!
	if(istype(M) && !QDELETED(M) && tool)
		// Double-check this in case it changed between initial check and now.
		if(zone in M.op_stage.in_progress)
			to_chat(user, SPAN_WARNING("You can't operate on this area while surgery is already in progress."))
		else if(S.is_valid_target(M))
			M.op_stage.in_progress += list(zone = user)
			S.begin_step(user, M, zone, tool)

			// Get the base surgery time before modifiers.
			var/duration = S.get_surgery_time(user, M)

			// Get the base surgery success rate based on tools.
			// This should eventually be reworked to use ToolQualityComponents when we add that.
			var/success_rate = S.tool_quality(tool)

			// Query the surgeon if they have any components that would like to modify the success chance.
			SEND_SIGNAL(user, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, M, &success_rate, &duration)

			// Skill modifier checks
			var/list/effective_skill_requirements = S.get_surgery_skill_requirements(user, M, zone)
			for (var/skill_comp, required_level in effective_skill_requirements)
				var/skill_level = GET_SKILL_LEVEL(user, skill_comp)
				// Null condition handles NPCs and Antags that won't have the skill setup.
				if (!isnull(skill_level))
					success_rate += (skill_level - required_level) * S.skill_diff_fail_modifier
			// End of skill modifier checks

			if(prob(success_rate) && do_mob(user, M, duration) && !autofail)
				S.end_step(user, M, zone, tool)
			else if ((tool in user.contents) && user.Adjacent(M))
				S.fail_step(user, M, zone, tool)
			else
				to_chat(user, SPAN_WARNING("You must remain close to your patient to conduct surgery."))
			if(!QDELETED(M))
				M.op_stage.in_progress -= list(zone = user)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.update_surgery()
		return TRUE
	return TRUE

/datum/surgery_status
	var/eyes = 0
	var/face = 0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/list/in_progress = list()

/datum/surgery_status/Destroy(force)
	in_progress?.Cut()
	return ..()
