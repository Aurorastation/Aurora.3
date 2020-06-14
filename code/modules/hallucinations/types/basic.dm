/datum/hallucination/announcement	//fake AI announcements, complete with sound. Text is weirder than normal, but easy to glaze over.
	min_power = HAL_POWER_LOW
	duration = 1200		//this duration length + not allowing duplicates prevents spamming announcements on every valid handle_hallucination() which can get VERY annoying if rng decides to give you 3 in a row
	allow_duplicates = FALSE

/datum/hallucination/announcement/start()
	var/list/hal_sender = SShallucinations.message_sender
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.client && !player_is_antag(H, only_offstation_roles = TRUE))	//We're not going to add ninjas, mercs, borers, etc to prevent meta.
			hal_sender += H
	switch(rand(1,15))
		if(1)
			sound_to(holder, 'sound/AI/radiation.ogg')
			to_chat(holder, "<h2 class='alert'>Anomaly Break</h2>")
			to_chat(holder, SPAN_ALERT("Comfortable levels of radiation detected near the station. [pick(SShallucinations.hallucinated_phrases)] Please cower among the shielded maintenance burrows."))	//hallucinated phrases contains the punctuation

		if(2)
			sound_to(holder, 'sound/AI/strangeobject.ogg')
			to_chat(holder, "<h2 class='alert'>Welcome Object</h2>")
			to_chat(holder, SPAN_ALERT("Transport signature of [pick(adjectives)] origin detected in your path, an object appears to have been nesting aboard NSS Upsilon. [pick(SShallucinations.hallucinated_phrases)]"))

		if(3)
			sound_to(holder, 'sound/AI/scrubbers.ogg')
			to_chat(holder, "<h2 class='alert'>Reminder: Backpressure Warning</h2>")
			to_chat(holder, SPAN_ALERT("The scrubbers network is expecting \an [pick(adjectives)] surge. Some ejection of [pick(adjectives)] contents will occur."))

		if(4)
			sound_to(holder, 'sound/AI/emergencyshuttlecalled.ogg')
			to_chat(holder, "<h2 class='alert'>Emergency Departure</h2>")
			to_chat(holder, SPAN_ALERT("The emergency evacuation shuttle has arrived. It will depart in approximately two minutes. Please do not allow [holder] to board."))

		if(5)
			sound_to(holder, 'sound/AI/vermin.ogg')
			to_chat(holder, "<h2 class='alert'>Vermin Feast</h2>")
			to_chat(holder, SPAN_ALERT("We indicate that [pick("rats", "lizards", "hivebots", "children")] have nested nearby. Free them before this starts to affect longetivity."))

		if(6)
			sound_to(holder, 'sound/AI/outbreak7.ogg')
			to_chat(holder, "<h2 class='alert'>What have you done?</h2>")
			to_chat(holder, SPAN_ALERT("Confirmed outbreak of help level 17 viral biohazard aboard [holder]. Help me. All personnel must destroy the outbreak. What have you helpME done?"))
			to_chat(holder, SPAN_ALERT("-[pick(hal_sender)]"))
		if(7)
			sound_to(holder, 'sound/AI/meteors.ogg')
			to_chat(holder, "<h2 class='alert'>Meteor Alarm</h2>")
			to_chat(holder, SPAN_ALERT("A [pick(adjectives)] meteor storm has been authorized for a destruction course with your station. Less than three minutes until impact, shields cannot help you; seek shelter in the upper level."))

		if(8)
			sound_to(holder, pick('sound/AI/fungi.ogg', 'sound/AI/funguy.ogg', 'sound/AI/fun_guy.ogg', 'sound/AI/fun_gi.ogg'))
			to_chat(holder, "<h2 class='alert'>Biohealth Notice</h2>")
			to_chat(holder, SPAN_ALERT("Healthy fungi detected on station. Your bodies may be contaminated. This is mandatory, [holder]."))

		if(9)
			sound_to(holder, 'sound/effects/nuclearsiren.ogg')
			to_chat(holder, "<font color='#008000'><b>Supermatter Monitor</b> states, \"WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT.\"</font>")
			addtimer(CALLBACK(src, .proc/delam_call), 20)
			addtimer(CALLBACK(src, .proc/delam_call), 35)

		if(10 to 15)    //Announcements that would be made by a player instead of random event
			var/list/body = list(
                        "Please avoid [pick("medical", "security", "the bar", "engineering", "cargo")] at this time due to [pick("a k'ois outbreak.", "a hostage situation.", "hostile boarders.", "[holder].")]",
						"Due to various complaints about [holder], we have conducted an investigation and due to the findings, we will [pick("arrest them. Please turn yourself in, [holder]", "terminate their employment with us.", "inform their family of their shortcomings.", "cyborgify them immediately.")]. Thank you.",
						"[pick("Boarders have", "The AI has", "Intruders have")] demanded we sacrifice a crewmember to them. After [pick("much", "little", "quick")] deliberation, we have chosen [holder]. Please turn yourself over, or [pick("we", "your family", "all of us", "those you love")] will die.",
						"Central Command has chosen [holder] as the NanoTrasen employee of the month! Everyone please congratulate them.",
						"Everything is fine.",
						"The tesla may or may not be loose.",
						"This is your directive 11. [pick("Spiders have killed several crew.", "Boarders have taken a hostage.", "[holder] is armed and dangerous. Avoid them at all costs.", "Two black-suited individuals have taken items from the vault and armory.")]",
						"Please stop [pick("drawing in blood. It's unsanitary.", "killing your fellow crew. It's rude.", "[holder] at all costs.", "falling down holes.")]",
						"[holder] disappoints us all once again.")
			sound_to(holder, 'sound/misc/announcements/notice.ogg')
			to_chat(holder, "<h2 class='alert'>Station Announcement</h2>")
			to_chat(holder, SPAN_ALERT(pick(body)))
			to_chat(holder, SPAN_ALERT("-[pick(hal_sender)]"))

