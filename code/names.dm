var/list/ai_names = file2list("config/names/ai.txt")
var/list/wizard_first = file2list("config/names/wizardfirst.txt")
var/list/wizard_second = file2list("config/names/wizardsecond.txt")
var/list/ninja_titles = file2list("config/names/ninjatitle.txt")
var/list/ninja_names = file2list("config/names/ninjaname.txt")
var/list/commando_names = file2list("config/names/death_commando.txt")
var/list/first_names_male = file2list("config/names/first_male.txt")
var/list/first_names_female = file2list("config/names/first_female.txt")
var/list/last_names = file2list("config/names/last.txt")

var/list/verbs = file2list("config/names/verbs.txt")
var/list/adjectives = file2list("config/names/adjectives.txt")

//loaded on startup because of "
//would include in rsc if ' was used

var/list/greek_letters = list("Alpha", "Beta", "Gamma", "Delta",
	"Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu",
	"Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi",
	"Chi", "Psi", "Omega")

/proc/generate_system_name()
	return "[pick("CRZ", "BNM", "Xavier", "GJ", "HD", "TC")][prob(10) ? " Eridani" : ""] [rand(100,999)]"

/proc/generate_planet_name()
	return "[capitalize(pick(last_names))]-[pick(greek_letters)]"

/proc/generate_planet_type()
	return pick("terrestial planet", "ice planet", "dwarf planet", "desert planet", "ocean planet", "lava planet", "gas giant", "forest planet")