#define RISK_LOW list("You feel like you can't focus on anything.", "Why should you care about others?", "You cannot bring yourself to care.", "Other people's emotions seem tedious.", "Nothing seems urgent anymore.", "You feel your attention drifting.", "It is difficult to hold onto a feeling.", "Why was it you were concerned again?", "You feel your attention wandering.", "Everyone seems too worried.", "Everything feels muffled.")

#define RISK_MEDIUM list("Everything feels dulled and distant.", "Your thoughts feel sluggish.", "You struggle to remember what you were just thinking.", "You have trouble recalling why this mattered to you.", "Your mind feels wrapped in a thick fog.", "Why was it that this mattered to you again?", "Your thoughts feel distant from you.", "What was it you were feeling again?", "You lose track of what you meant to say.", "Everything feels numb.", "What was it you were doing again?")

#define RISK_HIGH list("You feel detached from your surroundings.", "Everyone seems less real.", "The world feels insulated.", "Everything seems so quiet.", "For a moment, it feels like there is a faint hum.", "The people around you seem indistinct.", "The quiet feels thicker than before.", "The world feels distant and muffled.", "Your thoughts seem to vanish before you can finish them.", "You cannot remember how long you have been standing here.", "You feel strangely absent for a moment.", "There was something important... What was it again?", "The world around you feels artificial.", "You feel disconnected from your actions.", "How did you get here again?", "Something feels like it is missing from you.")

/datum/component/timed_life/psiblock_drugs
	/// Typecasted parent of this component.
	var/mob/living/carbon/human/owner

	/// The set of messages to choose from when this drug is first taken.
	var/initial_effect_message_list = list("Everything feels dulled and distant.", "You feel like you can't focus on anything.", "Your thoughts feel sluggish.", "Why should you care about others?")

	/// The set of messages to choose from when this drug wears off.
	var/removal_message_list = list("You feel more sensitive to your surroundings.", "Your thoughts feel clearer.", "You feel more aware of others around you.", "You can focus better.")

	/// How much this drug modifies the user's psi sensitivity.
	var/psi_sensitivity_modifier = -1

	/// The percent chance that this drug will cancel a psionic power when the user is targeted by one.
	var/telepathy_cancel_probability = 95

/datum/component/timed_life/psiblock_drugs/Initialize(lifetime_seconds = 5 MINUTES)
	. = ..()
	if (!parent)
		return

	owner = ashuman(parent)

	if (length(initial_effect_message_list))
		to_chat(parent, SPAN_NOTICE(pick(initial_effect_message_list)))

	RegisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)
	RegisterSignal(parent, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_empathy), override = TRUE)
	RegisterSignal(parent, COMSIG_RECEIVE_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_receiving), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_LEADERSHIP_MODIFIERS, PROC_REF(modify_leadership_empathy), override = TRUE)

/datum/component/timed_life/psiblock_drugs/Destroy()
	owner = null
	if (!parent)
		return ..()

	// This is here and not on the reagent because the reagent's duration is handled by this component rather than metabolism.
	// If the parent is being deleted, then there's no need to send a message about the drug wearing off.
	if (!QDELING(parent) && length(removal_message_list))
		to_chat(parent, SPAN_NOTICE(pick(removal_message_list)))

	UnregisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY)
	UnregisterSignal(parent, COMSIG_PSI_MIND_POWER)
	UnregisterSignal(parent, COMSIG_GET_MINISTRY_MODIFIERS)
	UnregisterSignal(parent, COMSIG_RECEIVE_MINISTRY_MODIFIERS)
	UnregisterSignal(parent, COMSIG_GET_LEADERSHIP_MODIFIERS)
	return ..()

/datum/component/timed_life/psiblock_drugs/proc/modify_sensitivity(parent, effective_sensitivity)
	SIGNAL_HANDLER

	*effective_sensitivity = *effective_sensitivity + psi_sensitivity_modifier

/datum/component/timed_life/psiblock_drugs/proc/cancel_power(parent, caster, cancelled, cancel_return, wide_field)
	SIGNAL_HANDLER
	if (prob(telepathy_cancel_probability))
		*cancelled = TRUE

