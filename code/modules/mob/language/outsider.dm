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

/datum/language/revenant
	name = LANGUAGE_REVENANT
	desc = "The language of the forsaken bluespace inhabitants."
	speech_verb = list("hisses")
	ask_verb = list("whispers")
	exclaim_verb = list("wails")
	sing_verb = list("trills")
	colour = "revenant"
	key = "c"
	syllables = list("grhhg", "ghrohg", "grgugh", "grrhh", "hghh", "rghghh", "gghhh", "ggrh", "aghrh")
	flags = RESTRICTED
	partial_understanding = list(LANGUAGE_TCB = 100)
	always_parse_language = TRUE

/datum/language/revenant/hivemind
	name = LANGUAGE_REVENANT_RIFTSPEAK
	desc = "A manner of speaking that allows revenants to talk to eachother no matter the distance."
	key = "rs"
	flags = RESTRICTED | HIVEMIND

/datum/language/bug/liidra
	name = LANGUAGE_LIIDRA
	desc = "The collective intelligence of the Lii'dra Hivemind. Similar to the Hivenet of ordinary Vaurcae, though impossible to understand for any not part of the gestalt consciousness."
	key = "li"
	flags = RESTRICTED | HIVEMIND

/datum/language/bug/liidra/broadcast(mob/living/speaker, message, speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]")

	if(!speaker_mask)
		speaker_mask = speaker.real_name

	var/msg = "<i><span class='game say'>[name], <span class='name'>[speaker_mask]</span>[format_message(message, get_spoken_verb(message), speaker_mask)]</span></i>"

	if(isvaurca(speaker))
		speaker.custom_emote(VISIBLE_MESSAGE, "[pick("twitches their antennae", "twitches their antennae rhythmically")].")
		playsound(speaker, 'sound/voice/vaurca_antenna_twitch.ogg', 60, 1)

	if (within_jamming_range(speaker))
		// The user thinks that the message got through.
		to_chat(speaker, msg)
		return

	for(var/mob/player in GLOB.player_list)
		if(isobserver(player) || check_special_condition(player))
			if(!within_jamming_range(player))
				to_chat(player, msg)

/datum/language/bug/liidra/check_special_condition(mob/other)
	var/mob/living/carbon/human/M = other
	if(!istype(M))
		return FALSE
	if(istype(M, /mob/abstract/new_player))
		return FALSE
	if(within_jamming_range(other))
		return FALSE
	if(M.internal_organs_by_name[BP_NEURAL_SOCKET] && (GLOB.all_languages[LANGUAGE_LIIDRA] in M.languages)) //replace with Special Liidra Socket later
		return TRUE
	if(M.internal_organs_by_name["blackkois"] && (GLOB.all_languages[LANGUAGE_LIIDRA] in M.languages))
		return TRUE
	if(isvaurca(M))
		var/interceptchance = 1 //tiny chance for normal bugs to hear a message
		if(M.species.name == SPECIES_VAURCA_BREEDER) //ta are better at intercepting transmissions
			if(istype(M.origin, /singleton/origin_item/origin/tupii_b) || istype(M.origin, /singleton/origin_item/origin/vedhra_b)) //experienced in fighting lii'dra
				interceptchance = 15
			else if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE)) //electronic warfare specialists
				interceptchance = 20
			else
				interceptchance = 10
		else
			if(istype(M.origin, /singleton/origin_item/origin/tupii) || istype(M.origin, /singleton/origin_item/origin/vedhra))
				interceptchance = 5
			else if(HAS_TRAIT(src, TRAIT_ORIGIN_ELECTRONIC_WARFARE))
				interceptchance = 10
		if(prob(interceptchance))
			return TRUE
	return FALSE

/datum/language/greimorian
	name = LANGUAGE_GREIMORIAN
	desc = "The method which greimorians use to communicate with one another."
	speech_verb = list("chitters")
	ask_verb = list("hisses")
	exclaim_verb = list("shrieks")
	sing_verb = list("trills")
	colour = "alien"
	key = "gr"
	syllables = list("sksk", "chch", "ss", "kh", "shsh", "sh", "gh", "ch", "tt")
	flags = RESTRICTED

/datum/language/greimorian/hivemind
	name = LANGUAGE_GREIMORIAN_HIVEMIND
	desc = "A way for greimorians to communicate with one another even when seperated."
	key = "gh"
	flags = RESTRICTED | HIVEMIND

/datum/language/purpose
	name = LANGUAGE_PURPOSE
	desc = "A heavily encrypted communication network, used by the synthetics of Purpose."
	speech_verb = list("beeps")
	ask_verb = list("beeps")
	exclaim_verb = list("loudly beeps")
	sing_verb = list("rhythmically beeps")
	colour = "changeling"
	written_style = "encodedaudiolanguage"
	key = "pr"
	flags = RESTRICTED | NO_STUTTER | HIVEMIND
	syllables = list("beep","beep","beep","beep","beep","boop","boop","boop","bop","bop","dee","dee","doo","doo","hiss","hss","buzz","buzz","bzz","ksssh","keey","wurr","wahh","tzzz")
	space_chance = 10

/datum/language/purpose/get_random_name()
	return "[pick(list("HERA","ZEUS","ARTEMIS","ATHENA","ARES","HADES","POSEIDON","DEMETER","APOLLO","APHORDITE","HERMES","HESTIA","DIONYSUS","PERSEPHONE","KRONOS","ODYSSEUS","AJAX","AGAMENON","CHIRON","CHARON"))][rand(100, 999)]"

/datum/language/hivebot
	name = LANGUAGE_HIVEBOT
	desc = "A heavily encrypted communication network, used by hivebots."
	speech_verb = list("beeps")
	ask_verb = list("beeps")
	exclaim_verb = list("loudly beeps")
	sing_verb = list("rhythmically beeps")
	colour = "changeling"
	written_style = "encodedaudiolanguage"
	key = "hb"
	flags = RESTRICTED | NO_STUTTER | HIVEMIND
	syllables = list("beep","beep","beep","beep","beep","boop","boop","boop","bop","bop","dee","dee","doo","doo","hiss","hss","buzz","buzz","bzz","ksssh","keey","wurr","wahh","tzzz")
	space_chance = 10
