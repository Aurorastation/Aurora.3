/mob/abstract/egg
	name = "egg conscience"
	see_in_dark = 2
	see_invisible = SEE_INVISIBLE_LIVING

	var/obj/item/caretaker_egg/my_egg // to which egg do we belong?

/mob/abstract/egg/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	announce_ghost_joinleave(ghostize(1, 0))

/mob/abstract/egg/Initialize()
	. = ..()
	add_language(LANGUAGE_TCB)

/mob/abstract/egg/Login()
	..()
	introduction()

/mob/abstract/egg/proc/introduction()
	to_chat(src, SPAN_DANGER(FONT_LARGE("You are growing inside an egg!")))
	to_chat(src, SPAN_DANGER("You're close to hatching aboard the [station_name()]! Do not fret."))
	to_chat(src, SPAN_DANGER("Your caretaker is supposed to take care of you, listen to what they have to say."))
	to_chat(src, SPAN_DANGER("When you are born, you can choose to continue listening to them, or forge your own path."))
	to_chat(src, SPAN_DANGER("You can psionically speak to others while in this state, but only those very close to you will hear."))

/mob/abstract/egg/say(message)
	message = sanitize_text(message)
	if(!message)
		return

	log_say("[my_egg] Conscience/[src.key] : [message]", ckey=key_name(src))

	if(src.client?.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
		to_chat(src, SPAN_WARNING("You cannot talk. (Admin Muted)"))
		return

	to_chat(src, "<font color=[COLOR_ASSEMBLY_GREEN]>You psionically transmit, \"<b>[message]</b>\"</font>")
	for(var/H in range(1, my_egg))
		to_chat(H, message_process(message))

/mob/abstract/egg/proc/message_process(var/message)
	return "<font color=[COLOR_ASSEMBLY_GREEN]>Something pokes at the back of your mind, \"<b>[message]</b>\"</font>"

/mob/abstract/egg/emote()
	to_chat(src, SPAN_WARNING("You cannot emote."))
	return

/mob/abstract/egg/proc/inhabit(var/new_ckey)
	src.ckey = new_ckey