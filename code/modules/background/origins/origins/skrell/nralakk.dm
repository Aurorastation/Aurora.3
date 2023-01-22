#define CITIZENSHIPS_NRALAKK list(CITIZENSHIP_NRALAKK, CITIZENSHIP_BIESEL, CITIZENSHIP_SOL, CITIZENSHIP_COALITION, CITIZENSHIP_ERIDANI, CITIZENSHIP_EUM)
#define RELIGIONS_NRALAKK list(RELIGION_QEBLAK, RELIGION_WEISHII, RELIGION_SUURKA, RELIGION_KIRGUL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/culture/federation
	name = "Federation Skrell"
	desc = "The Nralakk Federation was first formed in 900 CE to unite the Skrell diaspora on Qerrbalak and its initial colonies, and formed again in 2245 CE with the disappearance of Glorsh-Omega. The Federation throughout the centuries has always had the main goal of uplifting the Skrell species as a whole, resulting in a culture that places importance on family, success, and working as a collective for the betterment of Skrellkind."
	possible_origins = list(
		/singleton/origin_item/origin/nralakk_core,
		/singleton/origin_item/origin/traverse,
		/singleton/origin_item/origin/generation_fleets
	)

/singleton/origin_item/origin/nralakk_core
	name = "Core Worlds"
	desc = "The Core Worlds are locations within the inner sphere of the Nralakk Federation. The Core Worlds consist of the system Nralakk, the birthplace of the Skrell, as well as the first colonies founded by the species. High quality of life and pro-Nralakk Federation views are common for those who live here."
	important_information = "The Nralakk Federation monitors its citizens closely while they're abroad, and they risk deportation if their actions are deemed a serious threat to the Federation."
	possible_accents = list(ACCENT_SKRELL, ACCENT_HOMEWORLD, ACCENT_QERRMALIC, ACCENT_ALIOSE, ACCENT_AWEIJI)
	possible_citizenships = CITIZENSHIPS_NRALAKK
	possible_religions = RELIGIONS_NRALAKK

/singleton/origin_item/origin/traverse
	name = "Traverse"
	desc = "The Traverse consists of the outer systems that make up the majority of Federation space, where the quality of life and planet development varies greatly. Views on the Federation are mixed depending on personal interactions with the Government, with many being influenced by the resistance cells that operate here."
	possible_accents = list(ACCENT_TRAVERSE, ACCENT_TATTUQIG, ACCENT_SKRELL)
	possible_citizenships = CITIZENSHIPS_NRALAKK
	possible_religions = RELIGIONS_NRALAKK

/singleton/origin_item/origin/generation_fleets
	name = "Generation Fleets"
	desc = "Generation Fleets were utilised throughout most of the Skrell's era of colonisation, with the more modern fleets becoming roaming nomads during the reign of Glorsh-Omega. Some of these fleets are still active today in some capacity, with most being officially approved by the Federation Government - although some others are branded as marauders and rebels."
	possible_accents = list(ACCENT_SKRELL, ACCENT_GENNER)
	possible_citizenships = CITIZENSHIPS_NRALAKK
	possible_religions = RELIGIONS_NRALAKK