/datum/component/timed_life/psiblock_drugs/proc/modify_ministry_empathy(minister, ministree, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(minister, SPAN_BAD("Why should you care how [ministree] feels?"))
	*moodlet_value = *moodlet_value * 0.5

/datum/component/timed_life/psiblock_drugs/proc/modify_ministry_receiving(ministree, minister, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(ministree, SPAN_BAD("You feel nothing from [minister]'s words."))
	*moodlet_value = *moodlet_value * 0.5

/datum/component/timed_life/psiblock_drugs/proc/modify_leadership_empathy(leader, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(leader, SPAN_BAD("Why should you care about how others feel?"))
	*moodlet_value = *moodlet_value * 0.5

// Variants of psiblocking drugs
/datum/component/timed_life/psiblock_drugs/yomi_genetics
	/// The next time (in real life seconds) that a hand tremor will occur.
	var/next_tremor_time = 0

	/// The minimum time between hand tremors, in real life seconds.
	var/min_tremor_time = 1 MINUTE

	/// The maximum time between hand tremors, in real life seconds.
	var/max_tremor_time = 3 MINUTES

	/// The next time (in real life seconds) that a seizure will occur.
	var/next_seizure_time = 0

	/// The minimum time between seizures, in real life seconds.
	var/min_seizure_time = 9 MINUTES + 30 SECONDS

	/// The maximum time between seizures, in real life seconds.
	var/max_seizure_time = 2 HOURS // Intentionally far greater than the actual duration, seizures are meant to be rare.

	/// The penalty to accuracy for gun attacks due to hand tremors.
	var/accuracy_penalty = 0.25

	/// The penalty to dispersion for gun attacks due to hand tremors.
	var/dispersion_penalty = 5

	/// The penalty to surgery success chance due to hand tremors.
	var/surgery_success_penalty = -10

	/// The intensity of the seizures
	var/seizure_intensity = 1

	/// The time until the seizure after the warning
	var/seizure_warning_delay = 20 SECONDS

	/// The time until the next message
	var/next_message = 0

	/// The delay between messages, to avoid spamming the player
	var/message_delay = 30 SECONDS

	var/next_drug_message = 1 MINUTE

	/// The message randomly given while under the effect of the drug. It should preferably be set in initialize
	var/ongoing_effect_message = list(
		"Everything feels dulled and distant.",
		"You feel like you can't focus on anything.",
		"Your thoughts feel sluggish.",
		"Why should you care about others?",
		"You struggle to remember what you were just thinking.",
		"You cannot bring yourself to care.",
		"Other people's emotions seem tedious.",
		"You have trouble recalling why this mattered to you.",
		"Nothing seems urgent anymore.",
		"You feel detached from your surroundings.",
		"Your mind feels wrapped in a thick fog.",
		"Everyone seems less real.",
		"The world feels insulated.",
		"Why was it that this mattered to you again?",
		"Everything seems so quiet.",
		"For a moment, it feels like there is a faint hum.",
		"Your thoughts feel distant from you.",
		"It is difficult to hold onto a feeling.",
		"Why was it you were concerned again?",
		"You feel your attention drifting.",
		"The people around you seem indistinct.",
		"The quiet feels thicker than before.",
		"What was it you were feeling again?",
		"The world feels distant and muffled."
	)

	var/list/seizure_warning_messages = list(
		"A powerful metallic taste suddenly floods your mouth.",
		"You briefly smell something burning.",
		"An overpowering chemical taste fills your mouth.",
		"The air suddenly smells sickeningly sweet.",
		"A wave of nausea rises abruptly through your stomach."
	)

/datum/component/timed_life/psiblock_drugs/yomi_genetics/Initialize(lifetime_seconds = 5 MINUTES)
	. = ..()
	next_tremor_time = REALTIMEOFDAY + rand(min_tremor_time, max_tremor_time)
	next_seizure_time = REALTIMEOFDAY + rand(min_seizure_time, max_seizure_time)

	next_message = REALTIMEOFDAY + message_delay
	// A little slower than normal. Estimated frequency: 1 min
	next_drug_message = REALTIMEOFDAY + (DRUG_MESSAGE_COOLDOWN * 2)

	// Some skill check penalties related to hand tremors. Tremors give a small penalty to some skill checks.
	RegisterSignal(parent, COMSIG_BEFORE_GUN_FIRE, PROC_REF(check_tremor_gun), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(check_tremor_surgery), override = TRUE)

	ongoing_effect_message = RISK_LOW + RISK_MEDIUM

/datum/component/timed_life/psiblock_drugs/yomi_genetics/Destroy()
	UnregisterSignal(parent, COMSIG_BEFORE_GUN_FIRE)
	UnregisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	return ..()

/datum/component/timed_life/psiblock_drugs/yomi_genetics/proc/check_tremor_gun(mob/shooter, accuracy_decrease, dispersion_increase)
	SIGNAL_HANDLER
	*accuracy_decrease = *accuracy_decrease + accuracy_penalty
	*dispersion_increase = *dispersion_increase + dispersion_penalty

/datum/component/timed_life/psiblock_drugs/yomi_genetics/proc/check_tremor_surgery(mob/living/user, success_rate)
	SIGNAL_HANDLER
	*success_rate = *success_rate + surgery_success_penalty

/datum/component/timed_life/psiblock_drugs/yomi_genetics/process(seconds_per_tick)
	. = ..()
	if(REALTIMEOFDAY >= next_tremor_time && REALTIMEOFDAY >= next_message)
		owner.visible_message(
			SPAN_NOTICE("[owner]'s hand shakes..."),
			SPAN_NOTICE("Your hand shakes...")
		)
		next_tremor_time = REALTIMEOFDAY + rand(min_tremor_time, max_tremor_time)
		next_message = REALTIMEOFDAY + message_delay

	if(REALTIMEOFDAY >= next_drug_message && REALTIMEOFDAY >= next_message)
		if(!length(ongoing_effect_message))
			next_message = (REALTIMEOFDAY + 2 HOURS)
			return
		var/message = pick(ongoing_effect_message)
		to_chat(owner, SPAN_NOTICE("[message]"))
		next_drug_message = REALTIMEOFDAY + (DRUG_MESSAGE_COOLDOWN * 2)
		next_message = REALTIMEOFDAY + message_delay

	if(REALTIMEOFDAY >= next_seizure_time)
		begin_seizure_warning()
		next_seizure_time = REALTIMEOFDAY + rand(min_seizure_time, max_seizure_time)

/datum/component/timed_life/psiblock_drugs/yomi_genetics/proc/begin_seizure_warning()
	if(!owner)
		return

	to_chat(owner, SPAN_WARNING(pick(seizure_warning_messages)))
	// For some reason, the timer cuts one minute away, so we add an extra minute to make up for it
	var/seizure_long_delay = seizure_warning_delay + 1 MINUTE
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, seizure), seizure_intensity), seizure_long_delay)

