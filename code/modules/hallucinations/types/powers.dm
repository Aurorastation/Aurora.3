/datum/hallucination/mindread
	allow_duplicates = FALSE
	min_power = HAL_POWER_MED
	special_flags = NO_THOUGHT | NO_EMOTE

/datum/hallucination/mindread/can_affect(mob/living/carbon/C)
	if(C.psi)	//Don't give it to people who already have psi powers
		return FALSE
	if(locate(/datum/hallucination/telepathy) in C.hallucinations)
		return FALSE
	return ..()

/datum/hallucination/mindread/activate()
	..()
	addtimer(CALLBACK(src, .proc/mind_give), rand(30, 50))

//set duration, foreshadow powers
/datum/hallucination/mindread/start()
	duration = rand(2, 4) MINUTES
	switch(rand(1, 3))
		if(1)
			sound_to(holder, 'sound/misc/announcements/notice.ogg')
			to_chat(holder, "<h2 class='alert'>Ion Storm?</h2>")
			to_chat(holder, SPAN_ALERT("It has come to our attention that the station has passed through an unusual ion storm. Several crewmembers are exhibiting unusual abilities."))
		if(2)
			sound_to(holder, 'sound/hallucinations/behind_you1.ogg')
			to_chat(holder, SPAN_GOOD("You hear a whispering in your mind. A promise of [pick("power", "enlightenment", "sight beyond sight", "knowledge terrible but true")]. Your vision goes white for a moment; when it returns, you feel... different."))
			flick("e_flash", holder.flash)
		if(3)
			to_chat(holder, FONT_LARGE(SPAN_DANGER("You feel a sudden pain in your head, as if it's being ripped in two! When it subsides to a dull throbbing a moment later, you feel... different.")))
			holder.emote("me",1,"winces.")
			if(ishuman(holder))
				var/mob/living/carbon/human/H = holder
				var/obj/item/organ/external/O = H.get_organ(BP_HEAD)
				O.add_pain(25)

//grant powers
/datum/hallucination/mindread/proc/mind_give()
	to_chat(holder, SPAN_NOTICE(FONT_LARGE("<B>You have developed a psionic gift!</B>")))
	to_chat(holder, SPAN_NOTICE("You can feel your mind surging with power! Check the abilities tab to use your new power!"))
	holder.verbs += /mob/living/carbon/proc/fakemindread

