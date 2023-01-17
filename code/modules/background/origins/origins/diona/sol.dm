/singleton/origin_item/culture/diona_sol
	name = "Sol Alliance"
	desc = "Despite the loss of much of its territory during the Solarian Collapse of 2463, most of those that fall under the general umbrella of Solarian culture are citizens or belong to statelets affiliated with the Alliance of Sovereign Solarian Nations (ASSN). By and large, Solarians are generally perceived as xenophobic, nationalistic, and militarist. Non-humans, aside from Skrell, are generally rare on Solarian worlds, and many that do reside on them are treated as second-class citizens at best."
	possible_origins = list(
		/singleton/origin_item/origin/diona_sol,
		/singleton/origin_item/origin/sol_wildborn
	)

/singleton/origin_item/origin/diona_sol
	name = "Sol Grown"
	desc = "Dionaea who were originally grown in and influenced by the Sol Alliance."
	important_information = "Dionae grown in the Sol Alliance are forced into a contract for a set period of time that requires them to stay employed in some form within Alliance territory, commonly with a megacorporation."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/sol_wildborn
	name = "Wildborn"
	desc = "Dionae who were originally considered wild Dionae before being uplifted and integrated somewhere in the Solarian Alliance or one of the megacorporations active within its borders."
	important_information = "Dionae integrated by the Sol Alliance are forced into a contract for a set period of time that requires them to stay employed in some form within Alliance territory, commonly with a megacorporation."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_SOL, CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)