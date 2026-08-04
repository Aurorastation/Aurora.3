// Noise "language", for audible emotes.
/datum/language/noise
	name = LANGUAGE_NOISE
	desc = "Noises."
	key = "e"
	flags = RESTRICTED | INNATE | NO_TALK_MSG | NO_STUTTER | TCOMSSIM
	allow_accents = TRUE

/datum/language/noise/format_message(message, verb)
	return span("message", colourize(message))

/datum/language/noise/format_message_plain(message, verb)
	return message

/datum/language/noise/get_talkinto_msg_range(message)
	// if you make a loud noise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2

/datum/language/common
	name = LANGUAGE_SOL_COMMON
	short = "SOL"
	desc = "A language that emerged towards the end of the 21st century as a sort of hybridization between English and Chinese; official language of the Sol Alliance as well as a few of its former colonies. Most speakers of any human language by population. A dialect of Sol Common is spoken by the various alien races of the Spur and it is the primary lingua franca of known space."
	written_style = "solcommon"
	key = "0"
	flags = WHITELISTED | TCOMSSIM
	syllables = list("a", "abe", "ade", "ai", "an", "ana", "ba", "bae", "bai", "bang", "bao", "bei", "ben", "beo", "bi", "bian", "bing", "bo", "bu", "bugu", "bun", "cai", "can", "cao", "cau", "chan", "chen", "cheong",
	"chiu", "chong", "chyo", "da", "dan", "dao", "de", "deun", "duo", "eon", "eun", "eusi", "feng", "fu", "ga", "gak", "gan", "gang", "gao", "ge", "gei", "gen", "geo", "gil", "go", "gou", "gu", "gua", "gui", "gul",
	"gun", "guo", "gwi", "ha", "hai", "hal", "han", "hap", "hara", "he", "hego", "hen", "hon", "hoo", "hu", "hua", "hun", "hyeong", "i", "jae", "jeo", "jeon", "ji", "jia", "jian", "jiang", "jie", "jong", "ju", "jue",
	"juede", "jung", "juzi", "ka", "kang", "kawa", "ke", "keun", "ki", "kin", "ko", "kore", "kou", "ku", "kuda", "kun", "kyu", "lang", "lao", "leng", "leung", "li", "lian", "liang", "lie", "ling", "lizi", "lleo", "long",
	"lu", "ma", "mah", "me", "mei", "meinu", "men", "meng", "meog", "meoni", "mi", "mian", "min", "mo", "mot", "mu", "mun", "na", "nae", "nai", "nari", "ne", "ni", "nii", "nim", "nin", "no", "nop", "nu", "o", "oba", "oga", "oji",
	"oka", "ong", "op", "oto", "pa", "pai", "pang", "pin", "ping", "pong", "pu", "pum", "pye", "qi", "qie", "qing", "ra", "rei", "ren", "ri", "ru", "ruan", "sa", "sai", "sama", "san", "sang", "se", "sei", "sen", "seo", "seon", "seong",
	"shang", "shen", "sheng", "shi", "sho", "shui", "si", "su", "sui", "sum", "sun", "swi", "ta", "tae", "tai", "tame", "tamen", "tan", "te", "tei", "ti", "tian", "to", "ton", "tsu", "ul", "wa", "wan", "wang", "wei", "wo", "xi", "xian",
	"xiao", "xing", "xiong", "xiu", "xu", "xuan", "xue", "ya", "yan", "yang", "yeong", "yi", "yige", "yin", "ying", "yiqi", "yong", "you", "yu", "yuli", "yuyi", "zai", "zao", "zhan", "zhang", "zhe", "zhen", "zheng", "zhuo", "zi", "zo",
	"zu", "zun", "zuo")
	allow_accents = TRUE

