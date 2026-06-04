var/list/department_radio_keys = list(
		":r" = "right ear",	".r" = "right ear",
		":l" = "left ear",	".l" = "left ear",
		":i" = "intercom",	".i" = "intercom",
		":h" = "department",	".h" = "department",
		":+" = "special",		".+" = "special", //activate radio-specific special functions
		":a" = "Common",		".a" = "Common",
		":c" = "Command",		".c" = "Command",
		":n" = "Science",		".n" = "Science",
		":m" = "Medical",		".m" = "Medical",
		":e" = "Engineering", ".e" = "Engineering",
		":f" = "Coalition Navy", ".f" = "Coalition Navy",
		":s" = "Security",	".s" = "Security",
		":q" = "Penal",		".q" = "Penal",
		":w" = "whisper",		".w" = "whisper",
		":t" = "Mercenary",	".t" = "Mercenary",
		":x" = "Raider",		".x" = "Raider",
		":b" = "Burglar",		".b" = "Burglar",
		":k" = "Jockey",			".k" = "Jockey",
		":j" = "Bluespace",	".j" = "Bluespace",
		":y" = "Hailing",		".y" = "Hailing",
		":q" = "Ninja",		".q" = "Ninja",
		":u" = "Operations",	".u" = "Operations",
		":v" = "Service",		".v" = "Service",
		":p" = "AI Private",	".p" = "AI Private",
		":z" = "Entertainment",".z" = "Entertainment",
		":d" = "Expeditionary",".d" = "Expeditionary",

		":R" = "right ear",	".R" = "right ear",
		":L" = "left ear",	".L" = "left ear",
		":I" = "intercom",	".I" = "intercom",
		":H" = "department",	".H" = "department",
		":A" = "Common",		".A" = "Common",
		":C" = "Command",		".C" = "Command",
		":N" = "Science",		".N" = "Science",
		":M" = "Medical",		".M" = "Medical",
		":E" = "Engineering",	".E" = "Engineering",
		":F" = "Coalition Navy", ".F" = "Coalition Navy",
		":S" = "Security",	".S" = "Security",
		":Q" = "Penal",		".Q" = "Penal",
		":W" = "whisper",		".W" = "whisper",
		":T" = "Mercenary",	".T" = "Mercenary",
		":X" = "Raider",		".X" = "Raider",
		":B" = "Burglar",		".B" = "Burglar",
		":K" = "Jockey",			".K" = "Jockey",
		":J" = "Bluespace",	".J" = "Bluespace",
		":Y" = "Hailing",		".Y" = "Hailing",
		":Q" = "Ninja",		".Q" = "Ninja",
		":U" = "Operations",	".U" = "Operations",
		":V" = "Service",		".V" = "Service",
		":P" = "AI Private",	".P" = "AI Private",
		":Z" = "Entertainment",".Z" = "Entertainment",
		":D" = "Expeditionary",".D" = "Expeditionary",

		//kinda localization -- rastaf0
		//same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
		":ê" = "right ear",	".ê" = "right ear",
		":ä" = "left ear",	".ä" = "left ear",
		":ø" = "intercom",	".ø" = "intercom",
		":ð" = "department",	".ð" = "department",
		":ñ" = "Command",		".ñ" = "Command",
		":ò" = "Science",		".ò" = "Science",
		":ü" = "Medical",		".ü" = "Medical",
		":ó" = "Engineering",	".ó" = "Engineering",
		":û" = "Security",	".û" = "Security",
		":ö" = "whisper",		".ö" = "whisper",
		":å" = "Mercenary",	".å" = "Mercenary",
		":é" = "Operations",	".é" = "Operations"
)


var/list/channel_to_radio_key = new
/proc/get_radio_key_from_channel(var/channel)
	var/key = channel_to_radio_key[channel]
	if(!key)
		for(var/radio_key in department_radio_keys)
			if(department_radio_keys[radio_key] == channel)
				key = radio_key
				break
		if(!key)
			key = ""
		channel_to_radio_key[channel] = key

	return key

