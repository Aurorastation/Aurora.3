/mob/living/silicon/robot/handle_speech_problems(message, say_verb, message_mode, message_range)
	if(!message_range)
		message_range = world.view
	//Handle gibberish when components are damaged
	if(message_mode)
		//If we have a radio message, just look at the damage of the radio
		var/datum/robot_component/C = get_component("radio")
		if(C.get_damage())
			. = TRUE
			message = Gibberish(message, C.max_damage / C.get_damage())
	else
		var/damaged = 100 - (clamp(health, 0, maxhealth) / maxhealth) * 100
		if(damaged > 40)
			. = TRUE
			message = Gibberish(message, damaged - 10)

/mob/living/silicon/robot/handle_message_mode(datum/say_message/msg, datum/language/primary, list/used_radios)
	var/text = msg.to_string()
	var/message_mode = msg.message_mode
	if(message_mode == "whisper" && !msg.whisper)
		whisper(text, primary, say_verb = TRUE, msg = msg)
		return TRUE
	if(message_mode)
		if(!is_component_functioning("radio"))
			to_chat(src, SPAN_WARNING("Your radio isn't functional at this time."))
			return 0
		if(message_mode == "general")
			message_mode = null
		log_say("[key_name(src)] : [text]")
		return common_radio.talk_into(src, text, message_mode, msg.verb, primary, say_message = msg)

/mob/living/silicon/robot/drone/handle_message_mode()
	return null

/mob/living/silicon/ai/handle_message_mode(datum/say_message/msg, datum/language/primary, list/used_radios)
	var/text = msg.to_string()
	var/message_mode = msg.message_mode
	if(message_mode == "whisper" && !msg.whisper)
		whisper(text, primary, say_verb = TRUE, msg = msg)
		return TRUE
	if(message_mode == "department")
		return holopad_talk(msg)
	else if(message_mode)
		if(ai_radio.disabledAi || ai_restore_power_routine || stat)
			to_chat(src, SPAN_DANGER("System Error - Transceiver Disabled."))
			return FALSE
		if(message_mode == "general")
			message_mode = null
		log_say("[key_name(src)] : [text]")
		return ai_radio.talk_into(src, text, message_mode, msg.verb, primary, say_message = msg)

/mob/living/silicon/pai/handle_message_mode(datum/say_message/msg, datum/language/primary, list/used_radios)
	var/text = msg.to_string()
	var/message_mode = msg.message_mode
	if(message_mode)
		if(message_mode == "whisper" && !msg.whisper)
			whisper(text, primary, say_verb = TRUE, msg = msg)
			return TRUE
		if(message_mode == "general")
			message_mode = null
		log_say("[key_name(src)] : [text]")
		return radio.talk_into(src, text, message_mode, msg.verb, primary, say_message = msg)

/mob/living/silicon/say_quote(var/text, var/datum/language/speaking = null, var/singing = FALSE, var/whisper = FALSE)
	if(singing)
		return "sings"
	if(whisper)
		return "whispers"
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return speak_query
	else if(ending == "!")
		return speak_exclamation
	return speak_statement

/mob/living/silicon/robot/drone/say_quote(var/message, var/datum/language/speaking = null, var/singing = FALSE)
	if(speaking)
		var/ending = copytext(message, length(message))
		var/pre_ending = copytext(message, length(message) - 1, length(message))
		return speaking.get_spoken_verb(ending, pre_ending, singing)
	return ..()

#define IS_AI 1
#define IS_ROBOT 2
#define IS_PAI 3

