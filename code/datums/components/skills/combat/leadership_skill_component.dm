#define GET_SPEECH_TYPE(owner) tgui_alert(owner.client, "What type of chat message would you like to use for your inspirational speech?", "Say Type", list("Say", "Whisper", "Emote"))
#define GET_SPEECH_TEXT(owner) tgui_input_text(owner, "Write what you wish to say for your speech.", "Deliver Speech")

/datum/moodlet/leadership
	moodlet_descriptor = SPAN_GOOD("Listened to an encouraging speech")
	initial_descriptor = SPAN_GOOD("You have received a morale modifier from hearing words of encouragement.")
	duration = 15 MINUTES

/datum/moodlet/leadership_rally
	moodlet_descriptor = SPAN_GOOD("Stand Fast! (Rallied)")
	initial_descriptor = SPAN_GOOD("You have been rallied by a commanding leader, steadying your nerves against panic and fatigue.")
	duration = 90 SECONDS

/**
 * Temporary stamina-poise buff granted by a Professional leader's Stand Fast! area speech.
 */
/datum/component/leadership_rally
	var/stamina_drain_mult = 0.75
	var/expire_timer

/datum/component/leadership_rally/Initialize(duration = 90 SECONDS)
	. = ..()
	if(!parent)
		return
	RegisterSignal(parent, COMSIG_STAMINA_DRAIN_MODIFIERS, PROC_REF(reduce_stamina_drain), override = TRUE)
	refresh_duration(duration)

/datum/component/leadership_rally/Destroy(force)
	if(expire_timer)
		deltimer(expire_timer)
		expire_timer = null
	if(parent)
		UnregisterSignal(parent, COMSIG_STAMINA_DRAIN_MODIFIERS)
	return ..()

/datum/component/leadership_rally/proc/refresh_duration(duration = 90 SECONDS)
	if(expire_timer)
		deltimer(expire_timer)
	expire_timer = addtimer(CALLBACK(src, PROC_REF(expire)), duration, TIMER_STOPPABLE)

/datum/component/leadership_rally/proc/expire()
	expire_timer = null
	qdel(src)

/datum/component/leadership_rally/proc/reduce_stamina_drain(mob/living/carbon/human/user, stamina_cost)
	SIGNAL_HANDLER
	*stamina_cost = *stamina_cost * stamina_drain_mult

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

	var/trigger_stand_fast = FALSE
	if (leadership_skill.skill_level >= SKILL_LEVEL_PROFESSIONAL && world.time >= leadership_skill.next_stand_fast)
		trigger_stand_fast = TRUE
		leadership_skill.next_stand_fast = world.time + leadership_skill.stand_fast_cooldown
		leadership_skill.rallied_allies.Cut()

	var/rallied_count = 0
	var/stand_fast_tagged = FALSE
	for (var/mob/player_mob in listening)
		var/datum/component/morale/receiver_morale = player_mob.GetComponent(MORALE_COMPONENT)
		if (!receiver_morale)
			continue

		rallied_count++
		if (astype((locate(/datum/moodlet/leadership) in receiver_morale.moodlets), /datum/moodlet)?.get_morale_modifier() >= moodlet_value)
			receiver_morale.load_moodlet(/datum/moodlet/leadership)?.refresh_moodlet()
		else
			var/datum/moodlet/speech = receiver_morale.load_moodlet(/datum/moodlet/leadership, moodlet_value)
			speech.refresh_moodlet()
			speech.moodlet_descriptor += " from [owner.name]."

		if (trigger_stand_fast)
			apply_stand_fast(player_mob, receiver_morale)
			if (ishuman(player_mob))
				leadership_skill.rallied_allies |= WEAKREF(player_mob)
				stand_fast_tagged = TRUE

	if (trigger_stand_fast)
		var/datum/component/morale/owner_morale = owner.GetComponent(MORALE_COMPONENT)
		if (owner_morale)
			apply_stand_fast(owner, owner_morale)
		if (stand_fast_tagged)
			leadership_skill.stand_fast_end = world.time + 90 SECONDS
			START_PROCESSING(SSprocessing, leadership_skill)

	if (rallied_count)
		to_chat(owner, SPAN_NOTICE("Your speech rallies [rallied_count] [rallied_count == 1 ? "person" : "people"]."))

