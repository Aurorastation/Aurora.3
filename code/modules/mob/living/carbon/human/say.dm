/mob/living/carbon/human/proc/forcesay(list/append)
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//case sensitive means

				temp = replacetext(temp, ";", "")	//general radio

				if(findtext(trim_left(temp), ":", 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), ":", 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)

				if(findtext(temp, "*", 1, 2))	//emotes
					return
				temp = copytext(trim_left(temp), 1, rand(5,8))

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=[null]")

/mob/living/carbon/human/say_understands(var/mob/other, var/datum/language/speaking = null)

	if(has_brain_worms()) //Brain worms translate everything. Even rat and alien speak.
		return TRUE

	if(species.can_understand(other))
		return TRUE

	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (istype(other, /mob/living/carbon/alien/diona))
			if(other.languages.len >= 2) //They've sucked down some blood and can speak common now.
				return TRUE
		if (istype(other, /mob/living/silicon))
			return TRUE
		if (istype(other, /mob/living/announcer))
			return TRUE
		if (istype(other, /mob/living/carbon/brain))
			return TRUE
		if (istype(other, /mob/living/carbon/slime))
			return TRUE

	//This is already covered by mob/say_understands()
	//if (istype(other, /mob/living/simple_animal))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()

/mob/living/carbon/human/GetVoice()
	var/voice_sub
	if(istype(back,/obj/item/rig))
		var/obj/item/rig/rig = back
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice)
			voice_sub = rig.speech.voice_holder.voice
	if(!voice_sub)
		for(var/obj/item/gear in list(wear_mask,wear_suit,head))
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice)
				voice_sub = changer.voice
	if(voice_sub)
		return voice_sub
	var/obj/item/organ/external/head/face = organs_by_name[BP_HEAD]
	if(face?.disfigured) // if your face is ruined, your ability to vocalize is also ruined
		return "Unknown" // above ling voice mimicing so they don't get caught out immediately
	if(mind)
		var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
		if(changeling?.mimicing)
			return changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice


/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/living/carbon/human/say_quote(var/message, var/datum/language/speaking = null, var/singing = FALSE, var/whisper = FALSE)
	var/ending = copytext(message, length(message))
	var/pre_ending = copytext(message, length(message) - 1, length(message))

	if(speaking)
		. = speaking.get_spoken_verb(ending, pre_ending, singing, whisper)
	else
		. = ..()

/mob/living/carbon/human/handle_speech_problems(var/message, var/verb, var/message_mode)
	message = handle_speech_muts(message,verb)
	if(silent || (sdisabilities & MUTE))
		message = ""
		speech_problem_flag = 1
	else if(!src.is_diona() && istype(wear_mask, /obj/item/clothing/mask))
		var/obj/item/clothing/mask/M = wear_mask
		if(M.voicechange)
			message = pick(M.say_messages)
			verb = pick(M.say_verbs)
			speech_problem_flag = 1

	if(message != "")
		var/list/parent = ..()
		message = parent[1]
		verb = parent[2]
		if(parent[3])
			speech_problem_flag = 1

	var/list/returns[4]
	returns[1] = message
	returns[2] = verb
	returns[3] = speech_problem_flag
	returns[4] = world.view

	returns = species.handle_speech_problems(src, returns, message, verb, message_mode)
	return returns

/mob/living/carbon/human/get_radio()
	var/list/headsets = list()
	if(istype(l_ear, /obj/item/device/radio))
		headsets["Left Ear"] = l_ear
	if(istype(r_ear, /obj/item/device/radio))
		headsets["Right Ear"] = r_ear
	if(istype(wrists, /obj/item/device/radio))
		headsets["Wrist"] = wrists

	if(length(headsets))
		if(client && (client.prefs.primary_radio_slot in headsets))
			return headsets[client.prefs.primary_radio_slot]
		return headsets[headsets[1]]
	return null

