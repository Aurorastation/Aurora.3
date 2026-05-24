/// Moodlet used for the Ministry skill.
/datum/moodlet/ministry_blessing
	moodlet_descriptor = SPAN_GOOD("Received a blessing.")
	initial_descriptor = SPAN_GOOD("You have received a morale modifier from hearing a blessing.")

/// Action bar object used by the Ministry skill.
/datum/action/ministry
	name = "Offer Blessing"
	action_type = 6
	procname = "queue_click"
	button_icon = 'icons/hud/action_buttons/skills.dmi'
	button_icon_state = "ministry"

/datum/action/ministry/proc/queue_click()
	if (!owner)
		return

	to_chat(owner, SPAN_NOTICE("You prepare yourself to offer a blessing to another. Left click on an adjacent character to offer them it."))
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(get_target), override = TRUE)

/datum/action/ministry/Destroy()
	if (!owner)
		return ..()

	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	return ..()

/datum/action/ministry/proc/get_target(owner, atom/target, modifiers)
	SIGNAL_HANDLER
	if (owner == target)
		to_chat(owner, SPAN_NOTICE("You cannot offer a blessing to yourself."))
		return COMSIG_MOB_CANCEL_CLICKON

	if (!astype(target, /mob)?.client)
		to_chat(owner, SPAN_NOTICE("[target] cannot receive a blessing."))
		return COMSIG_MOB_CANCEL_CLICKON

	if (get_dist(owner, target) >= 2)
		to_chat(owner, SPAN_NOTICE("You must be adjacent to [target] to offer them a blessing."))
		return COMSIG_MOB_CANCEL_CLICKON

	// StrongDMM for whatever ungodly reason can't tell that this proc won't block the caller.
	UNLINT(try_give_blessing(target))
	UnregisterSignal(owner, COMSIG_MOB_CLICKON)
	return COMSIG_MOB_CANCEL_CLICKON

/datum/action/ministry/proc/try_give_blessing(mob/target)
	set waitfor = FALSE
	switch(alert(target.client, "Would you like to accept a blessing from [owner]? You will need to remain close to them while they speak it", "Accept Blessing", "Yes", "No"))
		if ("Yes")
			var/blessing_type = alert(owner.client, "What type of chat message would you like to use for your blessing?", "Say Type", "Say", "Whisper", "Emote")
			var/blessing_text = tgui_input_text(owner, "Write what you wish to say as a blessing for [target].", "Offer Blessing")
			if (!blessing_text)
				to_chat(owner, SPAN_NOTICE("You have stopped speaking."))
				to_chat(target, SPAN_NOTICE("[owner] has stopped speaking."))
				return

			if (get_dist(owner, target) >= 2)
				to_chat(owner, SPAN_NOTICE("[target] is too far away to receive a blessing."))
				to_chat(target, SPAN_NOTICE("[owner] tried to offer a blessing, but you were too far away to receive it."))
				return

			switch(blessing_type)
				if ("Say")
					owner.say(blessing_text)
				if ("Whisper")
					owner.whisper(blessing_text)
				if ("Emote")
					owner.emote(blessing_text)

			var/datum/component/skill/ministry/ministry_skill = owner.GetComponent(MINISTRY_SKILL_COMPONENT)
			if (!ministry_skill)
				return

			var/datum/component/morale/target_morale = target.GetComponent(MORALE_COMPONENT)
			if (!target_morale)
				return

			var/moodlet_value = ministry_skill.moodlet_value_per_rank * (ministry_skill.skill_level - 1)
			if (astype(owner, /mob/living/carbon/human)?.religion == astype(target, /mob/living/carbon/human)?.religion)
				moodlet_value *= ministry_skill.same_religion_bonus_mod


			SEND_SIGNAL(owner, COMSIG_GET_MINISTRY_MODIFIERS, target, &moodlet_value)
			SEND_SIGNAL(target, COMSIG_RECEIVE_MINISTRY_MODIFIERS, owner, &moodlet_value)
			if (!moodlet_value)
				return

			if (astype(target_morale.moodlets[/datum/moodlet/ministry_blessing], /datum/moodlet)?.get_morale_modifier() >= moodlet_value)
				target_morale.load_moodlet(/datum/moodlet/ministry_blessing)?.refresh_moodlet()
				return // Don't overwrite stronger moodlets.

			var/datum/moodlet/blessing = target_morale.load_moodlet(/datum/moodlet/ministry_blessing, moodlet_value)
			blessing.refresh_moodlet()
			blessing.moodlet_descriptor += " from [owner.name]."

		if ("No")
			to_chat(owner, SPAN_NOTICE("[target] has refused your blessing."))
			return

/datum/component/skill/ministry
	/// The action icon stored for this ability.
	var/datum/action/ministry/ministry_action

	/// The value of the moodlet provided by this ability.
	var/moodlet_value_per_rank = 10.0 / 3.0

	/// The moodlet value multiplier for a target having the same religion as the performer.
	var/same_religion_bonus_mod = 1.5

/datum/component/skill/ministry/Initialize(level)
	. = ..()
	if (!parent)
		return

	ministry_action = new /datum/action/ministry()
	ministry_action.SetTarget(ministry_action)
	ministry_action.Grant(parent)

	RegisterSignal(parent, COMSIG_MOB_AFTER_LOGIN, PROC_REF(setup_action_button), override = TRUE)

/datum/component/skill/ministry/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_MOB_AFTER_LOGIN)
	ministry_action?.Remove(parent)
	QDEL_NULL(ministry_action)
	return ..()

/datum/component/skill/ministry/proc/setup_action_button()
	astype(parent, /mob)?.update_action_buttons()
