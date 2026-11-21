// See code/__DEFINES/messages.dm for visible and audible message flags

/**
 * Generate a visible message from this atom
 *
 * Show a message to all player mobs who sees this atom
 *
 * Show a message to the src mob (if the src is a mob)
 *
 * Use for atoms performing visible actions
 *
 * message is output to anyone who can see, e.g. `"The [src] does something!"`
 *
 * Vars:
 * * message is the message output to anyone who can see.
 * * self_message (optional) is what the src mob sees e.g. "You do something!"
 * * blind_message (optional) is what blind people will hear e.g. "You hear something!"
 * * vision_distance (optional) define how many tiles away the message can be seen.
 * * ignored_mobs (optional) doesn't show any message to any mob in this list.
 * * visible_message_flags (optional) controls message delivery and formatting. Use LOCAL_MESSAGE to omit distant observer chat.
 * * intent_message - A message sent via `intent_message()`
 * * intent_range - The range considered for the evaluation of the `intent_message`
 * * emote_message (optional) supplies a complete formatted chat sentence when EMOTE_MESSAGE is set, preserving existing emotes and custom `^` name placement without prepending the speaker's name twice.
 */
/atom/proc/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, visible_message_flags = NONE, intent_message = null, intent_range = DEFAULT_MESSAGE_RANGE, emote_message = null)
	SHOULD_NOT_SLEEP(TRUE)
	var/turf/T = get_turf(src)
	if(!T)
		return

	if(isnull(vision_distance))
		vision_distance = DEFAULT_MESSAGE_RANGE

	if(!islist(ignored_mobs))
		ignored_mobs = list(ignored_mobs)
	var/list/hearers = T ? get_hearers_in_view(vision_distance, src) : list()
	if(!hearers)
		hearers = list()
	var/list/local_hearers = hearers.Copy()
	hearers -= ignored_mobs

	var/raw_msg = message
	if(visible_message_flags & WITH_EMPHASIS_MESSAGE)
		message = process_chat_markup(message)
		raw_msg = message
		if(!isnull(emote_message))
			emote_message = process_chat_markup(emote_message)
	if(visible_message_flags & EMOTE_MESSAGE)
		langchat_drop_images()
		message = span("emote", (isnull(emote_message) ? "<b>[src]</b> [message]" : emote_message))

	var/list/delivered_mobs = list()
	var/list/objects = list()
	var/mob/source_mob = ismob(src) ? src : null
	for(var/atom/movable/hearer as anything in hearers)
		if(!ismob(hearer))
			objects |= hearer
			continue
		var/mob/hearing_mob = hearer
		if(!hearing_mob.client || (hearing_mob in delivered_mobs))
			continue
		if(self_message && hearing_mob == src)
			continue
		var/msg = message
		var/msg_type = VISIBLE_MESSAGE
		if((source_mob && source_mob.is_invisible_to(hearing_mob)) || (!source_mob && (hearing_mob.see_invisible < invisibility || !alpha)))
			msg = blind_message
			msg_type = AUDIBLE_MESSAGE
		else if(T != loc && T != src)
			if(hearing_mob != loc)
				msg = blind_message
				msg_type = AUDIBLE_MESSAGE
		else if(!T.luminosity && get_dist(hearing_mob, T) > max(1, hearing_mob.see_in_dark) && hearing_mob.lighting_alpha >= LIGHTING_PLANE_ALPHA_VISIBLE)
			msg = blind_message
			msg_type = AUDIBLE_MESSAGE
		if(!msg)
			continue
		if(isghost(hearing_mob))
			msg = "[ghost_follow_link(src, hearing_mob)] [msg]"
		var/list/perceived = hearing_mob.show_message(msg, msg_type, blind_message, AUDIBLE_MESSAGE)
		if(!perceived)
			continue
		delivered_mobs |= hearing_mob
		if(visible_message_flags & EMOTE_MESSAGE && perceived[2] && runechat_prefs_check(hearing_mob, TRUE))
			var/bubble_text = perceived[2] == VISIBLE_MESSAGE ? raw_msg : blind_message
			if(bubble_text)
				langchat_build_image(bubble_text, list(hearing_mob), additional_styles = list("emote", "langchat_small"))

	for(var/atom/movable/hearer as anything in objects)
		if(ismob(src) && isobj(hearer))
			var/obj/object_listener = hearer
			object_listener.see_emote(src, message, VISIBLE_MESSAGE)
		else
			hearer.show_message(message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE)
	if(!(visible_message_flags & LOCAL_MESSAGE))
		for(var/mob/observer as anything in GLOB.dead_mob_list)
			if(!isghost(observer) || !observer.client || (observer in delivered_mobs) || (observer in ignored_mobs) || (self_message && observer == src))
				continue
			if(observer.client.prefs.toggles & CHAT_GHOSTSIGHT && message)
				to_chat(observer, "[ghost_follow_link(src, observer)] [message]")
	if(visible_message_flags & EMOTE_MESSAGE)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_images)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	if(intent_message && T)
		intent_message(intent_message, intent_range, local_hearers)
	if(ismovable(src))
		var/atom/movable/movable_source = src
		if(movable_source.bound_overlay)
			movable_source.bound_overlay.visible_message(raw_msg, blind_message = blind_message, vision_distance = vision_distance, ignored_mobs = ignored_mobs | delivered_mobs, visible_message_flags = (visible_message_flags & ~WITH_EMPHASIS_MESSAGE) | LOCAL_MESSAGE, emote_message = message)

