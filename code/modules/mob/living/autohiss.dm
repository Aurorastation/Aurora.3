
#define AUTOHISS_OFF 0
#define AUTOHISS_BASIC 1
#define AUTOHISS_FULL 2

#define AUTOHISS_NUM 3

/mob/living/proc/handle_autohiss(message, datum/language/L)
	return message // no autohiss at this level

/mob/living/carbon/human/handle_autohiss(message, datum/language/L)
	if(!client || client.autohiss_mode == AUTOHISS_OFF) // no need to process if there's no client or they have autohiss off
		return message
	return species.handle_autohiss(message, L, client.autohiss_mode)

/client
	var/autohiss_mode = AUTOHISS_OFF

/client/verb/toggle_autohiss()
	set name = "Toggle Auto-Hiss"
	set desc = "Toggle automatic hissing as Unathi, r-rolling as Taj, and buzzing as Vaurca"
	set category = "OOC"

	autohiss_mode = (autohiss_mode + 1) % AUTOHISS_NUM
	switch(autohiss_mode)
		if(AUTOHISS_OFF)
			src << "Auto-hiss is now OFF."
		if(AUTOHISS_BASIC)
			src << "Auto-hiss is now BASIC."
		if(AUTOHISS_FULL)
			src << "Auto-hiss is now FULL."
		else
			soft_assert(0, "invalid autohiss value [autohiss_mode]")
			autohiss_mode = AUTOHISS_OFF
			src << "Auto-hiss is now OFF."

/datum/species
	var/list/autohiss_basic_map = null
	var/list/autohiss_extra_map = null
	var/list/autohiss_exempt = null
	var/list/autohiss_basic_extend = null
	var/list/autohiss_extra_extend = null
	var/autohiss_extender = "..."

/datum/species/unathi
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		)
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		)
	autohiss_exempt = list(
			LANGUAGE_UNATHI,
			LANGUAGE_AZAZIBA
		)

/datum/species/tajaran
	autohiss_basic_map = list(
			"r" = list("rr", "rrr", "rrrr")
		)
	autohiss_exempt = list(
			LANGUAGE_SIIK_MAAS,
			LANGUAGE_SIIK_TAJR,
			LANGUAGE_SIGN_TAJARA,
			LANGUAGE_YA_SSA,
			LANGUAGE_DELVAHII
		)

/datum/species/bug
	autohiss_basic_map = list(
			"s" = list("z","zz")
		)
	autohiss_extra_map = list(
			"f" = list("v", "vh"),
			"ph" = list("v", "vh")
		)
	autohiss_exempt = list(LANGUAGE_VAURCA)

/datum/species/bug/type_b
	autohiss_basic_map = list(
			"s" = list("z","zz", "zzz")
		)
	autohiss_extra_map = list(
			"f" = list("v", "vh"),
			"ph" = list("v", "vh")
		)
	autohiss_exempt = list(LANGUAGE_VAURCA)

/datum/species/diona

	autohiss_basic_extend = list("who","what","when","where","why","how")
	autohiss_extra_extend = list("i'm","i","am","this","they","are","they're","their","his","her","their","the","he","she")
	autohiss_extender = "..."

	autohiss_basic_map = list(
			"s" = list("s","ss","sss"),
			"z" = list("z","zz","zzz"),
			"ee" = list("ee","eee")
		)
	autohiss_extra_map = list(
			"a" = list("a","aa", "aaa"),
			"i" = list("i","ii", "iii"),
			"o" = list("o","oo", "ooo"),
			"u" = list("u","uu", "uuu")
		)
	autohiss_exempt = list(
			LANGUAGE_ROOTSONG
		)

/datum/species/proc/handle_autohiss(message, datum/language/lang, mode)

	if(autohiss_exempt && (lang.name in autohiss_exempt))
		return message
	// No reason to auto-hiss in sign-language.
	if (lang.flags && (lang.flags & SIGNLANG))
		return message

	if(autohiss_extender && autohiss_basic_extend)
		var/longwords = autohiss_basic_extend.Copy()
		if(mode == AUTOHISS_FULL && autohiss_extra_extend)
			longwords |= autohiss_extra_extend

		var/list/returninglist = list()

		for(var/word in text2list(message," ")) // For each word in a message
			if (lowertext(word) in longwords)
				word += autohiss_extender
			returninglist += word
		message = returninglist.Join(" ")

	if (autohiss_basic_map)
		var/map = autohiss_basic_map.Copy()
		if(mode == AUTOHISS_FULL && autohiss_extra_map)
			map |= autohiss_extra_map

		. = list()

		while(length(message))
			var/min_index = 10000 // if the message is longer than this, the autohiss is the least of your problems
			var/min_char = null
			for(var/char in map)
				var/i = findtext(message, char)
				if(!i) // no more of this character anywhere in the string, don't even bother searching next time
					map -= char
				else if(i < min_index)
					min_index = i
					min_char = char
			if(!min_char) // we didn't find any of the mapping characters
				. += message
				break
			. += copytext(message, 1, min_index)
			if(copytext(message, min_index, min_index+1) == uppertext(min_char))
				switch(text2ascii(message, min_index+1))
					if(65 to 90) // A-Z, uppercase; uppercase R/S followed by another uppercase letter, uppercase the entire replacement string
						. += uppertext(pick(map[min_char]))
					else
						. += capitalize(pick(map[min_char]))
			else
				. += pick(map[min_char])
			message = copytext(message, min_index + 1)

	return jointext(., "")

#undef AUTOHISS_OFF
#undef AUTOHISS_BASIC
#undef AUTOHISS_FULL
#undef AUTOHISS_NUM
