/var/datum/controller/subsystem/hallucinations/SShallucinations

/datum/controller/subsystem/hallucinations
	name = "Hallucinations"
	flags = SS_NO_FIRE

	var/list/hallucinated_phrases = list()
	var/list/hallucinated_actions = list()
	var/list/hallucinated_thoughts = list()
	var/static/list/hal_emote = list("mutters quietly.", "stares.", "grunts.", "looks around.", "twitches.", "shivers.", "swats at the air.", "wobbles.", "gasps!", "blinks rapidly.", "murmurs.",
				"dry heaves!", "twitches violently.", "giggles.", "drools.", "scratches all over.", "grinds their teeth.", "whispers something quietly.")
	var/static/list/message_sender = list("Mom", "Dad", "Captain", "Captain(as Captain)", "help", "Home", "MaxBet Online Casino", "IDrist Corp", "Dr. Maxman",
			"www.wetskrell.nt", "You are our lucky grand prize winner!",  "Officer Beepsky", "Ginny", "Ian",
			"what have you DONE?", "Miranda Trasen", "Central Command", "AI", "maintenance drone", "Unknown", "I don't want to die")
	var/list/all_hallucinations = list()

/datum/controller/subsystem/hallucinations/New()
	NEW_SS_GLOBAL(SShallucinations)

/datum/controller/subsystem/hallucinations/Initialize()
	. = ..()
	for(var/T in subtypesof(/datum/hallucination/))
		all_hallucinations += T
	hallucinated_phrases = file2list("code/modules/hallucinations/text_lists/hallucinated_phrases.txt")
	hallucinated_actions = file2list("code/modules/hallucinations/text_lists/hallucinated_actions.txt")	//important note when adding to this file: "you" will always be replaced by the hallucinator's name
	hallucinated_thoughts = file2list("code/modules/hallucinations/text_lists/hallucinated_thoughts.txt")

/datum/controller/subsystem/hallucinations/proc/get_hallucination(var/mob/living/carbon/C)
	var/list/candidates = list()
	for(var/T in all_hallucinations)
		var/datum/hallucination/H = new T
		if(H.can_affect(C))
			candidates += H
	if(candidates.len)
		var/datum/hallucination/D = pick(candidates)
		return D