/mob/living/proc/binarycheck(var/mob/speaker)
	return FALSE

/mob/living/proc/get_stuttered_message(message)
	return stutter(message, stuttering)

/mob/living/proc/get_default_language()
	return default_language

/mob/proc/is_muzzled()
	return istype(wear_mask, /obj/item/clothing/mask/muzzle)

/mob/living/proc/handle_speech_problems(message, say_verb, message_mode, message_range)
	if(!length(message))
		return

	if(!message_range)
		message_range = world.view

	if((mutations & HULK) && !src.isSynthetic() && !isvaurca(src))
		var/ending = copytext(message, length(message), length(message) + 1)
		if(ending && GLOB.correct_punctuation[ending])
			message = copytext(message, 1, length(message))
		message = "[uppertext(message)]!!!"
		say_verb = pick("yells", "roars", "hollers")
		. = TRUE
	else if(brokejaw)
		message = slur(message, 100)
		say_verb = pick("slobbers", "slurs")
		switch(rand(1, 100))
			if(1 to 10)
				to_chat(src, SPAN_DANGER("You feel a sharp pain from your jaw as you speak!"))
				Weaken(3)
			if(11 to 60)
				to_chat(src, SPAN_WARNING("You struggle to speak with your dislocated jaw!"))
			else
				. = null //This does nothing, it's to avoid a dreamchecker error
		. = TRUE
	else if(stuttering)
		message = get_stuttered_message(message)
		say_verb = pick(get_stutter_verbs())
		. = TRUE
	else if(slurring)
		message = slur(message, slurring)
		say_verb = pick("slobbers", "slurs")
		. = TRUE
	else if(HAS_TRAIT(src, TRAIT_SPEAKING_GIBBERISH))
		message = Gibberish(message, 40)
		say_verb = pick("blurbles", "blorps")
		. = TRUE

	if(.)
		return list(
			HSP_MSG = message,
			HSP_VERB = say_verb,
			HSP_MSGMODE = message_mode,
			HSP_MSGRANGE = message_range
		)

/mob/living/proc/get_stutter_verbs()
	return list("stammers", "stutters")

/mob/living/proc/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name, whisper)
	if(message_mode == "intercom")
		for(var/obj/item/radio/intercom/I in view(1, src))
			used_radios += I
			I.talk_into(src, message, verb, speaking)

	if(message_mode == "whisper" && !whisper)
		whisper(message, speaking, say_verb = TRUE)
		return TRUE

	return FALSE

/mob/living/proc/handle_speech_sound()
	var/list/returns[3]
	returns[1] = null
	returns[2] = null
	returns[3] = FALSE
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending=="!")
		return pick("exclaims","shouts","yells")
	if(ending=="?")
		return "asks"
	return verb

/mob/living/proc/get_font_size_modifier()
	if(ismech(loc))
		var/mob/living/heavy_vehicle/HV = loc
		if(HV.loudening)
			return FONT_SIZE_LARGE
	return null