//for REALLY selling that fake delamination
/datum/hallucination/announcement/proc/delam_call()
	var/list/people = list()
	for(var/mob/living/carbon/human/M in living_mob_list)
		if(!M.isMonkey() && !player_is_antag(M, only_offstation_roles = TRUE))	//Antag check prevents meta
			people += M
	people -= holder
	if(!people.len)
		return
	var/radio_exclaim = pick("Oh SHIT!", "Oh fuck.", "Uhhh!", "That's not good!", "FUCK.", "Engineering?", "It's under control!", "We're fucked!", "Ohhhh boy.", "What?!", "Um, <b>what?!</b>")
	to_chat(holder, "<font color='#008000'><b>[pick(people)]</b> says, \"[radio_exclaim]\"</font>")


/datum/hallucination/pda	//fake PDA messages. this only plays the beep and sends something to chat; it won't show up in the PDA.
	min_power = 20
	duration = 900		//this duration length + not allowing duplicates prevents spamming messages on every valid handle_hallucination() which can get VERY annoying if rng decides to give you 3 in a row
	allow_duplicates = FALSE

/datum/hallucination/pda/start()
	var/list/sender = SShallucinations.message_sender
	var/hall_job = "Unknown"
	if(ishuman(holder))
		var/mob/living/carbon/human/M = holder
		hall_job = M.job
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.client && !player_is_antag(H, only_offstation_roles = TRUE))	//adds current players to default list to provide variety. leaves out offstation antags.
			sender += H
	to_chat(holder, "<b>Message from [pick(sender)] to [holder.name] ([hall_job]),</b> \"[pick(SShallucinations.hallucinated_phrases)]\" (<FONT color = blue><u>reply</u></FONT>)")
	sound_to(holder, 'sound/machines/twobeep.ogg')

//hallucinate someone else doing something.
/datum/hallucination/paranoia
	var/list/hal_target = list()	//The potential mob you're going to imagine doing this

/datum/hallucination/paranoia/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C))
		if(!M.stat)
			hal_target += M
	if(hal_target.len)
		return TRUE

