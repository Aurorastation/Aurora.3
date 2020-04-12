/mob/living/silicon/say(message, sanitize = TRUE)
	return ..(sanitize ? sanitize(message) : message)

/mob/living/silicon/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	log_say("[key_name(src)] : [message]",ckey=key_name(src))

/mob/living/silicon/robot/handle_speech_problems(var/message, var/verb, var/message_mode)
	var/speech_problem_flag = FALSE
	//Handle gibberish when components are damaged
	if(message_mode)
		//If we have a radio message, just look at the damage of the radio
		var/datum/robot_component/C = get_component("radio")
		if(C.get_damage())
			speech_problem_flag = TRUE
			message = Gibberish(message, C.max_damage / C.get_damage())
	else
		var/damaged = 100 - (Clamp(health, 0, maxHealth) / maxHealth) * 100
		if(damaged > 40)
			speech_problem_flag = TRUE
			message = Gibberish(message, damaged - 10)

	var/list/returns[4]
	returns[1] = message
	returns[2] = verb
	returns[3] = speech_problem_flag
	returns[4] = world.view
	return returns

/mob/living/silicon/robot/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	..()
	if(message_mode)
		if(!is_component_functioning("radio"))
			to_chat(src, SPAN_WARNING("Your radio isn't functional at this time."))
			return 0
		if(message_mode == "general")
			message_mode = null
		return common_radio.talk_into(src, message, message_mode, verb, speaking)

/mob/living/silicon/ai/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	..()
	if(message_mode == "department")
		return holopad_talk(message, verb, speaking)
	else if(message_mode)
		if(ai_radio.disabledAi || ai_restore_power_routine || stat)
			to_chat(src, SPAN_DANGER("System Error - Transceiver Disabled."))
			return FALSE
		if(message_mode == "general")
			message_mode = null
		return ai_radio.talk_into(src, message, message_mode, verb, speaking)

/mob/living/silicon/pai/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	..()
	if(message_mode)
		if(message_mode == "general")
			message_mode = null
		return radio.talk_into(src, message, message_mode, verb, speaking)

/mob/living/silicon/say_quote(var/text)
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return speak_query
	else if(ending == "!")
		return speak_exclamation
	return speak_statement

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
		if(istype(other, /mob/living/carbon/brain))
			return TRUE
	return ..()

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(var/message, verb, datum/language/speaking)
	log_say("[key_name(src)] : [message]",ckey=key_name(src))
	message = trim(message)
	if(!message)
		return

	var/obj/machinery/hologram/holopad/H = src.holo
	if(H && H.masters[src])//If there is a hologram and its master is the user.
		// AI can hear their own message, this formats it for them.
		if(speaking)
			to_chat(src, "<i><span class='game say'>Holopad transmitted, <span class='name'>[real_name]</span> [speaking.format_message(message, verb)]</span></i>")
		else
			to_chat(src, "<i><span class='game say'>Holopad transmitted, <span class='name'>[real_name]</span> [verb], <span class='message'><span class='body'>\"[message]\"</span></span></span></i>")

		//This is so pAI's and people inside lockers/boxes,etc can hear the AI Holopad, the alternative being recursion through contents.
		//This is much faster.
		var/list/listening = list()
		var/list/listening_obj = list()
		var/turf/T = get_turf(H)

		if(T)
			var/list/hear = hear(7, T)
			var/list/hearturfs = list()

			for(var/I in hear)
				if(istype(I, /mob))
					var/mob/M = I
					listening += M
					hearturfs += M.locs[1]
					for(var/obj/O in M.contents)
						listening_obj |= O
				else if(istype(I, /obj))
					var/obj/O = I
					hearturfs += O.locs[1]
					listening_obj |= O


			for(var/mob/M in player_list)
				if(M.stat == DEAD && M.client?.prefs.toggles & CHAT_GHOSTEARS)
					M.hear_say(message, verb, speaking, null, null, src)
					continue
				if(M.loc && M.locs[1] in hearturfs)
					M.hear_say(message, verb, speaking, null, null, src)
	else
		to_chat(src, SPAN_WARNING("No holopad connected."))
		return FALSE
	return TRUE

/mob/living/silicon/ai/proc/holopad_emote(var/message) //This is called when the AI uses the 'me' verb while using a holopad.
	log_emote("[key_name(src)] : [message]",ckey=key_name(src))

	message = trim(message)
	if(!message)
		return

	var/obj/machinery/hologram/holopad/T = src.holo
	if(T?.masters[src])
		var/rendered = "<span class='game say'><span class='name'>[name]</span> <span class='message'>[message]</span></span>"
		to_chat(src, "<i><span class='game say'>Holopad action relayed, <span class='name'>[real_name]</span> <span class='message'>[message]</span></span></i>")

		for(var/mob/M in viewers(get_turf(T)))
			to_chat(M, rendered)
	else //This shouldn't occur, but better safe then sorry.
		to_chat(src, SPAN_WARNING("No holopad connected."))
		return FALSE
	return TRUE

/mob/living/silicon/ai/emote(var/act, var/type, var/message)
	var/obj/machinery/hologram/holopad/T = src.holo
	if(T?.masters[src]) //Is the AI using a holopad?
		src.holopad_emote(message)
	else //Emote normally, then.
		..()

#undef IS_AI
#undef IS_ROBOT
#undef IS_PAI