/mob/living/carbon/brain/emote(var/act,var/m_type=1,var/message = null)
	if(!(container && istype(container, /obj/item/device/mmi)))//No MMI, no emotes
		return

	if (findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	if(src.stat == DEAD)
		return
	switch(act)
		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted & MUTE_IC)
					src << "<span class='warning'>You cannot send IC messages (muted).</span>"
					return
			if (stat)
				return
			if(!(message))
				return
			return custom_emote(m_type, message)

		if ("custom")
			return custom_emote(m_type, message)
		if ("alarm")
			message = "<B>[src]</B> sounds an alarm."
			m_type = 2
		if ("alert")
			message = "<B>[src]</B> lets out a distressed noise."
			m_type = 2
		if ("notice")
			message = "<B>[src]</B> plays a loud tone."
			m_type = 2
		if ("flash")
			message = "The lights on <B>[src]</B> flash quickly."
			m_type = 1
		if ("blink")
			message = "<B>[src]</B> blinks."
			m_type = 1
		if ("whistle")
			message = "<B>[src]</B> whistles."
			m_type = 2
		if("beep")
			message = "<B>[src]</B> beeps."
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
			m_type = 2
		if("ping")
			message = "<B>[src]</B> pings."
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			m_type = 2
		if("buzz")
			message = "<B>[src]</B> buzzes."
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			m_type = 2
		if ("boop")
			message = "<B>[src]</B> boops."
			m_type = 2
		if ("help")
			src << "alarm,alert,notice,flash,blink,whistle,beep,boop"
		else
			src << "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>"

	if (message)
		log_emote("[name]/[key] : [message]",ckey=key_name(key))

		send_emote(message, m_type)
