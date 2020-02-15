var/list/hallucinated_phrases = file2list("config/hallucination/hallucinated_phrases.txt")
var/list/hallucinated_actions = file2list("config/hallucination/hallucinated_actions.txt")	//important note when adding to this file: "you" will always be replaced by the hallucinator's name
var/list/hallucinated_thoughts = file2list("config/hallucination/hallucinated_thoughts.txt")


/mob/living/carbon/var/next_hallucination = 0			//Hallucination spam limit var
/mob/living/carbon/var/list/hallucinations = list()		//Hallucinations currently affecting the mob

///////////////////////////////////////Hallucinated Hearing///////////////////////////
/mob/living/carbon/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(hallucination >= 40 && prob(hallucination/40))		//Hallucinating someone speaking in a different language.
		world << "Called: Hear_say_language"
		var/list/hallucinated_languages = subtypesof(/datum/language)
		language = pick(hallucinated_languages)
	if(hallucination >= 80 && prob(1))
		world << "Called: Hear_say_message"
		var/orig_message = message
		message = pick(hallucinated_phrases)
		log_say("Hallucination level changed [orig_message] by [speaker] to [message] for [key_name(src)].", ckey=key_name(src))
	..()
/mob/living/carbon/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")
	if(hallucination >= 40 && prob(hallucination/40))		//Hallucinating someone speaking in a different language.
		var/list/hallucinated_languages = subtypesof(/datum/language)
		language = pick(hallucinated_languages)
		world << "Called: Hear_radio_language"
	if(hallucination >= 80 && prob(1))
		world << "Called: Hear_radio_message"
		var/orig_message = message
		message = pick(hallucinated_phrases)
		log_say("Hallucination level changed [orig_message] by [speaker] to [message] for [key_name(src)].", ckey=key_name(src))
	..()

/mob/living/carbon/proc/handle_hallucinations()     //Main handling proc, called in life()

	hallucination -= 1	//Tick down the duration

	if(!hallucination)  //We're done
		return

	if(!client || stat || world.time < next_hallucination)
		return

	var/hall_delay = rand(160,250)

	if(hallucination < 25)		//Winding down, less frequent.
		hall_delay *= 2
	if(hallucination > 75)		//Yo mind really fucked, more frequent.
		hall_delay *= 0.75
	next_hallucination = world.time + hall_delay
	var/list/candidates = list()
	for(var/T in subtypesof(/datum/hallucination/))
		var/datum/hallucination/H = new T
		if(H.can_affect(src))
			candidates += H
			world << "[H] added to candidates"
	if(candidates.len)
		var/datum/hallucination/H = pick(candidates)
		H.holder = src
		H.activate()


///////////////////////////Hallucination Datums//////////////////////////

/datum/hallucination
	var/mob/living/carbon/holder
	var/allow_duplicates = TRUE     //This is set to false for hallucinations with long durations or ones we do not want repeated for a time
	var/duration = 10		//how long before we call end()
	var/min_power = 0 		//mobs only get this hallucination at this threshold
	var/max_power = INFINITY	//mobs don't get this hallucination if it's above this threshold. Used to weed out more common ones if you're super fucked up

///////////Things you involuntarily emote while hallucinating //////////////
	var/list/hal_emote = list("mutters quietly.", "stares.", "grunts.", "looks around.", "twitches.", "shivers.", "swats at the air.", "wobbles.", "gasps!", "blinks rapidly.", "murmurs.",
				"dry heaves!", "twitches violently.", "giggles.", "drools.", "scratches all over.", "grinds their teeth.", "whispers something quietly.")

/////////////// Sender list of names for fake messages/announcements/other uses. Some copied over from spam messages//////
	var/list/message_sender = list("Mom", "Dad", "Captain", "Captain(as Captain)", "help", "Home", "MaxBet Online Casino", "IDrist Corp", "Dr. Maxman",
			"www.wetskrell.nt", "You are our lucky grand prize winner!",  "Officer Beepsky", "Ginny", "Ian",
			"what have you DONE?", "Miranda Trasen", "Central Command", "AI", "maintenance drone", "Unknown", "I don't want to die")

/////////////////////////////////////////////
/////		PROCS			/////
/////////////////////////////////////////////
/datum/hallucination/proc/start()

/datum/hallucination/proc/end()
	world << "Called: Default End"
	if(holder)
		holder.hallucination_thought()			//Hallucinations really focus on your mind.
		hallucination_emote(holder)		//Always a chance to involuntarily emote to others as if on drugs
		holder.hallucinations -= src
	qdel(src)
	//holder = null

/datum/hallucination/proc/can_affect(mob/living/carbon/C)		//Used to verify if a hallucination can be added to the list of candidates
	if(!C.client)
		world << "[src] cannot affect due to: no client"
		return FALSE
	if(!allow_duplicates && (locate(type) in C.hallucinations))
		world << "[src] cannot affect due to: duplicate in list"
		return FALSE
	if(min_power > C.hallucination || max_power < C.hallucination)
		world << "[src] cannot affect due to: min or max power"
		return FALSE
	return TRUE

