/datum/hallucination/mindread
	allow_duplicates = FALSE
	min_power = 50
	special_flags = NO_THOUGHT | NO_EMOTE

/datum/hallucination/mindread/can_affect(mob/living/carbon/C)	//Don't give it to people who already have psi powers
	if(C.psi)
		return FALSE
	return ..()

/datum/hallucination/mindread/start()
	duration = rand(2, 4) MINUTES
	to_chat(holder, SPAN_NOTICE(FONT_LARGE("<B>You have developed a psionic gift!</B>")))
	to_chat(holder, SPAN_NOTICE("You can feel your mind surging with power! Check the abilities tab to use your new power!"))
	holder.verbs += /mob/living/carbon/human/verb/fakemindread

/datum/hallucination/mindread/end()
	if(holder)
		holder.verbs -= /mob/living/carbon/human/verb/fakemindread
		to_chat(holder, SPAN_NOTICE("<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
		holder.drowsyness += 12
	..()

/mob/living/carbon/human/verb/fakemindread()
	set name = "Read Mind"
	set category = "Abilities"

	if(!hallucination)
		for(var/datum/hallucination/mindread/H in hallucinations)
			H.end()
		return

	if(stat)
		to_chat(usr, SPAN_WARNING("You're not in any state to use your powers right now!"))
		return

	var/list/creatures = list()
	for(var/mob/living/C in oview(usr))
		creatures += C
	creatures -= usr
	if(!creatures.len)
		return

	var/mob/target = input("Whose mind do you wish to probe?") as null|anything in creatures
	if(isnull(target))
		return
	if(target.stat)
		to_chat(usr, SPAN_WARNING("\The [target]'s mind is not in any state to be probed!"))
		return

	to_chat(usr, SPAN_NOTICE("<b>You dip your mentality into the surface layer of \the [target]'s mind, seeking a prominent thought.</b>"))
	if(do_after(usr, 30))
		sleep(rand(50, 120))
		to_chat(usr, SPAN_NOTICE("<b>You skim thoughts from the surface of \the [target]'s mind: \"<i>[pick(SShallucinations.hallucinated_phrases)]</i>\"</b>"))
		for(var/mob/living/carbon/human/M in oviewers(src))
			to_chat(M, "<B>[usr]</B> puts [usr.get_pronoun(1)] hands to [usr.get_pronoun(1)] head and mumbles incoherently as they stare, unblinking, at \the [target].")
	else
		to_chat(usr, SPAN_WARNING("You need to stay still to focus your energy!"))


//Fake telepathy, inspired by and mostly ported from Bay's
/datum/hallucination/telepathy
	min_power = 75
	allow_duplicates = FALSE
	special_flags = NO_THOUGHT | NO_EMOTE

/datum/hallucination/telepathy/can_affect(mob/living/carbon/C)	//Don't give it to people who already have psi powers
	if(C.psi)
		return FALSE
	return ..()


/datum/hallucination/telepathy/start()
	duration = rand(2, 4) MINUTES
	to_chat(holder, SPAN_NOTICE(FONT_LARGE("<B>You have developed a psionic gift!</B>")))
	to_chat(holder, SPAN_NOTICE("You can feel your mind surging with power! Check the abilities tab to use your new power!"))
	holder.verbs += /mob/living/carbon/human/verb/faketelepathy

/datum/hallucination/telepathy/end()
	if(holder)
		holder.verbs -= /mob/living/carbon/human/verb/faketelepathy
		to_chat(holder, SPAN_NOTICE("<b>Your psionic powers vanish abruptly, leaving you cold and empty.</b>"))
		holder.drowsyness += 12
	..()


/mob/living/carbon/human/verb/faketelepathy()
	set name = "Send Telepathic Message"
	set category = "Abilities"

	if(!hallucination)
		for(var/datum/hallucination/telepathy/H in hallucinations)
			H.end()
		return

	if(stat)
		to_chat(usr, SPAN_WARNING("You're not in any state to use your powers right now!"))
		return

	var/list/creatures = list()
	for(var/mob/living/C in oview(usr))
		creatures += C
	creatures -= usr
	if(!creatures.len)
		return
	var/mob/target = input("Who do you wish to send a message to?") as null|anything in creatures
	if(isnull(target))
		return
	if(target.stat)
		to_chat(usr, SPAN_WARNING("\The [target]'s mind is not in any state to receive messages!"))
		return

	var/message = sanitizeSafe(input("Enter your message."), MAX_MESSAGE_LEN)
	if(!message)
		return

	to_chat(usr, SPAN_NOTICE("<b>You focus your mental energy and begin projecting your message into the mind of \the [target]...</b>"))

	if(do_after(usr, 30))
		to_chat(usr, SPAN_NOTICE("<b>You feel your message enter \the [target]'s mind!</b>"))
		for(var/mob/living/carbon/human/M in oviewers(src))
			to_chat(M,"<span class='game say'><span class='name'>[usr]</span> [usr.say_quote(message)], <span class='message'><span class='body'>\"[message]\"</span></span></span>")
	else
		to_chat(usr, SPAN_WARNING("You need to stay still to focus your efforts!"))