///Adds the functionality to self_message.
/mob/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, visible_message_flags = NONE, intent_message = null, intent_range = DEFAULT_MESSAGE_RANGE, emote_message = null)
	. = ..()
	if(!self_message || (src in ignored_mobs))
		return
	var/raw_self_message = self_message
	var/block_self_highlight = visible_message_flags & BLOCK_SELF_HIGHLIGHT_MESSAGE
	if(visible_message_flags & WITH_EMPHASIS_MESSAGE)
		self_message = process_chat_markup(self_message)
		raw_self_message = self_message
	if(visible_message_flags & EMOTE_MESSAGE)
		self_message = span("emote", self_message)
	var/list/perceived
	if(visible_message_flags & ALWAYS_SHOW_SELF_MESSAGE)
		to_chat(src, self_message, avoid_highlighting = block_self_highlight)
		perceived = list(self_message, VISIBLE_MESSAGE)
	else
		perceived = show_message(self_message, VISIBLE_MESSAGE, blind_message, AUDIBLE_MESSAGE, block_self_highlight)
	if(perceived && perceived[2] && (visible_message_flags & EMOTE_MESSAGE) && runechat_prefs_check(src, TRUE))
		var/bubble_text = perceived[2] == VISIBLE_MESSAGE ? raw_self_message : blind_message
		if(bubble_text)
			// Append self's bubble without clearing the audience bubbles created by the parent.
			langchat_build_image(bubble_text, list(src), additional_styles = list("emote", "langchat_small"))
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_images)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/**
 * Show a message to all mobs in earshot of this atom
 *
 * Show a message to all player mobs who hears this atom
 *
 * Show a message to the src mob (if the src is a mob)
 *
 * Use for objects performing audible actions
 *
 * message is output to anyone who can hear, e.g. `"The [src] does something!"`
 *
 * vars:
 * * message is the message output to anyone who can hear.
 * * self_message (optional) is what the src mob hears.
 * * deaf_message (optional) is what deaf people will see.
 * * hearing_distance (optional) is the range, how many tiles away the message can be heard.
 * * audible_message_flags (optional) controls message delivery and formatting. Use LOCAL_MESSAGE to omit distant observer chat.
 * * intent_message - A message sent via `intent_message()`
 * * intent_range - The range considered for the evaluation of the `intent_message`
 * * emote_message (optional) supplies a complete formatted chat sentence when EMOTE_MESSAGE is set, preserving existing emotes and custom `^` name placement without prepending the speaker's name twice.
 */
