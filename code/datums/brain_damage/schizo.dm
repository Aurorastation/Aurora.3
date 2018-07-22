#define OWNER 0
#define STRANGER 1

/datum/brain_trauma/severe/split_personality
	name = "Split Personality"
	desc = "Patient's brain is split into two personalities, which randomly switch control of the body."
	scan_desc = "conflicting neuroimaging reports"
	gain_text = "<span class='warning'>You feel like your mind was split in two.</span>"
	lose_text = "<span class='notice'>You feel alone again.</span>"
	cure_type = CURE_SOLITUDE
	var/current_controller = OWNER
	var/initialized = FALSE //to prevent personalities deleting themselves while we wait for ghosts
	var/mob/living/mental/split_personality/stranger_backseat //there's two so they can swap without overwriting
	var/mob/living/mental/split_personality/owner_backseat

/datum/brain_trauma/severe/split_personality/on_gain()
	..()
	make_backseats()
	get_ghost()

/datum/brain_trauma/severe/split_personality/proc/make_backseats()
	stranger_backseat = new(owner, src)
	owner_backseat = new(owner, src)

/datum/brain_trauma/severe/split_personality/proc/get_ghost()
	set waitfor = FALSE
	var/datum/ghosttrap/G = get_ghost_trap("split personality")
	G.request_player(stranger_backseat, "Would you like to play as [owner]'s split personality?", 60 SECONDS)
	addtimer(CALLBACK(src, .proc/reset_search), 60 SECONDS)

/datum/brain_trauma/severe/split_personality/proc/reset_search()
	if(src.stranger_backseat && src.stranger_backseat.key)
		return
	else
		qdel(src)

/datum/brain_trauma/severe/split_personality/on_life()
	if(owner.stat == DEAD)
		if(current_controller != OWNER)
			switch_personalities()
		qdel(src)
	else if(prob(3))
		switch_personalities()
	..()

/datum/brain_trauma/severe/split_personality/on_lose()
	if(current_controller != OWNER) //it would be funny to cure a guy only to be left with the other personality, but it seems too cruel
		switch_personalities()
	QDEL_NULL(stranger_backseat)
	QDEL_NULL(owner_backseat)
	..()

/datum/brain_trauma/severe/split_personality/proc/switch_personalities()
	if(QDELETED(owner) || owner.stat == DEAD || QDELETED(stranger_backseat) || QDELETED(owner_backseat))
		return

	var/mob/living/mental/split_personality/current_backseat
	var/mob/living/mental/split_personality/free_backseat
	if(current_controller == OWNER)
		current_backseat = stranger_backseat
		free_backseat = owner_backseat
	else
		current_backseat = owner_backseat
		free_backseat = stranger_backseat

	log_game("[current_backseat]/([current_backseat.ckey]) assumed control of [owner]/([owner.ckey] due to [src]. (Original owner: [current_controller == OWNER ? owner.ckey : current_backseat.ckey])")
	to_chat(owner, "<span class='danger'>You feel your control being taken away... your other personality is in charge now!</span>")
	to_chat(current_backseat, "<span class='danger'>You manage to take control of your body!</span>")

	//Body to backseat

	var/h2b_id = owner.computer_id
	var/h2b_ip= owner.lastKnownIP
	owner.computer_id = null
	owner.lastKnownIP = null

	free_backseat.ckey = owner.ckey

	free_backseat.name = owner.name

	if(owner.mind)
		free_backseat.mind = owner.mind

	if(!free_backseat.computer_id)
		free_backseat.computer_id = h2b_id

	if(!free_backseat.lastKnownIP)
		free_backseat.lastKnownIP = h2b_ip

	//Backseat to body

	var/s2h_id = current_backseat.computer_id
	var/s2h_ip= current_backseat.lastKnownIP
	current_backseat.computer_id = null
	current_backseat.lastKnownIP = null

	owner.ckey = current_backseat.ckey
	owner.mind = current_backseat.mind

	if(!owner.computer_id)
		owner.computer_id = s2h_id

	if(!owner.lastKnownIP)
		owner.lastKnownIP = s2h_ip

	current_controller = !current_controller


/mob/living/mental/split_personality
	name = "split personality"
	real_name = "unknown conscience"
	var/mob/living/carbon/body
	var/datum/brain_trauma/severe/split_personality/trauma

