/datum/language/diona
	name = LANGUAGE_ROOTSONG
	desc = "A creaking, subvocal language spoken instinctively by the Dionaea. Due to the unique makeup of the average Diona, a phrase of Rootspeak can be a combination of anywhere from one to twelve individual voices and notes."
	speech_verb = list("creaks and rustles")
	ask_verb = list("creaks")
	exclaim_verb = list("rustles")
	sing_verb = list("croaks")
	colour = "soghun"
	key = "q"
	flags = RESTRICTED|TCOMSSIM
	syllables = list("hs","zt","kr","st","sh")

/datum/language/diona/get_random_name()
	var/new_name = "[pick(list("To Sleep Beneath","Changing of", "Soaring Above", "Wind Over","Embrace of","Dreams of","Witnessing", "Lost in", "To Walk Beneath","Approaching the", "Distant Memories of", "Forgotten Glimpse of", "Roots of", "Tendrils of", "Leaves Rustling in", "Last Hope of", "Speaking to"))]"
	new_name += " [pick(list("the Void","the Stillness of Death", "the Sky","Encroaching Night","Planetsong","Starsong","the Wandering Star","the Empty Day","Daybreak","Nightfall","the Rain", "a Distant Galaxy", "a Starless Night", "the Fruits of Dreams", "the Rising Dawn", "the Song of Life", "a Lonely Shadow", "Forlorn Hope", "a Bleak Wasteland"))]"
	while(findtextEx(new_name,"the the",1,null))
		new_name = replacetext(new_name, "the the", "the")

	while(findtextEx(new_name,"the a",1,null))
		new_name = replacetext(new_name, "the a", "a")

	return new_name


// Unathi languages
/datum/language/unathi
	name = LANGUAGE_UNATHI
	short = "UNA"
	desc = "The common language of Moghes, composed of sibilant hisses and rattles. Spoken natively by Unathi."
	speech_verb = list("hisses")
	ask_verb = list("hisses")
	exclaim_verb = list("roars")
	sing_verb = list("hisses")
	colour = "soghun"
	written_style = "sintaunathi"
	key = "o"
	flags = WHITELISTED|TCOMSSIM
	allow_accents = TRUE
	space_chance = 40
	syllables = list(
		"za", "az", "ze", "ez", "zi", "iz", "zo", "oz", "zu", "uz", "zs", "sz",
		"ha", "ah", "he", "eh", "hi", "ih", "ho", "oh", "hu", "uh", "hs", "sh",
		"la", "al", "le", "el", "li", "il", "lo", "ol", "lu", "ul", "ls", "sl",
		"ka", "ak", "ke", "ek", "ki", "ik", "ko", "ok", "ku", "uk", "ks", "sk",
		"sa", "as", "se", "es", "si", "is", "so", "os", "su", "us", "ss", "ss",
		"ra", "ar", "re", "er", "ri", "ir", "ro", "or", "ru", "ur", "rs", "sr",
		"a",  "a",  "e",  "e",  "i",  "i",  "o",  "o",  "u",  "u",  "s",  "s"
	)
	partial_understanding = list(LANGUAGE_AZAZIBA = 25)
	allow_accents = TRUE

/datum/language/unathi_azaziba
	name = LANGUAGE_AZAZIBA
	short = "AZA"
	desc = "A language of Moghes consisting of a combination of spoken word and gesticulation. While waning since Moghes entered the galactic stage, it enjoys popular use by Unathi that never fell to the Hegemony's cultural dominance."
	speech_verb = list("hisses")
	ask_verb = list("hisses")
	exclaim_verb = list("roars")
	signlang_verb = list("signs", "gestures aggressively")
	sing_verb = list("hisses")
	colour = "soghun_alt"
	written_style = "sintaazaziba"
	key = "p"
	flags = WHITELISTED | NONVERBAL
	syllables = list("azs","zis","zau","azua","skiu","zuakz","izo","aei","ki","kut","zo")
	partial_understanding = list(LANGUAGE_UNATHI = 50)
	allow_accents = TRUE

