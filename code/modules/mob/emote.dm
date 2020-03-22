// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message = null, var/log_emote = 1)
	if(usr && stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	if(m_type == 2 && muzzled) return

	var/input
	if(!message)
		input = sanitize(input(src,"Choose an emote to display.") as text|null)
	else
		input = message
	if(input)
		message = "<B>[src]</B> [input]"
	else
		return


	if (message)
		send_emote(message, m_type)
		if (log_emote)
			log_emote("[name]/[key] : [message]",ckey=key_name(key))

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
	var/list/messagemobs = list()//List of living mobs nearby who can hear it, and distant ghosts who've chosen to hear it
	var/list/messagemobs_neardead = list()//List of nearby ghosts who can hear it. Those that qualify ONLY go in this list

	var/hearing_aid = FALSE
	if(type == 2 && ishuman(src))
		var/mob/living/carbon/human/H = src
		hearing_aid = H.has_hearing_aid()

	for (var/turf in view(world.view, get_turf(src)))
		messageturfs += turf

	for(var/mob/M in player_list)
		if (!M.client || istype(M, /mob/abstract/new_player))
			continue
		if(get_turf(M) in messageturfs)
			if (istype(M, /mob/abstract/observer))
				messagemobs_neardead += M
				continue
			else if (isliving(M) && !(type == 2 && ((sdisabilities & DEAF) && !hearing_aid) || ear_deaf > 1))
				messagemobs += M
		else if(src.client)
			if (M.stat == DEAD && (M.client.prefs.toggles & CHAT_GHOSTSIGHT))
				messagemobs += M
				continue

	for (var/mob/N in messagemobs)
		N.show_message(message, type)

	message = "<B>[message]</B>"

	for (var/mob/O in messagemobs_neardead)
		O.show_message(message, type)