/mob/living/carbon/human/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name, whisper, var/is_singing = FALSE)
	if(!whisper && (paralysis || InStasis()))
		whisper(message, speaking)
		return TRUE
	switch(message_mode)
		if("intercom")
			for(var/obj/item/device/radio/intercom/I in view(1))
				I.add_fingerprint(src)
				used_radios += I
				I.talk_into(src, message, null, verb, speaking)
		if("headset")
			var/obj/item/device/radio/R = get_radio()
			if(R)
				used_radios += R
				R.talk_into(src, message, null, verb, speaking)
		if("right ear")
			var/obj/item/device/radio/R
			var/has_radio = FALSE
			if(istype(r_ear,/obj/item/device/radio))
				R = r_ear
				has_radio = TRUE
			if(istype(r_hand, /obj/item/device/radio))
				R = r_hand
				has_radio = TRUE
			if(has_radio)
				used_radios += R
				R.talk_into(src,message,null,verb,speaking)
		if("left ear")
			var/obj/item/device/radio/R
			var/has_radio = FALSE
			if(istype(l_ear, /obj/item/device/radio))
				R = l_ear
				has_radio = TRUE
			if(istype(l_hand, /obj/item/device/radio))
				R = l_hand
				has_radio = TRUE
			if(has_radio)
				used_radios += R
				R.talk_into(src,message,null,verb,speaking)
		if("wrist")
			var/obj/item/device/radio/R
			var/has_radio = FALSE
			if(istype(wrists,/obj/item/device/radio))
				R = wrists
				has_radio = TRUE
			if(istype(r_hand, /obj/item/device/radio))
				R = wrists
				has_radio = TRUE
			if(has_radio)
				used_radios += R
				R.talk_into(src,message,null,verb,speaking)
		if("whisper")
			whisper(message, speaking, is_singing)
			return TRUE
		else if(message_mode)
			var/obj/item/device/radio/R = get_radio()
			if(R)
				used_radios += R
				R.talk_into(src, message, message_mode, verb, speaking)

/mob/living/carbon/human/handle_speech_sound()
	var/list/returns = ..()
	returns = species.handle_speech_sound(src, returns)
	return returns

/mob/living/carbon/human/proc/handle_speech_muts(var/message, var/verb)
	if(message)
		if(disabilities & TOURETTES)
			var/prefix=copytext(message,1,2)
			if(prefix == ";")
				message = copytext(message,2)
			else if(prefix in list(":","#"))
				prefix += copytext(message,2,3)
				message = copytext(message,3)
			else
				prefix=""

			var/list/words = splittext(message," ")
			for(var/i=1;i<=words.len;i++)
				var/cword = pick(words)
				words.Remove(cword)
				if(prob(50))
					if(prob(50))
						message = replacetext(message,"[cword]","[pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
					else
						message = replacetext(message,"[cword]","[cword] [pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")] ")
			message ="[prefix] [message]"

		if(disabilities & GERTIE)
			var/compassing = pick("north","south","east","west")
			var/stational = pick("fore","aft","port","starboard")
			var/directional = pick("up","down","left","right")
			var/motional = pick("in","out","above","below")
			message = replacetext(message,"north"," [compassing] ")
			message = replacetext(message,"south"," [compassing] ")
			message = replacetext(message,"east"," [compassing] ")
			message = replacetext(message,"west"," [compassing] ")
			message = replacetext(message,"fore"," [stational] ")
			message = replacetext(message,"aft"," [stational] ")
			message = replacetext(message,"port"," [stational] ")
			message = replacetext(message,"starboard"," [stational] ")
			message = replacetext(message,"up"," [directional] ")
			message = replacetext(message,"down"," [directional] ")
			message = replacetext(message,"left"," [directional] ")
			message = replacetext(message,"right"," [directional] ")
			message = replacetext(message,"in"," [motional] ")
			message = replacetext(message,"out"," [motional] ")
			message = replacetext(message,"above"," [motional] ")
			message = replacetext(message,"below"," [motional] ")
		if(disabilities & UNINTELLIGIBLE)
			var/prefix=copytext(message,1,2)
			if(prefix == ";")
				message = copytext(message,2)
			else if(prefix in list(":","#"))
				prefix += copytext(message,2,3)
				message = copytext(message,3)
			else
				prefix=""

			var/list/words = splittext(message," ")
			var/list/rearranged = list()
			for(var/i=1;i<=words.len;i++)
				var/cword = pick(words)
				words.Remove(cword)
				var/suffix = copytext(cword,length(cword)-1,length(cword))
				while(length(cword)>0 && (suffix in list(".",",",";","!",":","?")))
					cword  = copytext(cword,1              ,length(cword)-1)
					suffix = copytext(cword,length(cword)-1,length(cword)  )
				if(length(cword))
					rearranged += cword
			message ="[prefix][jointext(rearranged," ")]"
		if(losebreath >= 5) //Gasping is a mutation, right?
			var/prefix=copytext(message,1,2)
			if(prefix == ";")
				message = copytext(message,2)
			else if(prefix in list(":","#"))
				prefix += copytext(message,2,3)
				message = copytext(message,3)
			else
				prefix=""

			var/list/words = splittext(message," ")
			if (prob(50))
				if (words.len>1)
					var/gasppoint = rand(2, words.len)
					words.Cut(gasppoint)
				words[words.len] = "[words[words.len]]..."
				if(prob(50))
					emote("gasp")
				else
					emote("choke")


			message = "[prefix][jointext(words," ")]"
	return message

/mob/living/carbon/human/binarycheck()
	for(var/obj/item/device/radio/headset/dongle in list(l_ear, r_ear))
		if(dongle.translate_binary)
			return TRUE
	return FALSE
