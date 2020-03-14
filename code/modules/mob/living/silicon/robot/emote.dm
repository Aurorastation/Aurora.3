/mob/living/silicon/robot/emote(var/act, var/m_type = 1, var/message)
	var/param
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	switch(act)
		if("me")
			if(client?.prefs.muted & MUTE_IC)
				to_chat(src, SPAN_WARNING("You cannot send IC messages (muted)."))
				return
			if(!message || stat)
				return
			else
				return custom_emote(m_type, message)
		if("custom")
			return custom_emote(m_type, message)
		if("salute")
			if(!buckled)
				var/M
				if(param)
					for(var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null
				if(param)
					message = "salutes to [param]."
				else
					message = "salutes."
			m_type = 1
		if("bow")
			if(!buckled)
				var/M
				if(param)
					for(var/mob/A in view(null, null))
						if(param == A.name)
							M = A
							break
				if(!M)
					param = null

				if(param)
					message = "bows to [param]."
				else
					message = "bows."
			m_type = 1

		if("clap")
			if(!restrained())
				message = "claps."
				m_type = 2
		if("flap")
			if(!restrained())
				message = "flaps its wings."
				m_type = 2

		if("aflap")
			if(!restrained())
				message = "flaps its wings ANGRILY!"
				m_type = 2

		if("twitch")
			message = "twitches violently."
			m_type = 1

		if("twitch_s")
			message = "twitches."
			m_type = 1

		if("nod")
			message = "nods."
			m_type = 1

		if("deathgasp")
			message = "shudders violently for a moment, then becomes motionless, its eyes slowly darkening."
			m_type = 1

		if("glare")
			var/M
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "glares at [param]."
			else
				message = "glares."

		if("stare")
			var/M
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "stares at [param]."
			else
				message = "stares."

		if("look")
			var/M
			if(param)
				for(var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break

			if(!M)
				param = null

			if(param)
				message = "looks at [param]."
			else
				message = "looks."
			m_type = 1

		if("beep")
			var/M
			if(param)
				for(var/mob/A in view(null, null))
					if(param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "beeps at [param]."
			else
				message = "beeps."
			playsound(loc, 'sound/machines/twobeep.ogg', 50, 0)
			m_type = 1

		if("ping")
			var/M
			if(param)
				for(var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "pings at [param]."
			else
				message = "pings."
			playsound(loc, 'sound/machines/ping.ogg', 50, 0)
			m_type = 1

		if("buzz")
			var/M
			if(param)
				for (var/mob/A in view(null, null))
					if (param == A.name)
						M = A
						break
			if(!M)
				param = null

			if(param)
				message = "buzzes at [param]."
			else
				message = "buzzes."
			playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			m_type = 1

		if("help")
			to_chat(src, "salute, bow-(none)/mob, clap, flap, aflap, twitch, twitch_s, nod, deathgasp, glare-(none)/mob, stare-(none)/mob, look, beep, ping, \nbuzz, law, halt")
		else
			to_chat(src, SPAN_NOTICE("Unusable emote '[act]'. Say *help for a list."))

	if(message && stat == CONSCIOUS)
		custom_emote(m_type, message)

	return

/mob/living/silicon/robot/verb/powerwarn()
	set category = "Robot Commands"
	set name = "Power Warning"

	if(!is_component_functioning("power cell") || !cell?.charge)
		visible_message(SPAN_WARNING("The power warning light on \the [src] flashes urgently."), \
		SPAN_NOTICE("You announce you are operating in low power mode."))
		playsound(get_turf(src), 'sound/machines/buzz-two.ogg', 50, 0)
	else
		to_chat(src, SPAN_WARNING("You can only use this emote when you're out of charge."))