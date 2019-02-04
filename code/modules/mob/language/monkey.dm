/datum/language/human/monkey
	name = LANGUAGE_CHIMPANZEE
	desc = "Ook ook ook."
	speech_verb = "chimpers"
	ask_verb = "chimpers"
	exclaim_verb = "screeches"
	key = "6"
	machine_understands = FALSE

/datum/language/skrell/monkey
	name = LANGUAGE_NEAERA
	desc = "Squik squik squik."
	key = "8"
	machine_understands = FALSE

/datum/language/unathi/monkey
	name = LANGUAGE_STOK
	desc = "Hiss hiss hiss."
	key = "7"
	machine_understands = FALSE

/datum/language/tajaran/monkey
	name = LANGUAGE_FARWA
	desc = "Meow meow meow."
	key = "^"
	machine_understands = FALSE

/datum/language/bug/monkey
	name = LANGUAGE_BUG
	desc = "Buzz buzz buzz."
	key = "#"
	speech_verb = "chitters"
	ask_verb = "ponders"
	exclaim_verb = "buzzes"
	syllables = list("vaur","uyek","uyit","avek","sc'theth","k'ztak","teth","wre'ge","lii","dra'","zo'","ra'","k'lax'","zz","vh","ik","ak",
	"uhk","zir","sc'orth","sc'er","thc'yek","th'zirk","th'esk","k'ayek","ka'mil","sc'","ik'yir","yol","kig","k'zit","'","'","zrk","krg","isk'yet","na'k",
	"sc'azz","th'sc","nil","n'ahk","sc'yeth","aur'sk","iy'it","azzg","a'","i'","o'","u'","a","i","o","u","zz","kr","ak","nrk")
	machine_understands = FALSE

/datum/language/dog
	name = LANGUAGE_DOG
	desc = "Woof woof woof."
	speech_verb = "barks"
	ask_verb = "woofs"
	exclaim_verb = "howls"
	key = "n"
	flags = RESTRICTED
	space_chance = 100
	syllables = list("bark", "woof", "bowwow", "yap", "arf")
	machine_understands = FALSE

/datum/language/cat
	name = LANGUAGE_CAT
	desc = "Meow meow meow."
	speech_verb = "meows"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	key = "c"
	flags = RESTRICTED
	space_chance = 100
	syllables = list("meow", "mrowl", "purr", "meow", "meow", "meow")
	machine_understands = FALSE

/datum/language/mouse
	name = LANGUAGE_MOUSE
	desc = "Squeak squeak. *Nibbles on cheese*"
	speech_verb = "squeaks"
	ask_verb = "squeaks"
	exclaim_verb = "squeaks"
	key = "m"
	flags = RESTRICTED
	space_chance = 100
	syllables = list("squeak")	// , "gripes", "oi", "meow")
	machine_understands = FALSE

/datum/language/bird
	name = LANGUAGE_BIRD
	desc = "Chirp chirp, give me food"
	speech_verb = "chirps"
	ask_verb = "tweets"
	exclaim_verb = "squawks"
	key = "m"
	flags = RESTRICTED
	space_chance = 100
	syllables = list("chirp", "squawk", "tweet")
	machine_understands = FALSE