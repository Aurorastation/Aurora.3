/mob/living/silicon/pai/emote(var/act,var/m_type=1,var/message = null)
/*	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)
*/
	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	switch(act)
		if ("me")
			if (src.client)
				if(client.prefs.muted & MUTE_IC)
					src << "You cannot send IC messages (muted)."
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			else
				return custom_emote(m_type, message)

		if ("custom")
			return custom_emote(m_type, message)

		if ("salute")
			message = "<B>[src]</b> displays an image of a person saluting."
			m_type = 1
		if ("bow")
			message = "<B>[src]</B> displays an image of a person bowing."
			m_type = 1

		if ("clap")
			message = "<B>[src]</B> displays an image of hands clapping."
			m_type = 2
		if ("flap")
			message = "<B>[src]</B> displays an image of wings flapping."
			m_type = 2

		if ("aflap")
			message = "<B>[src]</B> displays an image of wings flapping ANGRILY!"
			m_type = 2

		if ("twitch")
			message = "<B>[src]</B> displays an image of a person twitching violently."
			m_type = 1

		if ("twitch_s")
			message = "<B>[src]</B>  displays an image of a person twitching."
			m_type = 1

		if ("nod")
			message = "<B>[src]</B> displays an image of a person nodding."
			m_type = 1

		if("beep")
			message = "<B>[src]</B> beeps."
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
			m_type = 1

		if("ping")
			message = "<B>[src]</B> pings."
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			m_type = 1

		if("buzz")
			message = "<B>[src]</B> buzzes."
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			m_type = 1

		if("law")
			if (src:secHUD)
				message = "<B>[src]</B> flashes its legal authorization barcode."
				playsound(src.loc, 'sound/voice/biamthelaw.ogg', 50, 0)
				m_type = 2
			else
				src << "You are not THE LAW, pal."

		if("halt")
			if (src:secHUD)
				message = "<B>[src]</B>'s speakers skreech, \"Halt! Security!\"."

				playsound(src.loc, 'sound/voice/halt.ogg', 50, 0)
				m_type = 2
			else
				src << "You are not security."

		if ("help")
			src << "salute, bow, clap, flap, aflap, twitch, twitch_s, nod, beep, ping, \nbuzz, law, halt"
		else
			src << "\blue Unusable emote '[act]'. Say *help for a list."

	if ((message && src.stat == 0))
		if (m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)
	return