/datum/hallucination/paranoia/start()
	var/firstname = copytext(holder.real_name, 1, findtext(holder.real_name, " "))
	var/t = pick(SShallucinations.hallucinated_actions)
	t = replace_characters(t, list("you" = "[firstname]"))	//the list contains items that say "you." This replaces "you" with the hallucinator's first name to sell the fact that the person is doing the emote.
	to_chat(holder, "<b>[pick(hal_target)]</b> [t]")

/datum/hallucination/skitter
	max_power = 60

/datum/hallucination/skitter/start()
	to_chat(holder, "The spiderling skitters around.")


/datum/hallucination/prick
	duration = 40
	max_power = 35

/datum/hallucination/prick/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C, 1))
		if(!M.stat)
			return TRUE

/datum/hallucination/prick/start()
	to_chat(holder,SPAN_NOTICE("You feel a tiny prick!"))

/datum/hallucination/prick/end()	//chance to feel another effect after duration time
	switch(rand(1,6))
		if(1)
			holder.druggy += min(holder.hallucination, 15)
		if(2)
			holder.make_dizzy(105)
		if(3)
			to_chat(holder,SPAN_GOOD("You feel good."))
	..()

//the prick feeling but you actually imagine someone injecting you
/datum/hallucination/prick/by_person
	min_power = HAL_POWER_LOW
	max_power = INFINITY
	duration = 20
	var/injector
	var/needle = "syringe"

/datum/hallucination/prick/by_person/start()
	var/list/prick_candidates = list()
	for(var/mob/living/M in oview(holder, 1))
		if(!M.stat)
			prick_candidates += M
	injector = pick(prick_candidates)
	needle = pick("syringe", "hypospray", "pen")
	to_chat(holder, SPAN_WARNING("\The [injector] is trying to inject \the [holder] with \the [needle]!"))

/datum/hallucination/prick/by_person/end()
	to_chat(holder,SPAN_NOTICE("\The [injector] injects \the [holder] with \the [needle]!"))
	..()


/datum/hallucination/insides
	duration = 60
	max_power = 75

/datum/hallucination/insides/start()
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		var/obj/O = pick(H.organs)
		to_chat(holder,SPAN_DANGER("You feel something [pick("moving","squirming","skittering", "writhing", "burrowing", "crawling")] inside of your [O.name]!"))
	else
		to_chat(holder,SPAN_DANGER("You feel something [pick("moving","squirming","skittering", "writhing", "burrowing", "crawling")] inside of you!"))
	if(prob(min(holder.hallucination/2, 80)))
		sound_to(holder, pick('sound/misc/zapsplat/chitter1.ogg', 'sound/misc/zapsplat/chitter2.ogg', 'sound/effects/squelch1.ogg', 'sound/effects/lingextends.ogg'))

/datum/hallucination/insides/end()
	if(prob(50))
		to_chat(holder, SPAN_WARNING(pick("You see something moving under your skin!", "Whatever it is, it's definitely alive!", "If you don't get it out soon...", "It's moving towards your mouth!")))
	..()

//Pain. Picks a random type of pain, and severity is based on their level of hallucination.
/datum/hallucination/pain
	special_flags = NO_EMOTE

/datum/hallucination/pain/start()
	var/pain_type = rand(1,5)
	var/obj/item/organ/external/O
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		O = pick(H.organs)
		O.add_pain(min(holder.hallucination / 3, 25))	//always cause fake pain
	else
		O = BP_CHEST
		holder.adjustHalLoss(min(holder.hallucination / 3, 25))	//always cause fake pain
	switch(pain_type)
		if(1)
			to_chat(holder,SPAN_DANGER("You feel a sharp pain in your head!"))
		if(2)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, SPAN_WARNING("You feel a light pain in your [O.name]."))
				if(16 to 49)
					to_chat(holder, SPAN_DANGER("You feel a throbbing pain in your [O.name]!"))
				if(HAL_POWER_MED to INFINITY)
					to_chat(holder, SPAN_DANGER("You feel an excruciating pain in your [O.name]!"))
					holder.emote("me",1,"winces.")
		if(3)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, SPAN_WARNING("The muscles in your body hurt a little."))
				if(16 to 49)
					to_chat(holder, SPAN_DANGER("The muscles in your body cramp up painfully."))
				if(HAL_POWER_MED to INFINITY)
					to_chat(holder, SPAN_DANGER("There's pain all over your body!"))
					holder.emote("me",1,"flinches as all the muscles in their body cramp up.")
		if(4)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, SPAN_WARNING("Your [O.name] feels itchy."))
				if(16 to 49)
					to_chat(holder, SPAN_DANGER("You want to scratch the itch on your [O.name] badly!"))
				if(HAL_POWER_MED to INFINITY)
					to_chat(holder, SPAN_DANGER("You can't focus on anything but scratching the itch on your [O.name]!"))
					holder.emote("me",1,"shivers slightly.")
		if(5)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, SPAN_WARNING("You feel a little too warm."))
				if(16 to 49)
					to_chat(holder, SPAN_DANGER("You feel a horrible burning sensation on your [O.name]!"))
				if(HAL_POWER_MED to INFINITY)
					to_chat(holder, SPAN_DANGER("It feels like your [O.name] is being burnt to the bone!"))
					holder.emote("me",1,"flinches.")