/datum/language/nova_parla
	name = LANGUAGE_NOVA_PARLA
	short = "NOVPA"
	desc = "A language that originally began as an effort in the early 2200s to create a “New Latin” for the world of Romance languages so that the countries that spoke said languages could have a single language to coordinate their space-borne colonial efforts with. As such, it's been decently successful and has seen adoption across the spur from Eridani, to San Colette, to Assunzione."
	speech_verb = list("enunciates")
	sing_verb = list("performs")
	colour = "novaparla"
	written_style = "novaparla"
	key = "1"
	flags = TCOMSSIM
	allow_accents = TRUE
	syllables = list("a", "acc", "ai", "al", "ali", "am", "ama", "ami", "amo", "an", "ang", "arme", "ave", "ba", "bai", "bar", "bat", "bi", "blie", "bris", "ca", "can", "cant", "car", "care", "ce", "ci", "cis", "cit", "cla", "co", "cul", "cur", "curt", "da", "dam", "dans", "de",
	"di", "dier", "dim", "dins", "dorm", "du", "duro", "e", "eaux", "ec", "ecto", "ees", "ego", "el", "en", "ent", "er", "ere", "eres", "eri", "ero", "es", "et", "ex", "far", "fi", "fic", "fine", "fol", "foll", "fri", "fro", "gen", "gil", "go", "gran", "hab", "ho", "huc", "ia",
	"iam", "ibus", "idor", "ie", "iens", "ier", "ieur", "iis", "il", "in", "ine", "int", "ir", "is", "ise", "it", "itt", "jar", "je", "jo", "jor", "la", "lar", "lav", "le", "lees", "ler", "les", "li", "lib", "lie", "lo", "lu", "ma", "man", "manu", "mar", "mari", "mas", "me", "mea",
	"mee", "mejo", "men", "mes", "meum", "meus", "mi", "mier", "min", "mine", "mit", "mo", "moi", "mon", "mons", "mors", "mou", "mul", "na", "nam", "ne", "nee", "nent", "nes", "ni", "nit", "no", "nom", "nu", "num", "o", "oc", "occ", "oja", "om", "omni", "or", "ori", "oro", "os", "ou",
	"oub", "pa", "par", "pars", "pas", "plu", "pluv", "po", "pol", "pos", "pou", "pous", "pre", "pu", "pug", "pus", "que", "qui", "re", "ri", "ric", "riga", "rito", "ro", "rom", "sa", "sal", "se", "ser", "sers", "ses", "sim", "sion", "so", "sol", "som", "sou", "sper", "sse", "ste", "su",
	"suis", "sul", "sur", "ta", "tar", "te", "teau", "tem", "temp", "ten", "tene", "tes", "ti", "tibus", "tien", "tion", "to", "tol", "ton", "tons", "tout", "tra", "trai", "tre", "trou", "tuo", "tus", "tut", "ues", "ui", "ul", "um", "un", "upa", "us", "ut", "ux", "va", "vail", "ve", "ven",
	"veni", "vi", "viam", "vie", "vo", "xus", "za", "zio")

