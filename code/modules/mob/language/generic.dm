// Noise "language", for audible emotes.
/datum/language/noise
	name = "Noise"
	desc = "Noises"
	key = ""
	flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER

/datum/language/noise/format_message(message, verb)
	return "<span class='message'><span class='[colour]'>[message]</span></span>"

/datum/language/noise/format_message_plain(message, verb)
	return message

/datum/language/noise/format_message_radio(message, verb)
	return "<span class='[colour]'>[message]</span>"

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

// 'basic' language; spoken by default.
/datum/language/common
	name = LANGUAGE_TCB
	desc = "A spiritual successor of Esperanto, established in 2404 in Tau Ceti by Ceti intellectuals. Its unique, fully customized alphabet and structure allow it to be spoken even by most alien species. It's the official language of Tau Ceti and has growing traction in diplomatic circles and Universalists across human space."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "0"
	flags = RESTRICTED
	syllables = list("blah","blah","blah","bleh","meh","neh","nah","wah")

//TODO flag certain languages to use the mob-type specific say_quote and then get rid of these.
/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

// Galactic common languages (systemwide accepted standards).
/datum/language/trader
	name = LANGUAGE_TRADEBAND
	desc = "Descended from latin and romance languages of old Earth, Tradeband remains the main tongue of the upper class of humanity. The language sounds elegant and well structured to most ears. It remains in popular use with traders, diplomats, and those seeking to hold onto a piece of a romantic past."
	speech_verb = "enunciates"
	colour = "say_quote"
	key = "2"
	space_chance = 100
	syllables = list("lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
					 "sed", "do", "eiusmod", "tempor", "incididunt", "ut", "labore", "et", "dolore",
					 "magna", "aliqua", "ut", "enim", "ad", "minim", "veniam", "quis", "nostrud",
					 "exercitation", "ullamco", "laboris", "nisi", "ut", "aliquip", "ex", "ea", "commodo",
					 "consequat", "duis", "aute", "irure", "dolor", "in", "reprehenderit", "in",
					 "voluptate", "velit", "esse", "cillum", "dolore", "eu", "fugiat", "nulla",
					 "pariatur", "excepteur", "sint", "occaecat", "cupidatat", "non", "proident", "sunt",
					 "in", "culpa", "qui", "officia", "deserunt", "mollit", "anim", "id", "est", "laborum")

// Criminal language.
/datum/language/gutter
	name = LANGUAGE_GUTTER
	desc = "A language of renegades and frontiersmen descending from various languages from Earth like Hindi combined into a multi-rooted jumble that sounds incoherent or even barbarian to non-native speakers. This language is the only common cultural identity for humans in the frontier. Speaking this language in itself boldly declares the speaker a free spirit. Often called 'Gutter' by Alliance citizens."
	speech_verb = "growls"
	colour = "rough"
	key = "3"
	syllables = list("slo","nik","ko","zels","het","zlo","nis","iv","da","ati","yib","ban","dup","sha","ansh","nou","nec","zby", "ci")

// Sign language
/datum/language/sign
	name = LANGUAGE_SIGN
	desc = "A signed version of Standard, though its intent is primarily to help out people who are deaf and mute, "
	speech_verb = "signs"
	signlang_verb = list("signs", "gestures")
	colour = "i"
	key = "4"
	flags = NO_STUTTER|SIGNLANG

// Helper
/proc/get_lang_name(var/datum/language/language)
	if (!language || !istype(language))
		return "Unknown"

	return language.name

/datum/language/aphasia
	name = LANGUAGE_GIBBERING
	desc = "It is theorized that any sufficiently brain-damaged person can speak this language."
	speech_verb = "garbles"
	ask_verb = "mumbles"
	whisper_verb = "mutters"
	exclaim_verb = "screams incoherently"
	key = "i"
	syllables = list("m","n","gh","h","l","s","r","a","e","i","o","u")
	space_chance = 20
	flags = RESTRICTED