/mob/living/silicon/say_understands(var/other, var/datum/language/speaking = null)
	//These only pertain to common. Languages are handled by mob/say_understands()
	if(!speaking)
		if(istype(other, /mob/living/carbon))
			return TRUE
		if(istype(other, /mob/living/silicon))
			return TRUE
		if (istype(other, /mob/living/announcer))
			return TRUE
		if(istype(other, /mob/living/carbon/brain))
			return TRUE
	return ..()

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(datum/say_message/msg)
	log_say("[key_name(src)] : [msg.raw_message]")
	if(!length(msg.to_string()))
		return
	// :h is only a routing shortcut for AIs, not a department-radio mode for the delivered message.
	msg.message_mode = null

	var/obj/structure/machinery/hologram/holopad/H = src.holo
	if(H?.active_holograms[src])//If there is a hologram and its master is the user.
		// AI hears its own message. text_for keeps each language.
		to_chat(src, "<i><span class='game say'>Holopad transmitted, <span class='name'>[real_name]</span> [msg.verb], <span class='message'><span class='body'>\"[msg.text_for(src)]\"</span></span></span></i>")

		//This is so pAI's and people inside lockers/boxes,etc can hear the AI Holopad, the alternative being recursion through contents.
		//This is much faster.
		var/list/listening = list()
		var/list/listening_obj = list()
		var/turf/T = get_turf(H)

		if(T)
			var/list/hear = get_hear(7, T)
			var/list/hearturfs = list()

			for(var/I in hear)
				if(istype(I, /mob))
					var/mob/M = I
					listening += M
					hearturfs += get_turf(M)
					for(var/obj/O in M.contents)
						listening_obj |= O
				else if(istype(I, /obj))
					var/obj/O = I
					hearturfs += get_turf(O)
					listening_obj |= O

			for(var/mob/M in GLOB.player_list)
				if(M.stat == DEAD && M.client?.prefs.toggles & CHAT_GHOSTEARS)
					M.hear_message(msg)
					continue
				if(M.loc && (get_turf(M) in hearturfs))
					M.hear_message(msg)
	else
		to_chat(src, SPAN_WARNING("No holopad connected."))
		return FALSE
	return TRUE

/mob/living/silicon/ai/proc/holopad_emote(var/message, var/m_type = VISIBLE_MESSAGE, var/do_show_observers = TRUE)
	if((usr && stat) || (!use_me && usr == src))
		to_chat(src, "You are unable to emote.")
		return FALSE

	message = trim(message)
	if(!message)
		return FALSE

	var/obj/structure/machinery/hologram/holopad/T = src.holo
	var/obj/effect/overlay/hologram/H = T?.active_holograms[src]
	if(!H)
		to_chat(src, SPAN_WARNING("No holopad connected."))
		return FALSE

	log_emote("[key_name(src)] : [message]")
	var/langchat_message = process_chat_markup(message, list("~", "_"))
	var/rendered = format_emote(src, message)
	rendered = process_chat_markup(rendered, list("~", "_"))
	var/list/emote_viewers = list()

	if(m_type == VISIBLE_MESSAGE)
		emote_viewers = viewers(world.view, H)
		for(var/mob/M in emote_viewers)
			M.show_message(rendered, VISIBLE_MESSAGE)
		if(T.has_established_connection())
			for(var/mob/M in viewers(world.view, T.connected_pad))
				M.show_message(rendered, VISIBLE_MESSAGE)
				emote_viewers |= M
	else
		var/list/hearers = get_hearers_in_view(world.view, H)
		for(var/atom/movable/hearer as anything in hearers)
			if(hearer == T)
				continue
			hearer.show_message(rendered, AUDIBLE_MESSAGE)
			if(ismob(hearer))
				emote_viewers |= hearer
		if(T.has_established_connection())
			for(var/atom/movable/hearer as anything in get_hearers_in_view(world.view, T.connected_pad))
				if(hearer == T.connected_pad)
					continue
				hearer.show_message(rendered, AUDIBLE_MESSAGE)
				if(ismob(hearer))
					emote_viewers |= hearer

	to_chat(src, "<i><span class='game say'>Holopad action relayed, <span class='message'>[rendered]</span></span></i>")
	langchat_speech(langchat_message, emote_viewers, additional_styles = list("emote", "langchat_small"))
	return TRUE

#undef IS_AI
#undef IS_ROBOT
#undef IS_PAI