/mob/proc/check_speech_punctuation_state(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "question"
	else if (ending == "!")
		return "exclamation"
	return "statement"


/mob/living/say(var/message, var/datum/language/speaking = null, var/verb, var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE, var/skip_edit = FALSE)
	if(stat)
		if(stat == DEAD)
			return say_dead(message)
		return

	if(silent)
		to_chat(src, SPAN_WARNING("You try to speak, but nothing comes out!"))
		return

	var/message_mode = parse_message_mode(message, "headset")

	var/regex/emote = regex("^(\[\\*^\])\[^*\]+$")

	if(emote.Find(message))
		if(emote.group[1] == "*") return client_emote(copytext(message, 2))
		if(emote.group[1] == "^") return custom_emote(VISIBLE_MESSAGE, copytext(message,2))

	//parse the radio code and consume it
	if (message_mode)
		if (message_mode == "headset")
			message = copytext(message,2)	//it would be really nice if the parse procs could do this for us.
		else
			message = copytext(message,3)

	message = trim(message)
	message = formalize_text(message)

	var/datum/say_message/msg
	if(copytext(message, 1, 2) == "!")	// audible emote
		msg = new
		msg.speaker = src
		msg.raw_message = message
		msg.collapse_to(GLOB.all_languages[LANGUAGE_NOISE], trim_left(copytext(message, 2)))
	else
		var/datum/language/forced = (speaking && !speaking.always_parse_language) ? speaking : null
		msg = build_say_message(message, forced)

	if(!length(msg.to_string()))
		return FALSE

	// the first segment's language is the message's primary
	var/datum/language/primary = msg.segments[1].language
	var/list/speech_mod = primary?.handle_message_mode(message_mode)
	if(speech_mod)
		primary = speech_mod[1]
		message_mode = speech_mod[2]

	if(copytext(msg.segments[1].text, 1, 2) == "%")
		msg.segments[1].text = copytext(msg.segments[1].text, 2)
		if(primary?.sing_verb)
			msg.singing = TRUE
			msg.sing_note = pick("\u2669", "\u266A", "\u266B")

	// hivemind languages reach all speakers regardless of distance
	if(msg.single_language?.flags & HIVEMIND)
		if(msg.single_language.name == LANGUAGE_VAURCA && within_jamming_range(src))
			to_chat(src, SPAN_WARNING("Your head buzzes as your message is blocked with jamming signals."))
			return
		msg.single_language.broadcast(src, trim(msg.to_string()))
		return TRUE

	msg.verb = verb || say_quote(msg.to_string(), primary, msg.singing, whisper)

	var/is_shouting = FALSE
	if(primary)
		for(var/verb_to_check in primary.shout_verb)
			if(verb_to_check == msg.verb)
				is_shouting = TRUE
				break

	if(is_muzzled())
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
		return

	msg.message_mode = message_mode
	msg.message_range = world.view
	msg.whisper = whisper
	msg.alt_name = alt_name
	msg.ghost_hearing = ghost_hearing
	msg.mode = SAYMODE_SPOKEN

	// autohiss and speech problems run per segment, skipping NO_STUTTER languages
	if(!skip_edit)
		for(var/datum/say_segment/segment as anything in msg.segments)
			if(segment.language && (segment.language.flags & NO_STUTTER))
				continue
			segment.text = handle_autohiss(segment.text, segment.language)
			var/list/hsp_params = handle_speech_problems(segment.text, msg.verb, msg.message_mode, msg.message_range)
			if(hsp_params)
				segment.text = hsp_params[HSP_MSG] || segment.text
				msg.verb = hsp_params[HSP_VERB] || msg.verb
				msg.message_mode = hsp_params[HSP_MSGMODE] || msg.message_mode
				msg.message_range = hsp_params[HSP_MSGRANGE] || msg.message_range
	for(var/datum/say_segment/segment as anything in msg.segments)
		segment.text = process_chat_markup(segment.text, list("~", "_"))

	if(!length(msg.to_string()))
		return FALSE

	if(msg.single_language?.flags & SIGNLANG)
		return say_signlang(msg.to_string(), pick(msg.single_language.signlang_verb), msg.single_language, msg.single_language.sign_adv_length)
	if(primary && (primary.flags & NONVERBAL) && prob(30))
		custom_emote(VISIBLE_MESSAGE, "[pick(primary.signlang_verb)].")

	message = msg.to_string()

	var/list/obj/item/used_radios = new
	if(handle_message_mode(msg.message_mode, message, msg.verb, primary, used_radios, alt_name, whisper, msg.singing))
		return TRUE

	var/list/handle_v = handle_speech_sound()
	msg.speech_sound = handle_v[1]
	msg.sound_vol = handle_v[2]
	msg.italics = handle_v[3]
	msg.font_size = get_font_size_modifier()

	//speaking into radios
	if(length(used_radios))
		msg.italics = TRUE
		msg.message_range = 1
		if(primary)
			msg.message_range = primary.get_talkinto_msg_range(message)
		if(!primary || !(primary.flags & NO_TALK_MSG))
			var/talk_msg = SPAN_NOTICE("\The [src] talks into \the [used_radios[1]].")
			for (var/mob/living/L in get_hearers_in_view(5, src) - src)
				L.show_message(talk_msg)
		if(msg.speech_sound)
			msg.sound_vol *= 0.5

	var/list/listening = list()
	var/turf/T = get_turf(src)

	if(whisper)
		msg.message_range = 1
		msg.italics = TRUE

	if(T)
		if(!msg.single_language || !(msg.single_language.flags & PRESSUREPROOF))
			//make sure the air can transmit speech - speaker's side
			var/datum/gas_mixture/environment = T.return_air()
			var/pressure = SAFE_XGM_PRESSURE(environment)
			if(pressure < SOUND_MINIMUM_PRESSURE)
				msg.message_range = 1

			if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
				msg.italics = TRUE
				msg.sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		listening = get_hearers_in_view(msg.message_range, src)

		var/sensitive_listener = get_intent_listeners(src, msg.message_range + 1)
		listening = mergelists(listening, sensitive_listener, TRUE)

	if(client)
		for (var/mob/player_mob in GLOB.player_list)
			if(!player_mob || player_mob.stat != DEAD || (player_mob in listening))
				continue
			if(player_mob.client?.prefs.toggles & CHAT_GHOSTRADIO && length(used_radios)) //If they are talking into a radio and we hear all radio messages, don't duplicate for observers
				continue
			if(player_mob.client?.prefs.toggles & CHAT_GHOSTEARS)
				listening |= player_mob

	var/list/hear_clients = list()
	for(var/mob/M in listening)
		if(M.hear_message(msg) && M.client)
			hear_clients += M.client
		listening -= M

	var/speech_bubble_state = check_speech_punctuation_state(message)
	var/speech_state_modifier = get_speech_bubble_state_modifier()
	if(speech_bubble_state && speech_state_modifier)
		speech_bubble_state = "[speech_state_modifier]_[speech_bubble_state]"

	var/image/speech_bubble
	if(speech_bubble_state)
		speech_bubble = image('icons/mob/talk.dmi', src, speech_bubble_state)
		adjust_typing_indicator_offsets(speech_bubble)
		speech_bubble.layer = layer
		speech_bubble.plane = plane

	speech_bubble.appearance_flags = RESET_COLOR|RESET_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(animate_speechbubble), speech_bubble, hear_clients, 30)

	var/list/langchat_styles = list()
	if(istype(primary, /datum/language/noise))
		langchat_styles = list("emote", "langchat_small")
	if(whisper)
		langchat_styles = list("langchat_italic")
	if(is_shouting)
		langchat_styles = list("langchat_yell")

	langchat_speech(message, get_hearers_in_view(msg.message_range, src), primary, additional_styles = langchat_styles)

	var/bypass_listen_obj = (msg.single_language && (msg.single_language.flags & PASSLISTENOBJ))
	if(!bypass_listen_obj)
		for(var/obj/O as anything in listening)
			if(O) //It's possible that it could be deleted in the meantime.
				INVOKE_ASYNC(O, TYPE_PROC_REF(/obj, hear_talk), src, message, msg.verb, primary)

	if(mind)
		mind.last_words = message

	if(whisper)
		log_whisper("[key_name(src)] : [msg.raw_message]")
	else
		log_say("[key_name(src)] : [msg.raw_message]")

	return TRUE

/proc/animate_speechbubble(image/I, list/show_to, duration)
	var/matrix/M = matrix()
	M.Scale(0,0)
	I.transform = M
	I.alpha = 0
	for(var/client/C in show_to)
		C.images += I
	animate(I, transform = 0, alpha = 255, time = 5, easing = ELASTIC_EASING)
	sleep(duration-5)
	animate(I, alpha = 0, time = 5, easing = EASE_IN)
	sleep(5)
	for(var/client/C in show_to)
		C.images -= I

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language, var/list/sign_adv_length)
	log_say("[key_name(src)] : ([get_lang_name(language)]) [message]")

	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src, sign_adv_length)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/proc/GetVoice()
	return name