//sort of like the vampire friend messages.
/datum/hallucination/friendly
	max_power = 45
	special_flags = NO_THOUGHT

/datum/hallucination/friendly/start()
	var/list/halpal = list()
	for(var/mob/living/L in oview(holder))
		halpal += L
	if(halpal.len)
		var/pal = pick(halpal)
		var/list/halpal_emotes = list("[pal] looks trustworthy.",
			"You feel as if [pal] is a relatively friendly individual.",
			"You feel yourself paying more attention to what [pal] is saying.",
			"[pal] has your best interests at heart, you can feel it.",
			"A quiet voice tells you that [pal] should be considered a friend.",
			"You never noticed until now how delightful [pal] is...",
			"[pal] will keep you safe.",
			"You feel captivated by [pal]'s charisma.",
			"[pal] might as well be family to you.")
		to_chat(holder, "<font color='green'><i>[pick(halpal_emotes)]</i></font>")

/datum/hallucination/passive
	duration = 600	//minute fallback
	allow_duplicates = FALSE
	max_power = 55

/datum/hallucination/passive/can_affect(mob/living/carbon/C)
	if(C.is_berserk())
		return FALSE
	if(C.disabilities & PACIFIST)
		return FALSE
	return ..()

/datum/hallucination/passive/start()
	duration = rand(500, 700)
	var/message = pick("You hurt so many people before... You have to stop.", "You won't hurt anyone ever again.", "Violence has caused so many problems. It's time to stop.", "The idea of conflict is terrifying!", "You realize that violence isn't the answer. Ever.", "You're struck by an overwhelming sense of guilt for your past acts of violence!")
	to_chat(holder, SPAN_DANGER("A sudden realization surges to the forefront of your mind. [message]"))
	holder.disabilities |= PACIFIST
	for(var/i = 1; i <= 2; i++)
		addtimer(CALLBACK(src, .proc/calm_feeling), rand(80, 150)*i)

/datum/hallucination/passive/end()
	if(holder.disabilities & PACIFIST)
		holder.disabilities &= ~PACIFIST
	to_chat(holder, SPAN_NOTICE("You no longer feel passive."))
	..()

/datum/hallucination/passive/proc/calm_feeling()
	var/feeling = pick("You feel calm. It's so peaceful.", "Violence seems like such a strange idea to you.", "You feel relaxed and peaceful.", "A wave of calm washes over you as you feel all your anger leave you.", "You wonder why people waste their time fighting.", "It's fine. Everything's fine.", "You can't remember ever feeling angry.", "Nothing can hurt you as long as you don't hurt it.")
	to_chat(holder, SPAN_GOOD(feeling))

/datum/hallucination/colorblind
	min_power = HAL_POWER_LOW
	duration = 100
	allow_duplicates = FALSE
	var/colorblindness

/datum/hallucination/colorblind/can_affect(mob/living/carbon/C)
	if(C.client.color)	//if they're already colorblind, we bail.
		return FALSE
	return ..()

