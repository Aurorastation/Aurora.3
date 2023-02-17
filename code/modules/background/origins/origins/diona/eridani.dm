/singleton/origin_item/culture/diona_eridani
	name = "Eridani Corporate Federation"
	desc = "The Eridani Corporate Federation is an autonomous member of the Solarian Alliance that is infamous abroad for its starkly divided society and extreme levels of corporate involvement in daily life. Corporations touch every aspect of Eridani, and its society is divided between corporate \"Suits\" that work for its companies and non-citizen \"Dregs\" that live off the scraps of society. Between the two, \"Reinstated Dregs\" chart an awkward balance: too corporate to be Dregs, but not corporate enough to be Suits."
	possible_origins = list(
		/singleton/origin_item/origin/slum_grown,
		/singleton/origin_item/origin/sunlight_grown
	)

/singleton/origin_item/origin/slum_grown
	name = "Slum Grown"
	desc = "Dionae who were originally grown in and influenced by the slums of Eridani, most often in the underbelly of Oran."
	important_information = "These Dionae tend to be significantly influenced by Eridanian Dregs, generally taking on some of their mannerisms and vocabulary."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)

/singleton/origin_item/origin/sunlight_grown
	name = "Sunlight Grown"
	desc = "Dionae who were originally grown in and influenced by the Eridani Federation in a more positive environment, most often on Akhet."
	important_information = "These Dionae tend to be significantly influenced by Eridanian Suits, generally taking on some of their mannerisms and vocabulary."
	possible_accents = list(ACCENT_ROOTSONG, ACCENT_VOIDSONG)
	possible_citizenships = list(CITIZENSHIP_BIESEL, CITIZENSHIP_NRALAKK, CITIZENSHIP_EUM, CITIZENSHIP_COALITION)
	possible_religions = list(RELIGION_ETERNAL, RELIGION_OTHER, RELIGION_NONE)