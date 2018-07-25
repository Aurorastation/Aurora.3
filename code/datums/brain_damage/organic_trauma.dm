/datum/brain_trauma/organic
	var/triggered = 0
	var/triggered_timer = 0
	var/trigger_type
	var/next_check = 0
	var/special_check = 0
	var/list/trigger_words
	//instead of cycling every atom, only cycle the relevant types
	var/list/trigger_mobs
	var/list/trigger_objs //also checked in mob equipment
	var/list/trigger_turfs
	var/list/trigger_species
	var/trauma_severity = 0


/datum/brain_trauma/organic/New(obj/item/organ/B, _permanent)
	if(!trigger_type)
		trigger_type = pick(SStraumas.phobia_types)

	trigger_words = SStraumas.phobia_words[trigger_type]
	trigger_mobs = SStraumas.phobia_mobs[trigger_type]
	trigger_objs = SStraumas.phobia_objs[trigger_type]
	trigger_turfs = SStraumas.phobia_turfs[trigger_type]
	trigger_species = SStraumas.phobia_species[trigger_type]

	brainowner = B
	owner = B.owner
	permanent = _permanent
	if(owner)
		trauma_severity = max(1, round(owner.brainloss/10,1))
		on_gain()

/datum/brain_trauma/organic/on_life()
	..()
	triggered_life()
	if(triggered_timer)
		triggered_timer = max(0, triggered_timer - 1)
	if(owner.eye_blind)
		if(trigger_type == "darkness" && prob(25))
			on_gain() //rip
		return
	if(world.time > next_check && world.time > special_check)
		next_check = world.time + 50
		var/list/seen_atoms = view(owner)

		if(LAZYLEN(trigger_objs))
			for(var/obj/O in seen_atoms)
				if(is_type_in_typecache(O, trigger_objs))
					on_gain(O)
					return

		if(LAZYLEN(trigger_turfs))
			for(var/turf/T in seen_atoms)
				if(is_type_in_typecache(T, trigger_turfs))
					on_gain(T)
					return
				if((T.get_lumcount(0,1) <= 0.25) && trigger_type == "darkness") //probably snowflake but can't think of a better way without creating a new trauma type entirely
					on_gain(T)
					return

		if(LAZYLEN(trigger_mobs) || LAZYLEN(trigger_objs))
			for(var/mob/M in seen_atoms)
				if(is_type_in_typecache(M, trigger_mobs))
					on_gain(M)
					return

				if((M.stat == DEAD) && trigger_type == "death") //probably snowflake but can't think of a better way without creating a new trauma type entirely
					on_gain(M)
					return

				else if(ishuman(M)) //check their equipment for trigger items
					var/mob/living/carbon/human/H = M

					if(LAZYLEN(trigger_species) && H.species && is_type_in_typecache(H.species, trigger_species) && H != owner)
						on_gain(H)

					for(var/X in H.contents)
						var/obj/I = X
						if(!QDELETED(I) && is_type_in_typecache(I, trigger_objs))
							on_gain(I)
							return
		if(triggered && !triggered_timer)
			on_lose()
	if(!triggered)
		return

/datum/brain_trauma/organic/on_gain(atom/reason, trigger_word)
	if(triggered)
		return
	var/message = pick("sends you reeling", "brings back the bad memories", "hurts your mind", "sends you into the dark place", "sends chills down your spine")
	if(reason)
		to_chat(owner, "<span class='danger'>Seeing [reason] [message]!</span>")
	else if(trigger_word)
		to_chat(owner, "<span class='danger'>Hearing \"[trigger_word]\" [message]!</span>")
	else
		to_chat(owner, "<span class='danger'>Something [message]!</span>")
	to_chat(owner, gain_text)
	triggered = 1
	triggered_timer = 20

/datum/brain_trauma/organic/on_lose(silent)
	..()
	triggered = 0

/datum/brain_trauma/organic/on_hear(message, speaker, message_language, raw_message, radio_freq)
	if(owner.disabilities & DEAF || world.time < special_check) //words can't trigger you if you can't hear them *taps head*
		return message
	for(var/word in trigger_words)
		if(findtext(message, word))
			addtimer(CALLBACK(src, .proc/on_gain, null, word), 10) //to react AFTER the chat message
			break
	return message

/datum/brain_trauma/organic/on_say(message)
	for(var/word in trigger_words)
		if(findtext(message, word))
			to_chat(owner, "<span class='warning'>You can't bring yourself to say the word \"[word]\"!</span>")
			return ""
	return message

/datum/brain_trauma/organic/proc/triggered_life()
	if(!triggered)
		return