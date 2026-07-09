/obj/item/organ/internal/augment/bioaug/mind_blanker
	name = "mind blanker"
	desc = "A small, discrete organ attached near the base of the brainstem." \
		+ "Any attempt to read the mind of an individual with this augment installed will fail, as will attempts at psychic brainwashing."
	icon_state = "mind_blanker"
	organ_tag = BP_AUG_MIND_BLANKER
	parent_organ = BP_HEAD
	var/sensitivity_modifier = -1

	/// The message randomly given while under the effect of the drug
	var/ongoing_effect_message = list("Everything feels dulled and distant.", "You feel like you can't focus on anything.", "Your thoughts feel sluggish.", "Why should you care about others?", "You struggle to remember what you were just thinking.", "You cannot bring yourself to care.", "Other people's emotions seem tedious.", "You have trouble recalling why this mattered to you.", "Nothing seems urgent anymore.", "You feel detached from your surroundings.", "Your mind feels wrapped in a thick fog.", "Everyone seem less real.", "The world feels insulated.", "Why was it this mattered to you again?", "Everything seems so quiet.", "For a moment, it feels like there is a faint hum.")

	/// Time until the next ongoing message
	var/next_message = 0

/obj/item/organ/internal/augment/bioaug/mind_blanker/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)
	RegisterSignal(owner, COMSIG_GET_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_empathy), override = TRUE)
	RegisterSignal(owner, COMSIG_RECEIVE_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_receiving), override = TRUE)
	RegisterSignal(owner, COMSIG_GET_LEADERSHIP_MODIFIERS, PROC_REF(modify_leadership_empathy), override = TRUE)

	/// This lasts all round, so lets make it less frequent. Estimated frequency: every 2 min
	next_message = REALTIMEOFDAY + (DRUG_MESSAGE_COOLDOWN * 4)

/obj/item/organ/internal/augment/bioaug/mind_blanker/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)
	RegisterSignal(owner, COMSIG_GET_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_empathy), override = TRUE)
	RegisterSignal(owner, COMSIG_RECEIVE_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_receiving), override = TRUE)
	RegisterSignal(owner, COMSIG_GET_LEADERSHIP_MODIFIERS, PROC_REF(modify_leadership_empathy), override = TRUE)

/obj/item/organ/internal/augment/bioaug/mind_blanker/removed()
	if(!owner)
		return ..()

	UnregisterSignal(owner, COMSIG_PSI_MIND_POWER)
	UnregisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY)
	UnregisterSignal(owner, COMSIG_GET_MINISTRY_MODIFIERS)
	UnregisterSignal(owner, COMSIG_RECEIVE_MINISTRY_MODIFIERS)
	UnregisterSignal(owner, COMSIG_GET_LEADERSHIP_MODIFIERS)
	return ..()

/obj/item/organ/internal/augment/bioaug/mind_blanker/process(seconds_per_tick)
	. = ..()
	if(REALTIMEOFDAY >= next_message)
		if(!length(ongoing_effect_message))
			next_message = (REALTIMEOFDAY + 2 HOURS)
			return
		var/message = pick(ongoing_effect_message)
		to_chat(owner, SPAN_NOTICE("[message]"))
		if(prob(20))
			owner.play_screen_text("[message]", /atom/movable/screen/text/screen_text/mental_message, COLOR_TEAL)
		next_message = (REALTIMEOFDAY + DRUG_MESSAGE_COOLDOWN * 4)

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/cancel_power(implantee, caster, cancelled, cancel_return, wide_field)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*cancelled = TRUE
	if(wide_field || implantee == caster)
		return

	to_chat(implantee, SPAN_DANGER("Your mind wriggles as it repulses an outside thought."))

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/modify_sensitivity(implantee, effective_sensitivity)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*effective_sensitivity += sensitivity_modifier

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/modify_ministry_empathy(minister, ministree, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(minister, SPAN_BAD("Why should you care how [ministree] feels?"))
	*moodlet_value = *moodlet_value * 0.5

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/modify_ministry_receiving(ministree, minister, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(ministree, SPAN_BAD("You feel nothing from [minister]'s words."))
	*moodlet_value = *moodlet_value * 0.5

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/modify_leadership_empathy(leader, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(leader, SPAN_BAD("Why should you care about how others feel?"))
	*moodlet_value = *moodlet_value * 0.5

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal
	name = "lethal mind blanker"
	desc = "A small, discrete organ attached near the base of the brainstem." \
		+ "Available only to higher-up MfAS agents and members of the Galatean government." \
		+ "This enhanced variant of a mind blanker includes a psionic trap which inflicts severe neural damage on anyone attempting to read the user's mind."
	organ_tag = BP_AUG_MIND_BLANKER_L
	parent_organ = BP_HEAD
	var/sensitivity_modifier = -1

	/// The message randomly given while under the effect of the drug
	var/ongoing_effect_message = list("Everything feels dulled and distant.", "You feel like you can't focus on anything.", "Your thoughts feel sluggish.", "Why should you care about others?", "You struggle to remember what you were just thinking.", "You cannot bring yourself to care.", "Other people's emotions seem tedious.", "You have trouble recalling why this mattered to you.", "Nothing seems urgent anymore.", "You feel detached from your surroundings.", "Your mind feels wrapped in a thick fog.", "Everyone seem less real.", "The world feels insulated.", "Why was it this mattered to you again?", "Everything seems so quiet.", "For a moment, it feels like there is a faint hum.")

	/// Time until the next ongoing message
	var/next_message = 0

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power_lethal), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

	/// This lasts all round, so lets make it less frequent. Estimated frequency: every 2 min
	next_message = REALTIMEOFDAY + (DRUG_MESSAGE_COOLDOWN * 4)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/process(seconds_per_tick)
	. = ..()
	if(REALTIMEOFDAY >= next_message)
		if(!length(ongoing_effect_message))
			next_message = (REALTIMEOFDAY + 2 HOURS)
			return
		var/message = pick(ongoing_effect_message)
		to_chat(owner, SPAN_NOTICE("[message]"))
		if(prob(20))
			owner.play_screen_text("[message]", /atom/movable/screen/text/screen_text/mental_message, COLOR_TEAL)
		next_message = (REALTIMEOFDAY + DRUG_MESSAGE_COOLDOWN * 3)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power_lethal), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_PSI_MIND_POWER)
	UnregisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/proc/cancel_power_lethal(mob/living/carbon/human/implantee, caster, cancelled, cancel_return, wide_field)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*cancelled = TRUE
	if(wide_field || implantee == caster)
		return

	to_chat(implantee, SPAN_DANGER("Your mind wriggles as it repulses an outside thought."))
	if(isliving(caster))
		var/mob/living/victim = caster
		victim.adjustBrainLoss(20)
		victim.confused += 20
		*cancel_return = SPAN_DANGER("Agony lances through my brain as their mind clamps down upon me!")

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/proc/modify_sensitivity(implantee, effective_sensitivity)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*effective_sensitivity += sensitivity_modifier
