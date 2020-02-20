/mob/living/carbon/slime/emote(var/act, var/m_type=1, var/message = null)
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		//param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/updateicon = 0

	switch(act) //Alphabetical please
		if("me")
			if(silent)
				return
			if(src.client)
				if(client.prefs.muted & MUTE_IC)
					to_chat(src, span("warning", "You cannot send IC messages (muted)."))
					return
				if(stat || !message)
					return
				return custom_emote(m_type, message)
		if("bounce")
			message = "<B>The [src.name]</B> bounces in place."
			m_type = 1

		if("custom")
			return custom_emote(m_type, message)

		if("jiggle")
			message = "<B>The [src.name]</B> jiggles!"
			m_type = 1

		if("light")
			message = "<B>The [src.name]</B> lights up for a bit, then stops."
			m_type = 1

		if("moan")
			message = "<B>The [src.name]</B> moans."
			m_type = 2

		if("shiver")
			message = "<B>The [src.name]</B> shivers."
			m_type = 2

		if("sway")
			message = "<B>The [src.name]</B> sways around dizzily."
			m_type = 1

		if("twitch")
			message = "<B>The [src.name]</B> twitches."
			m_type = 1

		if("vibrate")
			message = "<B>The [src.name]</B> vibrates!"
			m_type = 1

		if("nomood")
			mood = null
			updateicon = 1

		if("pout")
			mood = POUT
			updateicon = 1

		if("sad")
			mood = SAD
			updateicon = 1

		if("angry")
			mood = ANGRY
			updateicon = 1

		if("frown")
			mood = MISCHIEVOUS
			updateicon = 1

		if("smile")
			mood = HAPPY
			updateicon = 1

		if("help") //This is an exception
			to_chat(src, "Help for slime emotes. You can use these emotes with say \"*emote\":\n\nbounce, custom, jiggle, light, moan, shiver, sway, twitch, vibrate. You can also set your face with: \n\nnomood, pout, sad, angry, frown, smile")

		else
			to_chat(src, span("notice", "Unusable emote '[act]'. Say *help for a list."))

	if(message && !stat)
		send_emote(message, m_type)
	if(updateicon)
		regenerate_icons()
	return