/datum/hallucination/Destroy()
	. = ..()
	holder = null

/datum/hallucination/proc/activate()		//The actual kickoff to each effect
	if(!holder || !holder.client)
		return
	world << "Called: Activate Generic"
	holder.hallucinations += src
	start()
	addtimer(CALLBACK(src, .proc/end), duration)


/datum/hallucination/proc/hallucination_emote()		//You emoting to others involuntarily. This happens mostly in end()
	if(prob(min(holder.hallucination - 5, 80)) && !holder.stat)
		var/chosen_emote = pick(hal_emote)
		for(var/mob/M in oviewers(world.view, holder))		//Only shows to others, not you; you're not aware of what you're doing. Could prompt others to ask if you're okay, and lead to confusion.
			to_chat(M, "[holder] [chosen_emote]")

//I had to move this to carbon because /datum/hallucinations get deleted when they end, which I think messes with the callback. If anyone has a less janky way of doing this let me know

/mob/living/carbon/proc/hallucination_thought()	//Thoughts should come to you frequently, but not be spammed. This is called on every end() so usually occurs a few times.
	if(prob(min(src.hallucination/2, 50)))
		addtimer(CALLBACK(src, .proc/hal_thought_give), rand(30,70))

/mob/living/carbon/proc/hal_thought_give()
	to_chat(src, span("notice", "<i>[pick(hallucinated_thoughts)]</i>"))

/////////////////////////////////////////////
/////	    BASIC HALLUCINATIONS	/////
/////////////////////////////////////////////

/datum/hallucination/announcement		//fake AI announcements, complete with sound. Text is weirder than normal, but easy to glaze over.
	min_power = 30
	duration = 1200				//this duration length + not allowing duplicates prevents spamming announcements on every valid handle_hallucination() which can get VERY annoying if rng decides to give you 3 in a row
	allow_duplicates = FALSE

/datum/hallucination/announcement/start()
	world << "Called: Announcement Start"
	var/list/hal_sender = message_sender
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.client)
			hal_sender += H
			world << "[H] added to sender list"
	switch(rand(1,15))
		if(1)
			sound_to(holder, 'sound/AI/radiation.ogg')
			to_chat(holder, "<h2 class='alert'>Anomaly Break</h2>")
			to_chat(holder, span("alert", "Comfortable levels of radiation detected near the station. [pick(hallucinated_phrases)]. Please become one of the shielded maintenance burrows."))

		if(2)
			sound_to(holder, 'sound/AI/strangeobject.ogg')
			to_chat(holder, "<h2 class='alert'>Welcome Object</h2>")
			to_chat(holder, span("alert", "Transport signature of [pick(adjectives)] origin detected in your path, an object appears to have been nesting aboard NSS Upsilon. [pick(hallucinated_phrases)]"))

		if(3)
			sound_to(holder, 'sound/AI/scrubbers.ogg')
			to_chat(holder, "<h2 class='alert'>Reminder: Backpressure Warning</h2>")
			to_chat(holder, span("alert", "The scrubbers network is expecting \an [pick(adjectives)] surge. Some ejection of [pick(adjectives)] contents will occur."))

		if(4)
			sound_to(holder, 'sound/AI/emergencyshuttlecalled.ogg')
			to_chat(holder, "<h2 class='alert'>Emergency Departure</h2>")
			to_chat(holder, span("alert", "The emergency evacuation shuttle has arrived. It will depart in approximately two minutes. Please do not allow [holder] to board."))

		if(5)
			sound_to(holder, 'sound/AI/vermin.ogg')
			to_chat(holder, "<h2 class='alert'>Vermin Feast</h2>")
			to_chat(holder, span("alert", "We indicate that [pick("rats", "lizards", "hivebots", "children")] have nested nearby. Free them before this starts to affect longetivity."))

		if(6)
			sound_to(holder, 'sound/AI/outbreak7.ogg')
			to_chat(holder, "<h2 class='alert'>What have you done?</h2>")
			to_chat(holder, span("alert", "Confirmed outbreak of help level 17 viral biohazard aboard [holder]. Help me. All personnel must destroy the outbreak. What have you helpME done?"))
			to_chat(holder, span("alert", "-[pick(hal_sender)]"))
		if(7)
			sound_to(holder, 'sound/AI/meteors.ogg')
			to_chat(holder, "<h2 class='alert'>Meteor Alarm</h2>")
			to_chat(holder, span("alert", "A [pick(adjectives)] meteor storm has been authorized for a destruction course with your station. Less than three minutes until impact, shields cannot help you; seek shelter in the upper level."))

		if(8)
			sound_to(holder, pick('sound/AI/fungi.ogg', 'sound/AI/funguy.ogg', 'sound/AI/fun_guy.ogg', 'sound/AI/fun_gi.ogg'))
			to_chat(holder, "<h2 class='alert'>Biohealth Notice</h2>")
			to_chat(holder, span("alert", "Healthy fungi detected on station. Your bodies may be contaminated. This is mandatory, [holder]."))

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
			to_chat(holder, "<h2 class='alert'>Attention</h2>")
			to_chat(holder, span("alert", pick(body)))
			to_chat(holder, span("alert", "-[pick(hal_sender)]"))