/atom/proc/audible_message(message, self_message, deaf_message, hearing_distance = DEFAULT_MESSAGE_RANGE, audible_message_flags = NONE, intent_message = null, intent_range = DEFAULT_MESSAGE_RANGE, emote_message = null)
	SHOULD_NOT_SLEEP(TRUE)

	if(isnull(hearing_distance))
		hearing_distance = DEFAULT_MESSAGE_RANGE

	var/turf/T = get_turf(src)
	if(!T)
		return

	var/list/hearers = T ? get_hearers_in_view(hearing_distance, src) : list()
	if(!hearers)
		hearers = list()
	var/raw_msg = message
	if(audible_message_flags & WITH_EMPHASIS_MESSAGE)
		message = process_chat_markup(message)
		raw_msg = message
		if(!isnull(emote_message))
			emote_message = process_chat_markup(emote_message)
	if(audible_message_flags & EMOTE_MESSAGE)
		langchat_drop_images()
		message = span("emote", (isnull(emote_message) ? "<b>[src]</b> [message]" : emote_message))
	var/mob/source_mob = ismob(src) ? src : null
	var/list/delivered_mobs = list()
	for(var/atom/movable/hearer as anything in hearers)
		if(!ismob(hearer))
			hearer.show_message(message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)
			continue
		var/mob/hearing_mob = hearer
		if(!hearing_mob.client || (hearing_mob in delivered_mobs))
			continue
		if(self_message && hearing_mob == src)
			continue
		var/msg = source_mob && message ? "[source_mob.get_accent_icon(null, hearing_mob)] [message]" : message
		var/list/perceived = hearing_mob.show_message(msg, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE)
		if(!perceived)
			continue
		delivered_mobs |= hearing_mob
		if(audible_message_flags & EMOTE_MESSAGE && perceived[2] && runechat_prefs_check(hearing_mob, TRUE))
			var/bubble_text = perceived[2] == AUDIBLE_MESSAGE ? raw_msg : deaf_message
			if(bubble_text)
				langchat_build_image(bubble_text, list(hearing_mob), additional_styles = list("emote", "langchat_small"))

	if(!(audible_message_flags & LOCAL_MESSAGE))
		for(var/mob/observer as anything in GLOB.dead_mob_list)
			if(!isghost(observer) || !observer.client || (observer in delivered_mobs) || (self_message && observer == src))
				continue
			if(observer.client.prefs.toggles & CHAT_GHOSTEARS && message)
				to_chat(observer, "[ghost_follow_link(src, observer)] [message]")
	if(audible_message_flags & EMOTE_MESSAGE)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_images)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)
	if(intent_message && T)
		intent_message(intent_message, intent_range, hearers)

///Adds the functionality to self_message.
/mob/audible_message(message, self_message, deaf_message, hearing_distance = DEFAULT_MESSAGE_RANGE, audible_message_flags = NONE, intent_message = null, intent_range = DEFAULT_MESSAGE_RANGE, emote_message = null)
	. = ..()
	if(!self_message)
		return
	var/raw_self_message = self_message
	var/block_self_highlight = audible_message_flags & BLOCK_SELF_HIGHLIGHT_MESSAGE
	if(audible_message_flags & WITH_EMPHASIS_MESSAGE)
		self_message = process_chat_markup(self_message)
		raw_self_message = self_message
	if(audible_message_flags & EMOTE_MESSAGE)
		self_message = span("emote", self_message)
	var/list/perceived
	if(audible_message_flags & ALWAYS_SHOW_SELF_MESSAGE)
		to_chat(src, self_message, avoid_highlighting = block_self_highlight)
		perceived = list(self_message, AUDIBLE_MESSAGE)
	else
		self_message = "[get_accent_icon(null, src)] [self_message]"
		perceived = show_message(self_message, AUDIBLE_MESSAGE, deaf_message, VISIBLE_MESSAGE, block_self_highlight)
	if(perceived && perceived[2] && (audible_message_flags & EMOTE_MESSAGE) && runechat_prefs_check(src, TRUE))
		var/bubble_text = perceived[2] == AUDIBLE_MESSAGE ? raw_self_message : deaf_message
		if(bubble_text)
			langchat_build_image(bubble_text, list(src), additional_styles = list("emote", "langchat_small"))
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, langchat_drop_images)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_NO_HASH_WAIT)

/atom/proc/intent_message(message, range = DEFAULT_MESSAGE_RANGE, list/hearers = list())
	SHOULD_NOT_SLEEP(TRUE)
	if(air_sound(src))
		if(!length(hearers))
			hearers = get_hearers_in_view(range, src)
		for(var/mob/living/carbon/human/H as anything in GLOB.intent_listener)
			if(!(H in hearers))
				if(src.z == H.z && get_dist(src, H) <= range)
					H.intent_listen(src, message)