/datum/hallucination/mindread/end()
	if(holder)
		holder.verbs -= /mob/living/carbon/proc/fakemindread
		to_chat(holder, SPAN_NOTICE("<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
	..()

/mob/living/carbon/proc/fakemindread()
	set name = "Read Mind"
	set category = "Abilities"

	if(!hallucination)
		for(var/datum/hallucination/mindread/H in hallucinations)
			H.end()
		return

	if(use_check_and_message(usr))
		to_chat(usr, SPAN_WARNING("You're not in any state to use your powers right now!"))
		return

	if(chem_effects[CE_HALLUCINATE] < 0)
		to_chat(usr, SPAN_WARNING("Chemicals in your blood are disrupting your powers!"))
		return

	var/list/creatures = list()
	for(var/mob/living/C in oview(usr))
		creatures += C
	if(!creatures.len)
		return

	var/mob/target = input("Whose mind do you wish to probe?") as null|anything in creatures
	if(!target)
		return
	if(target.stat)
		to_chat(usr, SPAN_WARNING("\The [target]'s mind is not in any state to be probed!"))
		return

	to_chat(usr, SPAN_NOTICE("<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking a prominent thought.</b>"))
	if(do_after(usr, 30))
		sleep(rand(50, 120))
		usr.visible_message("<B>[usr]</B> puts [usr.get_pronoun(1)] hands to [usr.get_pronoun(1)] head and mumbles incoherently as they stare, unblinking, at \the [target].",
						SPAN_NOTICE("<b>You skim thoughts from the surface of \the [target]'s mind: \"<i>[pick(SShallucinations.hallucinated_phrases)]</i>\"</b>"))
	else
		to_chat(usr, SPAN_WARNING("You need to stay still to focus your energy!"))


//Fake telepathy, inspired by and mostly ported from Bay's
/datum/hallucination/telepathy
	min_power = HAL_POWER_HIGH
	allow_duplicates = FALSE
	special_flags = NO_THOUGHT | NO_EMOTE

/datum/hallucination/telepathy/can_affect(mob/living/carbon/C)
	if(C.psi)	//Don't give it to people who already have psi powers
		return FALSE
	if(locate(/datum/hallucination/mindread) in C.hallucinations)
		return FALSE
	return ..()

/datum/hallucination/telepathy/activate()
	..()
	addtimer(CALLBACK(src, .proc/tele_give), rand(30, 50))

/datum/hallucination/telepathy/start()
	duration = rand(2, 4) MINUTES
	switch(rand(1, 3))
		if(1)
			sound_to(holder, 'sound/misc/announcements/notice.ogg')
			to_chat(holder, "<h2 class='alert'>Ion Storm?</h2>")
			to_chat(holder, SPAN_ALERT("It has come to our attention that the station has passed through an unusual ion storm. Several crewmembers are exhibiting unusual abilities."))
		if(2)
			sound_to(holder, 'sound/hallucinations/behind_you1.ogg')
			to_chat(holder, SPAN_GOOD("You hear a whispering in your mind. A promise of [pick("power", "enlightenment", "sight beyond sight", "knowledge terrible but true")]. Your vision goes white for a moment; when it returns, you feel... different."))
			flick("e_flash", holder.flash)
		if(3)
			to_chat(holder, FONT_LARGE(SPAN_DANGER("You feel a sudden pain in your head, as if it's being ripped in two! When it subsides to a dull throbbing a moment later, you feel... different.")))
			holder.emote("me",1,"winces.")
			if(ishuman(holder))
				var/mob/living/carbon/human/H = holder
				var/obj/item/organ/external/O = H.get_organ(BP_HEAD)
				O.add_pain(25)

//grant powers
/datum/hallucination/telepathy/proc/tele_give()
	to_chat(holder, SPAN_NOTICE(FONT_LARGE("<B>You have developed a psionic gift!</B>")))
	to_chat(holder, SPAN_NOTICE("You can feel your mind surging with power! Check the abilities tab to use your new power!"))
	holder.verbs += /mob/living/carbon/proc/faketelepathy

/datum/hallucination/telepathy/end()
	if(holder)
		holder.verbs -= /mob/living/carbon/proc/faketelepathy
		to_chat(holder, SPAN_NOTICE("<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
	..()


/mob/living/carbon/proc/faketelepathy()
	set name = "Send Telepathic Message"
	set category = "Abilities"

	if(!hallucination)
		for(var/datum/hallucination/telepathy/H in hallucinations)
			H.end()
		return

	if(use_check_and_message(usr))
		to_chat(usr, SPAN_WARNING("You're not in any state to use your powers right now!"))
		return

	if(chem_effects[CE_HALLUCINATE] < 0)
		to_chat(usr, SPAN_WARNING("Chemicals in your blood are disrupting your powers!"))
		return

	var/list/creatures = list()
	for(var/mob/living/C in oview(usr))
		creatures += C
	if(!creatures.len)
		return
	var/mob/target = input("Who do you wish to send a message to?") as null|anything in creatures
	if(!target)
		return
	if(target.stat)
		to_chat(usr, SPAN_WARNING("\The [target]'s mind is not in any state to receive messages!"))
		return

	var/message = sanitizeSafe(input("Enter your message."), MAX_MESSAGE_LEN)
	if(!message)
		return

	to_chat(usr, SPAN_NOTICE("<b>You focus your mental energy and begin projecting your message into the mind of \the [target]...</b>"))

	if(do_after(usr, 30))
		usr.visible_message("<span class='game say'><span class='name'>[usr]</span> [usr.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>",
					SPAN_NOTICE("<b>You feel your message enter \the [target]'s mind!</b>"))
	else
		to_chat(usr, SPAN_WARNING("You need to stay still to focus your efforts!"))