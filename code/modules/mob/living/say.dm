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

/mob/living/get_default_language()
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

/mob/living/proc/handle_message_mode(datum/say_message/msg, datum/language/primary, list/used_radios)
	var/text = msg.to_string()
	var/message_mode = msg.message_mode
	if(message_mode == "intercom")
		for(var/obj/item/radio/intercom/I in view(1, src))
			used_radios += I
			I.talk_into(src, text, null, msg.message_mods[SAY_MOD_VERB], primary, say_message = msg)

	if(message_mode == "whisper" && !msg.whisper)
		whisper(text, primary, say_verb = TRUE, msg = msg)
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


/mob/living/finalize_say_message(datum/say_message/msg, skip_edit = FALSE)
	if(!skip_edit)
		for(var/datum/say_segment/segment as anything in msg.segments)
			if(segment.language && (segment.language.flags & NO_STUTTER))
				continue
			segment.text = handle_autohiss(segment.text, segment.language)
			var/list/hsp_params = handle_speech_problems(segment.text, msg.message_mods[SAY_MOD_VERB], msg.message_mode, msg.message_range)
			if(hsp_params)
				segment.text = hsp_params[HSP_MSG] || segment.text
				msg.message_mods[SAY_MOD_VERB] = hsp_params[HSP_VERB] || msg.message_mods[SAY_MOD_VERB]
				msg.message_mode = hsp_params[HSP_MSGMODE] || msg.message_mode
				msg.message_range = hsp_params[HSP_MSGRANGE] || msg.message_range
	return ..()

/// Builds and animates the speech bubble over the speaker for the given clients.
/mob/living/show_speech_bubble(datum/say_message/msg, message, list/client/show_to)
	var/speech_bubble_state = check_speech_punctuation_state(message)
	var/speech_state_modifier = get_speech_bubble_state_modifier()
	if(speech_bubble_state && speech_state_modifier)
		speech_bubble_state = "[speech_state_modifier]_[speech_bubble_state]"
	if(!speech_bubble_state)
		return
	var/image/speech_bubble = image('icons/mob/talk.dmi', src, speech_bubble_state)
	adjust_typing_indicator_offsets(speech_bubble)
	speech_bubble.layer = layer
	speech_bubble.plane = plane
	speech_bubble.appearance_flags = RESET_COLOR|RESET_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(animate_speechbubble), speech_bubble, show_to, 30)

/mob/living/say(text, datum/language/speaking = null, list/message_mods = null, ghost_hearing = GHOSTS_ALL_HEAR, whisper = FALSE, skip_edit = FALSE, message_range = null, list/spans = null, sanitize = TRUE)
	if(stat)
		if(stat == DEAD)
			return say_dead(text)
		return

	if(silent)
		to_chat(src, SPAN_WARNING("You try to speak, but nothing comes out!"))
		return

	message_mods = message_mods ? message_mods.Copy() : list()
	var/is_broadcast = message_mods[MODE_AMPLIFIED]
	var/message_mode = is_broadcast ? null : parse_message_mode(text, "headset")

	var/regex/emote = regex("^(\[\\*^\])\[^*\]+$")

	if(emote.Find(text))
		if(emote.group[1] == "*") return client_emote(copytext(text, 2))
		if(emote.group[1] == "^") return custom_emote(VISIBLE_MESSAGE, copytext(text,2))

	//parse the radio code and consume it
	if (message_mode)
		if (message_mode == "headset")
			text = copytext(text,2)	//it would be really nice if the parse procs could do this for us.
		else
			text = copytext(text,3)

	text = trim(text)
	text = formalize_text(text)

	message_mods[SAY_MOD_MESSAGE_MODE] = message_mode
	return ..(text, speaking, message_mods, ghost_hearing, whisper, skip_edit, message_range, spans, sanitize)