/datum/hallucination/announcement/proc/delam_call()	//for REALLY selling that fake delamination
	var/list/people = list()
	for(var/mob/living/carbon/human/M in living_mob_list)
		if(!M.isMonkey())
			people += M
	people -= holder
	if(!people.len)
		return
	var/radio_exclaim = pick("Oh SHIT!", "Oh fuck.", "Uhhh!", "That's not good!", "FUCK.", "Engineering?", "It's under control!", "We're fucked!", "Ohhhh boy.", "What?!", "Um, <b>what?!</b>")
	to_chat(holder, "<font color='#008000'><b>[pick(people)]</b> says, \"[radio_exclaim]\"</font>")



/datum/hallucination/pda				//fake PDA messages. this only plays the beep and sends something to chat; it won't show up in the PDA.
	min_power = 25
	duration = 900					//this duration length + not allowing duplicates prevents spamming messages on every valid handle_hallucination() which can get VERY annoying if rng decides to give you 3 in a row
	allow_duplicates = FALSE

/datum/hallucination/pda/start()
	world << "Called: PDA"
	var/list/sender = message_sender
	var/mob/living/carbon/human/M = holder
	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.client)
			sender += H	//adds current players to default list to provide variety
	holder.show_message("<b>Message from [pick(sender)] to [holder.name] ([M.job]),</b> \"[pick(hallucinated_phrases)]\" (<FONT color = blue><u>reply</u></FONT>)")
	sound_to(holder, 'sound/machines/twobeep.ogg')



/datum/hallucination/paranoia

/datum/hallucination/paranoia/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C))
		return TRUE

/datum/hallucination/paranoia/start()		//hallucinate someone else doing something. Yes, it's intentional that it's any living mob, not just other characters.
	world << "Called: Paranoia"
	var/list/hal_target = list() //The mob you're going to imagine doing this
	var/firstname = copytext(holder.real_name, 1, findtext(holder.real_name, " "))
	var/t = pick(hallucinated_actions)
	t = replace_characters(t, list("you" = "[firstname]"))		//the list contains items that say "you." This replaces "you" with the hallucinator's first name to sell the fact that the person is doing the emote.
	for(var/mob/living/M in oview(holder))
		hal_target += M
	if(hal_target.len)
		to_chat(holder, "<b>[pick(hal_target)]</b> [t]")



/datum/hallucination/skitter
	max_power = 60
/datum/hallucination/skitter/start()
	world << "Called: Skitter"
	to_chat(holder, "The spiderling skitters around.")



/datum/hallucination/prick
	duration = 40

/datum/hallucination/prick/start()
	to_chat(holder,span("notice", "You feel a tiny prick!"))

/datum/hallucination/prick/end()		//chance to feel another effect after duration time
	switch(rand(1,6))
		if(1)
			holder.druggy += min(holder.hallucination, 20)
		if(2)
			holder.make_dizzy(10)
		if(3)
			to_chat(holder,"<span class='good'>You feel good.</span>")
	..()

/datum/hallucination/prick/by_person	//the prick feeling but you actually imagine someone injecting you
	min_power = 40
	duration = 20
	var/injector
	var/needle

/datum/hallucination/prick/by_person/can_affect(mob/living/carbon/C)
	if(!..())
		world << "prick by person returned false"
		return FALSE
	for(var/mob/living/M in oview(C, 1))
		return TRUE

/datum/hallucination/prick/by_person/start()
	world << "CALLED: Prick by person"
	var/list/prick_candidates = list()
	for(var/mob/living/carbon/human/M in oview(holder, 1))
		if(!M.stat)
			prick_candidates += M
	if(!prick_candidates.len)
		return
	injector = pick(prick_candidates)
	needle = pick("syringe", "hypospray", "pen")
	to_chat(holder, span("warning", "\The [injector] is trying to inject \the [holder] with \the [needle]!"))

/datum/hallucination/prick/by_person/end()
	to_chat(holder,span("notice", "\The [injector] injects \the [holder] with \the [needle]!"))
	to_chat(holder,span("notice", "You feel a tiny prick!"))
	..()



/datum/hallucination/insides
	duration = 60
