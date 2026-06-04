#define GET_SPEECH_TYPE(owner) alert(owner.client, "What type of chat message would you like to use for your inspirational speech?", "Say Type", "Say", "Whisper", "Emote")
#define GET_SPEECH_TEXT(owner) tgui_input_text(owner, "Write what you wish to say for your speech.", "Deliver Speech")

/datum/moodlet/leadership
	moodlet_descriptor = SPAN_GOOD("Listened to an encouraging speech")
	initial_descriptor = SPAN_GOOD("You have received a morale modifier from hearing words of encouragement.")
	duration = 15 MINUTES

/datum/action/leadership
	name = "Deliver Speech"
	action_type = 6
	procname = "queue_click"
	button_icon = 'icons/hud/action_buttons/skills.dmi'
	button_icon_state = "leadership"

/datum/action/leadership/proc/queue_click()
	if (!owner)
		return

	to_chat(owner, SPAN_NOTICE("You prepare yourself to give a speech. Left click on yourself to target those who can hear you in an area. Left click on another person to instead give them directed words of encouragement. Targeting a single person will give a stronger morale modifier."))
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(get_target), override = TRUE)

/datum/action/leadership/proc/get_target(owner, atom/target, modifiers)
	SIGNAL_HANDLER
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	if (. == COMSIG_MOB_CANCEL_CLICKON)
		return . // Another signal-handler already got to it.

	// Both forms of deliver speech will immediately return control to the caller without blocking.
	// Unfortunately StrongDMM is apparently incapable of reading that.
	if (owner == target)
		UNLINT(deliver_speech_area(owner))
	else
		UNLINT(deliver_speech_target(owner, target))
	return COMSIG_MOB_CANCEL_CLICKON

/datum/action/leadership/proc/deliver_speech_area(mob/owner)
	set waitfor = FALSE // Immediately return control to the caller.
	if (!istype(owner))
		return

	owner.visible_message(SPAN_NOTICE("[owner] prepares to deliver a speech."))
	var/speech_text = GET_SPEECH_TEXT(owner)
	if (!speech_text)
		owner.visible_message(SPAN_NOTICE("[owner] has stopped speaking."))
		return

	owner.say(speech_text)
	var/datum/component/skill/leadership/leadership_skill = owner.GetComponent(LEADERSHIP_SKILL_COMPONENT)
	if (!leadership_skill)
		return

	var/moodlet_value = leadership_skill.moodlet_value_per_rank * (leadership_skill.skill_level - 1)
	SEND_SIGNAL(owner, COMSIG_GET_LEADERSHIP_MODIFIERS, &moodlet_value)
	if (!moodlet_value)
		return

	var/list/listening = get_hearers_in_view(world.view, owner)
	if (!listening)
		return
	listening -= owner

	for (var/mob/player_mob in listening)
		var/datum/component/morale/receiver_morale = player_mob.GetComponent(MORALE_COMPONENT)
		if (!receiver_morale)
			continue

		if (astype(receiver_morale.moodlets[/datum/moodlet/leadership], /datum/moodlet)?.get_morale_modifier() >= moodlet_value)
			receiver_morale.load_moodlet(/datum/moodlet/leadership)?.refresh_moodlet()
			continue // Don't overwrite stronger moodlets.

		var/datum/moodlet/speech = receiver_morale.load_moodlet(/datum/moodlet/leadership, moodlet_value)
		speech.refresh_moodlet()
		speech.moodlet_descriptor += " from [owner.name]."

/datum/action/leadership/proc/deliver_speech_target(mob/owner, mob/target)
	set waitfor = FALSE // Immediately return control to the caller.
	if (!istype(owner) || !istype(target))
		return

	if (!target.client)
		to_chat(owner, SPAN_NOTICE("[target] cannot hear your speech."))
		return

	owner.visible_message(SPAN_NOTICE("[owner] prepares to deliver a speech."))
	var/speech_type = GET_SPEECH_TYPE(owner)
	var/speech_text = GET_SPEECH_TEXT(owner)
	if (!speech_text)
		owner.visible_message(SPAN_NOTICE("[owner] has stopped speaking."))
		return

	switch(speech_type)
		if ("Say")
			if (get_dist(owner, target) >= 7)
				to_chat(owner, SPAN_NOTICE("You must be closer to [target] to give them words of encouragement"))
				return
			owner.say(speech_text)
		if ("Whisper")
			if (get_dist(owner, target) >= 2)
				to_chat(owner, SPAN_NOTICE("You must be adjacent to [target] to whisper them words of encouragement"))
				return
			owner.whisper(speech_text)
		if ("Emote")
			if (get_dist(owner, target) >= 7)
				to_chat(owner, SPAN_NOTICE("You must be closer to [target] to give them words of encouragement"))
			owner.emote(speech_text)

	var/datum/component/skill/leadership/leadership_skill = owner.GetComponent(LEADERSHIP_SKILL_COMPONENT)
	if (!leadership_skill)
		return

	var/moodlet_value = leadership_skill.moodlet_value_per_rank * (leadership_skill.skill_level - 1) * leadership_skill.single_target_bonus_mod
	SEND_SIGNAL(owner, COMSIG_GET_LEADERSHIP_MODIFIERS, &moodlet_value)
	if (!moodlet_value)
		return

	var/datum/component/morale/target_morale = target.GetComponent(MORALE_COMPONENT)
	if (!target_morale)
		return

	if (astype(target_morale.moodlets[/datum/moodlet/leadership], /datum/moodlet)?.get_morale_modifier() >= moodlet_value)
		target_morale.load_moodlet(/datum/moodlet/leadership)?.refresh_moodlet()
		return // Don't overwrite stronger moodlets.

	var/datum/moodlet/speech = target_morale.load_moodlet(/datum/moodlet/leadership, moodlet_value)
	speech.refresh_moodlet()
	speech.moodlet_descriptor += " from [owner.name]."

/**
 * Component used for the Leadership Skill.
 * The way this works is that having the component grants access to an "Inspire" action. Activating it will prompt the user to select a person, then prompt them to "Say something inspiring!".
 * If the target can "Hear" the inspirational speech, they gain a morale bonus which scales with the actor's Leadership Skill.
 */
/datum/component/skill/leadership
	/// The action icon stored for this ability.
	var/datum/action/leadership/leadership_action

	/// The value of the moodlet provided by this ability.
	var/moodlet_value_per_rank = 10.0 / 3.0

	/// Moodlet value multiplier for single target speeches.
	var/single_target_bonus_mod = 1.5

/datum/component/skill/leadership/Initialize(level)
	. = ..()
	if (!parent)
		return

	leadership_action = new /datum/action/leadership()
	leadership_action.SetTarget(leadership_action)
	leadership_action.Grant(parent)

	RegisterSignal(parent, COMSIG_MOB_AFTER_LOGIN, PROC_REF(setup_action_button), override = TRUE)

/datum/component/skill/leadership/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_MOB_AFTER_LOGIN)
	leadership_action?.Remove(parent)
	QDEL_NULL(leadership_action)
	return ..()

/datum/component/skill/leadership/proc/setup_action_button()
	astype(parent, /mob)?.update_action_buttons()

#undef GET_SPEECH_TYPE
#undef GET_SPEECH_TEXT
