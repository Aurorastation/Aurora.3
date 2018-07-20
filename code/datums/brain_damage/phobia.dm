/datum/brain_trauma/mild/phobia
	name = "Phobia"
	desc = "Patient is unreasonably afraid of something."
	scan_desc = "phobia"
	gain_text = ""
	lose_text = ""
	var/phobia_type
	var/next_check = 0
	var/next_scare = 0
	var/list/trigger_words
	//instead of cycling every atom, only cycle the relevant types
	var/list/trigger_mobs
	var/list/trigger_objs //also checked in mob equipment
	var/list/trigger_turfs
	var/list/trigger_species
	cure_type = CURE_HYPNOSIS

/datum/brain_trauma/mild/phobia/New(mob/living/carbon/C, _permanent, specific_type)
	phobia_type = specific_type
	if(!phobia_type)
		phobia_type = pick(SStraumas.phobia_types)

	gain_text = "<span class='warning'>You start finding [phobia_type] very unnerving...</span>"
	lose_text = "<span class='notice'>You no longer feel afraid of [phobia_type].</span>"
	scan_desc += " of [phobia_type]"
	trigger_words = SStraumas.phobia_words[phobia_type]
	trigger_mobs = SStraumas.phobia_mobs[phobia_type]
	trigger_objs = SStraumas.phobia_objs[phobia_type]
	trigger_turfs = SStraumas.phobia_turfs[phobia_type]
	trigger_species = SStraumas.phobia_species[phobia_type]
	..()

/datum/brain_trauma/mild/phobia/on_life()
	..()
	if(owner.eye_blind)
		if(phobia_type == "darkness" && prob(25))
			freak_out() //rip
		return
	if(world.time > next_check && world.time > next_scare)
		next_check = world.time + 50
		var/list/seen_atoms = view(7, owner)

		if(LAZYLEN(trigger_objs))
			for(var/obj/O in seen_atoms)
				if(is_type_in_typecache(O, trigger_objs))
					freak_out(O)
					return

		if(LAZYLEN(trigger_turfs))
			for(var/turf/T in seen_atoms)
				if(is_type_in_typecache(T, trigger_turfs))
					freak_out(T)
					return
				if((T.get_lumcount(0,1) <= 0.25) && phobia_type == "darkness") //probably snowflake but can't think of a better way without creating a new trauma type entirely
					freak_out(T)
					return

		if(LAZYLEN(trigger_mobs) || LAZYLEN(trigger_objs))
			for(var/mob/M in seen_atoms)
				if(is_type_in_typecache(M, trigger_mobs))
					freak_out(M)
					return

				if((M.stat == DEAD) && phobia_type == "death") //probably snowflake but can't think of a better way without creating a new trauma type entirely
					freak_out(M)
					return

				else if(ishuman(M)) //check their equipment for trigger items
					var/mob/living/carbon/human/H = M

					if(LAZYLEN(trigger_species) && H.species && is_type_in_typecache(H.species, trigger_species) && H != owner)
						freak_out(H)

					for(var/X in H.contents)
						var/obj/I = X
						if(!QDELETED(I) && is_type_in_typecache(I, trigger_objs))
							freak_out(I)
							return

/datum/brain_trauma/mild/phobia/on_hear(message, speaker, message_language, raw_message, radio_freq)
	if(owner.disabilities & DEAF || world.time < next_scare) //words can't trigger you if you can't hear them *taps head*
		return message
	for(var/word in trigger_words)
		if(findtext(message, word))
			addtimer(CALLBACK(src, .proc/freak_out, null, word), 10) //to react AFTER the chat message
			break
	return message

/datum/brain_trauma/mild/phobia/on_say(message)
	for(var/word in trigger_words)
		if(findtext(message, word))
			to_chat(owner, "<span class='warning'>You can't bring yourself to say the word \"[word]\"!</span>")
			return ""
	return message

/datum/brain_trauma/mild/phobia/proc/freak_out(atom/reason, trigger_word)
	next_scare = world.time + 120
	var/message = pick("spooks you to the bone", "shakes you up", "terrifies you", "sends you into a panic", "sends chills down your spine")
	if(reason)
		to_chat(owner, "<span class='danger'>Seeing [reason] [message]!</span>")
	else if(trigger_word)
		to_chat(owner, "<span class='danger'>Hearing \"[trigger_word]\" [message]!</span>")
	else
		to_chat(owner, "<span class='danger'>Something [message]!</span>")
	var/reaction = rand(1,4)
	owner.emote("scream")
	switch(reaction)
		if(1)
			to_chat(owner, "<span class='warning'>You are paralyzed with fear!</span>")
			owner.Stun(15)
			owner.Jitter(15)
		if(2)
			owner.Jitter(5)
			owner.say("AAARRRGGGH!!")
			if(reason)
				owner.pointed(reason)
		if(3)
			to_chat(owner, "<span class='warning'>You shut your eyes in terror!</span>")
			owner.Jitter(5)
			owner.eye_blind += 10
		if(4)
			owner.dizziness += 10
			owner.confused += 10
			owner.Jitter(10)
			owner.stuttering += 10