/datum/component/timed_life/psiblock_drugs/yomi_genetics/cheap
	min_tremor_time = 30 SECONDS
	max_tremor_time = 2 MINUTES

	min_seizure_time = 5 MINUTES
	max_seizure_time = 30 MINUTES

	telepathy_cancel_probability = 75
	psi_sensitivity_modifier = -0.75
	accuracy_penalty = 0.35
	dispersion_penalty = 10
	surgery_success_penalty = -20
	seizure_intensity = 2

/datum/component/timed_life/psiblock_drugs/yomi_genetics/cheap/Initialize(lifetime_seconds)
	. = ..()
	ongoing_effect_message = RISK_LOW + RISK_MEDIUM + RISK_HIGH

/datum/component/timed_life/psiblock_drugs/yomi_genetics/expensive
	min_tremor_time = 2 MINUTES
	max_tremor_time = 5 MINUTES

	min_seizure_time = 30 MINUTES

	telepathy_cancel_probability = 100
	psi_sensitivity_modifier = -1.25
	accuracy_penalty = 0.15
	dispersion_penalty = 2
	surgery_success_penalty = -5

/datum/component/timed_life/psiblock_drugs/yomi_genetics/expensive/Initialize(lifetime_seconds)
	. = ..()
	ongoing_effect_message = RISK_LOW

#undef RISK_LOW

#undef RISK_MEDIUM

#undef RISK_HIGH
