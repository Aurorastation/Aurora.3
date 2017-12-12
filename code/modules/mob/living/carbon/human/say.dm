/mob/living/carbon/human/say(var/message)
	var/alt_name = ""
	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"

	message = sanitize(message)
	..(message, alt_name = alt_name)

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

/mob/living/carbon/human/say_understands(var/mob/other,var/datum/language/speaking = null)

	if(has_brain_worms()) //Brain worms translate everything. Even mice and alien speak.
		return 1

	if(species.can_understand(other))
		return 1

	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (istype(other, /mob/living/carbon/alien/diona))
			if(other.languages.len >= 2) //They've sucked down some blood and can speak common now.
				return 1
		if (istype(other, /mob/living/silicon))
			return 1
		if (istype(other, /mob/living/carbon/brain))
			return 1
		if (istype(other, /mob/living/carbon/slime))
			return 1

	//This is already covered by mob/say_understands()
	//if (istype(other, /mob/living/simple_animal))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()

/mob/living/carbon/human/GetVoice()

	var/voice_sub
	if(istype(back,/obj/item/weapon/rig))
		var/obj/item/weapon/rig/rig = back
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice)
			voice_sub = rig.speech.voice_holder.voice
	else
		for(var/obj/item/gear in list(wear_mask,wear_suit,head))
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active && changer.voice)
				voice_sub = changer.voice
	if(voice_sub)
		return voice_sub
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
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

/mob/living/carbon/human/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending == "!")
			verb=pick("exclaims","shouts","yells")
		else if(ending == "?")
			verb="asks"

	return verb

/mob/living/carbon/human/handle_speech_problems(var/message, var/verb)
	handle_speech_muts(message,verb)
	for(var/datum/brain_trauma/trauma in get_traumas())
		message = trauma.on_say(message)
	if(silent || (sdisabilities & MUTE))
		message = ""
		speech_problem_flag = 1
	else if(istype(wear_mask, /obj/item/clothing/mask))
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

		var/braindam = getBrainLoss()
		if(braindam >= 60)
			speech_problem_flag = 1
			if(prob(braindam/4))
				message = stutter(message)
				verb = pick("stammers", "stutters")
			if(prob(braindam))
				message = uppertext(message)
				verb = "yells loudly"

	var/list/returns[3]
	returns[1] = message
	returns[2] = verb
	returns[3] = speech_problem_flag
	return returns

/mob/living/carbon/human/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	switch(message_mode)
		if("intercom")
			if(!src.restrained())
				for(var/obj/item/device/radio/intercom/I in view(1))
					I.talk_into(src, message, null, verb, speaking)
					I.add_fingerprint(src)
					used_radios += I
		if("headset")
			if(l_ear && istype(l_ear,/obj/item/device/radio))
				var/obj/item/device/radio/R = l_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += l_ear
			else if(r_ear && istype(r_ear,/obj/item/device/radio))
				var/obj/item/device/radio/R = r_ear
				R.talk_into(src,message,null,verb,speaking)
				used_radios += r_ear
		if("right ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(r_ear && istype(r_ear,/obj/item/device/radio))
				R = r_ear
				has_radio = 1
			if(r_hand && istype(r_hand, /obj/item/device/radio))
				R = r_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R
		if("left ear")
			var/obj/item/device/radio/R
			var/has_radio = 0
			if(l_ear && istype(l_ear,/obj/item/device/radio))
				R = l_ear
				has_radio = 1
			if(l_hand && istype(l_hand,/obj/item/device/radio))
				R = l_hand
				has_radio = 1
			if(has_radio)
				R.talk_into(src,message,null,verb,speaking)
				used_radios += R
		if("whisper")
			whisper_say(message, speaking, alt_name)
			return 1
		else
			if(message_mode)
				if(l_ear && istype(l_ear,/obj/item/device/radio))
					l_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += l_ear
				else if(r_ear && istype(r_ear,/obj/item/device/radio))
					r_ear.talk_into(src,message, message_mode, verb, speaking)
					used_radios += r_ear

/mob/living/carbon/human/handle_speech_sound()
	if(species.speech_sounds && prob(species.speech_chance))
		var/list/returns[2]
		returns[1] = sound(pick(species.speech_sounds))
		returns[2] = 50
		return returns
	return ..()

/mob/living/carbon/human/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	for(var/T in get_traumas())
		var/datum/brain_trauma/trauma = T
		message = trauma.on_hear(message, verb, language, alt_name, italics, speaker)
	..()

/mob/living/carbon/human/proc/handle_speech_muts(var/message, var/verb)
	if(message)
		if(disabilities & PIRATE)
			message = replacetext(message," gun "," blunderbuss ")
			message = replacetext(message," heaven "," davy jone's locker ")
			message = replacetext(message," die "," off t' davy jone's locker ")
			message = replacetext(message," dead "," on 'is way to davy jone's locker ")
			message = replacetext(message," I "," aye ")
			message = replacetext(message," my "," meh ")
			message = replacetext(message," yes "," yargh ")
			message = replacetext(message," are "," rgh ")
			message = replacetext(message," yeah "," yarrrh ")
			message = replacetext(message," captain "," cap'n ")
			message = replacetext(message," hos "," first mate ")
			message = replacetext(message," head of security "," first mate ")
			message = replacetext(message," commander "," first mate ")
			message = replacetext(message," hop "," crewmaster ")
			message = replacetext(message," head of personnel "," crew master ")
			message = replacetext(message," ai "," navigator ")
			message = replacetext(message," money "," treasure ")
			message = replacetext(message," cash "," booty ")
			message = replacetext(message," friend "," matey ")
			message = replacetext(message," station "," vessel ")
			message = replacetext(message," shuttle "," rowboat ")
			message = replacetext(message," engine "," sails ")
			message = replacetext(message," space "," sea ")
			message = replacetext(message," dock "," port a' call ")
			message = replacetext(message," nanotrasen "," Blackbeard's mighty fleet ")
			message = replacetext(message," nt "," Blackbeard's mighty fleet ")
			message = replacetext(message," centcomm "," Blackbeard's cove ")
			message = replacetext(message," central command "," Blackbeard's cove ")
			message = replacetext(message," odin "," cove a' Blackbeard ")
			message = replacetext(message," security "," blackguards an' buggers ")
			message = replacetext(message," medical "," sawbones ")
			message = replacetext(message," r&d "," 'em thinky types ")
			message = replacetext(message," rnd "," 'em thinky types ")
			message = replacetext(message," sick "," 'thick with scurvy ")
			message = replacetext(message," the "," th' ")
			message = replacetext(message," you "," ye ")
			message = replacetext(message," and "," an' ")
			message = replacetext(message," am "," be ")
			message = replacetext(message," is "," be ")
			message = replacetext(message,"ing ","in' ")
			message = replacetext(message," credits "," booty ")
		if(disabilities & SVEDISH)
			message = replacetext(message,"w","v")
			message = replacetext(message,"j","y")
			message = replacetext(message,"bo","bjo")
			if(prob(30))
				message += " Bork[pick("",", bork",", bork, bork")]!"
				if(prob(10)) //BORK A BORK OVERLOAD
					message = replacetext(message," "," bork[pick(" bork","","a'bork","-bork","'abork")] ")
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
				while(length(cword)>0 && suffix in list(".",",",";","!",":","?"))
					cword  = copytext(cword,1              ,length(cword)-1)
					suffix = copytext(cword,length(cword)-1,length(cword)  )
				if(length(cword))
					rearranged += cword
			message ="[prefix][jointext(rearranged," ")]"