/mob/living/prepare_say_message(datum/say_message/msg, skip_edit, list/used_radios)
	// the first segment's language is the message's primary
	var/datum/language/primary = msg.segments[1].language
	var/message_mode = msg.message_mode
	var/is_broadcast = msg.message_mods[MODE_AMPLIFIED]
	var/text = msg.to_string()
	var/list/speech_mod = primary?.handle_message_mode(message_mode)
	if(speech_mod)
		primary = speech_mod[1]
		message_mode = speech_mod[2]

	// hivemind languages reach all speakers regardless of distance
	if(msg.single_language?.flags & HIVEMIND)
		if(msg.single_language.name == LANGUAGE_VAURCA && within_jamming_range(src))
			to_chat(src, SPAN_WARNING("Your head buzzes as your message is blocked with jamming signals."))
			return
		msg.single_language.broadcast(src, trim(msg.to_string()))
		return SAY_PREPARE_HANDLED

	if(is_muzzled())
		to_chat(src, SPAN_DANGER("You're muzzled and cannot speak!"))
		return

	msg.message_mode = message_mode

	if(!..(msg, skip_edit, used_radios))
		return FALSE

	if(msg.single_language?.flags & SIGNLANG)
		msg.say_mode = SAYMODE_SIGN
		msg.message_mods[SAY_MOD_VERB] = pick(msg.single_language.signlang_verb)
		return say_signlang(msg) ? SAY_PREPARE_HANDLED : FALSE
	if(primary && (primary.flags & NONVERBAL) && prob(30))
		custom_emote(VISIBLE_MESSAGE, "[pick(primary.signlang_verb)].")

	text = msg.to_string()

	if(handle_message_mode(msg, primary, used_radios))
		return SAY_PREPARE_HANDLED

	var/list/handle_v = handle_speech_sound()
	msg.speech_sound = handle_v[1]
	msg.sound_vol = handle_v[2]
	msg.italics = handle_v[3]
	msg.font_size = is_broadcast ? FONT_SIZE_HUGE : get_font_size_modifier()

	//speaking into radios
	if(length(used_radios))
		msg.italics = TRUE
		msg.message_range = min(msg.message_range, 1)
		if(primary)
			msg.message_range = min(msg.message_range, primary.get_talkinto_msg_range(text))
		if(!primary || !(primary.flags & NO_TALK_MSG))
			var/talk_msg = SPAN_NOTICE("\The [src] talks into \the [used_radios[1]].")
			for (var/mob/living/L in get_hearers_in_view(5, src) - src)
				L.show_message(talk_msg)
		if(msg.speech_sound)
			msg.sound_vol *= 0.5

	return SAY_PREPARE_CONTINUE

/mob/living/get_speech_listeners(datum/say_message/msg, list/used_radios, ghost_hearing)
	var/list/listening = ..()
	if(client && ghost_hearing == GHOSTS_ALL_HEAR)
		for (var/mob/player_mob in GLOB.player_list)
			if(!player_mob || player_mob.stat != DEAD || (player_mob in listening))
				continue
			if(player_mob.client?.prefs.toggles & CHAT_GHOSTRADIO && length(used_radios)) //If they are talking into a radio and we hear all radio messages, don't duplicate for observers
				continue
			if(player_mob.client?.prefs.toggles & CHAT_GHOSTEARS)
				listening |= player_mob

	return listening

/mob/living/finish_say_message(datum/say_message/msg)
	if(mind)
		mind.last_words = msg.to_string()
	if(msg.whisper)
		log_whisper("[key_name(src)] : [msg.raw_message]")
	else
		log_say("[key_name(src)] : [msg.raw_message]")

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

/mob/living/proc/say_signlang(datum/say_message/msg)
	log_say("[key_name(src)] : ([get_lang_name(msg.single_language)]) [msg.raw_message]")

	for(var/mob/O in viewers(src, null))
		O.hear_message(msg)
	return TRUE

/obj/effect/speech_bubble
	var/mob/parent
