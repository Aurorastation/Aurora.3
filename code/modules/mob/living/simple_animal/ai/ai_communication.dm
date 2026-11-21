/**
 * Contextual speech and threat escalation adapted from Polaris.
 *
 * Aurora simple animals already expose idle speech/emote lists. The holder
 * mirrors those into this datum and adds lines for AI-specific events.
 */
/datum/ai_say_list
	var/list/speak = list()
	var/list/emote_hear = list()
	var/list/emote_see = list()
	var/list/say_understood = list()
	var/list/say_cannot = list()
	var/list/say_maybe_target = list()
	var/list/say_got_target = list()
	var/list/say_threaten = list()
	var/list/say_stand_down = list()
	var/list/say_escalate = list()
	var/list/say_retreat = list()
	var/threaten_sound
	var/stand_down_sound
	var/attack_sound

/datum/ai_say_list/pirate
	speak = list("Yarr!")
	say_understood = list("Alright, matey.")
	say_cannot = list("No, matey.")
	say_maybe_target = list("Eh?")
	say_got_target = list("Yarrrr!")
	say_threaten = list("You best leave. This booty is mine.", "No plank to walk on; just walk away.")
	say_stand_down = list("Good.")
	say_escalate = list("Yarr! The booty is mine!")
	say_retreat = list("I be retreating, matey!")

/datum/ai_say_list/mercenary
	speak = list("When are we getting out of this outfit?", "Wish I had better equipment.", "Anyone else smell that?")
	emote_see = list("checks their equipment", "looks around", "taps a foot")
	say_understood = list("Understood!", "Affirmative!")
	say_cannot = list("Negative!")
	say_maybe_target = list("Who's there?")
	say_got_target = list("Engaging!")
	say_threaten = list("Get out of here!", "Private property. Move along.")
	say_stand_down = list("Good.")
	say_escalate = list("Your funeral!", "Bring it!")
	say_retreat = list("Pulling back!", "Fall back!")

/datum/ai_say_list/android_scientist
	speak = list("Resuming task: collect data.", "No anomalies found.", "Error: no data sources found.")
	emote_hear = list("beeps quietly", "emits a soft buzz", "whirrs idly")
	emote_see = list("scans the area", "focuses on an object", "shifts in place")
	say_understood = list("Confirmed.", "Acknowledged.")
	say_cannot = list("Declined.", "Refused.")
	say_maybe_target = list("Unknown entity detected. Investigating.", "Possible breach detected.")
	say_got_target = list("Threat detected.", "Defending facility.", "Engaging target.")
	say_threaten = list("Unknown entity: present authorization.", "Unknown entity. Scanning.")
	say_stand_down = list("Stand-down accepted. Disengaging.")
	say_escalate = list("Threat detected. Rectifying.", "Verification expired. Engaging.")
	say_retreat = list("Disengaging.")

/datum/ai_say_list/hivebot
	speak = list("Resuming task: protect area.", "No threats found.", "Error: no targets found.")
	emote_hear = list("hums ominously", "whirrs softly", "grinds a gear")
	emote_see = list("looks around the area", "turns from side to side")
	say_understood = list("Affirmative.", "Positive.")
	say_cannot = list("Denied.", "Negative.")
	say_maybe_target = list("Possible threat detected. Investigating.", "Motion detected.")
	say_got_target = list("Threat detected.", "Threat removal engaged.", "Engaging target.")
	say_threaten = list("Warning: vacate area.", "Warning: lethal engagement authorized.")
	say_stand_down = list("Stand-down accepted. Disengaging.")
	say_escalate = list("Warning expired. Engaging.", "Threat removal engaged.")
	say_retreat = list("Disengaging.")

/datum/ai_holder/proc/should_threaten(atom/the_target = target)
	if(!threaten || !will_threaten(the_target) || check_attacker(the_target))
		return FALSE
	if(last_conflict_time && world.time < last_conflict_time + threaten_timeout)
		return FALSE
	return TRUE

/datum/ai_holder/proc/will_threaten(atom/the_target)
	return isliving(the_target)

/datum/ai_holder/proc/handle_alert()
	threaten_target()

/datum/ai_holder/proc/threaten_target()
	if(!target || !can_attack(target))
		stand_down()
		remove_target()
		return

	holder.face_atom(target)
	if(!threatening)
		threatening = TRUE
		last_threaten_time = world.time
		if(!emit_context(say_list?.say_threaten, target))
			holder.AIThreaten(target)
		play_context_sound(say_list?.threaten_sound, target)

	if(isnull(threaten_delay))
		return
	if(world.time < last_threaten_time + threaten_delay)
		return

	threatening = FALSE
	last_conflict_time = world.time
	emit_context(say_list?.say_escalate, target)
	play_context_sound(say_list?.attack_sound, target)
	set_stance(within_range(target) ? AI_STANCE_FIGHT : AI_STANCE_APPROACH)

/datum/ai_holder/proc/stand_down()
	if(!threatening)
		return
	threatening = FALSE
	emit_context(say_list?.say_stand_down, target)
	play_context_sound(say_list?.stand_down_sound, target)

/datum/ai_holder/proc/handle_idle_speaking()
	if(!speak_chance || rand(0, 200) >= speak_chance)
		return

	var/has_audience = FALSE
	for(var/mob/audience in viewers(holder))
		if(audience.client)
			has_audience = TRUE
			break
	if(!has_audience)
		return

	var/list/options = list()
	if(length(say_list?.speak))
		options += AI_COMM_SAY
	if(length(say_list?.emote_hear))
		options += AI_COMM_AUDIBLE_EMOTE
	if(length(say_list?.emote_see))
		options += AI_COMM_VISUAL_EMOTE
	if(!length(options))
		holder.AIIdleSpeak()
		return

	switch(pick(options))
		if(AI_COMM_SAY)
			holder.AIContextSpeak(pick(say_list.speak))
		if(AI_COMM_AUDIBLE_EMOTE)
			holder.AIAudibleEmote("[pick(say_list.emote_hear)].")
		if(AI_COMM_VISUAL_EMOTE)
			holder.AIVisualEmote("[pick(say_list.emote_see)].")

/datum/ai_holder/proc/emit_context(list/lines, atom/speak_to)
	if(!length(lines))
		return FALSE
	if(speak_to)
		holder.face_atom(speak_to)
	holder.AIContextSpeak(pick(lines))
	return TRUE

/datum/ai_holder/proc/play_context_sound(sound_file, atom/listener)
	if(!sound_file)
		return
	playsound(holder, sound_file, 50, TRUE)
	if(listener)
		playsound(listener, sound_file, 50, TRUE)

/datum/ai_holder/proc/on_hear_say(mob/living/speaker, message)
	return

/datum/ai_holder/proc/delayed_say(message, mob/living/speak_to)
	if(!message)
		return
	addtimer(CALLBACK(src, PROC_REF(finish_delayed_say), message, speak_to), rand(1 SECOND, 2 SECONDS), TIMER_DELETE_ME)

/datum/ai_holder/proc/finish_delayed_say(message, mob/living/speak_to)
	if(QDELETED(src) || QDELETED(holder) || !can_act())
		return
	if(speak_to)
		holder.face_atom(speak_to)
	holder.AIContextSpeak(message)
