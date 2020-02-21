/mob/abstract/hivemind
	name = "internal hivemind"
	see_in_dark = 2
	see_invisible = SEE_INVISIBLE_LIVING

	var/mob/living/carbon/human/changeling_mob // the head honcho
	var/list/mob/abstract/hivemind/hivemind = list() // who's in the head honcho's head

/mob/abstract/hivemind/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	announce_ghost_joinleave(ghostize(1, 0))
	to_chat(changeling_mob, SPAN_NOTICE("[src] has left our hivemind to join the living dead."))
	for(var/mob/abstract/hivemind/H in hivemind) // tell the other hiveminds
		to_chat(H, SPAN_NOTICE("[src] has left our hivemind to join the living dead."))

/mob/abstract/hivemind/proc/add_to_hivemind(var/mob/original_body, var/mob/living/carbon/human/ling)
	src.name = original_body.real_name
	src.languages = original_body.languages
	src.languages += ling.languages
	src.remove_language("Changeling") // no actual changeling speak for you, buddy
	if(original_body.ckey)
		src.ckey = original_body.ckey
	src.changeling_mob = ling
	if(changeling_mob)
		changeling_mob.mind.changeling.hivemind |= src
		update_hivemind()
	introduction(ling)

/mob/abstract/hivemind/proc/introduction(var/mob/ling)
	to_chat(src, SPAN_NOTICE("********************************************************************"))
	to_chat(src, SPAN_DANGER("You have been absorbed by [ling]! Do not fret."))
	to_chat(src, SPAN_DANGER("You are now a part of their hivemind."))
	to_chat(src, SPAN_DANGER("You can speak normally, to speak with them and the rest of the hivemind."))
	to_chat(src, SPAN_NOTICE("********************************************************************"))

/mob/abstract/hivemind/proc/update_hivemind() // this brings all the hiveminds up to date with the ling's hivemind
	for(var/mob/abstract/hivemind/H in changeling_mob.mind.changeling.hivemind)
		H.hivemind = changeling_mob.mind.changeling.hivemind

/mob/abstract/hivemind/say(message)
	message = sanitize(message)

	if(!message)
		return

	log_say("[changeling_mob] Hivemind/[src.key] : [message]", ckey=key_name(src))

	if(src.client?.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
		to_chat(src, SPAN_WARNING("You cannot talk. (Admin Muted)"))
		return

	to_chat(changeling_mob, message_process(message)) // tell the changeling
	for(var/mob/abstract/hivemind/H in hivemind) // tell the other hiveminds
		to_chat(H, message_process(message))

/mob/abstract/hivemind/proc/message_process(var/message)
	return "<font color=#94582e>[src] says, \"[message]\"</font>"

/mob/abstract/hivemind/emote()
	to_chat(src, SPAN_WARNING("You cannot emote."))
	return