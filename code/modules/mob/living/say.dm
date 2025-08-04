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
		for(var/obj/item/device/radio/intercom/I in view(1, src))
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

	var/had_speaking = !!speaking
	//parse the language code and consume it
	if(!speaking || speaking.always_parse_language)
		speaking = parse_language(message)
	if(!had_speaking)
		if(speaking)
			message = copytext(message,2+length(speaking.key))
		else
			speaking = get_default_language()

	if(speaking)
		var/list/speech_mod = speaking.handle_message_mode(message_mode)
		speaking = speech_mod[1]
		message_mode = speech_mod[2]

	var/is_singing = FALSE
	if(length(message) >= 1 && copytext(message, 1, 2) == "%")
		message = copytext(message, 2)
		if(speaking?.sing_verb)
			is_singing = TRUE

	// This is broadcast to all mobs with the language,
	// irrespective of distance or anything else.
	if(speaking && (speaking.flags & HIVEMIND))
		if(speaking.name == LANGUAGE_VAURCA && within_jamming_range(src))
			to_chat(src, SPAN_WARNING("Your head buzzes as your message is blocked with jamming signals."))
			return
		speaking.broadcast(src,trim(message))
		return TRUE

	if(!verb)
		verb = say_quote(message, speaking, is_singing, whisper)

	if(is_muzzled())
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
		return

	message = trim_left(message)
	var/message_range = world.view
	if(!skip_edit && !(speaking && (speaking.flags & NO_STUTTER)))
		message = handle_autohiss(message, speaking)
		var/list/hsp_params = handle_speech_problems(message, verb, message_mode, message_range)
		if(hsp_params)
			message = hsp_params[HSP_MSG] || message
			verb = hsp_params[HSP_VERB] || verb
			message_mode = hsp_params[HSP_MSGMODE] || message_mode
			message_range = hsp_params[HSP_MSGRANGE] || message_range

	if(!message || message == "")
		return FALSE

	message = process_chat_markup(message, list("~", "_"))
	if(is_singing)
		var/randomnote = pick("\u2669", "\u266A", "\u266B")
		message = "[randomnote] <span class='singing'>[message]</span> [randomnote]"

	//handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & NONVERBAL)
			if (prob(30))
				src.custom_emote(VISIBLE_MESSAGE, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & SIGNLANG)
			return say_signlang(message, pick(speaking.signlang_verb), speaking, speaking.sign_adv_length)

	var/list/obj/item/used_radios = new
	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name, whisper, is_singing))
		return TRUE

	var/list/handle_v = handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2]
	var/italics = handle_v[3]

	//speaking into radios
	if(length(used_radios))
		italics = TRUE
		message_range = 1
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		if(!speaking || !(speaking.flags & NO_TALK_MSG))
			var/msg = SPAN_NOTICE("\The [src] talks into \the [used_radios[1]].")
			for (var/mob/living/L in get_hearers_in_view(5, src) - src)
				L.show_message(msg)
		if(speech_sound)
			sound_vol *= 0.5

	var/list/listening = list()
	var/turf/T = get_turf(src)

	if(whisper)
		message_range = 1
		italics = TRUE

	if(T)
		if(!speaking || !(speaking.flags & PRESSUREPROOF))
			//make sure the air can transmit speech - speaker's side
			var/datum/gas_mixture/environment = T.return_air()
			var/pressure = (environment)? environment.return_pressure() : 0
			if(pressure < SOUND_MINIMUM_PRESSURE)
				message_range = 1

			if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
				italics = TRUE
				sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

		listening = get_hearers_in_view(message_range, src)

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
		var/heard_say = M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol, get_font_size_modifier())
		if(heard_say && M.client)
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
	if(istype(speaking, /datum/language/noise))
		langchat_styles = list("emote", "langchat_small")

	langchat_speech(message, get_hearers_in_view(message_range, src), speaking, additional_styles = langchat_styles)

	var/bypass_listen_obj = (speaking && (speaking.flags & PASSLISTENOBJ))
	if(!bypass_listen_obj)
		for(var/obj/O as anything in listening)
			if(O) //It's possible that it could be deleted in the meantime.
				INVOKE_ASYNC(O, TYPE_PROC_REF(/obj, hear_talk), src, message, verb, speaking)

	if(mind)
		mind.last_words = message

	if(whisper)
		log_whisper("[key_name(src)] : ([get_lang_name(speaking)]) [message]")
	else
		log_say("[key_name(src)] : ([get_lang_name(speaking)]) [message]")

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