/datum/hallucination/insides/start()
	world << "Called: Insides"
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		var/obj/O = pick(H.organs)
		to_chat(holder,span("danger", "You feel something [pick("moving","squirming","skittering", "writhing", "burrowing", "crawling")] inside of your [O.name]!"))
	else
		to_chat(holder,span("danger", "You feel something [pick("moving","squirming","skittering", "writhing", "burrowing", "crawling")] inside of you!"))
	if(prob(min(holder.hallucination/2, 50)))
		sound_to(holder, pick('sound/misc/zapsplat/chitter1.ogg', 'sound/misc/zapsplat/chitter2.ogg', 'sound/effects/squelch1.ogg'))

/datum/hallucination/insides/end()
	if(prob(50))
		to_chat(holder, span("warning", pick("You see something moving under your skin!", "Whatever it is, it's definitely alive!", "If you don't get it out soon...", "It's moving towards your mouth!")))
	..()



/datum/hallucination/pain				//Pain. Picks a random type of pain, and severity is based on their level of hallucination.
/datum/hallucination/pain/start()
	var/pain_type = rand(1,5)
	world << "Called: Pain at value [holder.hallucination] with type [pain_type]"
	switch(pain_type)
		if(1)
			to_chat(holder,span("danger", "You feel a sharp pain in your head!"))
		if(2)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, span("warning", "You feel a light pain in your head."))
				if(16 to 40)
					to_chat(holder, span("danger", "You feel a throbbing pain in your head!"))
				if(41 to INFINITY)
					to_chat(holder, span("danger", "You feel an excruciating pain in your head!"))
					holder.eye_blurry += 9
					holder.emote("me",1,"winces.")
		if(3)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, span("warning", "The muscles in your body hurt a little."))
				if(16 to 40)
					to_chat(holder, span("danger", "The muscles in your body cramp up painfully."))
				if(41 to INFINITY)
					holder.emote("me",1,"flinches as all the muscles in their body cramp up.")
					to_chat(holder, span("danger", "There's pain all over your body."))
					holder.eye_blurry += 9
		if(4)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, span("warning", "You feel a slight itch."))
				if(16 to 40)
					to_chat(holder, span("danger", "You want to scratch your itch badly!"))
				if(41 to INFINITY)
					holder.emote("me",1,"shivers slightly.")
					to_chat(holder, span("danger", "This itch makes it really hard to concentrate!"))
					holder.eye_blurry += 9
		if(5)
			switch(holder.hallucination)
				if(1 to 15)
					to_chat(holder, span("warning", "You feel a little too warm."))
				if(16 to 40)
					to_chat(holder, span("danger", "You feel a horrible burning sensation!"))
				if(41 to INFINITY)
					holder.emote("me",1,"flinches.")
					to_chat(holder, span("danger", "It feels like you're being burnt to the bone!"))
					holder.eye_blurry += 9

	holder.adjustHalLoss(min(holder.hallucination / 2, 50))		//always cause fake pain




/datum/hallucination/friendly			//sort of like the vampire friend messages.
	max_power = 60
/datum/hallucination/friendly/start()
	world << "Called: Friendly Feeling"
	var/list/halpal = list()
	for(var/mob/living/L in oview(holder))
		halpal += L
		world << "[L] added to halpal"
	if(!halpal.len)
		world << "Called: No HalPal for friendly feeling. Ending"
		end()
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



/datum/hallucination/rage
	min_power = 50
	allow_duplicates = FALSE

/datum/hallucination/rage/start()		//We don't want ALL the effects of berserk. You're not going to hallucinate the ability to tear down walls
	duration = rand(150, 300)
	to_chat(holder, span("danger", "An uncontrollable rage overtakes your thoughts!"))
	holder.a_intent_change(I_HURT)
	if(prob(60))							//Getting this overlay too frequently is kind of a nuisance when tested. We're trying to keep away from memery interruptions
		holder.add_client_color(/datum/client_color/berserk)
	if(prob(holder.hallucination))
		addtimer(CALLBACK(src, .proc/fury), rand(40, 60))

/datum/hallucination/rage/end()
	to_chat(holder, span("danger", "Your thoughts clear as you feel your rage slip away."))
	if(holder)
		holder.remove_client_color(/datum/client_color/berserk)
	..()

/datum/hallucination/rage/proc/fury()
	var/list/rage_targets = list()
	for(var/mob/living/L in oview(holder))
		rage_targets += L
	if(rage_targets.len)
		var/rage_pick = pick(rage_targets)
		to_chat(holder, span("danger", pick("You need to hit [rage_pick], NOW!", "[rage_pick] needs a good punch!", "Someone needs to shut [rage_pick] up!", "[rage_pick] is really irritating you!", "[rage_pick] is trying to ruin you!", "You know you'll feel better if you just get a good hit on [rage_pick]!", "You can't calm down with [rage_pick] standing there!")))
	else
		to_chat(holder, span("danger", "You need to hit something, NOW!"))
	holder.emote("me",1,"growls angrily.")




