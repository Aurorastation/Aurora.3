var/list/datum/gender/gender_datums = list()

/hook/startup/proc/populate_gender_datum_list()
	for(var/type in typesof(/datum/gender))
		var/datum/gender/G = new type
		gender_datums[G.key] = G
	return 1

/datum/gender
	var/key  = "plural"

	var/He   = "They"
	var/he   = "they"
	var/His  = "Their"
	var/his  = "their"
	var/hers = "theirs" // used to disambiguate between possessive pronouns and possessive adjectives
	var/Hers = "Theirs"
	var/him  = "them"
	var/has  = "have"
	var/is   = "are"
	var/does = "do"
	var/himself = "themselves"
	var/end = ""

/datum/gender/male
	key  = "male"

	He   = "He"
	he   = "he"
	His  = "His"
	his  = "his"
	hers = "his"
	Hers = "His"
	him  = "him"
	has  = "has"
	is   = "is"
	does = "does"
	himself = "himself"
	end = "s"

/datum/gender/female
	key  = "female"

	He   = "She"
	he   = "she"
	His  = "Her"
	his  = "her"
	hers = "hers"
	Hers = "Hers"
	him  = "her"
	has  = "has"
	is   = "is"
	does = "does"
	himself = "herself"
	end = "s"

/datum/gender/neuter
	key = "neuter"

	He   = "It"
	he   = "it"
	His  = "Its"
	his  = "its"
	hers = "its"
	Hers = "its"
	him  = "it"
	has  = "has"
	is   = "is"
	does = "does"
	himself = "itself"
	end = "s"

/atom/proc/get_gender() // This is on /atom/ for compatibility reasons, e.g. for emotes to not have to typecheck.
	return gender

/atom/proc/get_pronoun(var/wordtype)
	var/gender_to_use = get_gender()
	return gender_datums[gender_to_use][wordtype]