/datum/language/ling
	name = LANGUAGE_CHANGELING
	desc = "Although they are normally wary and suspicious of each other, changelings can commune over a distance."
	speech_verb = list("says")
	sing_verb = list("choruses")
	colour = "changeling"
	key = "g"
	flags = RESTRICTED | HIVEMIND

/datum/language/ling/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	if(speaker.mind)
		var/datum/changeling/changeling = speaker.mind.antag_datums[MODE_CHANGELING]
		if(changeling)
			..(speaker,message, changeling.changelingID)
			return
	..(speaker,message)

/datum/language/corticalborer
	name = LANGUAGE_BORER
	desc = "A language Cortical Borers use to influence the minds of those nearby, or those they infest."
	speech_verb = list("sings")
	ask_verb = list("sings")
	exclaim_verb = list("sings")
	colour = "alien"
	key = "v"
	flags = RESTRICTED

/datum/language/corticalborer/hivemind
	name = LANGUAGE_BORER_HIVEMIND
	desc = "Cortical Borers possess a strange link between their tiny minds, allowing them to communicate telepathically."
	key = "x"
	flags = RESTRICTED | HIVEMIND

/datum/language/corticalborer/hivemind/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	var/mob/living/simple_animal/borer/B

	if(istype(speaker, /mob/living/carbon))
		var/mob/living/carbon/M = speaker
		B = M.has_brain_worms()
	else if(istype(speaker, /mob/living/simple_animal/borer))
		B = speaker

	if(B)
		speaker_mask = B.truename
	..(speaker, message, speaker_mask)

/datum/language/cultcommon
	name = LANGUAGE_CULT
	desc = "The chants of the occult, the incomprehensible."
	speech_verb = list("intones")
	ask_verb = list("intones")
	exclaim_verb = list("chants")
	sing_verb = list("chants")
	colour = "cult"
	key = "f"
	flags = RESTRICTED
	space_chance = 100
	syllables = list("ire","ego","nahlizet","certum","veri","jatkaa","mgar","balaq", "karazet", "geeri", \
		"orkan", "allaq", "sas'so", "c'arta", "forbici", "tarem", "n'ath", "reth", "sh'yro", "eth", "d'raggathnor", \
		"mah'weyh", "pleggh", "at", "e'ntrath", "tok-lyr", "rqa'nap", "g'lt-ulotf", "ta'gh", "fara'qha", "fel", "d'amar det", \
		"yu'gular", "faras", "desdae", "havas", "mithum", "javara", "umathar", "uf'kal", "thenar", "rash'tla", \
		"sektath", "mal'zua", "zasan", "therium", "viortia", "kla'atu", "barada", "nikt'o", "fwe'sh", "mah", "erl", "nyag", "r'ya", \
		"gal'h'rfikk", "harfrandid", "mud'gib", "fuu", "ma'jin", "dedo", "ol'btoh", "n'ath", "reth", "sh'yro", "eth", \
		"d'rekkathnor", "khari'd", "gual'te", "nikka", "nikt'o", "barada", "kla'atu", "barhah", "hra" ,"zar'garis")
	machine_understands = FALSE

/datum/language/cultcommon/get_random_name()
	var/new_name = "[pick(list("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged"))]"
	new_name += "[pick(list(" "))]"
	new_name += "[pick(list("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Skeleton", "Visitant", "Wraith"))]"
	return new_name

/datum/language/cult
	name = LANGUAGE_OCCULT
	desc = "The initiated can share their thoughts by means defying all reason."
	speech_verb = list("intones")
	ask_verb = list("intones")
	exclaim_verb = list("chants")
	sing_verb = list("chants")
	colour = "cult"
	key = "y"
	flags = RESTRICTED | HIVEMIND

/datum/language/terminator
	name = LANGUAGE_TERMINATOR
	desc = "A heavily encrypted communication network that piggybacks off of the state telecomms relays to covertly link Hephaestus black ops droids to their control AIs."
	speech_verb = list("buzzes")
	ask_verb = list("buzzes")
	exclaim_verb = list("buzzes")
	sing_verb = list("buzzes")
	colour = "bad"
	key = "hd"
	flags = RESTRICTED | HIVEMIND
	syllables = list("beep","beep","beep","beep","beep","boop","boop","boop","bop","bop","dee","dee","doo","doo","hiss","hss","buzz","buzz","bzz","ksssh","keey","wurr","wahh","tzzz")
	space_chance = 10

/datum/language/terminator/get_random_name()
	return "HK [pick(list("Hera","Zeus","Artemis","Athena","Ares","Hades","Poseidon","Demeter","Apollo","Aphrodite","Hermes","Hestia","Dionysus","Persephone","Kronos","Odysseus","Ajax","Agamemnon","Chiron","Charon"))]-[rand(100, 999)]"

/datum/language/revenant
	name = LANGUAGE_REVENANT
	desc = "The language of the forsaken bluespace inhabitants."
	speech_verb = list("gargles")
	ask_verb = list("gags")
	exclaim_verb = list("retches")
	sing_verb = list("trills")
	colour = "revenant"
	key = "c"
	syllables = list("grhhg", "ghrohg", "grgugh", "grrhh", "hghh", "rghghh", "gghhh", "ggrh", "aghrh")
	flags = RESTRICTED
	partial_understanding = list(LANGUAGE_TCB = 80)
	always_parse_language = TRUE

/datum/language/revenant/hivemind
	name = LANGUAGE_REVENANT_RIFTSPEAK
	desc = "A manner of speaking that allows revenants to talk to eachother no matter the distance."
	key = "rs"
	flags = RESTRICTED | HIVEMIND