// tajaran languages
/datum/language/tajaran
	name = LANGUAGE_SIIK_MAAS
	short = "MAAS"
	desc = "The traditionally employed tongue of Adhomai, comprised of expressive yowls and chirps. Native to the Tajara."
	speech_verb = list("mrowls")
	ask_verb = list("mrowls")
	exclaim_verb = list("yowls")
	sing_verb = list("mrowls")
	colour = "tajaran"
	written_style = "siikmaas"
	key = "j"
	flags = WHITELISTED|TCOMSSIM
	syllables = list("mrr","rr","tajr","kir","raj","kii","mir","kra","ahk","nal","vah","khaz","jri","ran","darr",
	"mi","jri","dynh","manq","rhe","zar","rrhaz","kal","chur","eech","thaa","dra","jurl","mah","sanu","dra","ii'r",
	"ka","aasi","far","wa","baq","ara","qara","zir","sam","mak","hrar","nja","rir","khan","jun","dar","rik","kah",
	"hal","ket","jurl","mah","tul","cresh","azu","ragh","mro","mra","mrro","mrra")
	partial_understanding = list(LANGUAGE_YA_SSA = 25, LANGUAGE_DELVAHII = 50)
	allow_accents = TRUE

/datum/language/tajaran/get_random_name(var/gender)

	var/new_name
	if(gender==FEMALE)
		new_name += pick(list("Aisha","Amani","Agashka","Agramakova","Bakhteiarova","Bratomila","Dekhova","Derzhka","Farah","Faizah","Hanifa","Ikram","Jenna","Khadija","Kandaza","Karyme","Kismet","Malika","Mumtaz","Nashwa","Nafisha","Shahar","Sabah","Takiyah","Wafiqah","Wasime","Yesenia","Zahra","Zohra","Rajjurl","Marryam","Dhrarmela","Rrhuyala","Irryavga","Ahvulyar","Purryalna","Yasmin"))
	else if(gender==MALE)
		new_name += pick(list("Abdal","Akhtar","Akim","Alik","Arif","Azzam","Anton","Alzrun","Bahir","Barakh","Bohdan","Coman","Dekel","Dima","Fa'iq","Faidah","Fredek","Fakhr","Hasam","Hashim","Ioakim","Kadir","Kareef","Khrazmrrug","Khazarir","Rrhazumar","Mrrhazugal","Harrmalik","Mata'ke","Njadrasanukii","Tajrhalrr","Rhagrrhuzau","Vahzirthaamro","Lev","Misha","Mahir","Nasser","Nasir","Oleg","Qadir","Sharif","Stepka","Tamir","Yasir","Zahid"))
	new_name += " "
	new_name += pick(list("Alfarsi","Alekseev","Al-Barik","Al-Hamdan","Al-Mansur","Al-Kandari","Al-Shahrani","Antonov","Bogdanov","El-Hasem","El-Amin","Rrhakaslav","Mrrazhughran","Jrruzhani","Rrhamrare","Mrakiizar","Hirron","Prruzhulkanich","El-Tusi","Nejem","Hanar","Karimi","Markov","Saif","Yakub","Zaman","Zaydan","Zidan","Zahawi"))
	return new_name

/datum/language/tajaran_sign
	name = LANGUAGE_SIGN_TAJARA
	desc = "A sign language developed by Adhomian hunters."
	speech_verb = list("signs")
	signlang_verb = list("moves their tail", "flicks their ears", "swivels their ears", "flicks their tail", "shifts their ears and tail")
	sign_adv_length = list("", " briefly", " a few times", " several times in quick succession", " for a while")
	sing_verb = null
	colour = "i"
	key = "i"
	flags = NO_STUTTER | SIGNLANG | WHITELISTED

/datum/language/siik_tajr
	name = LANGUAGE_SIIK_TAJR
	desc = "A language native to the Tajara, it employs both verbal and non-verbal elements."
	speech_verb = list("mrowls")
	ask_verb = list("mrowls")
	exclaim_verb = list("yowls")
	signlang_verb = list("moves their tail", "flicks their ears", "swivels their ears", "flicks their tail", "shifts their ears and tail")
	sign_adv_length = list("", " briefly", " a few times", " several times in quick succession", " for a while")
	sing_verb = list("mrowls")
	colour = "tajaran_signlang"
	key = "w"
	flags = WHITELISTED | NONVERBAL
	syllables = list("mrr","rr","tajr","kir","raj","kii","mir","kra","ahk","nal","vah","khaz","jri","ran","darr",
	"mi","jri","dynh","manq","rhe","zar","rrhaz","kal","chur","eech","thaa","dra","jurl","mah","sanu","dra","ii'r",
	"ka","aasi","far","wa","baq","ara","qara","zir","sam","mak","hrar","nja","rir","khan","jun","dar","rik","kah",
	"hal","ket","jurl","mah","tul","cresh","azu","ragh","mro","mra","mrro","mrra")
	partial_understanding = list(LANGUAGE_SIIK_MAAS = 50, LANGUAGE_SIGN_TAJARA = 25)