/datum/hallucination/passive
	duration = 600	//minute
	allow_duplicates = FALSE

/datum/hallucination/passive/can_affect(mob/living/carbon/C)
	if(C.disabilities & PACIFIST)
		world << "[src] cannot affect due to: pacifist flag"
		return FALSE
	if((locate(/datum/hallucination/rage) in C.hallucinations))
		world << "[src] cannot affect due to: RAGE"
		return FALSE
	return ..()

/datum/hallucination/passive/start()
    var/message = pick("You hurt so many people before...", "You won't hurt anyone ever again.", "You're a monster, but you don't have to hurt anyone!", "Violence has caused so many problems. It's time to stop.", "The idea of conflict is terrifying!", "You realize that violence isn't the answer. Ever.", "You're struck by an overwhelming sense of guilt for your past acts of violence!")
    to_chat(holder, span("notice", "A sudden thought overtakes your mind. [message]"))
    duration += holder.hallucination
    holder.disabilities |= PACIFIST
    addtimer(CALLBACK(src, .proc/calm_feeling), rand(100, 250))

/datum/hallucination/passive/end()
    if(holder.disabilities & PACIFIST)
        holder.disabilities &= ~PACIFIST
    to_chat(holder, span("notice", "You no longer feel passive."))
    ..()

/datum/hallucination/passive/proc/calm_feeling()
    var/feeling = pick("You feel calm. It's so peaceful.", "You feel particularly passive.", "You feel relaxed and peaceful.", "A wave of calm washes over you as you feel all your anger leave you.")
    to_chat(holder, span("good", feeling))




/datum/hallucination/sound
	max_power = 70
	var/audio_effect = FALSE
	var/list/sounds = list('sound/weapons/smash.ogg',
			'sound/weapons/flash_ring.ogg',
			'sound/effects/Explosion1.ogg',
			'sound/effects/Explosion2.ogg',
			'sound/effects/explosionfar.ogg',
			'sound/effects/crusher_alarm.ogg',
			'sound/effects/smoke.ogg')

/datum/hallucination/sound/start()
	world << "Called: Sound"
	sound_to(holder, pick(sounds))


/datum/hallucination/sound/echo
	duration = 50	//This delays end() by 5 seconds, where we have a chance of playing another sound from this list.
	sounds = list('sound/machines/airlock.ogg',
			'sound/voice/shriek1.ogg',
			'sound/misc/nymphchirp.ogg',
			'sound/machines/twobeep.ogg',
			'sound/machines/windowdoor.ogg',
			'sound/effects/glass_break1.ogg',
			'sound/weapons/railgun.ogg',
			'sound/effects/phasein.ogg',
			'sound/effects/sparks1.ogg',
			'sound/effects/sparks2.ogg',
			'sound/effects/sparks3.ogg',
			'sound/effects/stealthoff.ogg',
			'sound/misc/zapsplat/chitter1.ogg',
			'sound/misc/zapsplat/chitter2.ogg', 
			'sound/effects/squelch1.ogg')

/datum/hallucination/sound/echo/end()
	world << "Called: Sound echo end()"
	if(prob(holder.hallucination / 2))
		sound_to(holder, pick(sounds))
	..()


/datum/hallucination/sound/tools
	sounds = list('sound/items/Ratchet.ogg','sound/items/Welder.ogg','sound/items/Crowbar.ogg','sound/items/Screwdriver.ogg', 'sound/items/drill_use.ogg', 'sound/items/air_wrench.ogg')

/datum/hallucination/sound/creepy
	min_power = 40
	max_power = INFINITY
	sounds = list('sound/effects/ghost.ogg',
				'sound/effects/ghost2.ogg',
				'sound/effects/screech.ogg',
				'sound/hallucinations/behind_you1.ogg',
				'sound/hallucinations/behind_you2.ogg',
				'sound/hallucinations/far_noise.ogg',
				'sound/hallucinations/growl1.ogg',
				'sound/hallucinations/growl2.ogg',
				'sound/hallucinations/growl3.ogg',
				'sound/hallucinations/im_here1.ogg',
				'sound/hallucinations/im_here2.ogg',
				'sound/hallucinations/i_see_you1.ogg',
				'sound/hallucinations/i_see_you2.ogg',
				'sound/hallucinations/look_up1.ogg',
				'sound/hallucinations/look_up2.ogg',
				'sound/hallucinations/over_here1.ogg',
				'sound/hallucinations/over_here2.ogg',
				'sound/hallucinations/over_here3.ogg',
				'sound/hallucinations/turn_around1.ogg',
				'sound/hallucinations/turn_around2.ogg',
				'sound/hallucinations/veryfar_noise.ogg',
				'sound/hallucinations/wail.ogg')

/datum/hallucination/sound/reaction
	min_power = 20