/mob/living/mental/split_personality/Initialize(mapload, _trauma)
	if(iscarbon(loc))
		body = loc
		name = body.real_name
		real_name = body.real_name
		trauma = _trauma
	return ..()

/mob/living/mental/split_personality/Life()
	if(QDELETED(body))
		qdel(src) //in case trauma deletion doesn't already do it

	if((body.stat == DEAD && trauma.owner_backseat == src))
		trauma.switch_personalities()
		qdel(trauma)

	//if one of the two ghosts, the other one stays permanently
	if(!body.client && trauma.initialized)
		trauma.switch_personalities()
		qdel(trauma)

	..()

/mob/living/mental/split_personality/Login()
	..()
	to_chat(src, "<span class='notice'>As a split personality, you cannot do anything but observe. However, you will eventually gain control of your body, switching places with the current personality.</span>")

/mob/living/mental/split_personality/say(message)
	to_chat(src, "<span class='warning'>You cannot speak, your other self is controlling your body!</span>")
	return FALSE

/mob/living/mental/split_personality/emote(message)
	return

///////////////BRAINWASHING////////////////////

/datum/brain_trauma/severe/split_personality/brainwashing
	name = "Split Personality"
	desc = "Patient's brain is split into two personalities, which randomly switch control of the body."
	scan_desc = "complete lobe separation"
	gain_text = ""
	lose_text = "<span class='notice'>You are free of your brainwashing.</span>"
	can_gain = FALSE
	var/codeword
	var/objective

/datum/brain_trauma/severe/split_personality/brainwashing/New(obj/item/organ/brain/B, _permanent, _codeword, _objective)
	..()
	if(_codeword)
		codeword = _codeword
	else
		codeword = pick(strings("ion_laws.json", "ionabstract")\
			| strings("ion_laws.json", "ionobjects")\
			| strings("ion_laws.json", "ionadjectives")\
			| strings("ion_laws.json", "ionthreats")\
			| strings("ion_laws.json", "ionfood")\
			| strings("ion_laws.json", "iondrinks"))

/datum/brain_trauma/severe/split_personality/brainwashing/on_gain()
	..()
	var/mob/living/mental/split_personality/traitor/traitor_backseat = stranger_backseat
	traitor_backseat.codeword = codeword
	traitor_backseat.objective = objective

/datum/brain_trauma/severe/split_personality/brainwashing/make_backseats()
	stranger_backseat = new /mob/living/mental/split_personality/traitor(owner, src, codeword, objective)
	owner_backseat = new(owner, src)


/datum/brain_trauma/severe/split_personality/brainwashing/get_ghost()
	set waitfor = FALSE
	var/datum/ghosttrap/G = get_ghost_trap("split personality")
	G.request_player(stranger_backseat, "Would you like to play as [owner]'s split personality?", 60 SECONDS)
	addtimer(CALLBACK(src, .proc/reset_search), 60 SECONDS)

/datum/brain_trauma/severe/split_personality/brainwashing/on_life()
	return //no random switching

/datum/brain_trauma/severe/split_personality/brainwashing/on_hear(message, speaker, message_language, raw_message, radio_freq)
	if(owner.disabilities & DEAF || owner == speaker)
		return message
	if(findtext(message, codeword))
		message = replacetext(message, codeword, "<span class='warning'>[codeword]</span>")
		addtimer(CALLBACK(src, /datum/brain_trauma/severe/split_personality.proc/switch_personalities), 10)
	return message

/datum/brain_trauma/severe/split_personality/brainwashing/on_say(message)
	if(findtext(message, codeword))
		return "" //oh hey did you want to tell people about the secret word to bring you back?
	return message

/mob/living/mental/split_personality/traitor
	name = "split personality"
	real_name = "unknown conscience"
	var/objective
	var/codeword

/mob/living/mental/split_personality/traitor/Login()
	..()
	to_chat(src, "<span class='notice'>As a brainwashed personality, you cannot do anything yet but observe. However, you may gain control of your body if you hear the special codeword, switching places with the current personality.</span>")
	to_chat(src, "<span class='notice'>Your activation codeword is: <b>[codeword]</b></span>")
	if(objective)
		to_chat(src, "<span class='notice'>Your master left you an objective: <b>[objective]</b>. Follow it at all costs when in control.</span>")

#undef OWNER
#undef STRANGER