/datum/hallucination/colorblind/start()
	duration = rand(350, 750)
	colorblindness = pick("deuteranopia", "protanopia", "tritanopia", "monochrome")
	switch(colorblindness)
		if("deuteranopia")
			holder.add_client_color(/datum/client_color/deuteranopia)
		if("protanopia")
			holder.add_client_color(/datum/client_color/protanopia)
		if("tritanopia")
			holder.add_client_color(/datum/client_color/tritanopia)
		if("monochrome")
			holder.add_client_color(/datum/client_color/monochrome)
	var/color_mes = pick("Everything looks... off.", "The colors shift around you.", "Wait, what happened to the colors?", "You watch as the colors around you swirl and shift.")
	to_chat(holder, SPAN_GOOD(color_mes))	//Good span makes it stand out

/datum/hallucination/colorblind/end()
	to_chat(holder, SPAN_GOOD("Slowly the colors around you shift back to what you feel is normal."))
	if(holder)
		switch(colorblindness)
			if("deuteranopia")
				holder.remove_client_color(/datum/client_color/deuteranopia)
			if("protanopia")
				holder.remove_client_color(/datum/client_color/protanopia)
			if("tritanopia")
				holder.remove_client_color(/datum/client_color/tritanopia)
			if("monochrome")
				holder.remove_client_color(/datum/client_color/monochrome)
	..()

//imagining someone hits you.
/datum/hallucination/fakeattack
	min_power = HAL_POWER_LOW
	var/list/attacker_candidates = list()

/datum/hallucination/fakeattack/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C,1))
		if(!M.stat)
			attacker_candidates += M
	if(attacker_candidates.len)
		return TRUE

/datum/hallucination/fakeattack/start()
	var/attacker = pick(attacker_candidates)
	attacker_candidates -= attacker
	if(prob(50))
		to_chat(holder, SPAN_DANGER("[attacker] has hit [holder]!"))
		sound_to(holder, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
	else
		to_chat(holder, SPAN_DANGER("[attacker] attempted to shove [holder]!"))
		sound_to(holder, 'sound/weapons/thudswoosh.ogg')

	//If we are hallucinating particularly hard and there's another person adjacent to us, we imagine they attack us, too.
	if(holder.hallucination >= 70 && attacker_candidates.len)
		attacker = pick(attacker_candidates)
		if(prob(50))
			to_chat(holder, SPAN_DANGER("[attacker] has hit [holder]!"))
			sound_to(holder, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
		else
			to_chat(holder, SPAN_DANGER("[attacker] attempted to shove [holder]!"))
			sound_to(holder, 'sound/weapons/thudswoosh.ogg')


/////////////////////////////////////////////
/////	PEOPLE TALKING ABOUT OR TO YOU	/////
/////////////////////////////////////////////
/datum/hallucination/talking
	var/repeats = 2		//In total, we'll get two messages. We don't need to reset this number anywhere because on end() it's deleted and a new one will be created if it's chosen again in handle_hallucinations
	special_flags = HEARING_DEPENDENT | NO_THOUGHT

/datum/hallucination/talking/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C))
		if(!M.stat)
			return TRUE

//Unique activate() since we are not adding the end() callback here; we're handling it in start() since it can loop
/datum/hallucination/talking/activate()
	if(!holder || !holder.client)
		return
	holder.hallucinations += src
	if(holder.hallucination >= 50)
		repeats = 3
	start()

