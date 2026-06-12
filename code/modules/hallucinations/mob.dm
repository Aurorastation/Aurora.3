//Hallucinated hearing: a chance to mishear the body entirely
/mob/proc/hallucinate_heard(text, mob/speaker)
	return text

/mob/living/carbon/hallucinate_heard(text, mob/speaker)
	if(hallucination >= 60 && prob(1))
		var/orig_message = text
		text = pick(SShallucinations.hallucinated_phrases)
		log_say("Hallucination level changed [orig_message] by [speaker] to [text] for [key_name(src)].")
	return text

//Main handling proc, called in life()
/mob/living/carbon/proc/handle_hallucinations()
	hallucination -= 1	//Tick down the duration

	//Good/bad chems affecting duration
	if(chem_effects[CE_HALLUCINATE] < 0)
		hallucination = max(0, hallucination - abs(chem_effects[CE_HALLUCINATE]))
	if(chem_effects[CE_HALLUCINATE] > 0 && prob(chem_effects[CE_HALLUCINATE]*20))
		hallucination += chem_effects[CE_HALLUCINATE]

	if(hallucination <= 0)  //We're done
		hallucination = 0
		return
	if(!client || stat || world.time < next_hallucination)
		return

	var/hall_delay = rand(30, 40) SECONDS	//Time between hallucinations, modified below.

	//Modifying time between effects based on strength and chemicals
	switch(hallucination)	//26-149 are intentionally left off, as they do not modify the delay. This is a pretty common range for hallucinations.
		if(1 to 25)		//Winding down, less frequent.
			hall_delay *= 2
		if(150 to 399)		//Yo mind really fucked, more frequent.
			hall_delay *= 0.75
		if(400 to INFINITY)		//This should only be possible in cult conversions. Very low delay to represent your flayed mind.
			hall_delay *= 0.25
	if(chem_effects[CE_HALLUCINATE] < 0)
		if(prob(abs(chem_effects[CE_HALLUCINATE]*40))) //Chance to skip effects entirely if you're medicated properly
			return
		else
			hall_delay *= min(1.25, abs(chem_effects[CE_HALLUCINATE])) //if CE_HALLUCINATE is -1, 25% more time between
	if(chem_effects[CE_HALLUCINATE] > 0)
		hall_delay /= max(1.15, chem_effects[CE_HALLUCINATE]) //if CE_HALLUCINATE is 1, 15% less time between

	next_hallucination = world.time + hall_delay
	var/datum/hallucination/H = SShallucinations.get_hallucination(src)
	if(isnull(H))
		LOG_DEBUG("Returned null hallucination for [src]")
		return
	H.holder = src
	H.activate()

//This is called on every end() so usually occurs a few times. Grants a thought to the user from thoughts list.
/mob/living/carbon/proc/hallucination_thought()
	if(prob(min(hallucination/2, 50)))
		addtimer(CALLBACK(src, PROC_REF(hal_thought_give)), rand(30,90))

/mob/living/carbon/proc/hal_thought_give()
	to_chat(src, "<I>[pick(SShallucinations.hallucinated_thoughts)]</I>")