/datum/hallucination/sound/reaction/start()
	world << "Called: Sound with reaction."
	switch(rand(1,3))
		if(1) //Nearmiss
			sound_to(holder, 'sound/weapons/gunshot/gunshot_light.ogg')
			to_chat(holder, span("danger", "Something zips by your head, barely missing you!")) //phantom reflex to audio
			shake_camera(holder, 3, 1)

		if(2) //Gunshot
			sound_to(holder, 'sound/weapons/gunshot/gunshot1.ogg')
			if(ishuman(holder))
				var/mob/living/carbon/human/H = holder
				to_chat(holder, span("danger", "You feel a sharp pain in your [LAZYPICK(H.organs, "chest")]!")) //phantom pain reaction to audio
			holder.adjustHalLoss(15)
			shake_camera(holder, 3, 1)
			if(prob(holder.hallucination))
				holder.eye_blurry += 8

		if(3) //Don't tase me bro
			sound_to(holder, 'sound/weapons/Taser.ogg')
			to_chat(holder, span("danger", "You feel numb as a shock courses through your body!")) //phantom pain reaction to audio
			holder.adjustHalLoss(20)
			if(prob(holder.hallucination))
				holder.eye_blind += 3




/datum/hallucination/colorblind
	min_power = 30
	duration = 100
	allow_duplicates = FALSE
	var/datum/client_color/colorblindness

/datum/hallucination/colorblind/can_affect(mob/living/carbon/C)
	var/datum/client_color/D
	if(locate(D in C.client_colors))		//if they're already colorblind, we bail.
		world << "Called: CBLIND cannot affect due to client colors"
		return FALSE
	return ..()

/datum/hallucination/colorblind/start()
	duration = rand(100, 200)
	colorblindness = pick("/datum/client_color/deuteranopia", "/datum/client_color/protanopia", "/datum/client_color/tritanopia", "/datum/client_color/monochrome")
	holder.add_client_color(colorblindness)
	world << "Called: Colorblind with colorblindness = [colorblindness]"

/datum/hallucination/colorblind/end()
	world << "Called: Colorblind End"
	holder.remove_client_color(colorblindness)
	..()




/datum/hallucination/fakeattack			//imagining someone hits you.
	min_power = 30

/datum/hallucination/fakeattack/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C,1))
		return TRUE

/datum/hallucination/fakeattack/start()
	var/list/attacker_candidates = list()
	for(var/mob/living/M in oview(holder,1))
		if(!M.stat)
			attacker_candidates += M
	var/attacker = pick(attacker_candidates)
	attacker_candidates -= attacker
	if(prob(50))
		to_chat(holder, span("danger", "[attacker] has hit [holder]!"))
		sound_to(holder, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
	else
		to_chat(holder, span("danger", "[attacker] attempted to shove [holder]!"))
		sound_to(holder, 'sound/weapons/thudswoosh.ogg')

	//If we are hallucinating particularly hard and there's another person adjacent to us, we imagine they attack us, too.
	if(holder.hallucination >= 70 && attacker_candidates.len)
		attacker = pick(attacker_candidates)
		if(prob(50))
			to_chat(holder, span("danger", "[attacker] has hit [holder]!"))
			sound_to(holder, pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
		else
			to_chat(holder, span("danger", "[attacker] attempted to shove [holder]!"))
			sound_to(holder, 'sound/weapons/thudswoosh.ogg')


/////////////////////////////////////////////
/////	    	 MIRAGES		/////
/////////////////////////////////////////////

/datum/hallucination/mirage
	duration = 120
	var/number = 3
	var/list/mirages = list()

/datum/hallucination/mirage/start()
	world << "Called: Mirage Start"
	var/list/possible_points = list()
	for(var/turf/simulated/floor/F in view(holder, world.view+1))
		possible_points += F
	if(possible_points.len)
		for(var/i = 1; i <= number; i++)
			var/image/thing = generate_mirage()
			mirages += thing
			thing.loc = pick(possible_points)
		holder.client.images += mirages
	else
		world << "No mirage possible points.len"

/datum/hallucination/mirage/Destroy()
	if(holder.client)
		holder.client.images -= mirages
	. = ..()

/datum/hallucination/mirage/proc/generate_mirage()
	var/icon/T = new('icons/obj/trash.dmi')
	return image(T, pick(T.IconStates()), layer = OBJ_LAYER)

/datum/hallucination/mirage/end()
	world << "Called: Mirage End"
	if(holder.client)
		holder.client.images -= mirages
	..()


/datum/hallucination/mirage/horror
	min_power = 70
	number = 1

/datum/hallucination/mirage/horror/generate_mirage()
	world << "Called Mirage Horror"
	var/icon/T = new('icons/mob/npc/animal.dmi')
	return image(T, pick("abomination", "lesser_ling", "faithless", "shark", "otherthing"), layer = MOB_LAYER)

/datum/hallucination/mirage/carnage
	min_power = 50
	number = 10

/datum/hallucination/mirage/carnage/start()
	if(holder.hallucination >= 100)				//Heavily hallucinating will increase the amount of horrific carnage we witness
		number = 20
		world << "Carnage changed to 20"
	..()

/datum/hallucination/mirage/carnage/generate_mirage()
	if(prob(50))
		var/image/I = image('icons/effects/blood.dmi', pick("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7"), layer = TURF_LAYER)
		I.color = pick("#1D2CBF", "#E6E600", "#A10808", "#A10808", "#A10808")	//skrell, vaurca, human. most likely to pick regular red
		return I
	else
		var/image/I = image('icons/obj/ammo.dmi', "s-casing-spent", layer = OBJ_LAYER)
		I.layer = TURF_LAYER
		I.dir = pick(alldirs)
		I.pixel_x = rand(-10,10)
		I.pixel_y = rand(-10,10)
		return I

/datum/hallucination/mirage/anomaly
	min_power = 40
	number = 1

/datum/hallucination/mirage/anomaly/start()
	..()
	to_chat(holder, span("warning", "With a small crackle, the [pick("entity", "idol", "device")] manifests!"))
	sound_to(holder, 'sound/effects/stealthoff.ogg')

/datum/hallucination/mirage/anomaly/generate_mirage()
	world << "Generated anomaly"
	var/istate = pick("ano01", "ano11", "ano21", "ano31", "ano41", "ano81", "ano121")
	var/image/I = image('icons/obj/xenoarchaeology.dmi', istate, layer = OBJ_LAYER)
	return I

/datum/hallucination/mirage/anomaly/end()
	to_chat(holder, span("warning", "With a loud zap, the [pick("entity", "idol", "device")] is sucked through a rift in bluespace!"))
	sound_to(holder, 'sound/effects/phasein.ogg')
	..()

/datum/hallucination/mirage/viscerator
	min_power = 50
	number = 3

/datum/hallucination/mirage/viscerator/start()
	addtimer(CALLBACK(src, .proc/buzz), rand(30, 60))
	..()

/datum/hallucination/mirage/viscerator/generate_mirage()
	var/image/I = image('icons/mob/npc/aibots.dmi', "viscerator_attack", layer = OBJ_LAYER)
	return I

/datum/hallucination/mirage/viscerator/proc/buzz()
	to_chat(holder, "The viscerator buzzes at [holder].")



/////////////////////////////////////////////
/////	PEOPLE TALKING ABOUT OR TO YOU	/////
/////////////////////////////////////////////

/datum/hallucination/talking/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C))
		if(!M.stat)
			return TRUE