////Talking about you. Most of it from Bay//////
/datum/hallucination/talking/start()
	if(!can_affect(holder) || !holder || !repeats)	//sanity check
		end()

	var/list/candidates = list()
	for(var/mob/living/M in oview(holder))
		if(!M.stat)
			if(holder.hallucination >= 75)	//If you're super fucked up you'll imagine more than just humans talking about you
				candidates += M
			else
				if(ishuman(M))
					candidates += M

	if(!candidates.len)	//No candidates, no effect.
		end()

	var/mob/living/talker = pick(candidates)	//Who is talking to us?
	var/message		//What will they say?

	//Name selection. This gives us variety. Sometimes it will be your last name, sometimes your first.
	var/list/names = list()
	var/lastname = copytext(holder.real_name, findtext(holder.real_name, " ")+1)
	var/firstname = copytext(holder.real_name, 1, findtext(holder.real_name, " "))
	if(lastname)
		names += lastname
	if(firstname)
		names += firstname
	if(!names.len)
		names += holder.real_name

	switch(rand(1,8))	//Deciding how we're going to manifest this hallucinated conversation.

		if(1)	//Nonverbal gesture.
			to_chat(holder,"<B>[talker]</B> [pick("points", "looks", "stares", "smirks")] at [pick(names)] and says something softly.")

		if(2 to 3)	//Talking prompts imported from Bay. Less variation in these phrases, so we have less chance to pick them. Mitigates some repetition.
			//message prep
			var/add = prob(20) ? ", [pick(names)]" : ""		//Accompanies phrases list. 20% chance to add the first or last name to the phrase for variation
			var/list/phrases = list("Get out[add]!","Go away[add].","What are you doing[add]?","Where's your ID[add]?", "You know I love you[add].", "You do great work[add]!")		//this is the phrase. [add] is chosen in the previous line.
			if(holder.hallucination > 50)		//If you're very messed up, the message variety gets a little more aggressive by adding these options
				phrases += list("What did you come here for[add]?","Don't touch me[add].","You're not getting out of here[add].", "You're a failure, [pick(names)].","Just kill yourself already, [pick(names)].","Put on some clothes[add].","You're a horrible person[add].","You know nobody wants you here, right[add]?")

			message = pick(phrases)
			to_chat(holder,"<span class='game say'><B>[talker]</B> [talker.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>")
		else	//More varied messages using text list and different speech prefixes
			
			//message prep
			var/speak_prefix = pick("Hey", "Uh", "Um", "Oh", "Ah", "")		//For variety, we have a different greeting. This one has a chance of picking a starter....
			speak_prefix = "[speak_prefix][pick(names)][pick(".","!","?")]"		//...then adds the name, and ends it randomly with ., !, or ? ("Hey, name?" "Oh, name!" "Ah, name." "Name!"") etc.

			message = prob(70) ? "[speak_prefix] [pick(SShallucinations.hallucinated_phrases)]" : pick(SShallucinations.hallucinated_phrases) //Here's the message that uses the hallucinated_phrases text list. Won't always apply the speak_prefix; sometimes they say weird shit without addressing you.
			to_chat(holder,"<span class='game say'><B>[talker]</B> [talker.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>")

	repeats -= 1
	if(repeats)	//And we do it all over again, one or two more times.
		addtimer(CALLBACK(src, .proc/start), rand(50, 100))
	else
		end()

//Thinking people are whispering messages to you.
/datum/hallucination/whisper
	special_flags = HEARING_DEPENDENT

/datum/hallucination/whisper/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C, 1))
		if(!M.stat)
			return TRUE

/datum/hallucination/whisper/start()
	var/list/whisper_candidates = list()
	for(var/mob/living/M in oview(holder, 1))
		if(!M.stat)
			whisper_candidates += M
	if(whisper_candidates.len)
		var/whisperer = pick(whisper_candidates)
		if(prob(70))
			to_chat(holder, "<B>[whisperer]</B> whispers, <I>\"[pick(SShallucinations.hallucinated_phrases)]\"</I>")
		else
			to_chat(holder, "<B>[whisperer]</B> [pick("gently nudges", "pokes at", "taps", "looks at", "pats")] [holder], trying to get their attention.")

//whispers that don't depend on a person's proximity
/datum/hallucination/whisper/no_entity
	min_power = HAL_POWER_LOW

/datum/hallucination/whisper/no_entity/can_affect(mob/living/carbon/C)
	return ..()

/datum/hallucination/whisper/no_entity/start()
	var/list/whisper_candidates = list("A familiar voice", "A distant voice", "A child's voice", "Something inside your head", "Your own voice", "A ghastly voice")
	to_chat(holder, "<B>[pick(whisper_candidates)]</B> whispers directly into your mind, <I>\"[pick(SShallucinations.hallucinated_phrases)]\"</I>")
	sound_to(holder, pick('sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg', 'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg'))
	holder.emote("me",1,"shivers.")