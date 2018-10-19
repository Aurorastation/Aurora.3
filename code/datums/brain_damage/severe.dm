//Severe traumas, when your brain gets abused way too much.
//These range from very annoying to completely debilitating.
//They can be suppressed with paroxetine, and require brain surgery to solve.

/datum/brain_trauma/severe

/datum/brain_trauma/severe/mute
	name = "Mutism"
	desc = "Patient is completely unable to speak."
	scan_desc = "extensive damage to the brain's language center"
	gain_text = "<span class='warning'>You forget how to speak!</span>"
	lose_text = "<span class='notice'>You suddenly remember how to speak.</span>"
	cure_type = CURE_CRYSTAL

/datum/brain_trauma/severe/mute/on_gain()
	owner.sdisabilities |= MUTE
	..()

//no fiddling with genetics to get out of this one
/datum/brain_trauma/severe/mute/on_life()
	if(!(owner.sdisabilities & MUTE))
		on_gain()
	..()

/datum/brain_trauma/severe/mute/on_lose()
	owner.sdisabilities &= ~MUTE
	..()

/datum/brain_trauma/severe/blindness
	name = "Cerebral Blindness"
	desc = "Patient's brain is no longer connected to its eyes."
	scan_desc = "extensive damage to the brain's occipital lobe"
	gain_text = "<span class='warning'>You can't see!</span>"
	lose_text = "<span class='notice'>Your vision returns.</span>"
	cure_type = CURE_SURGERY

/datum/brain_trauma/severe/blindness/on_gain()
	owner.sdisabilities |= BLIND
	..()

//no fiddling with genetics to get out of this one
/datum/brain_trauma/severe/blindness/on_life()
	if(!(owner.sdisabilities & BLIND))
		on_gain()
	..()

/datum/brain_trauma/severe/blindness/on_lose()
	if(owner.sdisabilities & BLIND)
		owner.sdisabilities &= ~BLIND
	..()

/datum/brain_trauma/severe/paralysis
	name = "Paralysis"
	desc = "Patient's brain can no longer control its motor functions."
	scan_desc = "cerebral paralysis"
	gain_text = "<span class='warning'>You can't feel your body anymore!</span>"
	lose_text = "<span class='notice'>You can feel your limbs again!</span>"
	cure_type = CURE_SURGERY

/datum/brain_trauma/severe/paralysis/on_life()
	owner.Weaken(200)
	..()

/datum/brain_trauma/severe/paralysis/on_lose()
	owner.SetWeakened(0)
	..()

/datum/brain_trauma/severe/narcolepsy
	name = "Narcolepsy"
	desc = "Patient may involuntarily fall asleep during normal activities."
	scan_desc = "traumatic narcolepsy"
	gain_text = "<span class='warning'>You have a constant feeling of drowsiness...</span>"
	lose_text = "<span class='notice'>You feel awake and aware again.</span>"
	cure_type = CURE_HYPNOSIS

/datum/brain_trauma/severe/narcolepsy/on_life()
	..()
	if(owner.stat == UNCONSCIOUS || owner.sleeping > 0)
		return
	var/sleep_chance = 5
	if(owner.m_intent == "run")
		sleep_chance += 15
	if(owner.drowsyness)
		sleep_chance += owner.drowsyness + 5
		if(owner.drowsyness >= 66)
			owner.drowsyness = 0
	if(prob(sleep_chance))
		to_chat(owner, "<span class='warning'>You fall asleep.</span>")
		owner.Sleeping(60)
	else if(prob(sleep_chance * 2))
		to_chat(owner, "<span class='warning'>You feel tired...</span>")
		owner.drowsyness += 10

/datum/brain_trauma/severe/monophobia
	name = "Monophobia"
	desc = "Patient feels sick and distressed when not around other people, leading to potentially lethal levels of stress."
	scan_desc = "severe monophobia"
	gain_text = ""
	lose_text = "<span class='notice'>You feel like you could be safe on your own.</span>"
	var/stress = 0
	cure_type = CURE_HYPNOSIS

/datum/brain_trauma/severe/monophobia/on_gain()
	..()
	if(check_alone())
		to_chat(owner, "<span class='warning'>You feel really lonely...</span>")
	else
		to_chat(owner, "<span class='notice'>You feel safe, as long as you have people around you.</span>")

/datum/brain_trauma/severe/monophobia/on_life()
	..()
	if(check_alone())
		stress = min(stress + 0.5, 100)
		if(stress > 10 && (prob(5)))
			stress_reaction()
	else
		stress -= 4

/datum/brain_trauma/severe/monophobia/proc/check_alone()
	if(owner.disabilities & BLIND)
		return TRUE
	for(var/mob/M in oview(owner, 7))
		if(!isliving(M)) //ghosts ain't people
			continue
		if((istype(M, /mob/living/simple_animal)) || M.ckey)
			return FALSE
	return TRUE

