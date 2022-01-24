/mob/abstract/hivemind
	name = "internal hivemind"
	see_in_dark = 2
	see_invisible = SEE_INVISIBLE_LIVING

	var/mob/living/carbon/human/changeling_mob // the head honcho

/mob/abstract/hivemind/Destroy()
	changeling_mob = null
	return ..()

/mob/abstract/hivemind/verb/ghost()
	set category = "OOC"
	set name = "Ghost"
	set desc = "Relinquish your life and enter the land of the dead."

	announce_ghost_joinleave(ghostize(1, 0))
	var/datum/changeling/changeling = changeling_mob.mind.antag_datums[MODE_CHANGELING]
	changeling.hivemind_members -= src
	relay_hivemind(SPAN_NOTICE("[src] has left our hivemind to join the living dead."), changeling_mob)

/mob/abstract/hivemind/proc/add_to_hivemind(var/mob/original_body, var/mob/living/carbon/human/ling)
	name = original_body.real_name
	languages = original_body.languages
	for(var/language in ling.languages)
		add_language(language)
	remove_language(LANGUAGE_CHANGELING) // no actual changeling speak for you, buddy
	if(original_body.ckey)
		ckey = original_body.ckey
		changeling_mob = ling
	if(changeling_mob)
		var/datum/changeling/changeling = changeling_mob.mind.antag_datums[MODE_CHANGELING]
		changeling.hivemind_members[name] = src
		introduction(changeling_mob)

/mob/abstract/hivemind/proc/introduction(var/mob/living/carbon/human/ling)
	to_chat(src, SPAN_DANGER(FONT_LARGE("You are a member of a Changeling's Hivemind!")))
	to_chat(src, SPAN_DANGER("You have been absorbed by [ling]! Do not fret."))
	to_chat(src, SPAN_DANGER("You are now a part of their hivemind."))
	to_chat(src, SPAN_DANGER("You can use 'say' to speak with them and the rest of the hivemind."))
	to_chat(src, SPAN_DANGER("What you say can only be heard by [ling] and the other members of their local hivemind."))

/mob/abstract/hivemind/say(message)
	message = sanitize_text(message)

	if(!message)
		return

	log_say("[changeling_mob] Hivemind/[src.key] : [message]", ckey=key_name(src))

	if(src.client?.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
		to_chat(src, SPAN_WARNING("You cannot talk. (Admin Muted)"))
		return
	relay_hivemind(changeling_message_process(message), changeling_mob)

/mob/abstract/hivemind/emote()
	to_chat(src, SPAN_WARNING("You cannot emote."))
	return

/mob/abstract/hivemind/proc/release_as_morph()
	relay_hivemind("<font color=[COLOR_LING_HIVEMIND]>Hivemind member [src] has been released into the outside world as a morph!</font>", changeling_mob)
	log_and_message_admins("has released [src] as a morph.", changeling_mob, get_turf(changeling_mob))

	var/mob/living/simple_animal/hostile/morph/M = new /mob/living/simple_animal/hostile/morph(get_turf(changeling_mob))
	M.stop_thinking = TRUE // prevent the AI from taking over when the player ghosts
	M.ckey = ckey
	morphs.add_antagonist(M.mind, TRUE, TRUE, FALSE, TRUE, TRUE)

	var/datum/changeling/changeling = changeling_mob.mind.antag_datums[MODE_CHANGELING]
	changeling.hivemind_members -= src

	qdel(src)