/datum/language/freespeak
	name = LANGUAGE_FREESPEAK
	short = "FREE"
	desc = "A language of renegades and frontiersmen descending from various languages from Earth like Hindi combined into a multi-rooted jumble that sounds incoherent or even barbarian to non-native speakers. This language is the only common cultural identity for humans in the frontier. Speaking this language in itself boldly declares the speaker a free spirit. Often called 'Gutter' by Alliance citizens."
	speech_verb = list("says")
	sing_verb = list("croons")
	colour = "freespeak"
	written_style = "freespeak"
	key = "2"
	flags = TCOMSSIM
	allow_accents = TRUE
	syllables = list("a", "aan", "aas", "ab", "aba", "ad", "aee", "aft", "ag", "ai", "aise", "ak", "akee", "aq", "ar", "ata", "aur", "aus", "ba", "baat", "bach", "bad", "bahe", "band", "be", "ben", "ber", "bhaa", "bhu", "bra", "burt", "cap", "cer", "ch", "cha", "chaar", "chale", "chalo", "chil",
	"com", "da", "daa", "daaj", "dat", "de", "dee", "dhaa", "di", "die", "dik",
	"koo", "ky", "la", "laa", "laat", "lad", "lada", "lana", "lane", "le", "lee", "leiden", "leis", "len", "lie", "lo", "maa", "maan", "mod ", "most", "muj", "mujhe", "mukt", "na", "naya", "ne", "nee", "net", "neta", "nir", "nka", "oon", "oop", "pa", "paa", "pet", "phen", "phot", "pi", "plo", "pra",
	"que", "ra", "raa", "rahe", "raho", "ran", "rana", "rar", "re", "ri", "rie", "rin", "ro", "rona", "rosh", "rtiv", "saa", "saal", "saath", "san", "santu", "sch", "se", "sen", "sh", "sha", "shee", "shi", "shn", "sht", "shuo", "soch", "sol", "soo", "ssa", "ster", "suk", "sur", "ta", "taan", "tak",
	"taka", "tal", "tan", "tar", "ten", "tend", "th", "tho", "tili", "to", "ton", "tr", "tu", "tum", "tung", "udaa", "ugr", "unge", "ut", "va", "vaa", "vaad", "vaib", "ve", "ven", "ver", "vi", "vis", "vol", "wic", "wu", "wut", "xi", "xiao", "ya", "yah", "yon", "you", "zas", "ze", "zhu", "zi", "zo", "zorn", "zt")

/datum/language/gavsa
	name = LANGUAGE_GAVSA
	short = "GAVSA"
	desc = "A language built during the late 21st century by the USSR and Warsaw Pact as a means to create a single, standardised language for all pact countries. This language was built from the grammar and vocabulary of the various languages of the Warsaw Pact, chief among them being Russian. The language saw limited adoption within the Eastern Bloc proper, but found widespread success within the often diverse USSR and Pact colonies as a common language for the colonists."
	speech_verb = list("articulates")
	sing_verb = list("performs")
	colour = "gavsa"
	written_style = "gavsa"
	key = "3"
	flags = TCOMSSIM
	allow_accents = TRUE
	syllables = list("MATT", "PUT", "SOME", "SHIT", "HERE")

/datum/language/morozi
	name = LANGUAGE_MOROZI
	short = "MOROZ"
	desc = "The official language of the Empire of Dominia. Many language scholars have determined Morozi to be a distant cousin of Sol Common, having emerged during Dominia’s prolonged isolation from the rest of Human civilization. Rather than being a hybridization of English and Chinese, scholars have determined that Morozi began as a pidgin language used between speakers of Sol Common, old Earth German, and old earth Chinese."
	speech_verb = list("proclaims")
	sing_verb = list("chirps")
	colour = "morozi"
	written_style = "morozi"
	key = "4"
	flags = TCOMSSIM
	allow_accents = TRUE
	syllables = list("AOAOAOAO", "IM", "SO", "FUCKING", "POSH")

// Sign language
/datum/language/sign
	name = LANGUAGE_SIGN
	desc = "A signed version of Sol Common. It is primarily used by those who are deaf, hearing impaired, or mute."
	speech_verb = list("signs")
	signlang_verb = list("signs", "gestures")
	sing_verb = null
	colour = "i"
	key = "s"
	flags = NO_STUTTER | SIGNLANG

// Helper
/proc/get_lang_name(var/datum/language/language)
	if (!language || !istype(language))
		return "Unknown"

	return language.name

/datum/language/aphasia
	name = LANGUAGE_GIBBERING
	desc = "It is theorized that any sufficiently brain-damaged person can speak this language."
	speech_verb = list("garbles")
	ask_verb = list("mumbles")
	whisper_verb = list("mutters")
	exclaim_verb = list("screams incoherently")
	sing_verb = list("gibbers")
	key = "gi"
	syllables = list("m","n","gh","h","l","s","r","a","e","i","o","u")
	space_chance = 20
	flags = RESTRICTED
