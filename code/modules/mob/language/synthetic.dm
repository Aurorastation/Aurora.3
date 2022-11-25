/datum/language/binary
	name = LANGUAGE_ROBOT
	desc = "Most human vessels or stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote"
	speech_verb = list("states")
	ask_verb = list("queries")
	exclaim_verb = list("declares")
	key = "b"
	flags = RESTRICTED | HIVEMIND
	var/drone_only

/datum/language/binary/proc/can_hear(var/mob/speaker, var/mob/hearer)
	return TRUE

/datum/language/binary/proc/get_speaker_name(var/mob/speaker)
	return speaker.real_name

/datum/language/binary/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(!speaker.binarycheck())
		return

	if (!message)
		return

	message = formalize_text(message)

	log_say("[key_name(speaker)] : ([name]) [message]",ckey=key_name(speaker))

	var/message_start = "<span style='font-size: [speaker.get_binary_font_size()];'><i><span class='game say'>[name], <span class='name'>[get_speaker_name(speaker)]</span>"
	var/message_body = span(message, "[speaker.say_quote(message)], \"[message]\"</span></span></i>")

	for (var/mob/M as anything in dead_mob_list)
		if(!istype(M,/mob/abstract/new_player) && !istype(M,/mob/living/carbon/brain)) //No meta-evesdropping
			M.show_message("[ghost_follow_link(speaker, M)] [message_start] [message_body]", 2)

	for(var/mob/living/S in living_mob_list)
		if(drone_only && !isDrone(S))
			continue
		else if(isAI(S))
			message_start = "<i><span class='game say'>[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[speaker];trackname=[html_encode(speaker.name)]'><span class='name'>[get_speaker_name(speaker)]</span></a></span></i>"
		else if (!S.binarycheck() || !can_hear(speaker, S))
			continue

		S.show_message("[message_start] [message_body]", 2)

	//robot binary xmitter component power usage
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		var/datum/robot_component/C = R.components["comms"]
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = LANGUAGE_DRONE
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = list("transmits")
	ask_verb = list("transmits")
	exclaim_verb = list("transmits")
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED | HIVEMIND
	drone_only = TRUE

/datum/language/binary/drone/get_speaker_name(mob/living/silicon/robot/drone/speaker)
	if(isMatriarchDrone(speaker))
		return "Matriarch [speaker.designation]"
	return ..()

/datum/language/binary/drone/can_hear(mob/living/silicon/robot/drone/speaker, mob/living/silicon/robot/drone/hearer)
	if(speaker.master_matrix != hearer.master_matrix)
		return FALSE
	return TRUE

/mob/living/proc/get_binary_font_size()
	return "1em"

/mob/living/silicon/robot/drone/construction/matriarch/get_binary_font_size()
	return "1.2em"

/datum/language/local_drone
	name = LANGUAGE_LOCAL_DRONE
	desc = "A heavily encoded damage coordination transmission, only supplied to drones within sight."
	speech_verb = list("transmits")
	ask_verb = list("transmits")
	exclaim_verb = list("transmits")
	key = "do"
	flags = RESTRICTED | KNOWONLYHEAR | PRESSUREPROOF | PASSLISTENOBJ

/datum/language/local_drone/handle_message_mode(var/message_mode)
	if(message_mode == "headset")
		return list(all_languages[LANGUAGE_DRONE], null)
	return list(src, null)