/datum/hallucination/talking
	var/repeats = 2		//In total, we'll get three messages. We don't need to reset this number anywhere because on end() it's deleted and a new one will be created if it's chosen again in handle_hallucinations

/datum/hallucination/talking/activate()		//Unique since we are not adding the end() callback in activate(); we're handling it in start() since it can loop
	world << "Called: Talking activate"
	if(!holder || !holder.client)
		return
	holder.hallucinations += src
	start()

/datum/hallucination/talking/start()
	if(!can_affect(holder) || !holder || !repeats)	//sanity check
		end()
	world << "Called: Talking START"
	var/list/candidates = list()
	for(var/mob/living/carbon/human/M in oview(holder))
		if(!M.stat)
			candidates += M
			world << "Called: Talking Candidates + [M]"
	if(holder.hallucination >= 100)				//If you're super fucked up you'll imagine more than just humans talking about you
		for(var/mob/living/L in oview(holder))
			if(!ishuman(L))
				candidates += L
	if(!candidates.len)
		world << "No candidates for talker. Ending"
		end()
	var/talker = pick(candidates)
	var/message
	if(prob(80))
		world << "Called: Talking prob80 WORDS"
		var/list/names = list()
		var/lastname = copytext(holder.real_name, findtext(holder.real_name, " ")+1)
		var/firstname = copytext(holder.real_name, 1, findtext(holder.real_name, " "))
		if(lastname)
			names += lastname
		if(firstname)
			names += firstname
		if(!names.len)
			names += holder.real_name

		//////Setting up messages//////
		var/add = prob(20) ? ", [pick(names)]" : ""		//Accompanies phrases list. Chance to add the first or last name to the phrase for variation
		var/list/phrases = list("Get out[add]!","Go away[add].","What are you doing[add]?","Where's your ID[add]?", "You know I love you[add].", "You do great work[add]!")
		if(holder.hallucination > 50)
			phrases += list("What did you come here for[add]?","Don't touch me[add].","You're not getting out of here[add].", "You're a failure, [pick(names)].","Just kill yourself already, [pick(names)].","Put on some clothes[add].","You're a horrible person[add].","You know nobody wants you here, right[add]?")

		var/speak_prefix = prob(50) ? "[pick("Hey", "Uh", "Um", "Oh", "Ah")], " : ""	//Separate from list/phrases. Possibly chooses a generic greeting...
		speak_prefix = "[speak_prefix][pick(names)][pick(".","!","?")]"					//...then adds the name, and ends it randomly with ., !, or ? ("Hey, name?" "Oh, name?") etc.
		//////Choosing the message//////
		if(prob(30))
			world << "Called: Talking 30prob PHRASES"
			message = pick(phrases)		//Less variation in phrases, so less chance to pick them.
		else
			world << "Called: Talking HAL_SPEAK"
			message = prob(70) ? "[speak_prefix] [pick(hallucinated_phrases)]" : "[pick(hallucinated_phrases)]"	//Don't always apply the speak_prefix. Sometimes they just need to say weird shit in general.

		//////Sending the message//////
		to_chat(holder,"<span class='game say'><span class='name'>[talker]</span> [holder.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>")
	else
		world << "Called: Talking prob20 NONVERBAL"
		to_chat(holder,"<B>[talker]</B> [pick("points", "looks", "stares", "smirks")] at [holder.name]")
		to_chat(holder,"<span class='game say'><span class='name'>[talker]</span> says something softly.</span>")
	repeats -= 1
	if(repeats)
		world << "Talking Repeating"
		addtimer(CALLBACK(src, .proc/start), rand(50, 100))
	else
		end()