/datum/brain_trauma/severe/monophobia/proc/stress_reaction()
	if(owner.stat != CONSCIOUS)
		return

	var/high_stress = (stress > 60) //things get psychosomatic from here on
	switch(rand(1,6))
		if(1)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>You feel sick...</span>")
			else
				to_chat(owner, "<span class='warning'>You feel really sick at the thought of being alone!</span>")
			addtimer(CALLBACK(owner, /mob/living/carbon.proc/vomit, high_stress), 50) //blood vomit if high stress
		if(2)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>You can't stop shaking...</span>")
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
			else
				to_chat(owner, "<span class='warning'>You feel weak and scared! If only you weren't alone...</span>")
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
				owner.adjustHalLoss(50)

		if(3, 4)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>You feel really lonely...</span>")
			else
				to_chat(owner, "<span class='warning'>You're going mad with loneliness!</span>")
				owner.hallucination += 20

		if(5)
			if(!high_stress)
				to_chat(owner, "<span class='warning'>Your heart skips a beat.</span>")
				owner.adjustOxyLoss(8)
			else
				if(prob(15) && ishuman(owner))
					var/mob/living/carbon/human/H = owner
					var/obj/item/organ/heart/heart = H.internal_organs_by_name["heart"]
					heart.take_damage(heart.min_bruised_damage)
					to_chat(H, "<span class='danger'>You feel a stabbing pain in your heart!</span>")
				else
					to_chat(owner, "<span class='danger'>You feel your heart lurching in your chest...</span>")
					owner.adjustOxyLoss(8)

/datum/brain_trauma/severe/discoordination
	name = "Discoordination"
	desc = "Patient is unable to use complex tools or machinery."
	scan_desc = "extreme discoordination"
	gain_text = "<span class='warning'>You can barely control your hands!</span>"
	lose_text = "<span class='notice'>You feel in control of your hands again.</span>"
	cure_type = CURE_CRYSTAL

/datum/brain_trauma/severe/discoordination/on_gain()
	owner.disabilities |= MONKEYLIKE
	..()

/datum/brain_trauma/severe/discoordination/on_lose()
	owner.disabilities &= ~MONKEYLIKE
	..()

/datum/brain_trauma/severe/aphasia
	name = "Aphasia"
	desc = "Patient is unable to speak or understand any language."
	scan_desc = "extensive damage to the brain's language center"
	gain_text = "<span class='warning'>You have trouble forming words in your head...</span>"
	lose_text = "<span class='notice'>You suddenly remember how languages work.</span>"
	var/list/prev_languages = list()
	var/datum/language_holder/mob_language
	cure_type = CURE_SURGERY

/datum/brain_trauma/severe/aphasia/on_gain()
	for(var/datum/language/L in owner.languages)
		prev_languages.Add(L)
		owner.remove_language(L.name)
	owner.add_language(LANGUAGE_GIBBERING)
	..()

/datum/brain_trauma/severe/aphasia/on_lose()
	for(var/datum/language/L in prev_languages)
		owner.add_language(L.name)
		prev_languages.Remove(L)
	owner.remove_language(LANGUAGE_GIBBERING)
	..()

/datum/brain_trauma/severe/pacifism
	name = "Traumatic Non-Violence"
	desc = "Patient is extremely unwilling to harm others in violent ways."
	scan_desc = "pacific syndrome"
	gain_text = "<span class='notice'>You feel oddly peaceful.</span>"
	lose_text = "<span class='notice'>You no longer feel compelled to not harm.</span>"
	cure_type = CURE_HYPNOSIS

/datum/brain_trauma/severe/pacifism/on_gain()
	owner.disabilities |= PACIFIST
	..()

/datum/brain_trauma/severe/pacifism/on_lose()
	owner.disabilities &= ~PACIFIST
	..()

/datum/brain_trauma/severe/total_colorblind
	name = "Total Colorblindedness"
	desc = "Patient's brain is loosely connected to ocular cones."
	scan_desc = "minor damage to the brain's occipital lobe"
	gain_text = "<span class='warning'>Your perception of color vanishes!</span>"
	lose_text = "<span class='notice'>Your vision returns.</span>"

/datum/brain_trauma/severe/total_colorblind/on_gain()
	owner.add_client_color(/datum/client_color/monochrome)
	..()

/datum/brain_trauma/severe/total_colorblind/on_life()
	if(owner.client && !owner.client.color)
		on_gain()

/datum/brain_trauma/severe/total_colorblind/on_lose()
	owner.remove_client_color(/datum/client_color/monochrome)
	..()