/datum/action/leadership/proc/apply_stand_fast(mob/living/target, datum/component/morale/morale_comp)
	var/datum/moodlet/rally = morale_comp.load_moodlet(/datum/moodlet/leadership_rally, 2)
	rally?.refresh_moodlet()
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		H.adjustHalLoss(-10)
		var/datum/component/leadership_rally/existing = H.GetComponent(/datum/component/leadership_rally)
		if (existing)
			existing.refresh_duration(90 SECONDS)
		else
			H.AddComponent(/datum/component/leadership_rally, 90 SECONDS)
		H.balloon_alert(H, "Stand fast!")

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
				return
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

	if (astype((locate(/datum/moodlet/leadership) in target_morale.moodlets), /datum/moodlet)?.get_morale_modifier() >= moodlet_value)
		target_morale.load_moodlet(/datum/moodlet/leadership)?.refresh_moodlet()
	else
		var/datum/moodlet/speech = target_morale.load_moodlet(/datum/moodlet/leadership, moodlet_value)
		speech.refresh_moodlet()
		speech.moodlet_descriptor += " from [owner.name]."

	// Trained+: Second Wind targeted stamina & pain recovery (and Professional psychic cleanse)
	if (leadership_skill.skill_level >= SKILL_LEVEL_TRAINED && world.time >= leadership_skill.next_second_wind && ishuman(target))
		var/mob/living/carbon/human/H = target
		leadership_skill.next_second_wind = world.time + leadership_skill.second_wind_cooldown
		if (H.max_stamina > 0)
			H.stamina = clamp(H.stamina + 25, 0, H.max_stamina)
			H.hud_used?.move_intent?.update_move_icon(H)
		H.adjustHalLoss(-10)
		H.balloon_alert(H, "Second wind!")
		to_chat(H, SPAN_GOOD("You catch your second wind from [owner]'s encouragement!"))
		if (leadership_skill.skill_level >= SKILL_LEVEL_PROFESSIONAL && target_morale.cleanse_worst_negative_moodlet())
			to_chat(H, SPAN_GOOD("Your mind clears as [owner]'s words steady your resolve!"))
			to_chat(owner, SPAN_NOTICE("Your words help [H] shake off a bout of psychic trauma."))

/**
 * Component used for the Leadership Skill.
 * Grants access to "Deliver Speech" (area and single-target morale boosts),
 * Trained "Second Wind" targeted recovery, and Professional "Stand Fast!" rally + passive aura.
 */
/datum/component/skill/leadership
	/// The action icon stored for this ability.
	var/datum/action/leadership/leadership_action

	/// The value of the moodlet provided by this ability.
	var/moodlet_value_per_rank = 10.0 / 3.0

	/// Moodlet value multiplier for single target speeches.
	var/single_target_bonus_mod = 1.5

	/// Cooldowns for Trained Second Wind and Professional Stand Fast!
	var/second_wind_cooldown = 3 MINUTES
	var/next_second_wind = 0
	var/stand_fast_cooldown = 5 MINUTES
	var/next_stand_fast = 0
	/// Weakrefs of allies tagged by Stand Fast!, and when the aura expires.
	var/list/rallied_allies = list()
	var/stand_fast_end = 0

/datum/component/skill/leadership/Initialize(level)
	. = ..()
	if (!parent)
		return

	leadership_action = new /datum/action/leadership()
	leadership_action.SetTarget(leadership_action)
	leadership_action.Grant(parent)

	RegisterSignal(parent, COMSIG_MOB_AFTER_LOGIN, PROC_REF(setup_action_button), override = TRUE)

/datum/component/skill/leadership/Destroy(force)
	STOP_PROCESSING(SSprocessing, src)
	rallied_allies.Cut()
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_MOB_AFTER_LOGIN)
	leadership_action?.Remove(parent)
	QDEL_NULL(leadership_action)
	return ..()

/datum/component/skill/leadership/process(seconds_per_tick)
	if (skill_level < SKILL_LEVEL_PROFESSIONAL || !stand_fast_end || world.time >= stand_fast_end || !length(rallied_allies))
		rallied_allies.Cut()
		stand_fast_end = 0
		return PROCESS_KILL

	var/mob/living/leader = parent
	if (!istype(leader) || leader.stat != CONSCIOUS)
		rallied_allies.Cut()
		stand_fast_end = 0
		return PROCESS_KILL

	var/applied_any = FALSE
	var/list/stale_refs
	for (var/datum/weakref/ally_ref as anything in rallied_allies)
		var/mob/living/carbon/human/ally = ally_ref?.resolve()
		if (QDELETED(ally))
			LAZYADD(stale_refs, ally_ref)
			continue
		if (ally.stat != CONSCIOUS || ally.max_stamina <= 0 || !(ally in view(world.view, leader)))
			continue
		var/datum/component/morale/ally_morale = ally.GetComponent(MORALE_COMPONENT)
		if (!ally_morale || !(locate(/datum/moodlet/leadership_rally) in ally_morale.moodlets))
			continue
		ally.stamina = clamp(ally.stamina + (1.5 * seconds_per_tick), 0, ally.max_stamina)
		applied_any = TRUE

	if (stale_refs)
		rallied_allies -= stale_refs

	if (!applied_any)
		rallied_allies.Cut()
		stand_fast_end = 0
		return PROCESS_KILL

/datum/component/skill/leadership/proc/setup_action_button()
	astype(parent, /mob)?.update_action_buttons()

#undef GET_SPEECH_TYPE
#undef GET_SPEECH_TEXT