/datum/hallucination/whisper			//Thinking people are whispering messages to you.
/datum/hallucination/whisper/can_affect(mob/living/carbon/C)
	if(!..())
		return FALSE
	for(var/mob/living/M in oview(C, 1))
		if(!M.stat)
			return TRUE

/datum/hallucination/whisper/start()
	world << "Called: Whisper start"
	var/list/whisper_candidates = list()
	for(var/mob/living/M in oview(holder, 1))
		if(!M.stat)
			whisper_candidates += M
		world << "added [M] to candidates"
	if(!whisper_candidates.len)
		world << "No candidates for whisper"
		return
	var/whisperer = pick(whisper_candidates)
	if(prob(70))
		to_chat(holder, "<B>[whisperer]</B> whispers, <I>\"[pick(hallucinated_phrases)]\"</I>")
	else
		to_chat(holder, "<B>[whisperer]</B> [pick("gently nudges", "pokes at", "taps", "looks at", "pats")] [holder], trying to get their attention.")


/////////////////////////////////////////////
/////	 	  FAKE POWERS		/////
/////////////////////////////////////////////

//Mind reading. Put as a verb for now but consider a fake psi UI later.

/datum/hallucination/mindread
	allow_duplicates = FALSE
	min_power = 50

/datum/hallucination/mindread/can_affect(mob/living/carbon/C)	//Don't give it to people who already have psi powers
	if(C.psi)
		world << "[src] cannot affect due to psi"
		return FALSE
	return ..()

/datum/hallucination/mindread/start()
	duration = rand(2, 4) MINUTES
	world << "Called: MINDREAD start"
	to_chat(holder, span("notice", "<B><font size = 3>You have developed a psionic gift!</font></B>"))
	to_chat(holder, span("notice", "You can feel your mind surging with power! Check the abilities tab to use your new power!"))
	holder.verbs += /mob/living/carbon/human/verb/fakemindread

/datum/hallucination/mindread/end()
	world << "Called: MINDREAD end"
	if(holder)
		holder.verbs -= /mob/living/carbon/human/verb/fakemindread
		to_chat(holder, span("notice", "<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
		holder.drowsyness += 5
		world << "Called: MINDREAD remove verb"
	..()

/mob/living/carbon/human/verb/fakemindread()
	set name = "Read Mind"
	set category = "Abilities"

	if(!hallucination)
		src.verbs -= /mob/living/carbon/human/verb/fakemindread
		return

	if(stat)
		to_chat(usr, span("warning", "You're not in any state to use your powers right now!"))
		return

	var/list/creatures = list()
	for(var/mob/living/C in oview(usr))
		creatures += C
	creatures -= usr
	var/mob/target = input("Whose mind do you wish to probe?") as null|anything in creatures
	if(target.stat)
		to_chat(usr, span("warning", "\The [target]'s mind is not in any state to be probed!"))
	if(isnull(target))
		return

	to_chat(usr, span("notice", "<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking a prominent thought.</b>"))
	if(do_after(usr, 30))
		sleep(rand(50, 120))
		to_chat(usr, span("notice", "<b>You skim thoughts from the surface of \the [target]'s mind: \"<i>[pick(hallucinated_phrases)]</i>\"</b>"))
	else
		to_chat(usr, span("warning", "You need to stay still to focus your energy!"))
	for(var/mob/living/carbon/human/M in oviewers(src))
		to_chat(M, "<B>[usr]</B> puts [usr.get_pronoun(1)] hands to [usr.get_pronoun(1)] head and mumbles incoherently as they stare, unblinking, at \the [target].")