// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, "<span class='danger'>You cannot send deadchat emotes (muted).</span>")
		return

	if(!(client.prefs.toggles & CHAT_DEAD))
		to_chat(src, "<span class='danger'>You have deadchat muted.</span>")
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return


	var/input
	if(!message)
		input = sanitize(input(src, "Choose an emote to display.") as text|null)
	else
		input = message

	if(input)
		log_emote("Ghost/[src.key] : [input]",ckey=key_name(src))
		say_dead_direct(input, src)


//This is a central proc that all emotes are run through. This handles sending the messages to living mobs
/mob/proc/send_emote(var/message, var/type)
	var/list/messageturfs = list()//List of turfs we broadcast to.
	var/list/messagemobs = list() 
	var/list/ghosts = list()
	var/list/ghosts_nearby = list()

	var/hearing_aid = FALSE
	if(type == 2 && ishuman(src))
		var/mob/living/carbon/human/H = src
		hearing_aid = H.has_hearing_aid()

	for (var/turf in view(world.view, get_turf(src)))
		messageturfs += turf

	for(var/mob/M in player_list)
		if (!M.client || isnewplayer(M))
			continue
		if(get_turf(M) in messageturfs)
			if (isobserver(M))
				ghosts_nearby += M
				continue
			else if (isliving(M) && !(type == 2 && ((sdisabilities & DEAF) && !hearing_aid) || ear_deaf > 1))
				messagemobs += M
		else if(src.client)
			if (M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT))
				ghosts += M
				continue

	for (var/mob/N in messagemobs)
		N.show_message(message, type)

	for(var/mob/O in ghosts)
		O.show_message("[ghost_follow_link(src, O)] [message]", type)
	
	for(var/mob/GN in ghosts_nearby)
		GN.show_message("[ghost_follow_link(src, GN)] <b>[message]</b>", type)
