
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
	var/self = "themselves"
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
	self = "himself"
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
	self = "herself"
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
	self = "itself"
	end = "s"