/datum/language/yassa
	name = LANGUAGE_YA_SSA
	short = "YAS"
	desc = "The traditional language of the tajaran nobility."
	speech_verb = list("mrowls")
	ask_verb = list("mrowls")
	exclaim_verb = list("yowls")
	sing_verb = list("mrowls")
	colour = "yassa"
	written_style = "yassa"
	key = "r"
	flags = WHITELISTED|TCOMSSIM
	syllables = list("hrr","rhr","tarj","khir","rajh","kir","mier","kre","ahek","nlhal","veh","khaz","dri","rhan","darrer",
	"mi","jhri","dynher","manqi","rhas","shar","drhaz","kalh","shur","echi","tha","draer","jurl","maher","sanii","dra","ii'r",
	"kan","aesi","fare","we","bash","arha","quara","zhir","sem","make","hrer","nja","rir","can","jhun","dar","rik","kah",
	"hal","kete","juril","mah","tul","cresh","azu","ragh","miro","mara","mrero","mrara")
	partial_understanding = list(LANGUAGE_SIIK_MAAS = 50)
	allow_accents = TRUE

/datum/language/delvahhi
	name = LANGUAGE_DELVAHII
	short = "DEL"
	desc = "A dialect developed by the Zhan-Khazan communities, commonly used in religious ceremonies dedicated to the Snow God and amongst settlements comprised mostly of Zhan-Khazan."
	speech_verb = list("mrowls")
	ask_verb = list("mrowls")
	exclaim_verb = list("yowls")
	sing_verb = list("mrowls")
	colour = "delvahhi"
	written_style = "delvahhi"
	key = "n"
	flags = WHITELISTED|TCOMSSIM
	syllables = list("mrr","rr","tajr","kir","raj","kii","mir","kra","ahk","nal","vah","khaz","jri","ran","darr",
	"mi","jri","dynh","manq","rhe","zar","rrhaz","kal","chur","eech","thaa","dra","jurl","mah","sanu","dra","ii'r",
	"ka","aasi","far","wa","baq","ara","qara","zir","sam","mak","hrar","nja","rir","khan","jun","dar","rik","kah",
	"hal","ket","jurl","mah","tul","cresh","azu","ragh","mro","mra","mrro","mrra")
	partial_understanding = list(LANGUAGE_SIIK_MAAS = 50)
	allow_accents = TRUE

/datum/language/skrell
	name = LANGUAGE_SKRELLIAN
	short = "NRAL"
	desc = "A melodic and complex language spoken by the Skrell of Qerrbalak. Some of the notes are inaudible to humans."
	speech_verb = list("warbles")
	ask_verb = list("warbles")
	exclaim_verb = list("warbles")
	sing_verb = list("warbles")
	colour = "skrell"
	written_style = "nralmalic"
	key = "k"
	flags = WHITELISTED|TCOMSSIM
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix","*","!")
	allow_accents = TRUE

