//Effects that produce feelings or altered states of mind

/datum/artifact_effect/badfeeling
	effecttype = "badfeeling"
	effect_type = 2
	var/list/messages = list("You feel worried.",\
		"Something doesn't feel right.",\
		"You get a strange feeling in your gut.",\
		"Your instincts are trying to warn you about something.",\
		"Someone just walked over your grave.",\
		"There's a strange feeling in the air.",\
		"There's a strange smell in the air.",\
		"The tips of your fingers feel tingly.",\
		"You feel witchy.",\
		"You have a terrible sense of foreboding.",\
		"You've got a bad feeling about this.",\
		"Your scalp prickles.",\
		"The light seems to flicker.",\
		"The shadows seem to lengthen.",\
		"The walls are getting closer.",\
		"Something is wrong")

	var/list/drastic_messages = list("You've got to get out of here!",\
		"Someone's trying to kill you!",\
		"There's something out there!",\
		"What's happening to you?",\
		"OH GOD!",\
		"HELP ME!")

/datum/artifact_effect/badfeeling/DoEffectTouch(var/mob/living/user)
	if(!user.isSynthetic())
		if(prob(50))
			if(prob(75))
				to_chat(user, "<b><font color='red' size='[num2text(rand(1,5))]'>[pick(drastic_messages)]</b></font>")
			else
				to_chat(user, "<span class='warning'>[pick(messages)]</span>")

		if(prob(50))
			user.dizziness = max(user.dizziness, rand(105, 200))

/datum/artifact_effect/badfeeling/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(effectrange,T))
			if(H.isSynthetic())
				continue
			if(prob(5))
				if(prob(75))
					to_chat(H, "<span class='warning'>[pick(messages)]</span>")
				else
					to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")

			if(prob(10))
				H.dizziness += rand(3,5)
		return TRUE

/datum/artifact_effect/badfeeling/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(effectrange,T))
			if(H.isSynthetic())
				continue
			if(prob(50))
				if(prob(95))
					to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<span class='warning'>[pick(messages)]</span>")
			if(prob(50))
				H.dizziness += rand(3,5)
			else if(prob(25))
				H.dizziness += rand(5,15)
		return TRUE


/datum/artifact_effect/goodfeeling
	effecttype = "goodfeeling"
	effect_type = 2
	var/list/messages = list("You feel good.",\
		"Everything seems to be going alright",\
		"You've got a good feeling about this",\
		"Your instincts tell you everything is going to be getting better.",\
		"There's a good feeling in the air.",\
		"Something smells... good.",\
		"The tips of your fingers feel tingly.",\
		"You've got a good feeling about this.",\
		"You feel happy.",\
		"You fight the urge to smile.",\
		"Your scalp prickles.",\
		"All the colours seem a bit more vibrant.",\
		"Everything seems a little lighter.",\
		"The troubles of the world seem to fade away.")

	var/list/drastic_messages = list("You want to hug everyone you meet!",\
		"Everything is going so well!",\
		"You feel euphoric.",\
		"You feel giddy.",\
		"You're so happy suddenly, you almost want to dance and sing.",\
		"You feel like the world is out to help you.")

/datum/artifact_effect/goodfeeling/DoEffectTouch(var/mob/living/user)
	if(ishuman(user) && !user.isSynthetic())
		var/mob/living/carbon/human/H = user
		if(prob(50))
			if(prob(75))
				to_chat(H, "<b><font color='blue' size='[num2text(rand(1,5))]'>[pick(drastic_messages)]</b></font>")
			else
				to_chat(H, "<span class='notice'>[pick(messages)]</span>")

		if(prob(50))
			H.dizziness += rand(3,5)

/datum/artifact_effect/goodfeeling/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(effectrange,T))
			if(H.isSynthetic())
				continue
			if(prob(5))
				if(prob(75))
					to_chat(H, "<span class='notice'>[pick(messages)]</span>")
				else
					to_chat(H, "<font color='blue' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")

			if(prob(5))
				H.dizziness += rand(3,5)
		return TRUE

/datum/artifact_effect/goodfeeling/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(effectrange,T))
			if(H.isSynthetic())
				continue
			if(prob(50))
				if(prob(95))
					to_chat(H, "<font color='blue' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<span class='notice'>[pick(messages)]</span>")

			if(prob(50))
				H.dizziness += rand(3,5)
			else if(prob(25))
				H.dizziness += rand(5,15)
		return TRUE

//Artifact makes you see things. Only carbon-level mobs and above experience hallucinations
/datum/artifact_effect/hallucination
	effecttype = "hallucination"
	effect_type = 2
	var/strength = 1

/datum/artifact_effect/hallucination/New()
	..()
	strength = rand(1, 3)

/datum/artifact_effect/hallucination/DoEffectTouch(var/mob/living/user)
	if(iscarbon(user) && !user.isSynthetic())
		var/mob/living/carbon/C = user
		var/weakness = GetAnomalySusceptibility(C)
		if(prob(weakness * 100))
			C.hallucination = max(strength * 20, C.hallucination + (strength * 10))
			to_chat(C, "<b>You touch \the [src],</b> [pick("but nothing of note happens","but nothing happens","but nothing interesting happens","but you notice nothing different","but nothing seems to have happened")].")
			if(prob(5))
				C.dizziness += rand(110,150)

/datum/artifact_effect/hallucination/DoEffectAura()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/C in range(effectrange,T))
			if(C.isSynthetic())
				continue
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				C.hallucination = max(strength * 5, C.hallucination + strength) //Constantly creeps up
		return TRUE

/datum/artifact_effect/hallucination/DoEffectPulse()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/C in range(effectrange,T))
			if(C.isSynthetic())
				continue
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(weakness * 100))
				C.hallucination = max(strength * 5, C.hallucination + strength) //Creeps up slower than a constant aura, but the bursts cause dizziness
				if(prob(20))
					C.dizziness += rand(50,75)

		return TRUE