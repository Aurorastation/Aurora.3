#define MICROPHONE_LISTEN_RANGE 5
/obj/item/radio/microphone
	name = "handheld microphone"
	desc = "A handheld microphone, used for on-the-fly interviewing. Pose for the fans!"
	icon_state = "microphone"
	item_state = "microphone"
	canhear_range = MICROPHONE_LISTEN_RANGE
	/// If we have specific people we want to be able to speak into the microphone.
	var/directed_listening = TRUE
	/// A lazylist of the people allowed to talk into the microphone. Essentially acts as a filter.
	var/list/mob/living/listeners
	/// If the messages end with these endings, bypass the listener check.
	var/static/list/word_bypasses = list("!", "!!", "?!", "!?")

/obj/item/radio/microphone/Initialize()
	. = ..()
	set_frequency(ENT_FREQ)
	internal_channels = list(num2text(ENT_FREQ) = list())

/obj/item/radio/microphone/Destroy()
	LAZYNULL(listeners)
	return ..()

/obj/item/radio/microphone/attack_hand(mob/user)
	. = ..()
	directed_listening = !directed_listening
	to_chat(user, SPAN_NOTICE("You are now [directed_listening ? "" : "no longer "]listening to specific people."))

/obj/item/radio/microphone/get_examine_text(mob/user, distance, is_adjacent, infix, suffix, get_extended)
	. = ..()
	. += SPAN_NOTICE("You are [directed_listening ? "" : SPAN_BOLD("not ")]listening to specific people with the microphone.")
	if(LAZYLEN(listeners))
		. += SPAN_NOTICE("You are angling the microphone specifically towards the following people: [SPAN_BOLD(english_list(listeners))].")

/obj/item/radio/microphone/mechanics_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += "By default, your microphone will not allow anyone other than you to speak into it."
	. += "You can [SPAN_BOLD("click")] someone with the microphone in hand to allow them to speak into it. [SPAN_BOLD("Click")] them again to disallow them again."
	. += "If someone moves more than 5 tiles away from your microphone, they will automatically be removed from the list."

/obj/item/radio/microphone/pickup(mob/user)
	. = ..()
	add_listener(user)

/obj/item/radio/microphone/dropped(mob/user)
	. = ..()
	remove_listener(user)

/obj/item/radio/microphone/attack(mob/living/target_mob, mob/living/user, target_zone)
	. = ..()
	if(get_dist(target_mob, get_turf(src)) < MICROPHONE_LISTEN_RANGE)
		if(!(target_mob in listeners))
			to_chat(user, SPAN_NOTICE("You angle the microphone to allow [target_mob] to speak into it."))
			add_listener(target_mob)
		else
			to_chat(user, SPAN_NOTICE("You angle the microphone away from [target_mob]."))
			remove_listener(target_mob)

/**
 * Add a mob to the list of listeners allowed to speak into the microphone.
 */
/obj/item/radio/microphone/proc/add_listener(mob/living/target_mob)
	LAZYADD(listeners, target_mob)
	RegisterSignal(target_mob, COMSIG_MOVABLE_MOVED, check_listener_distance())

/**
 * Remove a mob from the list of listeners allowed to speak into the microphone.
 */
/obj/item/radio/microphone/proc/remove_listener(mob/living/target_mob)
	UnregisterSignal(target_mob, COMSIG_MOVABLE_MOVED)
	LAZYREMOVE(listeners, target_mob)

/**
 * Checks if the mob is too far from the microphone, at which point we stop listening to them.
 **/
/obj/item/radio/microphone/proc/check_listener_distance(datum/source)
	SIGNAL_HANDLER
	if(get_dist(source, get_turf(src)) > MICROPHONE_LISTEN_RANGE)
		LAZYREMOVE(listeners, source)
		if(ismob(loc))
			var/mob/M = loc
			to_chat(M, SPAN_NOTICE("[source] moves away from the microphone."))

/obj/item/radio/microphone/hear_talk(mob/M, msg, var/verb = "says", datum/language/speaking)
    var/message_ending = copytext(msg, length(msg) - 1, length(msg)) //copies the last 2 letters
    if(directed_listening && ((M in listeners) || (message_ending in word_bypasses)))
        return ..()

#undef MICROPHONE_LISTEN_RANGE