/datum/language/skrell/get_random_name()
	var/new_name = ""
	var/suff = ""
	var/name_pieces = list("Qu", "Su", "Xu", "Xi", "Qi", "Si", "Ei", "Qui", "Iuq", "Qiu", "Kiu", "Uiu", "Eis", "Seq", "Eqa", "Uiq", "Kui", "Muu", "Muq", "Kuo", "Omq", "Xoi", "Liq", "Zuk", "Kono", "Koxi", "Auuo", "Iili", "Kesi", "Irek", "Quak", "Qoku", "Uokk", "Eeok", "Teie", "Xiou", "Xoku", "Xiru", "Qiuu", "Laqu", "Leua", "Olru", "Oquo", "Oeoo", "Isik", "Kiue", "Ruee", "Ouqu", "Kiiq", "Tesh", "Lish", "Ilin", "Shiq", "Quis", "Oquq", "Ququ", "Xoio", "Nolko", "Ruusi", "Ieliu", "Nuptu", "Eiuos", "Seiuu", "Xeriu", "Ioquk", "Teiqu", "Quoru", "Qiiuk", "Qeouu", "Quaoi", "Uieuu", "Koqun", "Nuouu", "Leuqo", "Luroq", "Urqul", "Uluqu", "Iequu", "Uiuou", "Suioq", "Urouu", "Xeouu", "Xeios", "Qarui", "Njubu", "Buquk", "Zueou", "Qosko", "Tuiru", "Tuquu", "Xorie", "Zouuo", "Euioi", "Liise", "Riori", "Iirun", "Akoox", "Nunuz", "Ezhin", "Vulun", "Ponoh", "Sulux", "Suqui", "Suqua", "Souqx", "Squix", "Quish", "Shiqu", "Jeshi", "Xushi", "Kiqui", "Liuiq", "Tuish", "Vuzuna", "Uptari", "Xiialt", "Yonosh", "Lieuqo", "Turiuu", "Utrieo", "Yutiex", "Xuitou", "Xieoru", "Xioshi", "Quisuu", "Juiqii", "Uituik", "Ruisui", "Tuisuh", "Jixktu", "Lioxui", "Shixul", "Iuoquu", "Nuitqu", "Kuixqu", "Oiquio", "Oiakuu", "Juukxu", "Iouiuu", "Tuirou", "Suahuk", "Seuaio", "Juirue", "Kioxui", "Xusuui", "Tuirul", "Luishi", "Liropo", "Lixuqe", "Urueir", "Queire", "Iuosuu", "Jaxxak", "Kqullu", "Xulluu", "Xikkuq", "Oiuqkk", "Tuiskk", "Liqukk", "Orueix", "Rkusix", "Turieu", "Kduish", "Xdurui", "Liquuq", "Shiruu", "Xuisoo", "Ooruex", "Uuooux", "Oieuix", "Laishi", "Xiaooi", "Oruexi", "Xiatal", "Xekkua")
	var/first_name = "[pick(name_pieces)]"
	name_pieces -= first_name
	if(prob(40))
		suff = "[pick(name_pieces)]"
		name_pieces -= suff
		first_name += "[pick(list("'", "-"))]" + suff
	var/last_name = "[pick(name_pieces)]"
	name_pieces -= last_name
	if(prob(40))
		suff = "[pick(name_pieces)]"
		name_pieces -= suff
		last_name += "[pick(list("'", "-"))]" + suff
	new_name = first_name + " " + last_name
	return new_name

/datum/language/bug
	name = LANGUAGE_VAURCA
	desc = "A localised expression of the Vaurcae hivemind, allowing Vaurcae to communicate from across great distances. \"It's a bugs life.\""
	speech_verb = list(" broadcasts")
	colour = "vaurca"
	key = "9"
	native = 1
	flags = WHITELISTED | HIVEMIND
	syllables = list("vaur","uyek","uyit","avek","sc'theth","k'ztak","teth","wre'ge","lii","dra'","zo'","ra'","k'lax'","zz","vh","ik","ak",
	"uhk","zir","sc'orth","sc'er","thc'yek","th'zirk","th'esk","k'ayek","ka'mil","sc'","ik'yir","yol","kig","k'zit","'","'","zrk","krg","isk'yet","na'k",
	"sc'azz","th'sc","nil","n'ahk","sc'yeth","aur'sk","iy'it","azzg","a'","i'","o'","u'","a","i","o","u","zz","kr","ak","nrk")

/datum/language/bug/get_random_name()
	var/new_name = "[pick(list("Ka'","Za'","Ka'"))]"
	new_name += "[pick(list("Akaix'","Viax'"))]"
	new_name += "[pick(list("Uyek","Uyit","Avek","Theth","Ztak","Teth","Zir","Yek","Zirk","Ayek","Yir","Kig","Yol","'Zrk","Nazgr","Yet","Nak","Kiihr","Gruz","Guurz","Nagr","Zkk","Zohd","Norc","Agraz","Yizgr","Yinzr","Nuurg","Iii","Lix","Nhagh","Xir","Z'zit","Zhul","Zgr","Na'k","Isk'yet","Aaaa"))]"
	var/list/hive_names = list("Zo'ra" = 3, "K'lax" = 1, "C'thur" = 1)
	new_name += " [pickweight(hive_names)]"
	return new_name

/datum/language/bug/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	log_say("[key_name(speaker)] : ([name]) [message]",ckey=key_name(speaker))

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

	for(var/mob/player in player_list)
		if(istype(player,/mob/abstract/observer) || ((src in player.languages && !within_jamming_range(player)) || check_special_condition(player)))
			to_chat(player, msg)

/datum/language/bug/format_message(message, verb, speaker_mask)
	var/message_color = colour
	var/list/speaker_surname = splittext(speaker_mask, " ")
	switch(speaker_surname[2])
		if("Zo'ra")
			message_color = "vaurca_zora"
		if("C'thur")
			message_color = "vaurca_cthur"
		if("K'lax")
			message_color = "vaurca_klax"
		if("Lii'dra")
			message_color = "vaurca_liidra"
	if(copytext(message, 1, 2) == "!")
		return " projects <span class='message'><span class='[message_color]'>[copytext(message, 2)]</span></span>"
	return "[verb], <span class='message'><span class='[message_color]'>\"[capitalize(message)]\"</span></span>"

/datum/language/bug/check_special_condition(var/mob/other)
	if(istype(other, /mob/living/silicon))
		return 1

	var/mob/living/carbon/human/M = other
	if(!istype(M))
		return 0
	if(istype(M, /mob/abstract/new_player))
		return 0
	if(within_jamming_range(other))
		return 0
	if(M.internal_organs_by_name[BP_NEURAL_SOCKET])
		return 1
	if(M.internal_organs_by_name["blackkois"])
		return 1

	if (M.l_ear || M.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(M.l_ear,/obj/item/device/radio/headset))
			dongle = M.l_ear
		else
			dongle = M.r_ear

		if(!istype(dongle))
			return 0
		if(dongle.translate_hivenet)
			return 1

	return 0

/datum/language/human
	name = LANGUAGE_SOL_COMMON
	short = "SOL"
	desc = "With its roots in Mandarin Chinese, Common evolved as the official language of the Sol Alliance, with officials working to tie it together with a common tongue. It's spoken by state officials, taught in schools, and spoken by those who either feel a sense of national pride in the Alliance or otherwise fell sway to the culture."
	colour = "solcom"
	written_style = "solcommon"
	key = "1"
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

/datum/language/human/get_random_name(var/gender)
	if (prob(80))
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		return ..()

//Placeholder stuff for now, a lot of it
/datum/language/elyran
	name = LANGUAGE_ELYRAN_STANDARD
	short = "ELY"
	desc = "Elyran Standard is the official tongue of the Republic of Elyra. Constructed using elements of Farsi, Arabic, and Turkish, influence from all three of these languages can be seen throughout its grammar and vocabulary."
	colour = "elyran"
	written_style = "elyranstandard"
	key = "4"
	flags = WHITELISTED | TCOMSSIM
	syllables = list("af", "if", "ba", "ta", "tha", "id", "jem", "ha", "kha", "dal", "dhl", "ra", "zay", "sen", "um", "shn", "sid", "ad", "ta", "za", "ayn", "gha", "zir", "yn", "fa", "qaf", "iam", "mim", "al", "ja", "non", "ha", "waw", "ya",
		"hem", "zah", "hml", "ks", "ini", "da", "ks", "iga", "ih", "la", "ulf", "xe", "ayw", "sit", "ah", "aarah", "jalaa", "sirt", "kurt", "turhk", "ust", "irk", "kir", "mir", "ach", "oglu", "bolu", "shek", "she", "ghoz", "miya", "ejdan", 
		"haaz", "quq", "taab", "shanha", "an", "saa", "seh", "an'", "e'", "a'", "em'")
	allow_accents = TRUE

/datum/language/machine
	name = LANGUAGE_EAL
	short = "EAL"
	desc = "A language of encoded tones that allow for IPCs to communicate auditorily between each other in a manner that allows for easier transfer of information."
	speech_verb = list("beeps")
	ask_verb = list("beeps")
	exclaim_verb = list("loudly beeps")
	sing_verb = list("rhythmically beeps")
	colour = "changeling"
	written_style = "encodedaudiolanguage"
	key = "6"
	flags = RESTRICTED | NO_STUTTER | TCOMSSIM
	syllables = list("beep","beep","beep","beep","beep","boop","boop","boop","bop","bop","dee","dee","doo","doo","hiss","hss","buzz","buzz","bzz","ksssh","keey","wurr","wahh","tzzz")
	space_chance = 10

/datum/language/machine/get_random_name()
	if(prob(70))
		return "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	return pick(ai_names)
